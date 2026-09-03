import 'dart:io';
import 'package:args/args.dart';
import 'package:ftool_cli/src/templates.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;

final Logger _logger = Logger();

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help guide')
    ..addFlag('version', abbr: 'v', negatable: false, help: 'Show version')
    ..addFlag('clean', negatable: false)
    ..addFlag('mvc', negatable: false)
    ..addFlag('mvvm', negatable: false)
    ..addFlag('bloc', negatable: false)
    ..addFlag('getx', negatable: false)
    ..addFlag('provider', negatable: false)
    ..addOption('usecase', abbr: 'u')
    ..addOption('model', abbr: 'm')
    ..addOption('repository', abbr: 'r')
    ..addOption('datasource', abbr: 'd')
    ..addOption('sm');

  ArgResults results;
  try {
    results = parser.parse(arguments);
  } catch (e) {
    _logger.err('Invalid command usage. Run "ftool --help" for options.');
    return;
  }

  if (results['help'] as bool || arguments.contains('help')) {
    _printHelp();
    return;
  }

  if (results['version'] as bool || arguments.contains('-v')) {
    _logger.info('FTOOL CLI Version: 1.0.0');
    return;
  }

  if (arguments.isEmpty) {
    _printHelp();
    return;
  }

  final command = arguments.first;

  // Handle specific non-feature commands
  switch (command) {
    case 'init':
      final appName = arguments.length > 1 ? arguments[1] : null;
      await _handleInit(appName);
      return;
    case 'doctor':
    case 'health':
      _runDoctor();
      return;
    case 'tree':
      _showTree();
      return;
    case 'list':
      _listFeatures();
      return;
    case 'rm':
      if (arguments.length > 1) _removeFeature(arguments[1]);
      return;
    case 'rename':
      if (arguments.length > 2) {
        _renameFeature(arguments[1], arguments[2]);
      } else {
        _logger.err('Usage: ftool rename <OldName> <NewName>');
      }
      return;
    case 'clean':
      if (arguments.length > 1 && arguments[1] == 'pubspec') {
        _cleanPubspec();
      }
      return;
    case 'config':
      await _handleConfig(arguments);
      return;
  }

  // Feature Scaffolding Entrypoint
  _handleFeatureCreation(command, results);
}

// ─────────────────────────────────────────────────────────────
// PROJECT INITIALIZATION ENGINE
// ─────────────────────────────────────────────────────────────

Future<void> _handleInit(String? appName) async {
  _logger.info('''
============================================================
             🚀 Flutter Project Initialization              
============================================================
''');

  final pubspec = File('pubspec.yaml');
  String validAppName = appName ?? '';

  if (!pubspec.existsSync()) {
    while (validAppName.isEmpty || !_isValidFlutterAppName(validAppName)) {
      stdout.write('App name (lowercase, underscores only): ');
      validAppName = stdin.readLineSync()?.trim() ?? '';
    }

    _logger.info('\nCreating Flutter project "$validAppName"...');

    final process = await Process.run(
      'flutter', 
      ['create', validAppName], 
      runInShell: true,
    );

    if (process.exitCode == 0) {
      _logger.success('✅ Flutter project "$validAppName" created successfully!');
      Directory.current = Directory(validAppName);

      // Auto Execution Tasks
      _cleanPubspec();
      await _installDependencies();
      await _handleConfig(['config', 'theme']);
      await _handleConfig(['config', 'assets']);
      await _handleConfig(['config', 'backend']);
      await _handleConfig(['config', 'utils']);
      await _handleConfig(['config', 'main']);

      _logger.info('\n👉 Run "cd $validAppName" and start coding!');
    } else {
      _logger.err('Failed to create Flutter project: ${process.stderr}');
    }
  } else {
    _cleanPubspec();
    await _installDependencies();
    await _handleConfig(['config', 'theme']);
    await _handleConfig(['config', 'assets']);
    await _handleConfig(['config', 'backend']);
    await _handleConfig(['config', 'utils']);
    await _handleConfig(['config', 'main']);
    _logger.success('✅ Project setup completed successfully!');
  }
}

Future<void> _installDependencies() async {
  _logger.info('📦 Installing Dio, Hive, GetIt, GoRouter, Google Fonts...');
  final process = await Process.run(
    'flutter', 
    ['pub', 'add', 'dio', 'hive', 'hive_flutter', 'get_it', 'go_router', 'google_fonts', 'connectivity_plus', 'injectable', 'pretty_dio_logger', 'flutter_screenutil'], 
    runInShell: true,
    workingDirectory: Directory.current.path,
  );
  if (process.exitCode == 0) {
    _logger.success('✅ Dependencies installed successfully!');
  } else {
    _logger.err('Failed to install dependencies: ${process.stderr}');
  }
}

// ─────────────────────────────────────────────────────────────
// FEATURE & SCAFFOLDING LOGIC
// ─────────────────────────────────────────────────────────────

void _handleFeatureCreation(String featureName, ArgResults flags) {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    _logger.err('No Flutter project found here! Run "ftool init" first.');
    return;
  }

  final snakeName = featureName.toLowerCase();
  final pascalName = _toPascalCase(snakeName);

  // Check sub-component generation flags
  if (flags['usecase'] != null) {
    _createFile(
      path.join('lib', 'features', snakeName, 'domain', 'usecases', '${flags['usecase']}_usecase.dart'),
      '// UseCase: ${flags['usecase']}',
    );
    _logger.success('UseCase "${flags['usecase']}" generated under $featureName');
    return;
  }

  if (flags['model'] != null) {
    _createFile(
      path.join('lib', 'features', snakeName, 'data', 'models', '${flags['model']}_model.dart'),
      '// Model: ${flags['model']}',
    );
    _createFile(
      path.join('lib', 'features', snakeName, 'domain', 'entities', '${flags['model']}_entity.dart'),
      '// Entity: ${flags['model']}',
    );
    _logger.success('Model & Entity "${flags['model']}" generated under $featureName');
    return;
  }

  // Standard Architecture check via options
  String arch = 'Clean Architecture';
  if (flags['mvc'] as bool) arch = 'MVC';
  if (flags['mvvm'] as bool) arch = 'MVVM';

  // Base Screen Generation
  _createFile(
    path.join('lib', 'features', snakeName, 'presentation', 'views', '${snakeName}_screen.dart'), 
    Templates.getScreenContent(pascalName),
  );

  if (arch == 'Clean Architecture') {
    // 1. Data Layer
    _createFile(
      path.join('lib', 'features', snakeName, 'data', 'data_sources', '${snakeName}_data_source.dart'), 
      Templates.getDataSourceContent(pascalName),
    );
    _createFile(
      path.join('lib', 'features', snakeName, 'data', 'models', '${snakeName}_model.dart'), 
      Templates.getModelContent(pascalName),
    );
    _createFile(
      path.join('lib', 'features', snakeName, 'data', 'repositories', '${snakeName}_repository_implement.dart'), 
      Templates.getRepoImplContent(pascalName, snakeName),
    );

    // 2. Domain Layer
    _createFile(
      path.join('lib', 'features', snakeName, 'domain', 'repositories', '${snakeName}_repository.dart'), 
      Templates.getRepoContent(pascalName),
    );
    _createFile(
      path.join('lib', 'features', snakeName, 'domain', 'usecases', '${snakeName}_usecase.dart'), 
      Templates.getUseCaseContent(pascalName, snakeName),
    );

    // 3. Presentation Controller
    _createFile(
      path.join('lib', 'features', snakeName, 'presentation', 'manager', 'controller', '${snakeName}_controller.dart'), 
      Templates.getControllerContent(pascalName, snakeName),
    );

  } else if (arch == 'MVVM') {
    _createFile(path.join('lib', 'features', snakeName, 'viewmodels', '${snakeName}_viewmodel.dart'), '// ViewModel');
    _createFile(path.join('lib', 'features', snakeName, 'models', '${snakeName}_model.dart'), '// Model');
  } else if (arch == 'MVC') {
    _createFile(path.join('lib', 'features', snakeName, 'controllers', '${snakeName}_controller.dart'), '// Controller');
    _createFile(path.join('lib', 'features', snakeName, 'models', '${snakeName}_model.dart'), '// Model');
  }

  _logger.success('⚡ Feature "$featureName" generated successfully with $arch!');
}

// ─────────────────────────────────────────────────────────────
// CONFIGURATIONS & UTILITIES
// ─────────────────────────────────────────────────────────────

Future<void> _handleConfig(List<String> args) async {
  if (args.length < 2) return;
  final target = args[1];

  switch (target) {
    case 'theme':
      _createFile(path.join('lib', 'core', 'constants', 'colors.dart'), Templates.colorsContent);
      _createFile(path.join('lib', 'core', 'constants', 'sizes.dart'), Templates.sizesContent);
      _createFile(path.join('lib', 'core', 'constants', 'texts.dart'), Templates.textsContent);
      _createFile(path.join('lib', 'core', 'theme', 'app_theme.dart'), Templates.appThemeContent);
      _createFile(path.join('lib', 'core', 'theme', 'text_theme.dart'), Templates.textThemeContent);

      _createFile(path.join('lib', 'core', 'theme', 'widgets_theme', 'appbar_theme.dart'), Templates.appBarThemeContent);
      _createFile(path.join('lib', 'core', 'theme', 'widgets_theme', 'botton_sheet_theme.dart'), Templates.bottomSheetThemeContent);
      _createFile(path.join('lib', 'core', 'theme', 'widgets_theme', 'checkbox_theme.dart'), Templates.checkboxThemeContent);
      _createFile(path.join('lib', 'core', 'theme', 'widgets_theme', 'chip_theme.dart'), Templates.chipThemeContent);
      _createFile(path.join('lib', 'core', 'theme', 'widgets_theme', 'elevated_button_theme.dart'), Templates.elevatedButtonThemeContent);
      _createFile(path.join('lib', 'core', 'theme', 'widgets_theme', 'outlined_button_theme.dart'), Templates.outlinedButtonThemeContent);
      _createFile(path.join('lib', 'core', 'theme', 'widgets_theme', 'text_field_theme.dart'), Templates.textFieldThemeContent);

      _createFile(path.join('lib', 'core', 'routes', 'app_router.dart'), Templates.appRouterContent);
      _createFile(path.join('lib', 'core', 'helpers', 'device_helpers.dart'), Templates.deviceHelpersContent);
      _createFile(path.join('lib', 'core', 'extensions', 'context_extension.dart'), Templates.contextExtensionContent);

      _logger.success('🎨 Theme system & core routing created successfully!');
      break;

    case 'assets':
      Directory(path.join('assets', 'animations')).createSync(recursive: true);
      Directory(path.join('assets', 'icons')).createSync(recursive: true);
      Directory(path.join('assets', 'images')).createSync(recursive: true);
      _logger.success('📁 Assets directory generated!');
      break;

    case 'backend':
      _createFile(path.join('lib', 'core', 'network', 'dio_client.dart'), Templates.dioClientContent);
      _createFile(path.join('lib', 'core', 'network', 'network_info.dart'), Templates.networkInfoContent);
      _createFile(path.join('lib', 'core', 'services', 'hive_service.dart'), Templates.hiveStorageContent);
      _createFile(path.join('lib', 'injection.dart'), Templates.dependencyInjectionContent);
      _logger.success('⚡ Backend (Dio, Hive, DI) setup completed!');
      break;

      case 'utils':
      _createFile(path.join('lib', 'core', 'utils', 'api_endpoint.dart'), Templates.apiEndpointContent);
      _createFile(path.join('lib', 'core', 'utils', 'app_logger.dart'), Templates.appLoggerContent);
      _logger.success('⚡ Utils setup completed!');
      break;

    case 'main':
      _createFile(path.join('lib', 'app.dart'), Templates.appDartContent);
      _createFile(path.join('lib', 'main.dart'), Templates.mainDartContent);
      _logger.success('🚀 Clean main.dart & app.dart created!');
      break;
  }
}


/// Clean default comments from pubspec.yaml, configure assets, 
/// and create the corresponding physical asset directories.
void _cleanAndConfigurePubspec() {
  final file = File('pubspec.yaml');

  if (!file.existsSync()) {
    _logger.err('pubspec.yaml not found!');
    return;
  }

  // 1. Create physical asset directories on disk
  final assetDirectories = [
    'assets/animations',
    'assets/icons',
    'assets/images',
  ];

  for (final path in assetDirectories) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }
  _logger.success('Created physical asset directories.');

  // 2. Read and filter out comment lines
  final lines = file.readAsLinesSync();
  final cleanedLines = lines
      .where((line) => !line.trim().startsWith('#'))
      .toList();

  // 3. Remove existing root-level 'flutter:' section to avoid duplication
  final filteredLines = <String>[];
  bool inFlutterSection = false;

  for (final line in cleanedLines) {
    if (line.startsWith('flutter:')) {
      inFlutterSection = true;
      continue;
    }

    // Skip indented properties that belong to the old root flutter section
    if (inFlutterSection) {
      if (line.startsWith(' ') || line.startsWith('\t') || line.trim().isEmpty) {
        continue;
      } else {
        inFlutterSection = false;
      }
    }

    filteredLines.add(line);
  }

  // 4. Append clean flutter configuration with assets
  final updatedContent = StringBuffer();
  updatedContent.writeln(filteredLines.join('\n').trim());
  updatedContent.writeln('\nflutter:');
  updatedContent.writeln('  uses-material-design: true');
  updatedContent.writeln('  assets:');
  for (final path in assetDirectories) {
    updatedContent.writeln('    - $path/');
  }

  // 5. Write back to pubspec.yaml
  file.writeAsStringSync(updatedContent.toString());
  _logger.success('Cleaned pubspec.yaml and configured assets successfully!');
}

void _cleanPubspec() {
  _cleanAndConfigurePubspec();
}


void _createFile(String filePath, String content) {
  final file = File(filePath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}

bool _isValidFlutterAppName(String name) {
  final RegExp regex = RegExp(r'^[a-z][a-z0-9_]*$');
  return regex.hasMatch(name);
}

String _toPascalCase(String text) {
  return text.split(RegExp(r'[_ ]')).map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join('');
}

void _listFeatures() {
  final dir = Directory(path.join('lib', 'features'));
  if (dir.existsSync()) {
    final List<FileSystemEntity> entities = dir.listSync();
    _logger.info('📦 Active Features:');
    for (var entity in entities) {
      if (entity is Directory) {
        _logger.info('  • ${entity.path.split(Platform.pathSeparator).last}');
      }
    }
  } else {
    _logger.err('No features folder found.');
  }
}

void _removeFeature(String featureName) {
  final dir = Directory(path.join('lib', 'features', featureName.toLowerCase()));
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
    _logger.success('Feature "$featureName" removed successfully.');
  } else {
    _logger.err('Feature "$featureName" does not exist.');
  }
}

void _renameFeature(String oldName, String newName) {
  final oldDir = Directory(path.join('lib', 'features', oldName.toLowerCase()));
  if (oldDir.existsSync()) {
    oldDir.renameSync(path.join('lib', 'features', newName.toLowerCase()));
    _logger.success('Renamed feature "$oldName" to "$newName".');
  } else {
    _logger.err('Feature "$oldName" not found.');
  }
}

void _runDoctor() {
  _logger.info('Running FTOOL Health Check...');
  final pubspec = File('pubspec.yaml');
  if (pubspec.existsSync()) {
    _logger.success('Valid Flutter project environment.');
  } else {
    _logger.err('No Flutter project found in current path.');
  }
}

void _showTree() {
  final libDir = Directory('lib');
  if (libDir.existsSync()) {
    _printDirectory(libDir, '');
  } else {
    _logger.err('No lib directory found.');
  }
}

void _printDirectory(Directory dir, String indent) {
  final List<FileSystemEntity> entities = dir.listSync();
  for (var i = 0; i < entities.length; i++) {
    final entity = entities[i];
    final isLast = i == entities.length - 1;
    final prefix = isLast ? '└── ' : '├── ';
    _logger.info('$indent$prefix${entity.path.split(Platform.pathSeparator).last}');
    if (entity is Directory) {
      _printDirectory(entity, '$indent${isLast ? "    " : "│   "}');
    }
  }
}

void _printHelp() {
  _logger.info('''
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   ███████╗████████╗██████╗ ██████╗ ██╗                      │
│   ██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗██║                     │
│   █████╗     ██║   ██║  ██║██║   ██║██║                     │
│   ██╔══╝     ██║   ██║  ██║██║   ██║██║                     │
│   ██║        ██║   ╚██████╔╝╚██████╔╝███████╗               │
│   ╚═╝        ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝               │
│                                                             │
│   Flutter Architecture & Utility CLI Tool v1.0.0            │
│   Developed by : Rafsanul Rifat                             │
│   GitHub       : https://github.com/rafsanul247/ftool_cli   │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────────────────┬────────────────────────────────────┐
│  COMMAND                         │  DESCRIPTION                       │
├──────────────────────────────────┼────────────────────────────────────┤
│  ⚡ ftool init <appName>          │  # Initialize Flutter project      │
│  ⚡ ftool <Feature> --clean       │  # Scaffold Clean Architecture     │
│  ⚡ ftool <Feature> --mvvm        │  # Scaffold MVVM Architecture      │
│  ⚡ ftool <Feature> -u <UseCase>  │  # Inject custom UseCase           │
│  ⚡ ftool list                    │  # List all created features       │
│  ⚡ ftool rm <Feature>            │  # Safe remove feature             │
│  ⚡ ftool rename <Old> <New>      │  # Rename feature folder           │
│  ⚡ ftool config theme            │  # Inject Themes & Helpers         │
│  ⚡ ftool config assets           │  # Generate assets directories     │
│  ⚡ ftool doctor                  │  # Check project health            │
│  ⚡ ftool tree                    │  # Visual project directory        │
└──────────────────────────────────┴────────────────────────────────────┘
  ''');
}