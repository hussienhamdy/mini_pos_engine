import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_pos_engine/src/catalog/domain/entities/item.dart';
import 'package:mini_pos_engine/src/catalog/domain/usecases/get_catalog_usecase.dart';
import 'package:mini_pos_engine/src/catalog/presentation/blocs/catalog_bloc.dart';
import 'package:mini_pos_engine/src/core/either.dart';
import 'package:mini_pos_engine/src/core/failures.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCatalogUseCase extends Mock implements GetCatalogUsecase {}

void main() {
  late MockGetCatalogUseCase mockGetCatalogUseCase;

  setUp(() {
    mockGetCatalogUseCase = MockGetCatalogUseCase();
  });

  group('CatalogBloc', () {
    final tItems = [
      const Item(id: '1', name: 'Test Item 1', price: 10.0),
      const Item(id: '2', name: 'Test Item 2', price: 20.0),
    ];

    blocTest<CatalogBloc, CatalogState>(
      'emits [CatalogLoading, CatalogLoaded] when LoadCatalog is added and successful',
      build: () {
        when(
          () => mockGetCatalogUseCase.call(),
        ).thenAnswer((_) async => Either(value: tItems));
        return CatalogBloc(mockGetCatalogUseCase);
      },
      act: (bloc) {
        bloc.add(LoadCatalog());
      },
      expect: () => [CatalogLoading(), CatalogLoaded(tItems)],
      verify: (_) {
        verify(() => mockGetCatalogUseCase.call()).called(1);
      },
    );

    blocTest<CatalogBloc, CatalogState>(
      'emits [CatalogLoading, CatalogError] when LoadCatalog is added and fails',
      build: () {
        when(() => mockGetCatalogUseCase.call()).thenAnswer(
          (_) async =>
              Either(failure: FailureWithMessage(message: 'Failed to load')),
        );
        return CatalogBloc(mockGetCatalogUseCase);
      },
      act: (bloc) => bloc.add(LoadCatalog()),
      expect: () => [CatalogLoading(), const CatalogError('Failed to load')],
      verify: (_) {
        verify(() => mockGetCatalogUseCase.call()).called(1);
      },
    );
  });
}
