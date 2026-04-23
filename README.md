# General README

# API REST ChemXR
The purpose it's to connect the database and the clients, cleanly.

# Database
Postgres + r2dbc

# Main Libraries,plugins,extensions
gradle + spring + r2dbc + webflux + oauth2 + prometheus

# Security
You need to have KeyCloak running and configured in order to continue, it uses `Jwt + Keycloak`

# How to run
To execute the project just run

```bash
gradle bootRun
```
