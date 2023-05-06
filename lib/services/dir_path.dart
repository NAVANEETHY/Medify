import "dart:io";

class dirPath {
  getPath() async {
    final path = Directory(
        '/storage/emulated/0/Android/media/com.example.flutter_auth/files');
    if (await path.exists()) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }
}
