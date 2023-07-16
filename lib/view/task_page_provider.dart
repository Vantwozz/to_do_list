import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final switchProvider = StateProvider.autoDispose<bool>((ref) => false);
final dropdownValueProvider =
    StateProvider.autoDispose<String>((ref) => 'None');
