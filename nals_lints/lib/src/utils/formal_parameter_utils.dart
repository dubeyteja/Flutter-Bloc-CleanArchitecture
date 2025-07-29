import '../index.dart';

extension FormalParameterExt on FormalParameter {
  DartType? get type => declaredFragment?.element.type;

  bool get hasDefaultValue => declaredFragment?.element.hasDefaultValue == true;

  String? get defaultValue => declaredFragment?.element.defaultValueCode;

  bool get isNullableType => type?.isNullableType == true;
}
