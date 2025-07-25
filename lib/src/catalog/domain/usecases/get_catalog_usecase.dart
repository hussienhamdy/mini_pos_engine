import 'package:mini_pos_engine/src/catalog/domain/entities/item.dart';
import 'package:mini_pos_engine/src/catalog/domain/repositories/catalog_repository.dart';
import 'package:mini_pos_engine/src/core/either.dart';

class GetCatalogUsecase {
  final CatalogRepository catalogRepository;

  GetCatalogUsecase({required this.catalogRepository});

  Future<Either<List<Item>>> call() async {
    return await catalogRepository.getCatalog();
  }
}
