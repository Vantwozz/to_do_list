import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do_list/domain/data_manager.dart';
import 'package:to_do_list/domain/utils.dart';
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

  Future<void> connectionFalse() async {
    when(() => mockNetworkManager.checkConnection())
        .thenThrow(Exception('error!'));
    await sut.checkConnection();
  }

  test(
    'Check connection test',
        () async {
      await sut.checkConnection();
      verify(() => mockNetworkManager.checkConnection()).called(1);
    },
  );
  group(
    'Check get list',
        () {
      final List<AdvancedTask> listFromPersistence = [
        AdvancedTask(
          id: 'id',
          text: 'text',
          importance: 'low',
          done: false,
          createdAt: 1,
          changedAt: 1,
          lastUpdatedBy: '1',
        ),
      ];

      final List<AdvancedTask> listFromNetwork = [
        AdvancedTask(
          id: 'id2',
          text: 'text2',
          importance: 'low',
          done: false,
          createdAt: 2,
          changedAt: 2,
          lastUpdatedBy: '2',
        ),
      ];

      void setData() {
        when(() => mockPersistenceManager.getList())
            .thenAnswer((invocation) async => listFromPersistence);
        when(() => mockNetworkManager.getFullList())
            .thenAnswer((invocation) async => listFromNetwork);
      }

      test(
        'Network list getter called',
            () async {
          setData();
          await sut.getList();
          verify(() => mockNetworkManager.getFullList()).called(1);
        },
      );

      test(
        'Persistence list getter called',
            () async {
          setData();
          await connectionFalse();
          await sut.getList();
          verify(() => mockPersistenceManager.getList()).called(1);
        },
      );

      test(
        'List got from network',
            () async {
          setData();
          final list = await sut.getList();
          expect(list, listFromNetwork);
        },
      );

      test(
        'List got from persistence',
            () async {
          setData();
          await connectionFalse();
          var list = await sut.getList();
          expect(list, listFromPersistence);
        },
      );
    },
  );
  group('', () {

  });
}