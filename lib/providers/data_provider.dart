import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';

final databaseHelperProvider = Provider((ref) => HiveDatabaseHelper());