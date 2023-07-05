import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/domain/utils.dart';

List<StateProvider<Task>> listProvider = [];
StateProvider<int> length = StateProvider((ref) => 0);
StateProvider<int> numOfCompleted = StateProvider((ref) => 0);
StateProvider<bool> showCompleted = StateProvider((ref) => true);