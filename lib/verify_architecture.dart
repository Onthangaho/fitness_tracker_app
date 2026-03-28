import 'dart:io';


void main() {
  stdout.writeln('=== Architecture Verification ===\n');

  final projectRoot = Directory.current;
  final libPath = Directory('${projectRoot.path}/lib');

  bool allPassed = true;

  stdout.writeln('✓ Checking: No shared_preferences in presentation layer...');
  if (!_checkNosharedPreferencesInPath(libPath, 'presentation')) {
    stdout.writeln('✗ FAILED: Found shared_preferences imports in presentation layer');
    allPassed = false;
  } else {
    stdout.writeln('✓ PASSED: No shared_preferences found in presentation\n');
  }

  stdout.writeln('✓ Checking: No shared_preferences in domain/providers layer...');
  if (!_checkNosharedPreferencesInPath(libPath, 'providers')) {
    stdout.writeln('✗ FAILED: Found shared_preferences imports in providers layer');
    allPassed = false;
  } else {
    stdout.writeln('✓ PASSED: No shared_preferences found in providers\n');
  }

  stdout.writeln('✓ Checking: No ChangeNotifier in data layer...');
  if (!_checkNoChangeNotifierInPath(libPath, 'data')) {
    stdout.writeln('✗ FAILED: Found ChangeNotifier imports in data layer');
    allPassed = false;
  } else {
    stdout.writeln('✓ PASSED: No ChangeNotifier found in data layer\n');
  }

  stdout.writeln('✓ Checking: shared_preferences only exists in data layer...');
  if (!_checksharedPreferencesOnlyInData(libPath)) {
    stdout.writeln('✗ FAILED: shared_preferences found outside data layer');
    allPassed = false;
  } else {
    stdout.writeln('✓ PASSED: shared_preferences only in data layer\n');
  }

  stdout.writeln('✓ Checking: UserProfile model has required methods...');
  if (!_checkUserProfileModel(libPath)) {
    stdout.writeln('✗ FAILED: UserProfile model missing required methods');
    allPassed = false;
  } else {
    stdout.writeln('✓ PASSED: UserProfile model is complete\n');
  }

  stdout.writeln('✓ Checking: Required repositories exist...');
  if (!_checkRepositoriesExist(libPath)) {
    stdout.writeln('✗ FAILED: Required repositories not found');
    allPassed = false;
  } else {
    stdout.writeln('✓ PASSED: All required repositories exist\n');
  }

  stdout.writeln('✓ Checking: Presentation folder structure...');
  if (!_checkPresentationStructure(libPath)) {
    stdout.writeln('✗ FAILED: Presentation structure incomplete');
    allPassed = false;
  } else {
    stdout.writeln('✓ PASSED: Presentation structure is correct\n');
  }

  stdout.writeln('=== VERIFICATION SUMMARY ===');
  if (allPassed) {
    stdout.writeln('✓ ALL CHECKS PASSED - Architecture is correctly structured!');
    exit(0);
  } else {
    stdout.writeln('✗ SOME CHECKS FAILED - See details above');
    exit(1);
  }
}

bool _checkNosharedPreferencesInPath(Directory libPath, String folderName) {
  final folder = Directory('${libPath.path}/$folderName');
  if (!folder.existsSync()) {
    stdout.writeln('  Warning: Folder $folderName not found');
    return true;
  }

  final dartFiles = _getAllDartFiles(folder);
  for (final file in dartFiles) {
    final content = file.readAsStringSync();
    if (content.contains("import 'package:shared_preferences")) {
      stdout.writeln('  Found in: ${file.path}');
      return false;
    }
  }
  return true;
}

bool _checkNoChangeNotifierInPath(Directory libPath, String folderName) {
  final folder = Directory('${libPath.path}/$folderName');
  if (!folder.existsSync()) {
    return true;
  }

  final dartFiles = _getAllDartFiles(folder);
  for (final file in dartFiles) {
    final content = file.readAsStringSync();
    if (content.contains('ChangeNotifier')) {
      stdout.writeln('  Found in: ${file.path}');
      return false;
    }
  }
  return true;
}

bool _checksharedPreferencesOnlyInData(Directory libPath) {
  var modelsPath = Directory('${libPath.path}/models');
  if (modelsPath.existsSync() && !_checkNosharedPreferencesInPath(libPath, 'models')) {
    stdout.writeln('  Found in models folder');
    return false;
  }

  var presentationPath = Directory('${libPath.path}/presentation');
  if (presentationPath.existsSync() && !_checkNosharedPreferencesInPath(libPath, 'presentation')) {
    stdout.writeln('  Found in presentation folder');
    return false;
  }

  return true;
}

bool _checkUserProfileModel(Directory libPath) {
  final userProfileFile = File('${libPath.path}/models/user_profile.dart');
  if (!userProfileFile.existsSync()) {
    stdout.writeln('  user_profile.dart not found');
    return false;
  }

  final content = userProfileFile.readAsStringSync();
  final requiredMethods = [
    'factory UserProfile.defaults()',
    'Map<String, dynamic> toJson()',
    'factory UserProfile.fromJson',
    'UserProfile copyWith(',
  ];

  for (final method in requiredMethods) {
    if (!content.contains(method)) {
      stdout.writeln('  Missing method: $method');
      return false;
    }
  }

  return true;
}

bool _checkRepositoriesExist(Directory libPath) {
  final dataFolder = Directory('${libPath.path}/data');
  if (!dataFolder.existsSync()) {
    stdout.writeln('  data folder not found');
    return false;
  }

  final profileRepo = File('${dataFolder.path}/profile_repository.dart');
  final routineRepo = File('${dataFolder.path}/routine_repository.dart');

  if (!profileRepo.existsSync()) {
    stdout.writeln('  profile_repository.dart not found');
    return false;
  }

  if (!routineRepo.existsSync()) {
    stdout.writeln('  routine_repository.dart not found');
    return false;
  }

  final profileContent = profileRepo.readAsStringSync();
  if (!profileContent.contains("static const String _key = 'user_profile'")) {
    stdout.writeln('  ProfileRepository not using single JSON key pattern');
    return false;
  }

  return true;
}

bool _checkPresentationStructure(Directory libPath) {
  final presentationFolder = Directory('${libPath.path}/presentation');
  if (!presentationFolder.existsSync()) {
    stdout.writeln('  presentation folder not found');
    return false;
  }

  final screensFolder = Directory('${presentationFolder.path}/screens');
  final widgetsFolder = Directory('${presentationFolder.path}/widgets');
  final appRouter = File('${presentationFolder.path}/app_router.dart');

  if (!screensFolder.existsSync()) {
    stdout.writeln('  presentation/screens folder not found');
    return false;
  }

  if (!widgetsFolder.existsSync()) {
    stdout.writeln('  presentation/widgets folder not found');
    return false;
  }

  if (!appRouter.existsSync()) {
    stdout.writeln('  presentation/app_router.dart not found');
    return false;
  }

  return true;
}

List<File> _getAllDartFiles(Directory dir) {
  final files = <File>[];
  try {
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        files.add(entity);
      }
    }
  } catch (e) {
    stdout.writeln('Error reading directory: $e');
  }
  return files;
}

