import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mini_pos_engine/src/catalog/data/models/item_model.dart';
import 'package:mini_pos_engine/src/core/exceptions.dart';

abstract class CatalogDatasource {
  Future<List<ItemModel>> getCatalog();
}

class CatalogDatasourceImpl implements CatalogDatasource {
  @override
  Future<List<ItemModel>> getCatalog() async {
    try {
      final catalogJson = await rootBundle.loadString('assets/catalog.json');
      List<dynamic> catalog = json.decode(catalogJson) as List<dynamic>;
      return catalog
          .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ExceptionWithMessage(
        message: 'Failed to load catalog: ${e.toString()}',
      );
    }
  }
}
