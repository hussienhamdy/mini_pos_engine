import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mini_pos_engine/src/catalog/domain/entities/item.dart';
import 'package:mini_pos_engine/src/catalog/domain/usecases/get_catalog_usecase.dart';
import 'package:mini_pos_engine/src/core/failures.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final GetCatalogUsecase getCatalogUsecase;

  CatalogBloc(this.getCatalogUsecase) : super(CatalogInitial()) {
    on<LoadCatalog>((event, emit) async {
      emit(CatalogLoading());
      final result = await getCatalogUsecase.call();
      if (result.getValue() is Failure) {
        emit(CatalogError((result.getValue() as FailureWithMessage).message));
      } else {
        emit(CatalogLoaded(result.getValue() as List<Item>));
      }
    });
  }
}
