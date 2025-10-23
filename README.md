# DVPartners Tech Test

Aplicación Flutter para prueba técnica de gestión de usuarios con direcciones.

## Descripción

Esta aplicación demuestra el manejo de usuarios con sus direcciones, implementando:

- **Clean Architecture** con separación de capas (Domain, Data, Presentation, Core)
- **Principios SOLID** aplicados en toda la arquitectura
- **BLoC Pattern** para manejo de estado
- **Animaciones** con `TweenAnimationBuilder` y `AnimationController`
- **Base de datos SQLite** con `sqflite`
- **Inyección de dependencias** con `GetIt`
- **Testing completo** con unit tests y widget tests

## Patrones de Diseño Implementados (Solo lo necesario)

- **Factory Pattern**: `AnimationContainer.fromRight()`, `Button.icon()`, `Button.loading()`

## Arquitectura

```
lib/
├── core/                    # Configuración y utilidades
├── data/                    # Capa de datos (repositorios, servicios)
├── domain/                  # Entidades y casos de uso
└── presentation/            # UI, widgets y estado (BLoC)

```

## Comandos

### Instalación

```bash
flutter pub get
```

### Ejecutar la aplicación

```bash
flutter run
```

### Ejecutar tests

```bash

flutter test
```

### Generar mocks (Por si es necesario)

```bash
flutter packages pub run build_runner build
```
