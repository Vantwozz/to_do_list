import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/domain/utils.dart';

final dateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final switchProvider = StateProvider.autoDispose<bool>((ref) => false);
final dropdownValueProvider = StateProvider.autoDispose<String>((ref) => 'None');