import 'dart:io';
import 'package:flab/src/templates.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('FLAB Feature Scaffolding & Templates', () {
    test('Templates.getEntityContent generates valid entity class', () {
      final content = Templates.getEntityContent('Home');
      expect(content, contains('class HomeEntity {'));
      expect(content, contains('// TODO: Define entity properties here'));
      expect(content, contains('// final String? id;'));
      expect(content, contains('const HomeEntity('));
      expect(content, contains('// TODO: Pass entity properties to constructor'));
    });

    test('Templates.getModelContent generates valid model extending entity', () {
      final content = Templates.getModelContent('Home', 'home');
      expect(content, contains("import '../../domain/entities/home_entity.dart';"));
      expect(content, contains('class HomeModel extends HomeEntity {'));
      expect(content, contains('const HomeModel('));
      expect(content, contains('// TODO: Pass entity properties to super constructor'));
      expect(content, contains('// factory HomeModel.fromJson(Map<String, dynamic> json) {'));
      expect(content, contains('// Map<String, dynamic> toJson() {'));
    });

    test('Templates.getDataSourceContent generates valid data source template', () {
      final content = Templates.getDataSourceContent('Home', 'home');
      expect(content, contains("import 'package:dio/dio.dart';"));
      expect(content, contains("import '../models/home_model.dart';"));
      expect(content, contains('abstract class HomeDataSource {'));
      expect(content, contains('// TODO: Define Data Source methods here'));
      expect(content, contains('class HomeDataSourceImplement implements HomeDataSource {'));
      expect(content, contains('final Dio dio;'));
      expect(content, contains('// TODO: Implement Data Source methods'));
    });

    test('Templates.getUseCaseContent generates the use case template', () {
      final content = Templates.getUseCaseContent('Home', 'home');
      expect(content, contains("import 'package:dartz/dartz.dart';"));
      expect(content, contains("import '../../../../core/error/failures.dart';"));
      expect(content, contains("import '../entities/home_entity.dart';"));
      expect(content, contains("import '../repositories/home_repository.dart';"));
      expect(content, contains('class HomeUseCase'));
      expect(content, contains('final HomeRepository repository;'));
      expect(content, contains('Future<Either<Failure, List<HomeEntity>>> getUsers() async'));
    });

    test('Templates generate selected state management and MVC files', () {
      final getx = Templates.getStateManagementContent('Home', 'home', 'getx');
      final provider = Templates.getStateManagementContent('Home', 'home', 'provider');
      final riverpod = Templates.getStateManagementContent('Home', 'home', 'riverpod');
      final bloc = Templates.getStateManagementContent('Home', 'home', 'bloc');
      final mvcModel = Templates.getMvcModelContent('Home');
      final mvcController = Templates.getMvcControllerContent('Home', 'home');

      expect(getx, contains("import 'package:get/get.dart';"));
      expect(provider, contains('extends ChangeNotifier'));
      expect(riverpod, contains('NotifierProvider'));
      expect(bloc, contains('extends Cubit<bool>'));
      expect(mvcModel, contains('class HomeModel'));
      expect(mvcController, contains("import '../models/home_model.dart';"));
    });

    test('flab creates entities template and widgets directory', () async {
      final tempDir = await Directory.systemTemp.createTemp('flab_test_');
      try {
        // Create a dummy pubspec.yaml so flab recognises it as a project
        final pubspec = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspec.writeAsString('name: test_app\n');

        // Run flab CLI binary with a feature name
        final binPath = path.canonicalize(path.join(Directory.current.path, 'bin', 'flab.dart'));
        final result = await Process.run(
          'dart',
          ['run', binPath, 'home'],
          workingDirectory: tempDir.path,
          runInShell: true,
        );

        expect(result.exitCode, equals(0));

        // Verify domain/entities/home_entity.dart exists and has entity content
        final entityFile = File(
          path.join(tempDir.path, 'lib', 'features', 'home', 'domain', 'entities', 'home_entity.dart'),
        );
        expect(entityFile.existsSync(), isTrue);
        expect(entityFile.readAsStringSync(), contains('class HomeEntity'));

        // Verify data/models/home_model.dart exists and extends entity
        final modelFile = File(
          path.join(tempDir.path, 'lib', 'features', 'home', 'data', 'models', 'home_model.dart'),
        );
        expect(modelFile.existsSync(), isTrue);
        expect(modelFile.readAsStringSync(), contains('class HomeModel extends HomeEntity'));

        // Verify data/data_sources/home_data_source.dart exists and has updated template
        final dataSourceFile = File(
          path.join(tempDir.path, 'lib', 'features', 'home', 'data', 'data_sources', 'home_data_source.dart'),
        );
        expect(dataSourceFile.existsSync(), isTrue);
        expect(dataSourceFile.readAsStringSync(), contains('class HomeDataSourceImplement implements HomeDataSource'));
        expect(dataSourceFile.readAsStringSync(), contains("import '../models/home_model.dart';"));

        // Verify presentation/views/widgets directory exists
        final widgetsDir = Directory(
          path.join(tempDir.path, 'lib', 'features', 'home', 'presentation', 'views', 'widgets'),
        );
        expect(widgetsDir.existsSync(), isTrue);

        // Verify presentation/views/home_screen.dart exists
        final screenFile = File(
          path.join(tempDir.path, 'lib', 'features', 'home', 'presentation', 'views', 'home_screen.dart'),
        );
        expect(screenFile.existsSync(), isTrue);
      } finally {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      }
    });
  });
}

