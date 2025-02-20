# AllTech App

Aplicación Flutter que implementa un sistema de autenticación y gestión de usuarios utilizando el patrón GetX.

## Características

- 🔐 Sistema de autenticación completo (Login/Logout)
- 🔄 Refresh Token automático
- 👥 Gestión de usuarios
- 📱 Perfil de usuario (propio y de otros usuarios)
- 💾 Almacenamiento persistente de sesión

## Tecnologías

- Flutter SDK: ^3.6.2
- GetX: ^4.6.6 (State Management, Route Management, Dependency Injection)
- get_storage: ^2.1.1 (Almacenamiento persistente)
- path_provider: ^2.1.1

## Estructura del Proyecto

La aplicación sigue el patrón GetX Pattern generado por get_cli:

```
lib/
├── app/
│   ├── core/
│   │   ├── models/
│   │   │   ├── api_response.dart
│   │   │   └── base_provider.dart
│   ├── modules/
│   │   ├── auth/
│   │   │   └── login/
│   │   │       ├── bindings/
│   │   │       ├── controllers/
│   │   │       ├── views/
│   │   │       └── providers/
│   │   └── users/
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── services/
│       └── storage_service.dart
└── main.dart
```

## Configuración

1. Clona el repositorio
2. Ejecuta `flutter pub get`
3. Configura la URL base en `base_provider.dart`

## API Endpoints

```
BASE_URL: http://localhost:3000

Autenticación:
- POST /auth/login/user
- POST /auth/token-refresh
- POST /logout

Usuarios:
- GET /users
- GET /users/{id}
```

## Características Principales

### Sistema de Autenticación

- Login con credenciales
- Manejo automático de tokens
- Refresh token automático
- Logout
- Persistencia de sesión opcional

### Gestión de Usuarios

- Lista de usuarios
- Perfil de usuario detallado
- Visualización de perfil propio
- Refresh de usuarios

### Middleware y Seguridad

- Interceptores para tokens
- Manejo automático de errores 401
- Protección de rutas (AutghMiddleware)
- Almacenamiento seguro de credenciales (Get Storage)

## Uso

### Iniciar Sesión
```dart
Get.toNamed(Routes.AUTH_LOGIN);
```

### Ver Perfil de Usuario
```dart
Get.toNamed(Routes.USERS_PROFILE, arguments: {'userId': userId});
```

### Cerrar Sesión
```dart
await Get.find<StorageService>().clearTokens();
Get.offAllNamed(Routes.AUTH_LOGIN);
```

## BaseProvider

La aplicación utiliza un BaseProvider que maneja:
- Configuración de headers
- Refresh token automático
- Interceptores de peticiones
- Manejo de errores común


## Comandos Get CLI

### Instalación de Get CLI
```bash
flutter pub global activate get_cli
```

### Comandos Básicos

1. Crear un nuevo proyecto
```bash
get create project:my_project
```

2. Crear un nuevo módulo (incluye binding, controller, view)
```bash
get create page:users/profile
```

Esto generará:
```
lib/app/modules/users/profile/
├── bindings/
│   └── profile_binding.dart
├── controllers/
│   └── profile_controller.dart
└── views/
    └── profile_view.dart
```

3. Crear componentes individuales
```bash
# Crear controlador
get create controller:user_controller on users

# Crear vista
get create view:user_view on users

# Crear provider/servicio
get create provider:user_provider on users/providers
```

4. Crear modelo desde JSON
```bash
# Crear carpeta para el JSON
mkdir -p assets/models

# Crear el modelo o crear manualmente
get generate model on users/models with assets/models/user.json
```

### Ejemplo Completo: Módulo de Usuarios

1. Crear el módulo
```bash
get create page:users/list
```

2. Crear el provider
```bash
get create provider:user_provider on users/providers
```

3. Crear modelo (si tienes un JSON)
```bash
get generate model on users/models with assets/models/user.json
```

La estructura resultante será:
```
lib/app/modules/users/
├── list/
│   ├── bindings/
│   │   └── list_binding.dart
│   ├── controllers/
│   │   └── list_controller.dart
│   └── views/
│       └── list_view.dart
├── models/
│   └── user_model.dart
└── providers/
    └── user_provider.dart
```

Las rutas se generarán automáticamente en:
```
lib/app/routes/
├── app_pages.dart
└── app_routes.dart
```

### Comandos Adicionales

```bash
# Inicializar GetX en proyecto existente
get init

# Instalar dependencias
get install camera path

# Remover dependencias
get remove http

# Actualizar Get CLI
get update
```
## Referencias y Recursos Útiles

### Documentación Oficial
- [GetX - Pub.dev](https://pub.dev/packages/get)
- [GetX Documentation](https://github.com/jonataslaw/getx/blob/master/README.md)
- [GetX Pattern](https://github.com/kauemurakami/getx_pattern)

### Herramientas
- [Get CLI](https://pub.dev/packages/get_cli)
- [get_storage](https://pub.dev/packages/get_storage)

### Tutoriales y Guías
- [Get CLI Commands](https://github.com/jonataslaw/get_cli)

### Ejemplos
- [Getx Calculadora](https://www.youtube.com/watch?v=woGWx_lmbfw)
- [GetX Examples](https://github.com/jonataslaw/getx/tree/master/example)
