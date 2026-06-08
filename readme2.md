# ChemXR API - Autenticación OAuth2

## Cambios realizados

### 1. `build.gradle`
- Se agregó la dependencia `spring-boot-starter-oauth2-client` para habilitar el login con OAuth2 (Google y Facebook).

### 2. `src/main/resources/application.yml`
Se creó este archivo reemplazando el uso de `application.properties` con los siguientes cambios:
- Configuración de OAuth2 Client para **Google** y **Facebook** con variables de entorno (`GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `FACEBOOK_CLIENT_ID`, `FACEBOOK_CLIENT_SECRET`).
- Configuración de R2DBC para PostgreSQL con variables de entorno y valores por defecto.
- Puerto del servidor: `8080`.

### 3. `src/main/java/com/adrom/chemxr_api/config/SecurityConfig.java` (Nuevo)
Configuración de seguridad reactiva (WebFlux):
- **OAuth2 Login** con Google y Facebook mediante `oauth2Login()`.
- **CORS** permitido para `http://localhost:5173` y `http://localhost:3000`.
- **CSRF deshabilitado** para API REST.
- Redirección post-login a `http://localhost:5173/login-success`.
- Endpoints públicos: `/login**`, `/oauth2/**`.
- El resto de rutas requiere autenticación.

### 4. `src/main/java/com/adrom/chemxr_api/web/UserController.java` (Nuevo)
Endpoint `GET /user/me` que retorna los datos del usuario autenticado vía OAuth2:
```json
{
  "email": "usuario@gmail.com",
  "name": "Usuario",
  "picture": "https://...",
  "roles": ["ROLE_USER"]
}
```

### 5. `src/main/java/com/adrom/chemxr_api/dto/UserInfo.java` (Nuevo)
Record DTO para la respuesta de `/user/me`.

### 6. `src/test/java/.../ChemxrApiApplicationTests.java`
Se agregaron propiedades mock para OAuth2 en el test de contexto.

---

## Cómo ejecutar

### Prerrequisitos
1. Tener Docker corriendo con PostgreSQL (puerto `5435`):
   ```bash
   docker compose -f compose-db.yml up -d
   ```

2. Registrar las apps:
   - **Google**: https://console.cloud.google.com → credentials → OAuth 2.0 → URI de redirección: `http://localhost:8080/login/oauth2/code/google`
   - **Facebook**: https://developers.facebook.com → app → OAuth → URI de redirección: `http://localhost:8080/login/oauth2/code/facebook`

### Ejecutar
```bash
export GOOGLE_CLIENT_ID="..."
export GOOGLE_CLIENT_SECRET="..."
export FACEBOOK_CLIENT_ID="..."
export FACEBOOK_CLIENT_SECRET="..."
./gradlew bootRun
```

### Compilar
```bash
./gradlew build
```

### Endpoints
- `GET http://localhost:8080/login` — Redirige al login de Google/Facebook
- `GET http://localhost:8080/user/me` — Info del usuario autenticado
- `GET http://localhost:8080/actuator` — Health check
