import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:app_core/app_core.dart';
import 'package:app/app.dart';
import 'item_detail.dart';

@Injectable()
class ItemDetailBloc extends BaseBloc<ItemDetailEvent, ItemDetailState> {
  ItemDetailBloc() : super(const ItemDetailState()) {
    on<ItemDetailPageInitiated>(
      _onItemDetailPageInitiated,
      transformer: log(),
    );
  }

  FutureOr<void> _onItemDetailPageInitiated(
    ItemDetailPageInitiated event,
    Emitter<ItemDetailState> emit,
  ) {}
}
