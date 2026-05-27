import 'dart:io';

void main() async {
  final dir = Directory('lib');
  final testDir = Directory('test');
  final pubspec = File('pubspec.yaml');
  
  final allFiles = <File>[];
  if (dir.existsSync()) {
    allFiles.addAll(dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')));
  }
  if (testDir.existsSync()) {
    allFiles.addAll(testDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')));
  }
  if (pubspec.existsSync()) {
    allFiles.add(pubspec);
  }
  
  for (final file in allFiles) {
    String content = await file.readAsString();
    bool changed = false;
    
    if (content.contains('Waroeng')) {
      content = content.replaceAll('Waroeng', 'Serve');
      changed = true;
    }
    if (content.contains('waroeng')) {
      content = content.replaceAll('waroeng', 'serve');
      changed = true;
    }
    
    if (changed) {
      await file.writeAsString(content);
      print('Updated content in ${file.path}');
    }
    
    final basename = file.path.split(Platform.pathSeparator).last;
    if (basename.contains('waroeng')) {
      final newPath = file.path.replaceAll('waroeng', 'serve');
      await file.rename(newPath);
      print('Renamed $file to $newPath');
    }
  }
}
