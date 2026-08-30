# ChemXR API (Backend) — README de desarrollo

API REST reactiva (Spring Boot WebFlux + R2DBC) que conecta la base de datos
PostgreSQL `chemdb` con los clientes (app Android ChemXR).

> Este documento describe el estado real del proyecto a fecha de desarrollo.
> El `README.md` raíz se mantiene intacto con la descripción general.

## Stack
- Java 21
- Spring Boot 4.0.5 (WebFlux)
- Spring Data R2DBC (driver `r2dbc-postgresql`)
- Spring Security (`BCryptPasswordEncoder`)
- PostgreSQL 16+ (contenedor Docker)

## Base de datos
La BD corre en Docker (`compose-db.yml`). El contenedor se llama `chemdb` y
expone el puerto **5435** hacia el host (5432 interno).

```bash
docker compose -f compose-db.yml up -d
```

Credenciales de la BD (definidas en `compose-db.yml` y usadas en `application.properties`):

| Param | Valor |
|---|---|
| Host | `localhost` |
| Puerto | `5435` |
| Base de datos | `chemdb` |
| Usuario | `maximus` |
| Password | `MaximusTheGreat50` |

El esquema se inicializa automáticamente desde `init_chemdb.sql`
(26+ tablas: `people`, `users`, `courses`, `registrations`, etc.).

Acceso directo:

```bash
psql -h localhost -U maximus -d chemdb -p 5435
```

## Conexión (`application.properties`)
```properties
spring.r2dbc.url=r2dbc:postgresql://localhost:5435/chemdb
spring.r2dbc.username=maximus
spring.r2dbc.password=MaximusTheGreat50
spring.r2dbc.pool.enabled=true
spring.r2dbc.pool.initial-size=2
spring.r2dbc.pool.max-size=10
```

## Cómo ejecutar
Requisito: JDK 21 instalado (la toolchain del proyecto está fijada a Java 21).

```bash
JAVA_HOME=/home/cloud-devops/jdks/jdk-21 ./gradlew bootRun
```

Compilar sin ejecutar:

```bash
JAVA_HOME=/home/cloud-devops/jdks/jdk-21 ./gradlew build
```

El servidor queda en `http://localhost:8080` (y accesible por la IP LAN
`192.168.18.23:8080`).

## Estructura de código (`com.adrom.chemxr_api`)
```
config/SecurityConfig.java            Rutas públicas /auth/** + BCryptPasswordEncoder
domain/People.java                    Entidad R2DBC tabla people (Persistable)
domain/Users.java                     Entidad R2DBC tabla users (Persistable)
domain/Registrations.java             Entidad R2DBC tabla registrations (Persistable)
repository/PeopleRepository.java      ReactiveCrudRepository
repository/UsersRepository.java       findByUsername / findByEmail / existsBy*
repository/RegistrationsRepository.java
dto/RegisterRequest.java
dto/RegisterResponse.java
dto/LoginRequest.java
dto/LoginResponse.java
service/RegisterService.java          Transacción: people -> users -> registrations
service/LoginService.java             Validación BCrypt por usuario o correo
controller/RegisterController.java    POST /auth/register
controller/LoginController.java       POST /auth/login
exception/ApiException.java           Excepción con estado HTTP
exception/GlobalExceptionHandler.java Respuestas de error { "error": "..." }
```

Nota de diseño: las entidades implementan `Persistable<UUID>` con `isNew()=true`
para que Spring Data R2DBC ejecute `INSERT` (si el id ya viene pre-generado,
de lo contrario ejecuta `UPDATE` y no inserta nada — bug encontrado en desarrollo).

## Endpoints

### 1. Registro — `POST /auth/register`
Público. Crea `people` + `users` + `registrations` en una transacción.
La contraseña se guarda hasheada con BCrypt.

```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"juan","password":"mipass","firstName":"Juan","lastName":"Perez","email":"juan@correo.com","phone":"999888777"}'
```

Respuesta `201 Created`:
```json
{
  "id": "4fb8dc69-...",
  "username": "juan",
  "email": "juan@correo.com",
  "status": "APPROVED"
}
```

Errores:
- `400` campos obligatorios vacíos
- `409` correo o usuario ya registrado (mensaje en `error`)
- `500` error interno

### 2. Login — `POST /auth/login`
Público. Valida credenciales contra la tabla `users` (por **usuario o correo**)
comparando la contraseña con BCrypt.

```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"juan","password":"mipass"}'
```

Respuesta `200 OK`:
```json
{
  "id": "4fb8dc69-...",
  "username": "juan",
  "email": "juan@correo.com",
  "displayName": "Juan Perez",
  "firstName": "Juan",
  "lastName": "Perez"
}
```

Errores:
- `400` usuario/contraseña vacíos
- `401` credenciales incorrectas (`{"error":"Usuario o contraseña incorrectos"}`)
- `403` usuario bloqueado o inactivo

## Seguridad
- `SecurityConfig` deshabilita CSRF/form login y deja permitido `/auth/**`.
- `BCryptPasswordEncoder` como único `PasswordEncoder`.
- La contraseña nunca se almacena ni se transmite en texto plano; solo hash
  BCrypt en `users.password_hash`.

## Usuario inicial de desarrollo
Creado durante las pruebas vía `POST /auth/register`:

| Campo | Valor |
|---|---|
| Usuario | `admin` |
| Contraseña | `1234` |
| Correo | `admin@chemxr.com` |

Para crear más usuarios, usa `POST /auth/register` (o regístrate desde la app).

## Ver la data
```bash
docker exec chemdb psql -U maximus -d chemdb
SELECT id, username, email, is_active, password_hash FROM users;
SELECT username, email, status FROM registrations;
```

## Pendientes
- [ ] Tokens OAuth2 / sesiones seguras (hoy el login devuelve datos sin token)
- [ ] Endpoints de cursos, grupos, módulos (hoy la app los muestra hardcodeados)
- [ ] Compondría integrar Google/Facebook con el backend