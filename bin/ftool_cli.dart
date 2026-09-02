import 'dart:io';
import 'package:args/args.dart';
import 'package:cli_dialog/cli_dialog.dart';
import 'package:ftool_cli/src/templates.dart';
import 'package:mason_logger/mason_logger.dart';

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
      _handleConfig(arguments);
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
    _logger.info('ℹ️  📋 No Flutter project found. Let\'s create one first...\n');

    while (validAppName.isEmpty || !_isValidFlutterAppName(validAppName)) {
      stdout.write('App name (lowercase, underscores only, no spaces or special characters): ');
      validAppName = stdin.readLineSync()?.trim() ?? '';

      if (!_isValidFlutterAppName(validAppName)) {
        _logger.err('Invalid package name! Use lowercase letters and underscores only (e.g., my_app).');
      }
    }

    _logger.info('\nCreating Flutter project "$validAppName"...');

    final executable = Platform.isWindows ? 'flutter.bat' : 'flutter';
    final process = await Process.run(
      'flutter', 
      ['create', validAppName], 
      runInShell: true,
    );

    if (process.exitCode == 0) {
      _logger.success('✅ Flutter project "$validAppName" created successfully!');
      _logger.info('👉 Run "cd $validAppName" to enter your new project directory.');
    } else {
      _logger.err('Failed to create Flutter project: ${process.stderr}');
    }
  } else {
    _logger.success('✅ Flutter project already exists in this workspace.');
  }
}

bool _isValidFlutterAppName(String name) {
  final regExp = RegExp(r'^[a-z][a-z0-9_]*$');
  return regExp.hasMatch(name);
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
  final pascalName = _capitalize(snakeName);

  // Check sub-component generation flags
  if (flags['usecase'] != null) {
    _createFile('lib/features/$snakeName/domain/usecases/${flags['usecase']}_usecase.dart', '// UseCase: ${flags['usecase']}');
    _logger.success('UseCase "${flags['usecase']}" generated under $featureName');
    return;
  }

  if (flags['model'] != null) {
    _createFile('lib/features/$snakeName/data/models/${flags['model']}_model.dart', '// Model: ${flags['model']}');
    _createFile('lib/features/$snakeName/domain/entities/${flags['model']}_entity.dart', '// Entity: ${flags['model']}');
    _logger.success('Model & Entity "${flags['model']}" generated under $featureName');
    return;
  }

  // Standard Architecture check via options
  String arch = 'Clean Architecture';
  if (flags['mvc'] as bool) arch = 'MVC';
  if (flags['mvvm'] as bool) arch = 'MVVM';

  // Base view generation
  _createFile('lib/features/$snakeName/presentation/views/${snakeName}_screen.dart', '''
import 'package:flutter/material.dart';

class ${pascalName}Screen extends StatelessWidget {
  const ${pascalName}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$pascalName')),
      body: const Center(child: Text('$pascalName View')),
    );
  }
}
''');

  if (arch == 'Clean Architecture') {
    _createFile('lib/features/$snakeName/data/datasources/${snakeName}_remote_data_source.dart', '// Data Source');
    _createFile('lib/features/$snakeName/data/models/${snakeName}_model.dart', '// Model');
    _createFile('lib/features/$snakeName/data/repositories/${snakeName}_repository_impl.dart', '// Repository Impl');
    _createFile('lib/features/$snakeName/domain/entities/${snakeName}_entity.dart', '// Entity');
    _createFile('lib/features/$snakeName/domain/repositories/${snakeName}_repository.dart', '// Repository');
    _createFile('lib/features/$snakeName/domain/usecases/get_${snakeName}_usecase.dart', '// UseCase');
  } else if (arch == 'MVVM') {
    _createFile('lib/features/$snakeName/viewmodels/${snakeName}_viewmodel.dart', '// ViewModel');
    _createFile('lib/features/$snakeName/models/${snakeName}_model.dart', '// Model');
  } else if (arch == 'MVC') {
    _createFile('lib/features/$snakeName/controllers/${snakeName}_controller.dart', '// Controller');
    _createFile('lib/features/$snakeName/models/${snakeName}_model.dart', '// Model');
  }

  _logger.success('⚡ Feature "$featureName" generated successfully with $arch!');
}

// ─────────────────────────────────────────────────────────────
// CONFIGURATIONS & UTILITIES
// ─────────────────────────────────────────────────────────────

void _handleConfig(List<String> args) {
  if (args.length < 2) return;
  final target = args[1];

  switch (target) {
    case 'theme':
      _createFile('lib/core/theme/app_theme.dart', Templates.appThemeContent);
      _createFile('lib/core/helpers/device_helpers.dart', Templates.deviceHelpersContent);
      _createFile('lib/core/extensions/context_extension.dart', Templates.contextExtensionContent);
      _logger.success('Theme & Device helpers injected successfully!');
      break;
    case 'assets':
      Directory('assets/icons').createSync(recursive: true);
      Directory('assets/images').createSync(recursive: true);
      _logger.success('Assets directory structure generated!');
      break;
    case 'main':
      _createFile('lib/app.dart', '// MaterialApp entry point configuration');
      _logger.success('Cleaned main setup & app.dart created!');
      break;
  }
}

void _listFeatures() {
  final dir = Directory('lib/features');
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
  final dir = Directory('lib/features/${featureName.toLowerCase()}');
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
    _logger.success('Feature "$featureName" removed successfully.');
  } else {
    _logger.err('Feature "$featureName" does not exist.');
  }
}

void _renameFeature(String oldName, String newName) {
  final dir = Directory('lib/features/${oldName.toLowerCase()}');
  if (dir.existsSync()) {
    dir.renameSync('lib/features/${newName.toLowerCase()}');
    _logger.success('Renamed feature "$oldName" to "$newName".');
  } else {
    _logger.err('Feature "$oldName" not found.');
  }
}

void _cleanPubspec() {
  final file = File('pubspec.yaml');
  if (file.existsSync()) {
    final lines = file.readAsLinesSync();
    final cleaned = lines.where((line) => !line.trim().startsWith('#')).join('\n');
    file.writeAsStringSync(cleaned);
    _logger.success('Cleaned comments from pubspec.yaml!');
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

void _createFile(String path, String content) {
  final file = File(path);
  file.createSync(recursive: true);
  file.writeAsStringSync(content);
}

String _capitalize(String str) => str.isEmpty ? '' : '${str[0].toUpperCase()}${str.substring(1)}';

void _printHelp() {
  _logger.info('''
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   ███████╗████████╗██████╗  ██████╗  ██╗                    │
│   ██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗██║                     │
│   █████╗     ██║   ██║  ██║██║   ██║██║                     │
│   ██╔══╝     ██║   ██║  ██║██║   ██║██║                     │
│   ██║        ██║   ╚██████╔╝╚██████╔╝███████╗               │
│   ╚═╝        ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝               │
│                                                             │
│   Flutter Architecture & Utility CLI Tool v1.0.0            │
│   Developed by : Rafsanul Rifat                             │
│   GitHub       : https://github.com/rafsanul247/ftool_cli   │
|                                                             |
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ COMMAND                      │ DESCRIPTION                  │
├──────────────────────────────┼──────────────────────────────┤
│ ftool init <appName>         │ Initialize Flutter project   │
│ ftool <Feature> --clean      │ Scaffold Clean Architecture  │
│ ftool <Feature> --mvvm       │ Scaffold MVVM Architecture   │
│ ftool <Feature> -u <UseCase> │ Inject custom UseCase        │
│ ftool list                   │ List all created features    │
│ ftool rm <Feature>           │ Safe remove feature          │
│ ftool rename <Old> <New>     │ Rename feature folder        │
│ ftool config theme           │ Inject Themes & Helpers      │
│ ftool config assets          │ Generate assets directories  │
│ ftool doctor                 │ Check project health         │
│ ftool tree                   │ Visual project directory     │
└──────────────────────────────┴──────────────────────────────┘
  ''');
}