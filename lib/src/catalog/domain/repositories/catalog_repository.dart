import 'package:mini_pos_engine/src/catalog/domain/entities/item.dart';
import 'package:mini_pos_engine/src/core/either.dart';

abstract class CatalogRepository {
  Future<Either<List<Item>>> getCatalog();
}
