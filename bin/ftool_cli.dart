import 'dart:io';
import 'package:args/args.dart';
import 'package:cli_dialog/cli_dialog.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:ftool_cli/src/templates.dart';

final Logger _logger = Logger();

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Show ftool usage help')
    ..addFlag('version', abbr: 'v', negatable: false, help: 'Show version');

  final results = parser.parse(arguments);

  if (results['help'] as bool || arguments.contains('help')) {
    _printHelp();
    return;
  }

  if (arguments.isEmpty) {
    _logger.info(
        'Please specify a command or feature name. Example: ftool home or ftool doctor');
    return;
  }

  final command = arguments.first;

  switch (command) {
    case 'doctor':
      _runDoctor();
      break;
    case 'tree':
      _showTree();
      break;
    case 'config':
      if (arguments.length > 1 && arguments[1] == 'theme') {
        _setupThemeConfig();
      } else {
        _logger.err('Invalid config command. Use: ftool config theme');
      }
      break;
    default:
      _createFeatureInteractive(command);
      break;
  }
}

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
│ ftool <FeatureName>          │ Interactive feature scaffold │
│ ftool doctor                 │ Check workspace environment  │
│ ftool tree                   │ Visual project directory     │
│ ftool config theme           │ Inject Theme & Helpers       │
└──────────────────────────────┴──────────────────────────────┘
  ''');
}

void _runDoctor() {
  _logger.info('Running FTOOL Doctor checks...');
  final pubspec = File('pubspec.yaml');
  if (pubspec.existsSync()) {
    _logger.success(' Valid Flutter project directory found.');
  } else {
    _logger.err(
        ' pubspec.yaml missing. Run inside a valid Flutter root directory.');
  }
}

void _showTree() {
  _logger.info('📁 Project Directory Tree:');
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
    _logger.info(
        '$indent$prefix${entity.path.split(Platform.pathSeparator).last}');
    if (entity is Directory) {
      _printDirectory(entity, '$indent${isLast ? "    " : "│   "}');
    }
  }
}

void _createFeatureInteractive(String featureName) {
  final dialog = CLI_Dialog(listQuestions: [
    [
      {
        'question': 'Choose Architecture:',
        'options': ['Clean Architecture', 'MVVM', 'MVC']
      },
      'arch'
    ],
    [
      {
        'question': 'Choose State Management:',
        'options': ['Bloc', 'GetX', 'Provider', 'Skip']
      },
      'sm'
    ]
  ]);

  final answers = dialog.ask();
  final String arch = answers['arch'] ?? 'Clean Architecture';
  final String snakeName = featureName.toLowerCase();
  final String pascalName = _capitalize(snakeName);

  // Common Presentation View & Widgets Structure Generation
  _createFile(
      'lib/features/$snakeName/presentation/views/${snakeName}_screen.dart', '''
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

  Directory('lib/features/$snakeName/presentation/views/widgets')
      .createSync(recursive: true);

  // Architecture-based generation
  if (arch == 'Clean Architecture') {
    _createFile(
        'lib/features/$snakeName/data/datasources/${snakeName}_remote_data_source.dart',
        '// Remote Data Source');
    _createFile('lib/features/$snakeName/data/models/${snakeName}_model.dart',
        '// Model');
    _createFile(
        'lib/features/$snakeName/data/repositories/${snakeName}_repository_impl.dart',
        '// Repo Impl');
    _createFile(
        'lib/features/$snakeName/domain/entities/${snakeName}_entity.dart',
        '// Entity');
    _createFile(
        'lib/features/$snakeName/domain/repositories/${snakeName}_repository.dart',
        '// Repo');
    _createFile(
        'lib/features/$snakeName/domain/usecases/get_${snakeName}_usecase.dart',
        '// UseCase');
  } else if (arch == 'MVVM') {
    _createFile(
        'lib/features/$snakeName/viewmodels/${snakeName}_viewmodel.dart',
        '// ViewModel');
    _createFile(
        'lib/features/$snakeName/models/${snakeName}_model.dart', '// Model');
  } else if (arch == 'MVC') {
    _createFile(
        'lib/features/$snakeName/controllers/${snakeName}_controller.dart',
        '// Controller');
    _createFile(
        'lib/features/$snakeName/models/${snakeName}_model.dart', '// Model');
  }

  _logger.success(
      ' Feature "$featureName" created under $arch setup successfully.');
}

void _setupThemeConfig() {
  _createFile('lib/core/theme/app_theme.dart', Templates.appThemeContent);
  _createFile(
      'lib/core/helpers/device_helpers.dart', Templates.deviceHelpersContent);
  _createFile('lib/core/extensions/context_extension.dart',
      Templates.contextExtensionContent);
  _logger.success(' Themes and context extensions written successfully!');
}

void _createFile(String path, String content) {
  final file = File(path);
  file.createSync(recursive: true);
  file.writeAsStringSync(content);
}

String _capitalize(String str) =>
    str.isEmpty ? '' : '${str[0].toUpperCase()}${str.substring(1)}';
