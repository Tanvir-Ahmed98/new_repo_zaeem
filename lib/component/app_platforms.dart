
import 'dart:io';

enum AppPlatform { android, ios, windows, other }

AppPlatform getPlatform() {
  if (Platform.isAndroid) return AppPlatform.android;
  if (Platform.isIOS) return AppPlatform.ios;
  if (Platform.isWindows) return AppPlatform.windows;
  return AppPlatform.other;
}
