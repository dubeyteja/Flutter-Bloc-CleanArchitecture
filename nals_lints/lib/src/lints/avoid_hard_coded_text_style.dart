import '../index.dart';

class AvoidHardCodedTextStyle extends DartLintRule {
  const AvoidHardCodedTextStyle() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_hard_coded_text_style',
    problemMessage:
        'Avoid hard-coding text styles.\nPlease use \'AppTextStyles\' instead',
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
                if (_isHardCoded(element.expression.toString())) {
                  reporter.atNode(element.expression, code);
                }
              } else if (_isHardCoded(element.toString())) {
                reporter.atNode(element, code);
              }
            });
          },
          onVisitVariableDeclaration: (VariableDeclaration node) {
            if (node.initializer != null &&
                _isHardCoded(node.initializer.toString())) {
              reporter.atNode(node.initializer!, code);
            }
          },
          onVisitAssignmentExpression: (AssignmentExpression node) {
            if (_isHardCoded(node.rightHandSide.toString())) {
              reporter.atNode(node.rightHandSide, code);
            }
          },
          onVisitConstructorFieldInitializer:
              (ConstructorFieldInitializer node) {
            if (_isHardCoded(node.expression.toString())) {
              reporter.atNode(node.expression, code);
            }
          },
          onVisitSuperConstructorInvocation: (SuperConstructorInvocation node) {
            node.argumentList.arguments.forEach((element) {
              if (element is NamedExpression) {
                if (_isHardCoded(element.expression.toString())) {
                  reporter.atNode(element.expression, code);
                }
              } else if (_isHardCoded(element.toString())) {
                reporter.atNode(element, code);
              }
            });
          },
          onVisitConstructorDeclaration: (ConstructorDeclaration node) {
            node.parameters.parameterFragments.forEach((element) {
              if (element?.element.defaultValueCode != null &&
                  _isHardCoded(element!.element.defaultValueCode!)) {
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
                if (_isHardCoded(element.expression.toString())) {
                  reporter.atNode(element.expression, code);
                }
              } else if (_isHardCoded(element.toString())) {
                reporter.atNode(element, code);
              }
            });
          },
        )));
  }

  bool _isHardCoded(String textStyle) {
    return textStyle.replaceAll(' ', '').startsWith('TextStyle(');
  }
}
