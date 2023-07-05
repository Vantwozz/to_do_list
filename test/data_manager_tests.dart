import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do_list/domain//utils.dart';
import 'package:to_do_list/domain/data_manager.dart';
import 'package:to_do_list/repository/network_manager.dart';
import 'package:to_do_list/repository/persistence_manager.dart';

class MockNetworkManager extends Mock implements NetworkManager {}

class MockPersistenceManager extends Mock implements PersistenceManager {}

void main() {
  late DataManager sut;
  late MockNetworkManager mockNetworkManager;
  late MockPersistenceManager mockPersistenceManager;
  setUp(
    () {
      mockNetworkManager = MockNetworkManager();
      mockPersistenceManager = MockPersistenceManager();
      sut = DataManager(mockNetworkManager, mockPersistenceManager);
    },
  );
  test(
    'Check connection test',
    () async {
      await sut.checkConnection();
      verify(() => mockNetworkManager.checkConnection()).called(1);
    },
  );
  group(
    'Check equal lists',
    () {
      test(
        'List getters called',
        () async {
          when(() => mockPersistenceManager.getList()).thenAnswer(
            (invocation) async => [
              AdvancedTask(
                id: 'id',
                text: 'text',
                importance: 'low',
                done: false,
                createdAt: 1,
                changedAt: 1,
                lastUpdatedBy: '1',
              ),
            ],
          );
          when(() => mockNetworkManager.getFullList()).thenAnswer(
            (invocation) async => [
              AdvancedTask(
                id: 'id',
                text: 'text',
                importance: 'low',
                done: false,
                createdAt: 1,
                changedAt: 1,
                lastUpdatedBy: '1',
              ),
            ],
          );
          await sut.getList();
          verify(() => mockNetworkManager.getFullList()).called(1);
          verify(() => mockPersistenceManager.getList()).called(1);
        },
      );
      test(
        'List got',
        () async {},
      );
    },
  );
}
