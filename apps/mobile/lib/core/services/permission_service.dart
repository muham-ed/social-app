import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestCamera() async => (await Permission.camera.request()).isGranted;
  Future<bool> requestMicrophone() async => (await Permission.microphone.request()).isGranted;
  Future<bool> requestPhotos() async => (await Permission.photos.request()).isGranted;
  Future<bool> requestNotifications() async => (await Permission.notification.request()).isGranted;
  Future<bool> requestLocation() async => (await Permission.locationWhenInUse.request()).isGranted;
  Future<void> openSettings() => openAppSettings();
}