# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-09-04

### Added
- **Project Initialization (`flab init`)**:
  - Full Flutter application bootstrapping with a single command (`flab init <appName>`).
  - Interactive project naming and validation if executed without arguments.
  - In-place project initialization when executed inside an existing Flutter workspace.
  - Automatic installation of essential industry-standard dependencies (`dio`, `hive`, `hive_flutter`, `get_it`, `go_router`, `google_fonts`, `connectivity_plus`, `pretty_dio_logger`, `flutter_screenutil`).
  - Automatic physical asset folder creation (`assets/animations`, `assets/icons`, `assets/images`).
  - Automatic `test/widget_test.dart` synchronization with the generated `app.dart` root.

- **Multi-Architecture Feature Generator**:
  - **Clean Architecture** feature generator (`flab <Feature> --clean`):
    - Data Layer: Remote/Local Data Sources, Models with JSON serialization, Repository implementations.
    - Domain Layer: Abstract Repositories, UseCases.
    - Presentation Layer: Responsive views/screens and feature controllers.
  - **MVVM Architecture** scaffolding (`flab <Feature> --mvvm`).
  - **MVC Architecture** scaffolding (`flab <Feature> --mvc`).
  - Granular component scaffolding:
    - Dedicated UseCase injection via `-u, --usecase <UseCaseName>`.
    - Model & Entity generation via `-m, --model <ModelName>`.

- **Automated Dependency Injection**:
  - Auto-registration of Data Sources, Repositories, UseCases, and Controllers directly into `lib/injection.dart` using `GetIt`.
  - Automatic clean-up of DI registrations when features are removed.
  - Automatic update of DI bindings when features are renamed.

- **Feature Lifecycle Management**:
  - `flab list`: Lists all active features in `lib/features/`.
  - `flab rm <Feature>`: Safely deletes feature folder, corresponding test folder, and cleans up DI bindings.
  - `flab rename <Old> <New>`: Safely renames feature directories, test paths, and updates DI registrations.

- **Modular Configuration Subcommands (`flab config`)**:
  - `flab config theme`: Injects comprehensive theme system (`UAppTheme`, `UTextTheme`), color constants (`UColors`), size tokens (`USizes`), device helpers (`UDeviceHelper`), `BuildContext` extensions, and modular widget themes (AppBar, BottomSheet, Checkbox, Chip, Buttons, TextField).
  - `flab config assets`: Creates physical asset directories.
  - `flab config backend`: Injects `DioClient` (with interceptors and `PrettyDioLogger`), `NetworkInfo`, Hive `StorageService`, and base `injection.dart`.
  - `flab config utils`: Injects `ApiEndpoints` and `AppLogger`.
  - `flab config main`: Injects clean `main.dart` and responsive `app.dart` integrated with `ScreenUtilInit` and `GoRouter`.

- **Maintenance & Developer Utilities**:
  - `flab clean pubspec`: Strips default comment clutter from `pubspec.yaml`, automatically adds asset folders, and formats the `flutter:` block.
  - `flab doctor` / `flab health`: Diagnostic utility to verify if current directory is a valid Flutter project.
  - `flab tree`: Visual ASCII tree generator for `lib/` directory structure.
  - `flab --help` / `flab -h`: Interactive help guide and styled ASCII art banner.
  - `flab --version` / `flab -v`: Version information output.

### Changed
- Standardized CLI command name and binary executable to `flab`.