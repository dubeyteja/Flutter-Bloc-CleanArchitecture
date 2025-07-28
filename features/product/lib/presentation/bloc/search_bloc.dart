import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:app_core/app_core.dart';
import 'package:app/app.dart';
import 'search.dart';

@Injectable()
class SearchBloc extends BaseBloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchPageInitiated>(
      _onSearchPageInitiated,
      transformer: log(),
    );
  }

  FutureOr<void> _onSearchPageInitiated(SearchPageInitiated event, Emitter<SearchState> emit) {}
}
