// ignore_for_file: curly_braces_in_flow_control_structures

part of xlive_switch;

class _XlivSwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _XlivSwitchRenderObjectWidget({
    Key key,
    @required this.value,
    @required this.activeColor,
    @required this.unActiveColor,
    @required this.thumbColor,
    @required this.onChanged,
    @required this.vsync,
  }) : super(key: key);

  final bool value;
  final Color activeColor;
  final Color unActiveColor;
  final Color thumbColor;
  final ValueChanged<bool> onChanged;
  final TickerProvider vsync;

  @override
  _RenderXliveSwitch createRenderObject(BuildContext context) {
    return _RenderXliveSwitch(
      value: value,
      activeColor: activeColor,
      onChanged: onChanged,
      unActiveColor: unActiveColor,
      thumbColor: thumbColor,
      textDirection: Directionality.of(context),
      vsync: vsync,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderXliveSwitch renderObject) {
    renderObject
      ..value = value
      ..activeColor = activeColor
      ..unActiveColor = unActiveColor
      ..onChanged = onChanged
      ..thumbColor = thumbColor
      ..textDirection = Directionality.of(context)
      ..vsync = vsync;
  }
}

const double _kTrackWidth = 51.0;
const double _kTrackHeight = 31.0;
const double _kTrackRadius = _kTrackHeight / 2.0;
const double _kTrackInnerStart = _kTrackHeight / 2.0;
const double _kTrackInnerEnd = _kTrackWidth - _kTrackInnerStart;
const double _kTrackInnerLength = _kTrackInnerEnd - _kTrackInnerStart;
const double _kSwitchWidth = 59.0;
const double _kSwitchHeight = 39.0;

const Duration _kReactionDuration = Duration(milliseconds: 300);
const Duration _kToggleDuration = Duration(milliseconds: 200);

class _RenderXliveSwitch extends RenderConstrainedBox {
  _RenderXliveSwitch({
    @required bool value,
    @required Color activeColor,
    @required Color unActiveColor,
    @required Color thumbColor,
    @required ValueChanged<bool> onChanged,
    @required TextDirection textDirection,
    @required TickerProvider vsync,
  })  : assert(value != null),
        assert(activeColor != null),
        assert(vsync != null),
        _value = value,
        _activeColor = activeColor,
        _unActiveColor = unActiveColor,
        _onChanged = onChanged,
        _textDirection = textDirection,
        _thumbColor = thumbColor,
        _thumbPainter = _XliveThumbPainter(color: thumbColor),
        _vsync = vsync,
        super(
            additionalConstraints: const BoxConstraints.tightFor(
                width: _kSwitchWidth, height: _kSwitchHeight)) {
    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTap = _handleTap
      ..onTapUp = _handleTapUp
      ..onTapCancel = _handleTapCancel;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd;
    _positionController = AnimationController(
      duration: _kToggleDuration,
      value: value ? 1.0 : 0.0,
      vsync: vsync,
    );
    _position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.bounceOut,
    )
      ..addListener(markNeedsPaint)
      ..addStatusListener(_handlePositionStateChanged);
    _reactionController = AnimationController(
      duration: _kReactionDuration,
      vsync: vsync,
    );

    _color = ColorTween(
      begin: _unActiveColor,
      end: _activeColor,
    ).animate(_positionController);
  }

  Animation<Color> _color;

  Color _thumbColor;

  set thumbColor(Color value) {
    if (value == _thumbColor) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;

  AnimationController _positionController;
  CurvedAnimation _position;

  AnimationController _reactionController;

  bool get value => _value;
  bool _value;

  set value(bool value) {
    assert(value != null);
    if (value == _value) return;
    _value = value;
    markNeedsSemanticsUpdate();
    _position
      ..curve = Curves.bounceOut
      ..reverseCurve = Curves.bounceOut.flipped;
    if (value)
      _positionController.forward();
    else
      _positionController.reverse();
  }

  TickerProvider get vsync => _vsync;
  TickerProvider _vsync;

  set vsync(TickerProvider value) {
    assert(value != null);
    if (value == _vsync) return;
    _vsync = value;
    _positionController.resync(vsync);
    _reactionController.resync(vsync);
  }

  Color get activeColor => _activeColor;

  Color get unActiveColor => _unActiveColor;
  Color _activeColor;
  Color _unActiveColor;

  set activeColor(Color value) {
    assert(value != null);
    if (value == _activeColor) return;
    _activeColor = value;
    markNeedsPaint();
  }

  set unActiveColor(Color value) {
    assert(value != null);
    if (value == _unActiveColor) return;
    _unActiveColor = value;
    markNeedsPaint();
  }

  ValueChanged<bool> get onChanged => _onChanged;
  ValueChanged<bool> _onChanged;

  set onChanged(ValueChanged<bool> value) {
    if (value == _onChanged) return;
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    assert(value != null);
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  bool get isInteractive => onChanged != null;

  TapGestureRecognizer _tap;
  HorizontalDragGestureRecognizer _drag;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (value)
      _positionController.forward();
    else
      _positionController.reverse();
    if (isInteractive) {
      switch (_reactionController.status) {
        case AnimationStatus.forward:
          _reactionController.forward();
          break;
        case AnimationStatus.reverse:
          _reactionController.reverse();
          break;
        case AnimationStatus.dismissed:
        case AnimationStatus.completed:
          // nothing to do
          break;
      }
    }
  }

  @override
  void detach() {
    _positionController.stop();
    _reactionController.stop();
    super.detach();
  }

  void _handlePositionStateChanged(AnimationStatus status) {
    if (isInteractive) {
      if (status == AnimationStatus.completed && !_value)
        onChanged(true);
      else if (status == AnimationStatus.dismissed && _value) onChanged(false);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) _reactionController.forward();
  }

  void _handleTap() {
    if (isInteractive) onChanged(!_value);
  }

  void _handleTapUp(TapUpDetails details) {
    if (isInteractive) _reactionController.reverse();
  }

  void _handleTapCancel() {
    if (isInteractive) _reactionController.reverse();
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) _reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      // _position
      //   ..curve = null
      //   ..reverseCurve = null;
      final double delta = details.primaryDelta / _kTrackInnerLength;
      switch (textDirection) {
        case TextDirection.rtl:
          _positionController.value -= delta;
          break;
        case TextDirection.ltr:
          _positionController.value += delta;
          break;
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_position.value >= 0.5)
      _positionController.forward();
    else
      _positionController.reverse();
    _reactionController.reverse();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      _drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    if (isInteractive) config.onTap = _handleTap;

    config.isEnabled = isInteractive;
    config.isToggled = _value;
  }

  final _XliveThumbPainter _thumbPainter;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final double currentValue = _position.value;

    double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final trackColor = _color.value;
    const double borderThickness = 1.5 + (_kTrackRadius - 1.5) * 1.0;

    final Paint paint = Paint()..color = trackColor;

    final Rect trackRect = Rect.fromLTWH(
        offset.dx + (size.width - _kTrackWidth) / 2.0,
        offset.dy + (size.height - _kTrackHeight) / 2.0,
        _kTrackWidth,
        _kTrackHeight);
    final RRect outerRRect = RRect.fromRectAndRadius(
        trackRect, const Radius.circular(_kTrackRadius));
    final RRect innerRRect = RRect.fromRectAndRadius(
        trackRect.deflate(borderThickness),
        const Radius.circular(_kTrackRadius));
    canvas.drawDRRect(outerRRect, innerRRect, paint);

    final double thumbLeft = lerpDouble(
      trackRect.left + _kTrackInnerStart - _XliveThumbPainter.radius,
      trackRect.left + _kTrackInnerEnd - _XliveThumbPainter.radius,
      visualPosition,
    );
    final double thumbRight = lerpDouble(
      trackRect.left + _kTrackInnerStart + _XliveThumbPainter.radius,
      trackRect.left + _kTrackInnerEnd + _XliveThumbPainter.radius,
      visualPosition,
    );
    final double thumbCenterY = offset.dy + size.height / 2.0;

    _thumbPainter.paint(
      canvas,
      Rect.fromLTRB(
        thumbLeft + (currentValue / 2).abs() * 8.0,
        thumbCenterY - _XliveThumbPainter.radius,
        thumbRight - (currentValue / 2).abs() * 8.0,
        thumbCenterY + _XliveThumbPainter.radius,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(FlagProperty('value',
        value: value, ifTrue: 'checked', ifFalse: 'unchecked', showName: true));
    description.add(FlagProperty('isInteractive',
        value: isInteractive,
        ifTrue: 'enabled',
        ifFalse: 'disabled',
        showName: true,
        defaultValue: true));
  }
}
