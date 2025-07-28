import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:app_core/app_core.dart';
import 'package:app/app.dart';
import 'main.dart';

@Injectable()
class MainBloc extends BaseBloc<MainEvent, MainState> {
  MainBloc() : super(const MainState()) {
    on<MainPageInitiated>(
      _onMainPageInitiated,
      transformer: log(),
    );
  }

  FutureOr<void> _onMainPageInitiated(MainPageInitiated event, Emitter<MainState> emit) {}
}
