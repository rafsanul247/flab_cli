
# 🚀 FLAB CLI (Flutter Architecture & Booster)

[![Pub Version](https://img.shields.io/pub/v/flab.svg?style=flat-square&color=blue)](https://pub.dev/packages/flab)
[![Dart SDK](https://img.shields.io/badge/Dart-3.0+-0175C2.svg?style=flat-square&logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![GitHub](https://img.shields.io/badge/GitHub-rafsanul247%2Fflab__cli-181717.svg?style=flat-square&logo=github)](https://github.com/rafsanul247/flab_cli)

**FLAB** is an enterprise-grade Command Line Interface (CLI) tool designed to accelerate Flutter application development. It automates project initialization, feature scaffolding across multiple architecture patterns (**Clean Architecture**, **MVVM**, **MVC**), dependency injection setup, production-ready theme engines, responsive utilities, networking, and offline caching.

---

## 📑 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Architecture & Folder Structure](#-architecture--folder-structure)
  - [Generated Project Structure](#generated-project-structure)
  - [Clean Architecture Feature Structure](#clean-architecture-feature-structure)
- [Command Reference](#-command-reference)
  - [Project Initialization (`init`)](#1-project-initialization-init)
  - [Feature Scaffolding](#2-feature-scaffolding)
  - [Feature Lifecycle Management](#3-feature-lifecycle-management)
  - [Modular Configuration (`config`)](#4-modular-configuration-config)
  - [Pubspec Optimization (`clean pubspec`)](#5-pubspec-optimization-clean-pubspec)
  - [Diagnostics & Utilities (`doctor`, `tree`)](#6-diagnostics--utilities-doctor-tree)
- [Pre-configured Tech Stack](#-pre-configured-tech-stack)
- [CLI Command Cheat Sheet](#-cli-command-cheat-sheet)
- [Contributing](#-contributing)
- [License](#-license)
- [Author](#-author)

---

## ✨ Features

- ⚡ **Full Project Bootstrapping (`flab init`)**: Generate a production-ready Flutter app with pre-installed industry standard packages, structured asset directories, routing, theme systems, and dependency injection in seconds.
- 🏛️ **Multi-Architecture Support**:
  - **Clean Architecture** (Data, Domain, and Presentation separation).
  - **MVVM** (Model-View-ViewModel).
  - **MVC** (Model-View-Controller).
- 💉 **Automated Dependency Injection**: Automatically updates `lib/injection.dart` (`GetIt`) when adding, renaming, or removing features without manual registration boilerplate.
- 🎨 **Enterprise Theme & Design System**: Complete light & dark mode setups, typography with `flutter_screenutil`, curated color palette (`UColors`), spacing/sizes (`USizes`), and individual widget themes (AppBar, Buttons, BottomSheet, Checkbox, Chip, TextField).
- 🌐 **Production Networking & Storage**:
  - Pre-configured `DioClient` with logging (`PrettyDioLogger`), token management, custom error interceptors, and timeouts.
  - Offline local caching via `Hive` (`StorageService`).
  - Network connectivity checker (`NetworkInfo` via `connectivity_plus`).
- 🛠️ **Context Extensions & Helpers**: Device screen utilities, orientation handlers, responsive helpers, snackbars, and navigation shortcuts via `UDeviceHelper` and `BuildContext` extensions.
- 🧹 **Project Maintenance Tools**: Visual tree generator (`flab tree`), environment health check (`flab doctor`), and pubspec comment cleaner with asset auto-registration (`flab clean pubspec`).

---

## 📦 Installation

### Global Activation via Pub

Activate `flab` globally using the Dart package manager:

```bash
dart pub global activate flab
```

### Install from Source (GitHub)

```bash
dart pub global activate --source git https://github.com/rafsanul247/flab_cli.git
```

### Verify Installation

Check if the CLI is accessible from your terminal:

```bash
flab --version
# Output: FLAB CLI Version: 1.0.4

flab --help
```

> **Note**: Ensure your Dart global pub cache directory is added to your system's `PATH` environment variable:
> - **Windows**: `%LOCALAPPDATA%\Pub\Cache\bin`
> - **macOS / Linux**: `$HOME/.pub-cache/bin`

---

## 🚀 Quick Start

### 1. Create and Configure a New Project

Initialize a new Flutter project named `my_app`:

```bash
flab init my_app
```

This command will:
1. Run `flutter create my_app`.
2. Clean `pubspec.yaml` and configure asset directories.
3. Automatically install: `dio`, `hive`, `hive_flutter`, `get_it`, `go_router`, `google_fonts`, `connectivity_plus`, `pretty_dio_logger`, and `flutter_screenutil`.
4. Generate the full `core` architecture (Themes, Constants, Routes, Network, Hive, Helpers).
5. Set up `lib/injection.dart`, `lib/app.dart`, and `lib/main.dart`.
6. Fix `test/widget_test.dart` to link with the new entry point.

### 2. Configure an Existing Flutter Project

Navigate to your existing Flutter project and run:

```bash
cd existing_flutter_project
flab init
```

### 3. Generate Features

Generate a Clean Architecture feature with the default GetX state management:

```bash
flab authentication
```

To choose Provider, Riverpod, GetX, or Bloc interactively:

```bash
flab authentication --clean
flab profile --mvvm
flab dashboard --mvc
```

---

## 🏗️ Architecture & Folder Structure

### Generated Project Structure

```
my_app/
├── assets/
│   ├── animations/
│   ├── icons/
│   └── images/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── colors.dart         # UColors palette
│   │   │   ├── sizes.dart          # USizes responsive constants
│   │   │   └── texts.dart          # App strings & labels
│   │   ├── extensions/
│   │   │   └── context_extension.dart # BuildContext helpers (themes, navigation, dimensions)
│   │   ├── helpers/
│   │   │   └── device_helpers.dart # UDeviceHelper (platform, keyboard, screen metrics)
│   │   ├── network/
│   │   │   ├── dio_client.dart     # Configured Dio with interceptors & logger
│   │   │   └── network_info.dart   # Connectivity monitor
│   │   ├── routes/
│   │   │   └── app_router.dart     # GoRouter configuration & routes
│   │   ├── services/
│   │   │   └── hive_service.dart   # StorageService with Hive box operations
│   │   ├── theme/
│   │   │   ├── app_theme.dart      # UAppTheme (light & dark theme data)
│   │   │   ├── text_theme.dart     # UTextTheme responsive text typography
│   │   │   └── widgets_theme/      # Modular component themes
│   │   │       ├── appbar_theme.dart
│   │   │       ├── botton_sheet_theme.dart
│   │   │       ├── checkbox_theme.dart
│   │   │       ├── chip_theme.dart
│   │   │       ├── elevated_button_theme.dart
│   │   │       ├── outlined_button_theme.dart
│   │   │       └── text_field_theme.dart
│   │   └── utils/
│   │       ├── api_endpoint.dart   # Base URLs and endpoint constants
│   │       └── app_logger.dart     # Colored console logger
│   ├── features/                   # Application features / modules
│   ├── app.dart                    # ScreenUtilInit & MaterialApp.router setup
│   ├── injection.dart              # GetIt service locator registrations
│   └── main.dart                   # Application bootstrap with Hive & DI init
├── test/
│   └── widget_test.dart            # Synchronized test configuration
└── pubspec.yaml                    # Cleaned dependencies & registered assets
```

### Clean Architecture Feature Structure

When running `flab <feature_name>` or `flab <feature_name> --clean`:

```
lib/features/<feature_name>/
├── data/
│   ├── data_sources/
│   │   └── <feature_name>_data_source.dart         # Remote/Local data source contract & Dio implementation
│   ├── models/
│   │   └── <feature_name>_model.dart               # JSON serialization model
│   └── repositories/
│       └── <feature_name>_repository_implement.dart # Concrete repository implementation
├── domain/
│   ├── entities/
│   │   └── <feature_name>_entity.dart              # Core business entity
│   ├── repositories/
│   │   └── <feature_name>_repository.dart          # Abstract repository interface
│   └── usecases/
│       └── <feature_name>_usecase.dart             # Business logic use cases
└── presentation/
    ├── manager/                                    # Generated for Clean + GetX
    │   └── controller/
    │       └── <feature_name>_controller.dart      # GetX feature controller/state holder
    ├── views/
        ├── widgets/                                # Feature-specific widgets
        └── <feature_name>_screen.dart              # UI view screen
    └── state/
      └── <feature_name>_<state_management>.dart  # Provider, Riverpod, or Bloc starter
```

For Clean Architecture with GetX, the manager controller is used as the state holder, so no separate `presentation/state` GetX file is generated. When Provider, Riverpod, or Bloc is selected, the matching starter state file is generated instead.

---

## 💻 Command Reference

### 1. Project Initialization (`init`)

Initialize a brand new Flutter project or inject FLAB architecture into an existing one:

```bash
# Create a new Flutter app with complete setup
flab init <app_name>

# Initialize within current Flutter directory
flab init
```

---

### 2. Feature Scaffolding

Scaffold features according to your preferred architectural pattern:

#### Clean Architecture with GetX (Default)
```bash
flab auth
```
> *Generates Clean Architecture layers with a manager controller and installs the `get` package.*

#### Clean Architecture with Selected State Management
```bash
flab auth --clean
```
> *The CLI asks you to choose Provider, Riverpod, GetX, or Bloc and installs the matching package. Provider, Riverpod, and Bloc generate a starter state file; GetX uses the manager controller instead.*

#### MVVM Architecture
```bash
flab profile --mvvm
```
The CLI asks you to choose Provider, Riverpod, GetX, or Bloc, installs the matching package, and generates `models/`, `viewmodels/`, `views/`, and a state-management starter file.

#### MVC Architecture
```bash
flab dashboard --mvc
```
The CLI asks you to choose Provider, Riverpod, GetX, or Bloc, installs the matching package, and generates `models/`, `controllers/`, `views/`, and a state-management starter file with starter MVC model and controller classes.

#### Granular Component Generation
Generate specific components directly inside a feature:

```bash
# Generate a dedicated UseCase inside lib/features/auth/domain/usecases/
flab auth -u LoginUser

# Generate Model & Entity inside data/models and domain/entities
flab auth -m User
```

---

### 3. Feature Lifecycle Management

Keep your codebase clean with automated feature management:

```bash
# List all active features
flab list

# Safely delete a feature (removes folder, test directory, and unbinds from injection.dart)
flab rm <feature_name>

# Rename a feature (renames folder, updates imports, and re-registers in injection.dart)
flab rename <old_name> <new_name>
```

---

### 4. Modular Configuration (`config`)

Inject specific architectural modules individually into any Flutter project:

```bash
# Injects themes, constants, widgets_theme, helpers, context extension, and router
flab config theme

# Creates assets/animations, assets/icons, and assets/images directories
flab config assets

# Sets up Dio client, NetworkInfo, Hive StorageService, and lib/injection.dart
flab config backend

# Injects ApiEndpoints and AppLogger
flab config utils

# Injects production-ready app.dart and main.dart (with ScreenUtil & GoRouter integration)
flab config main
```

---

### 5. Pubspec Optimization (`clean pubspec`)

Cleans up boilerplate comments generated by Flutter in `pubspec.yaml`, automatically configures asset directories, and ensures proper YAML structure:

```bash
flab clean pubspec
```

---

### 6. Diagnostics & Utilities (`doctor`, `tree`)

```bash
# Check if the current environment is a valid Flutter workspace
flab doctor
# or
flab health

# Display an ASCII tree diagram of the lib/ folder
flab tree
```

---

## 🛠️ Pre-configured Tech Stack

Projects created or configured with `flab` come pre-equipped with industry standard, production-ready packages:

| Package | Purpose |
|---|---|
| [`get_it`](https://pub.dev/packages/get_it) | Fast Service Locator for Dependency Injection |
| [`go_router`](https://pub.dev/packages/go_router) | Declarative routing package for Flutter |
| [`dio`](https://pub.dev/packages/dio) | Powerful HTTP client with interceptors & global configuration |
| [`dartz`](https://pub.dev/packages/dartz) | Functional programming — `Either` for typed error handling |
| [`pretty_dio_logger`](https://pub.dev/packages/pretty_dio_logger) | Formatted network request and response logging |
| [`hive`](https://pub.dev/packages/hive) & [`hive_flutter`](https://pub.dev/packages/hive_flutter) | Lightweight and blazingly fast key-value offline storage |
| [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil) | Responsive UI adaptation and text scaling |
| [`google_fonts`](https://pub.dev/packages/google_fonts) | Modern typography and font management |
| [`connectivity_plus`](https://pub.dev/packages/connectivity_plus) | Network connectivity monitoring |
| [`get`](https://pub.dev/packages/get) | Default GetX state management for features |
| [`provider`](https://pub.dev/packages/provider) | Optional state management selected during scaffolding |
| [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) | Optional state management selected during scaffolding |
| [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) | Optional state management selected during scaffolding |

---

## 📋 CLI Command Cheat Sheet

| Command | Arguments / Flags | Description |
|---|---|---|
| `flab init` | `[appName]` | Initialize new or configure current Flutter project |
| `flab <feature>` | — | Clean Architecture with GetX by default |
| `flab <feature>` | `--clean` | Clean Architecture with interactive state-management selection |
| `flab <feature>` | `--mvvm` | MVVM with interactive state-management selection |
| `flab <feature>` | `--mvc` | MVC with interactive state-management selection |
| `flab <feature>` | `-u, --usecase <Name>` | Generate a dedicated UseCase file |
| `flab <feature>` | `-m, --model <Name>` | Generate Model and Entity files |
| `flab list` | — | List all existing features |
| `flab rm` | `<feature>` | Remove feature directory and unbind from `injection.dart` |
| `flab rename` | `<old>` `<new>` | Rename feature directory and update `injection.dart` |
| `flab config theme` | — | Inject theme engine, colors, sizes, and context extensions |
| `flab config assets`| — | Create standardized asset folder structure |
| `flab config backend`| — | Inject Dio, Hive storage service, and DI skeleton |
| `flab config utils` | — | Inject API endpoints and logger utilities |
| `flab config main`  | — | Inject responsive `main.dart` and `app.dart` |
| `flab clean pubspec`| — | Remove comments from pubspec & link assets automatically |
| `flab doctor`       | — | Run environment diagnostics |
| `flab tree`         | — | Print visual directory hierarchy of `lib/` |
| `flab --help`, `-h` | — | Show CLI help guide |
| `flab --version`, `-v`| — | Show installed FLAB version |

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repository on [GitHub](https://github.com/rafsanul247/flab_cli).
2. Create your feature branch (`git checkout -b feature/amazing-feature`).
3. Commit your changes (`git commit -m 'feat: add amazing feature'`).
4. Push to the branch (`git push origin feature/amazing-feature`).
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Rafsanul Rifat**
- GitHub: [@rafsanul247](https://github.com/rafsanul247)
- Repository: [rafsanul247/flab_cli](https://github.com/rafsanul247/flab_cli)
