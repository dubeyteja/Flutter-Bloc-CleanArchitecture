import '../index.dart';

class MissingCallingResponsive extends DartLintRule {
  const MissingCallingResponsive() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_calling_responsive',
    problemMessage:
        'Dimensions must be called with the \'responsive()\' function.\nPlease add the \'responsive()\' function.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    resolver.getResolvedUnitResult().then((value) =>
        value.unit.visitChildren(VariableAndArgumentVisitor(
          onVisitInstanceCreationExpression: (InstanceCreationExpression node) {
            node.argumentList.arguments.forEach((element) {
              if (element is NamedExpression) {
                if (_notResponsive(element.expression.toString())) {
                  reporter.atNode(element.expression, code);
                }
              } else if (_notResponsive(element.toString())) {
                reporter.atNode(element, code);
              }
            });
          },
          onVisitVariableDeclaration: (VariableDeclaration node) {
            if (node.initializer != null &&
                _notResponsive(node.initializer.toString())) {
              reporter.atNode(node.initializer!, code);
            }
          },
          onVisitAssignmentExpression: (AssignmentExpression node) {
            if (_notResponsive(node.rightHandSide.toString())) {
              reporter.atNode(node.rightHandSide, code);
            }
          },
          onVisitConstructorFieldInitializer:
              (ConstructorFieldInitializer node) {
            if (_notResponsive(node.expression.toString())) {
              reporter.atNode(node.expression, code);
            }
          },
          onVisitSuperConstructorInvocation: (SuperConstructorInvocation node) {
            node.argumentList.arguments.forEach((element) {
              if (element is NamedExpression) {
                if (_notResponsive(element.expression.toString())) {
                  reporter.atNode(element.expression, code);
                }
              } else if (_notResponsive(element.toString())) {
                reporter.atNode(element, code);
              }
            });
          },
          onVisitConstructorDeclaration: (ConstructorDeclaration node) {
            node.parameters.parameterFragments.forEach((element) {
              if (element?.element.defaultValueCode != null &&
                  _notResponsive(element!.element.defaultValueCode!)) {
                if (element.element is DefaultFieldFormalParameterElementImpl) {
                  reporter.atNode(
                      (element.element
                              as DefaultFieldFormalParameterElementImpl)
                          .constantInitializer!,
                      code);
                } else if (element.element is DefaultParameterElementImpl) {
                  reporter.atNode(
                      (element.element as DefaultParameterElementImpl)
                          .constantInitializer!,
                      code);
                } else {
                  reporter.atNode(node, code);
                }
              }
            });
          },
          onVisitArgumentList: (node) {
            node.arguments.forEach((element) {
              if (element is NamedExpression) {
                if (_notResponsive(element.expression.toString())) {
                  reporter.atNode(element.expression, code);
                }
              } else if (_notResponsive(element.toString())) {
                reporter.atNode(element, code);
              }
            });
          },
        )));
  }

  bool _notResponsive(String value) {
    return value.startsWith('Dimens.d') && !value.contains('responsive(');
  }

  @override
  List<Fix> getFixes() => [
        AddResponsiveFunction(),
      ];
}

class AddResponsiveFunction extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Add .responsive()',
      priority: 75,
    );

    changeBuilder.addDartFileEdit((builder) {
      builder.addSimpleInsertion(
          analysisError.sourceRange.end, '.responsive()');
    });
  }
}
