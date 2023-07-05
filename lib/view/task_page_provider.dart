import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/domain/utils.dart';

StateProvider<DateTime?> dateProvider = StateProvider((ref) => null);
StateProvider<bool> switchProvider = StateProvider((ref) => false);
StateProvider<String> dropdownValueProvider = StateProvider((ref) => 'None');