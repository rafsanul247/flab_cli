import 'dart:io';
import 'package:args/args.dart';
import 'package:flab/src/templates.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;

final Logger _logger = Logger();

Future<void> main(List<String> arguments) async {
  // 1. Direct help check
  if (arguments.isEmpty ||
      arguments.first == 'help' ||
      arguments.contains('--help') ||
      arguments.contains('-h')) {
    _printHelp();
    return;
  }

  // 2. Direct version check
  if (arguments.first == 'version' ||
      arguments.contains('--version') ||
      arguments.contains('-v')) {
    _logger.info('FLAB CLI Version: 1.0.0');
    return;
  }

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
    _logger.err('Invalid command usage. Run "flab --help" for options.');
    return;
  }

  if (results['help'] as bool) {
    _printHelp();
    return;
  }

  if (results['version'] as bool) {
    _logger.info('FLAB CLI Version: 1.0.0');
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
      if (arguments.length > 1) {
        _removeFeature(arguments[1]);
      } else {
        _logger.err('Usage: flab rm <FeatureName>');
      }
      return;
    case 'rename':
      if (arguments.length > 2) {
        _renameFeature(arguments[1], arguments[2]);
      } else {
        _logger.err('Usage: flab rename <OldName> <NewName>');
      }
      return;
    case 'clean':
      if (arguments.length > 1 && arguments[1] == 'pubspec') {
        _cleanPubspec();
      } else {
        _logger.err('Usage: flab clean pubspec');
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

  final currentPubspec = File('pubspec.yaml');
  String validAppName = appName?.trim() ?? '';

  if (validAppName.isNotEmpty) {
    if (!_isValidFlutterAppName(validAppName)) {
      _logger.err(
        'Invalid Flutter project name "$validAppName". Must be lowercase, numbers and underscores only, starting with a lowercase letter (e.g. my_app).',
      );
      return;
    }
    await _createNewFlutterProject(validAppName);
    return;
  }

  // No appName provided
  if (!currentPubspec.existsSync()) {
    while (validAppName.isEmpty || !_isValidFlutterAppName(validAppName)) {
      stdout.write('App name (lowercase, underscores only): ');
      validAppName = stdin.readLineSync()?.trim() ?? '';
      if (validAppName.isNotEmpty && !_isValidFlutterAppName(validAppName)) {
        _logger.err('Invalid Flutter project name. Please try again.');
      }
    }
    await _createNewFlutterProject(validAppName);
  } else {
    // Current directory already has a pubspec.yaml
    _cleanPubspec();
    await _installDependencies();
    await _handleConfig(['config', 'theme']);
    await _handleConfig(['config', 'assets']);
    await _handleConfig(['config', 'backend']);
    await _handleConfig(['config', 'utils']);
    await _handleConfig(['config', 'main']);
    _fixWidgetTest();
    _logger.success('✅ Project setup completed successfully!');
  }
}

Future<void> _createNewFlutterProject(String validAppName) async {
  final targetDir = Directory(path.join(Directory.current.path, validAppName));
  if (targetDir.existsSync()) {
    _logger.err('Directory "$validAppName" already exists! Please choose another name or remove the existing directory.');
    return;
  }

  _logger.info('Creating Flutter project "$validAppName"...');

  final process = await Process.run(
    'flutter',
    ['create', validAppName],
    runInShell: true,
  );

  if (process.exitCode == 0) {
    _logger.success('✅ Flutter project "$validAppName" created successfully!');
    final originalDir = Directory.current;
    Directory.current = targetDir;

    try {
      // Auto Execution Tasks inside the new Flutter project
      _cleanPubspec();
      await _installDependencies();
      await _handleConfig(['config', 'theme']);
      await _handleConfig(['config', 'assets']);
      await _handleConfig(['config', 'backend']);
      await _handleConfig(['config', 'utils']);
      await _handleConfig(['config', 'main']);
      _fixWidgetTest(validAppName);

      _logger.info('\n👉 Run "cd $validAppName" and start coding!');
    } finally {
      Directory.current = originalDir;
    }
  } else {
    _logger.err('Failed to create Flutter project: ${process.stderr}');
    if (process.stdout.toString().isNotEmpty) {
      _logger.info(process.stdout.toString());
    }
  }
}

Future<void> _installDependencies() async {
  _logger.info('📦 Installing Dio, Hive, GetIt, GoRouter, Google Fonts...');
  final process = await Process.run(
    'flutter',
    [
      'pub',
      'add',
      'dio',
      'hive',
      'hive_flutter',
      'get_it',
      'go_router',
      'google_fonts',
      'connectivity_plus',
      'pretty_dio_logger',
      'flutter_screenutil',
    ],
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
    _logger.err('No Flutter project found here! Run "flab init" first.');
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
    final modelRaw = flags['model'] as String;
    final modelSnake = modelRaw.toLowerCase();
    final modelPascal = _toPascalCase(modelSnake);
    _createFile(
      path.join('lib', 'features', snakeName, 'data', 'models', '${modelSnake}_model.dart'),
      Templates.getModelContent(modelPascal, modelSnake),
    );
    _createFile(
      path.join('lib', 'features', snakeName, 'domain', 'entities', '${modelSnake}_entity.dart'),
      Templates.getEntityContent(modelPascal),
    );
    _logger.success('Model & Entity "$modelRaw" generated under $featureName');
    return;
  }

  if (flags['datasource'] != null) {
    final dsRaw = flags['datasource'] as String;
    final dsSnake = dsRaw.toLowerCase();
    final dsPascal = _toPascalCase(dsSnake);
    _createFile(
      path.join('lib', 'features', snakeName, 'data', 'data_sources', '${dsSnake}_data_source.dart'),
      Templates.getDataSourceContent(dsPascal, snakeName),
    );
    _logger.success('DataSource "$dsRaw" generated under $featureName');
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
  Directory(
    path.join('lib', 'features', snakeName, 'presentation', 'views', 'widgets'),
  ).createSync(recursive: true);

  if (arch == 'Clean Architecture') {
    // 1. Data Layer
    _createFile(
      path.join('lib', 'features', snakeName, 'data', 'data_sources', '${snakeName}_data_source.dart'),
      Templates.getDataSourceContent(pascalName, snakeName),
    );
    _createFile(
      path.join('lib', 'features', snakeName, 'data', 'models', '${snakeName}_model.dart'),
      Templates.getModelContent(pascalName, snakeName),
    );
    _createFile(
      path.join('lib', 'features', snakeName, 'data', 'repositories', '${snakeName}_repository_implement.dart'),
      Templates.getRepoImplContent(pascalName, snakeName),
    );

    // 2. Domain Layer
    _createFile(
      path.join('lib', 'features', snakeName, 'domain', 'entities', '${snakeName}_entity.dart'),
      Templates.getEntityContent(pascalName),
    );
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

    // 4. Dependency Injection
    _addFeatureToInjection(snakeName, pascalName);
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
      _fixWidgetTest();
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
  final cleanedLines = lines.where((line) => !line.trim().startsWith('#')).toList();

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

String _getAppName() {
  final pubspec = File('pubspec.yaml');
  if (pubspec.existsSync()) {
    final lines = pubspec.readAsLinesSync();
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('name:')) {
        return trimmed.substring(5).replaceAll("'", '').replaceAll('"', '').trim();
      }
    }
  }
  return '';
}

void _fixWidgetTest([String? appName]) {
  final widgetTestFile = File(path.join('test', 'widget_test.dart'));
  if (!widgetTestFile.existsSync()) return;

  final effectiveAppName = (appName != null && appName.isNotEmpty) ? appName : _getAppName();
  if (effectiveAppName.isEmpty) return;

  final content = widgetTestFile.readAsStringSync();
  final updated = content.replaceAll(
    RegExp(r"""import\s+['"][^'"]*main\.dart['"]\s*;"""),
    "import 'package:$effectiveAppName/app.dart';",
  );
  widgetTestFile.writeAsStringSync(updated);
}

void _addFeatureToInjection(String snakeName, String pascalName) {
  final file = File(path.join('lib', 'injection.dart'));
  if (!file.existsSync()) {
    _createFile(file.path, Templates.dependencyInjectionContent);
  }

  var content = file.readAsStringSync();
  final isCrlf = content.contains('\r\n');
  content = content.replaceAll('\r\n', '\n');

  if (!content.contains("package:dio/dio.dart")) {
    content = "import 'package:dio/dio.dart';\n$content";
  }
  if (!content.contains("package:get_it/get_it.dart")) {
    content = "import 'package:get_it/get_it.dart';\n$content";
  }

  // 1. Prepare feature imports
  final featureImports = [
    "import 'features/$snakeName/data/data_sources/${snakeName}_data_source.dart';",
    "import 'features/$snakeName/data/repositories/${snakeName}_repository_implement.dart';",
    "import 'features/$snakeName/domain/repositories/${snakeName}_repository.dart';",
    "import 'features/$snakeName/domain/usecases/${snakeName}_usecase.dart';",
    "import 'features/$snakeName/presentation/manager/controller/${snakeName}_controller.dart';",
  ];

  final importsToAdd = featureImports.where((imp) => !content.contains(imp)).toList();

  if (importsToAdd.isNotEmpty) {
    final lastImportMatch = RegExp(r"""^import\s+['"][^'"]*['"];""", multiLine: true)
        .allMatches(content)
        .lastOrNull;

    if (lastImportMatch != null) {
      final insertPos = lastImportMatch.end;
      content = '${content.substring(0, insertPos)}\n\n${importsToAdd.join('\n')}${content.substring(insertPos)}';
    } else {
      content = '${importsToAdd.join('\n')}\n\n$content';
    }
  }

  // Ensure _setUpCore is defined and called
  if (!content.contains('_setUpCore()')) {
    final initMatch = RegExp(r"(Future<void>\s+(?:init|initDependencies)\s*\(\)\s*async\s*\{)([\s\S]*?)(\})").firstMatch(content);
    if (initMatch != null) {
      final beforeBrace = initMatch.group(1)!;
      final body = initMatch.group(2)!;
      final newBody = '\n  _setUpCore();$body';
      content = '${content.substring(0, initMatch.start + beforeBrace.length)}$newBody${content.substring(initMatch.end - 1)}';
    }
  }
  if (!content.contains('void _setUpCore()')) {
    final dioClientFile = File(path.join('lib', 'core', 'network', 'dio_client.dart'));
    if (dioClientFile.existsSync()) {
      if (!content.contains("core/network/dio_client.dart")) {
        content = "import 'core/network/dio_client.dart';\n$content";
      }
      content = '${content.trimRight()}\n\n// Core: Shared resources for all features\nvoid _setUpCore() {\n  sl.registerLazySingleton<DioClient>(() => DioClient());\n  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);\n}\n';
    } else {
      content = '${content.trimRight()}\n\n// Core: Shared resources for all features\nvoid _setUpCore() {\n  sl.registerLazySingleton<Dio>(() => Dio());\n}\n';
    }
  }

  // 2. Add `await _setUp<PascalName>();` inside init()
  final setupCall = 'await _setUp$pascalName();';
  if (!content.contains(setupCall)) {
    final initMatch = RegExp(r"(Future<void>\s+(?:init|initDependencies)\s*\(\)\s*async\s*\{)([\s\S]*?)(\})").firstMatch(content);
    if (initMatch != null) {
      final beforeBrace = initMatch.group(1)!;
      final body = initMatch.group(2)!;
      if (!body.contains('_setUp$pascalName')) {
        final newBody = '${body.trimRight()}\n  $setupCall\n';
        content = '${content.substring(0, initMatch.start + beforeBrace.length)}$newBody${content.substring(initMatch.end - 1)}';
      }
    }
  }

  // 3. Add `Future<void> _setUp<PascalName>() async { ... }` function
  final functionName = '_setUp$pascalName';
  if (!content.contains('Future<void> $functionName')) {
    final setupFunction = '''

Future<void> $functionName() async {
  // Data Sources
  sl.registerLazySingleton<${pascalName}DataSource>(
    () => ${pascalName}DataSourceImplement(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<${pascalName}Repository>(
    () => ${pascalName}RepositoryImplement(dataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => ${pascalName}UseCase(repository: sl()));

  // Controllers
  sl.registerFactory(() => ${pascalName}Controller(sl()));
}
''';
    content = '${content.trimRight()}\n$setupFunction';
  }

  if (isCrlf) {
    content = content.replaceAll('\n', '\r\n');
  }

  file.writeAsStringSync(content);
  _logger.success('⚡ Injected "$pascalName" into lib/injection.dart');
}

void _removeFeatureFromInjection(String snakeName, String pascalName) {
  final file = File(path.join('lib', 'injection.dart'));
  if (!file.existsSync()) return;

  var content = file.readAsStringSync();
  final isCrlf = content.contains('\r\n');
  content = content.replaceAll('\r\n', '\n');

  // 1. Remove feature imports and init call line
  final lines = content.split('\n');
  final filteredLines = <String>[];
  for (final line in lines) {
    if (line.trim().startsWith('import') && line.contains('features/$snakeName/')) {
      continue;
    }
    if (line.contains('_setUp$pascalName()')) {
      continue;
    }
    filteredLines.add(line);
  }
  content = filteredLines.join('\n');

  // 2. Remove the _setUp<PascalName>() function definition
  final setupRegex = RegExp(
    '\\n*Future<void>\\s+_setUp$pascalName\\s*\\(\\)\\s*async\\s*\\{[\\s\\S]*?\\n\\}',
  );
  content = content.replaceAll(setupRegex, '');

  // 3. Clean up extra blank lines
  content = '${content.replaceAll(RegExp(r'\n{3,}'), '\n\n').trimRight()}\n';

  if (isCrlf) {
    content = content.replaceAll('\n', '\r\n');
  }

  file.writeAsStringSync(content);
  _logger.success('🗑️ Removed "$pascalName" from lib/injection.dart');
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
  final snakeName = featureName.toLowerCase();
  final pascalName = _toPascalCase(snakeName);

  final dir = Directory(path.join('lib', 'features', snakeName));
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
    final testDir = Directory(path.join('test', 'features', snakeName));
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
    _removeFeatureFromInjection(snakeName, pascalName);
    _logger.success('Feature "$featureName" removed successfully.');
  } else {
    _logger.err('Feature "$featureName" does not exist.');
  }
}

void _renameFeature(String oldName, String newName) {
  final oldSnake = oldName.toLowerCase();
  final newSnake = newName.toLowerCase();
  final oldPascal = _toPascalCase(oldSnake);
  final newPascal = _toPascalCase(newSnake);

  final oldDir = Directory(path.join('lib', 'features', oldSnake));
  if (oldDir.existsSync()) {
    oldDir.renameSync(path.join('lib', 'features', newSnake));
    final oldTestDir = Directory(path.join('test', 'features', oldSnake));
    if (oldTestDir.existsSync()) {
      oldTestDir.renameSync(path.join('test', 'features', newSnake));
    }
    _removeFeatureFromInjection(oldSnake, oldPascal);
    _addFeatureToInjection(newSnake, newPascal);
    _logger.success('Renamed feature "$oldName" to "$newName".');
  } else {
    _logger.err('Feature "$oldName" not found.');
  }
}

void _runDoctor() {
  _logger.info('Running FLAB Health Check...');
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
│             ███████╗██╗       █████╗  ██████╗               │
│             ██╔════╝██║      ██╔══██╗ ██╔══██╗              │
│             █████╗  ██║      ███████║ ██████╔╝              │
│             ██╔══╝  ██║      ██╔══██║ ██╔══██╗              │
│             ██║     ███████╗ ██║  ██║ ██████╔╝              │
│             ╚═╝     ╚══════╝ ╚═╝  ╚═╝ ╚═════╝               │
│                                                             │
│   Flutter Architecture & Utility CLI Tool (FLAB) v1.0.0     │
│   Developed by : Rafsanul Rifat                             │
│   GitHub   : https://github.com/rafsanul247/flab_cli        │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────────────────┬────────────────────────────────────┐
│  COMMAND                         │  DESCRIPTION                       │
├──────────────────────────────────┼────────────────────────────────────┤
│  ⚡ flab init <appName>           │  # Initialize Flutter project      │
│  ⚡ flab <Feature> --clean        │  # Scaffold Clean Architecture     │
│  ⚡ flab <Feature> --mvvm         │  # Scaffold MVVM Architecture      │
│  ⚡ flab <Feature> -u <UseCase>   │  # Inject custom UseCase           │
│  ⚡ flab list                     │  # List all created features       │
│  ⚡ flab rm <Feature>             │  # Safe remove feature             │
│  ⚡ flab rename <Old> <New>       │  # Rename feature folder           │
│  ⚡ flab config theme             │  # Inject Themes & Helpers         │
│  ⚡ flab config assets            │  # Generate assets directories     │
│  ⚡ flab doctor                   │  # Check project health            │
│  ⚡ flab tree                     │  # Visual project directory        │
└──────────────────────────────────┴────────────────────────────────────┘
  ''');
}
