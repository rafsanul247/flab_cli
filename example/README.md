# FLAB CLI Example

This directory contains an example demonstrating the usage of the **FLAB CLI** tool.

## Running the Example

To run the Dart example demonstration script:

```bash
dart run example/example.dart
```

## Quick CLI Usage Overview

### 1. Global Activation
```bash
dart pub global activate flab
```

### 2. Project Initialization
```bash
# Initialize a brand-new Flutter project
flab init my_app

# Or configure inside an existing Flutter project
cd existing_project
flab init
```

### 3. Generate Features
```bash
# Clean Architecture (Default with GetIt DI)
flab auth --clean

# MVVM Architecture
flab profile --mvvm

# MVC Architecture
flab settings --mvc
```

### 4. Lifecycle & Configuration
```bash
# List features
flab list

# Rename feature
flab rename auth authentication

# Remove feature (auto cleans DI)
flab rm old_feature

# Inject individual modules
flab config theme
flab config backend
flab config assets
```
