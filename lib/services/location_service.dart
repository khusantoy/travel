import 'package:location/location.dart';

class LocationService {
  static final _location = Location();

  static bool _isServiceEnabled = false;
  static PermissionStatus _permissionStatus = PermissionStatus.denied;
  static LocationData? currentLocation;

  static Future<void> init() async {
    await _checkService();
    await _checkPermission();
  }

  // joylashuvni olish xizmati yoqilganmi tekshirmiz
  static Future<void> _checkService() async {
    _isServiceEnabled = await _location.serviceEnabled();

    if (!_isServiceEnabled) {
      _isServiceEnabled = await _location.requestService();
      if (!_isServiceEnabled) {
        return; // Redirect to Settings - Sozlamalardan to'g'rilash kerak endi
      }
    }
  }

  // joylashuvga ruxsat berilganini tekshiramiz
  static Future<void> _checkPermission() async {
    _permissionStatus = await _location.hasPermission();

    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.denied) {
        return; // Sozlamalardan ruxsat berish kerak
      }
    }
  }

  // hozirgi joylashuvni olish
  static Future<void> getCurrentLocation() async {
    if (_isServiceEnabled && _permissionStatus == PermissionStatus.granted) {
      currentLocation = await _location.getLocation();
    }
  }
}