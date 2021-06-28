import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/simpleprovider/inherited_provider.dart';

class Provider<T extends ChangeNotifier?> extends InheritedProvider<T> {
  Provider({
    required Create<T> create,
    required Widget child,
  }) : super(
          startListening: _startListening,
          create: create,
          dispose: _dispose,
          child: child,
        );

  static void _dispose(BuildContext context, ChangeNotifier? notifier) {
    notifier?.dispose();
  }

  static VoidCallback _startListening(InheritedContext e, Listenable? value) {
    value?.addListener(e.markNeedsNotifyDependents);
    return () => value?.removeListener(e.markNeedsNotifyDependents);
  }

  static T of<T>(BuildContext context) {
    final inheritedElement = context.getElementForInheritedWidgetOfExactType<
        InheritedProviderScope<T>>() as InheritedProviderScopeElement<T>;
    context.dependOnInheritedElement(inheritedElement);
    return inheritedElement.value;
  }
}
