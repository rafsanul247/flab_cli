import 'dart:io';
import 'package:flab/src/templates.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('FLAB Feature Scaffolding & Templates', () {
    test('Templates.getEntityContent generates valid entity class', () {
      final content = Templates.getEntityContent('Home');
      expect(content, contains('class HomeEntity {'));
      expect(content, contains('const HomeEntity();'));
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
