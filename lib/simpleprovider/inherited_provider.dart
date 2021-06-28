import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';
import 'package:flutter/scheduler.dart';

typedef Create<T> = T Function(BuildContext context);

typedef Dispose<T> = void Function(BuildContext context, T value);

typedef StartListening<T> = VoidCallback Function(
    InheritedContext<T> element, T value);

class InheritedProvider<T> extends SingleChildStatelessWidget {
  InheritedProvider({
    Create<T>? create,
    StartListening<T>? startListening,
    Dispose<T>? dispose,
    Widget? child,
  })  : _delegate = _CreateInheritedProvider(
          create: create,
          startListening: startListening,
          dispose: dispose,
        ),
        super(child: child);

  final _delegate;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return InheritedProviderScope<T>(
      owner: this,
      child: child!,
    );
  }
}

abstract class InheritedContext<T> extends BuildContext {
  void markNeedsNotifyDependents();
}

class _CreateInheritedProvider<T> {
  _CreateInheritedProvider({
    this.create,
    this.startListening,
    this.dispose,
  });

  final Create<T>? create;
  final StartListening<T>? startListening;
  final Dispose<T>? dispose;

  _CreateInheritedProviderState<T> createState() =>
      _CreateInheritedProviderState();
}

class _CreateInheritedProviderState<T> extends _DelegateState<T> {
  VoidCallback? _removeListener;
  bool _didInitValue = false;
  T? _value;

  @override
  T get value {
    if (!_didInitValue) {
      _didInitValue = true;
      if (delegate.create != null) {
        _value = delegate.create!(element!);
      }
    }

    _removeListener ??= delegate.startListening?.call(element!, _value as T);
    return _value as T;
  }

  @override
  bool get hasValue => _didInitValue;
}

abstract class _DelegateState<T> {
  InheritedProviderScopeElement<T>? element;

  T get value;

  dynamic get delegate => element!.widget.owner._delegate;

  bool get hasValue;

  void dispose() {}
}

class InheritedProviderScope<T> extends InheritedWidget {
  InheritedProviderScope({
    required this.owner,
    required Widget child,
  }) : super(child: child);

  final InheritedProvider<T> owner;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  @override
  InheritedProviderScopeElement<T> createElement() {
    return InheritedProviderScopeElement<T>(this);
  }
}

class InheritedProviderScopeElement<T> extends InheritedElement
    implements InheritedContext<T> {
  InheritedProviderScopeElement(InheritedProviderScope<T> widget)
      : super(widget);

  bool _firstBuild = true;
  late _DelegateState<T> delegateState;

  @override
  InheritedProviderScope<T> get widget =>
      super.widget as InheritedProviderScope<T>;

  @override
  void performRebuild() {
    if (_firstBuild) {
      _firstBuild = false;
      delegateState = widget.owner._delegate.createState()..element = this;
    }
    super.performRebuild();
  }

  @override
  Widget build() {
    notifyClients(widget);
    return super.build();
  }

  @override
  void unmount() {
    delegateState.dispose();
    super.unmount();
  }

  @override
  void markNeedsNotifyDependents() {
    markNeedsBuild();
  }

  T get value => delegateState.value;
}
