import "package:permission_handler/permission_handler.dart";

class CheckPermission {
  Future<bool> isStoragePermission() async {
    var isStorage = await Permission.storage.status;
    var isAcsLoc = await Permission.accessMediaLocation.status;
    var isMngExt = await Permission.manageExternalStorage.status;
    if (!isStorage.isGranted || !isAcsLoc.isGranted || isMngExt.isGranted) {
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      await Permission.manageExternalStorage.request();
      if (!isStorage.isGranted || !isAcsLoc.isGranted || !isMngExt.isGranted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
