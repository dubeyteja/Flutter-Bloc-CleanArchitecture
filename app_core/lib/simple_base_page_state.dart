import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

/// Simple base page state for features that provides basic functionality
/// without tight coupling to app-specific classes
abstract class SimpleBasePageState<T extends StatefulWidget, B extends BlocBase>
    extends State<T> with LogMixin {
  
  B? _bloc;
  
  B get bloc => _bloc ??= _createBloc();
  
  /// Override this to provide the bloc instance
  B _createBloc();
  
  /// Override this to build the page content
  Widget buildPage(BuildContext context);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (context) => bloc,
      child: buildPage(context),
    );
  }
  
  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}