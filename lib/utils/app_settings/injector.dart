import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/local_storage_structure.dart';

class Injector {
  final Palette palette = Palette();
  final QuickStorage quickStorage = QuickStorage();
}

Injector injector = Injector();
