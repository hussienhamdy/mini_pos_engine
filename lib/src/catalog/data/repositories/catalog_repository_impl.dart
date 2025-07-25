import 'package:mini_pos_engine/src/catalog/data/datasources/catalog_datasource.dart';
import 'package:mini_pos_engine/src/catalog/domain/entities/item.dart';
import 'package:mini_pos_engine/src/catalog/domain/repositories/catalog_repository.dart';
import 'package:mini_pos_engine/src/core/either.dart';
import 'package:mini_pos_engine/src/core/failures.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogDatasource datasource;

  CatalogRepositoryImpl(this.datasource);

  @override
  Future<Either<List<Item>>> getCatalog() async {
    try {
      final items = await datasource.getCatalog();
      List<Item> itemsEntities = items
          .map((item) => Item(id: item.id, name: item.name, price: item.price))
          .toList();
      return Either(value: itemsEntities);
    } catch (e) {
      return Either(
        failure: FailureWithMessage(
          message: 'Failed to fetch catalog: ${e.toString()}',
        ),
      );
    }
  }
}
