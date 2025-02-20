import 'package:hooks_riverpod/hooks_riverpod.dart';

final greetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;
  return hour < 12 ? 'Good Morning' : 
         hour < 18 ? 'Good Afternoon' : 'Good Evening';
});