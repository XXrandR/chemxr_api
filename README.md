# ChemXR API — Spring Boot 4 + Flyway V1 (solo app)

Proyecto ajustado a partir de tu `chemxr_api.rar`. Mantiene Spring Boot **4.0.5**, Java **25**, WebFlux, R2DBC y OAuth2 Resource Server tal como estaban. Se añadió exclusivamente la infraestructura de migración PostgreSQL y la nueva base de datos `app`.

## Qué cambió

- `build.gradle`: se agregó `spring-boot-starter-flyway` y `flyway-database-postgresql` compatibles con Spring Boot 4. Flyway usa PostgreSQL JDBC existente.
- `src/main/resources/application.properties`: la API sigue con R2DBC; Flyway usa conexión JDBC independiente. Datos de conexión en `.env` local.
- `src/main/resources/db/migration/V1__create_chemxr_app.sql`: primera y ÚNICA migración; **182 tablas** de `app`, 732 relaciones FK, índices, comentarios y catálogos.
- `compose-db.yml`: elimina la ejecución automática del SQL antiguo, fija PostgreSQL 17, agrega un volumen persistente.
- `init_chemdb.sql`: se elimina del proyecto entregado. No hay migraciones para autenticación.
- `.env`: generado para **desarrollo local**, contiene la contraseña local de este paquete. No subir a Git. Renovarla antes de reutilizar fuera de un entorno de pruebas.

## Pasos en Windows (PowerShell / terminal de IntelliJ)

1. **Usa una base NUEVA**, dedicada a la V1. Si el contenedor antiguo `chemdb` sigue activo, detén el proyecto anterior primero. No ejecutes Flyway sobre tablas preexistentes de `app`. Evita borrar bases con información importante.
2. Abre `chemxr_api` como proyecto Gradle en IntelliJ y deja que resuelva dependencias.
3. Desde el directorio donde está `compose-db.yml`:

   ```powershell
   docker compose -f compose-db.yml up -d
   docker compose -f compose-db.yml ps
   ```

4. Ejecuta el backend desde el directorio del proyecto:

   ```powershell
   .\gradlew.bat bootRun
   ```

5. Flyway se ejecuta automáticamente al iniciar Spring Boot: crea `app`, su tabla `flyway_schema_history` y aplica `V1__create_chemxr_app.sql`. La API usa R2DBC para el resto.
6. Comprueba en pgAdmin o consola SQL:

   ```sql
   SELECT installed_rank, version, description, success
   FROM app.flyway_schema_history ORDER BY installed_rank;

   SELECT COUNT(*) AS tablas_chemxr
   FROM information_schema.tables
   WHERE table_schema = 'app' AND table_type = 'BASE TABLE'
     AND table_name <> 'flyway_schema_history';
   -- Esperado: 182
   ```

## ⚠️ Si ya tienes `chemdb` inicializada con el SQL anterior

Flyway está configurado con `baseline-on-migrate=false`: evitará usar una BD preexistente como V1 sin advertir. Para desarrollo puedes crear una **base nueva limpia**. No se recomienda eliminar datos sin respaldo. Si quieres reiniciar únicamente el Docker Compose nuevo y sus volúmenes, `docker compose -f compose-db.yml down -v` **BORRA LA BD y todos sus datos**: ejecutarlo solo si estás seguro de que no se necesita nada.

## Para IntelliJ

Si utilizas **Run / Debug** en lugar de `bootRun`, asegúrate de que **Working directory** sea la raíz de `chemxr_api` para que Spring pueda leer `.env`, o establece `CHEMXR_DB_PASSWORD` en las variables de entorno de la ejecución.

## Qué queda expresamente fuera

- No se crea, modifica, elimina o documenta ningún objeto dentro del esquema de autenticación. La integración futura del proveedor OAuth2 queda a cargo de su propia configuración/migraciones.
- No se mantiene ni se ejecuta `init_chemdb.sql` en Docker.
- No se integra el plugin Gradle de Flyway (no es necesario para la ejecución automática con Spring Boot).
- Este paquete no contiene nuevas implementaciones de endpoints, servicios o repositorios: únicamente estructura de BD e integración de Flyway.

## Comprobaciones

Análisis estático: 182 tablas únicas, 732 referencias FK internas resueltas, sin referencia a autenticación y sin sentencias DROP. No se ha ejecutado aquí `gradlew bootRun` ni PostgreSQL real (requieren descargar dependencias y tener una instancia de PostgreSQL).

**Importante:** la base de datos es una propuesta funcional amplia. Aún hacen falta revisiones de permisos multitenant, seguridad, integridad de negocio, pruebas en PostgreSQL, y consensuar con el equipo las reglas de cada módulo antes de producción.
