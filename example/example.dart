import 'dart:io';

/// Example showing how to use the FLAB CLI commands in your terminal.
void main() async {
  print('--- FLAB CLI Quick Usage Example ---\n');

  // 1. Initialize Project
  print('1. Bootstrap a new Flutter project:');
  print('   \$ flab init my_awesome_app\n');

  // 2. Scaffold Feature Modules
  print('2. Scaffold Clean Architecture feature:');
  print('   \$ flab auth --clean\n');

  print('3. Scaffold MVVM feature:');
  print('   \$ flab profile --mvvm\n');

  // 3. Inject Specific Component
  print('4. Inject a custom UseCase:');
  print('   \$ flab auth -u LoginUser\n');

  // 4. Config & Utilities
  print('5. Inject theme configuration:');
  print('   \$ flab config theme\n');

  // 5. Diagnostics
  print('6. Check project health:');
  print('   \$ flab doctor\n');

  print('------------------------------------');
  print('For full command details, run: flab --help');
}