import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:smusy_v2/app/module.dart';
import 'package:smusy_v2/content/module.dart';

import 'cubit.dart';

class EditPage extends StatefulWidget {
  const EditPage({@required this.backgroundType, this.picturePath})
      : assert(backgroundType != null);

  final String backgroundType;
  final String picturePath;

  @override
  _EditPageState createState() => _EditPageState(backgroundType, picturePath);
}

class _EditPageState extends State<EditPage>
    with StateWithCubit<EditCubit, EditState, EditPage> {
  _EditPageState(String backgroundType, String picturePath)
      : assert(backgroundType != null),
        cubit = EditCubit(backgroundType, picturePath);

  @override
  final EditCubit cubit;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _textOverlays = <TextOverlay>[];
  var _textOverlayKeys = <GlobalKey>[];

  @override
  void onCubitData(EditState state) {
    state.maybeWhen(
      unknownError: () => _scaffoldKey.showSimpleSnackBar(
        context.s.general_error_unknown,
      ),
      updated: (textOverlays) {
        _textOverlays = textOverlays;
        _textOverlayKeys = _textOverlays.map((_) => GlobalKey()).toList();
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = context.theme.brightness;

    return WillPopScope(
      onWillPop: context.showDiscardChangesDialog,
      child: Theme(
        data: AppTheme.secondary(brightness),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(child: _buildPreview()),
                  Positioned.fill(child: _Overlay(cubit)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return AspectRatio(
      aspectRatio: ContentMedia.aspectRatio,
      child: SizedBox.expand(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return DragTarget<int>(
              onAcceptWithDetails: (details) =>
                  _moveTextOverlay(context, details, constraints),
              builder: (context, candidates, rejects) {
                return Stack(
                  children: [
                    Positioned.fill(child: _buildBackground()),
                    Positioned.fill(child: _buildGestureDetector(context)),
                    for (final entry in _textOverlays.asMap().entries)
                      _buildTextOverlay(entry),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Positioned _buildTextOverlay(MapEntry<int, TextOverlay> entry) {
    return Positioned.fill(
      child: TextOverlayWidget(
        cubit: cubit,
        globalKey: _textOverlayKeys[entry.key],
        index: entry.key,
        textOverlay: entry.value,
      ),
    );
  }

  GestureDetector _buildGestureDetector(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
          currentFocus.unfocus();
        }
      },
      child: SizedBox(),
    );
  }

  void _moveTextOverlay(BuildContext context, DragTargetDetails<int> details,
      BoxConstraints constraints) {
    // When a 'TextOverlayWidget' is moved, we need to calculate
    // the new relative x and y position (mapped to -1 and 1) and
    // therefore we use the global offset on the screen
    // (topLeft = 0,0) and subtract the widget's size.
    final offset =
        (context.findRenderObject() as RenderBox).globalToLocal(details.offset);
    final widgetSize = (_textOverlayKeys[details.data]
            .currentContext
            .findRenderObject() as RenderBox)
        .size;

    final x =
        offset.dx.mapRange(0, constraints.maxWidth - widgetSize.width, -1, 1);
    final y =
        offset.dy.mapRange(0, constraints.maxHeight - widgetSize.height, -1, 1);

    cubit.moveTextOverlay(details.data, x, y);
  }

  Widget _buildBackground() {
    return cubit.background.when(
      image: (file) => Image.file(file, fit: BoxFit.cover),
      gradient: (colors) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }
}

class TextOverlayWidget extends StatefulWidget {
  TextOverlayWidget({
    @required this.cubit,
    @required this.globalKey,
    @required this.index,
    @required this.textOverlay,
  })  : assert(cubit != null),
        assert(globalKey != null),
        assert(index != null),
        assert(textOverlay != null),
        super(key: ValueKey(index));

  final EditCubit cubit;
  final GlobalKey globalKey;
  final int index;
  final TextOverlay textOverlay;

  @override
  _TextOverlayWidgetState createState() => _TextOverlayWidgetState();
}

class _TextOverlayWidgetState extends State<TextOverlayWidget> {
  TextEditingController controller;
  final focusNode = FocusNode();
  StreamSubscription<bool> keyboardVisibilitySubscription;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.textOverlay.text);
    focusNode.addListener(() {
      if (!focusNode.hasFocus && widget.textOverlay.text.isBlank) {
        widget.cubit.deleteTextOverlay(widget.index);
      }
    });
    if (widget.textOverlay.text.isBlank) focusNode.requestFocus();

    keyboardVisibilitySubscription =
        KeyboardVisibilityController().onChange.listen((isVisible) {
      if (!isVisible) focusNode.unfocus();
    });
  }

  @override
  void dispose() {
    keyboardVisibilitySubscription.cancel();
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(widget.textOverlay.x, widget.textOverlay.y),
      child: Draggable<int>(
        data: widget.index,
        onDragStarted: widget.cubit.startDraggingTextOverlay,
        child: IntrinsicWidth(
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            onChanged: (value) =>
                widget.cubit.editTextOverlayText(widget.index, value),
            style: TextOverlay.baseTextStyle,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration.collapsed(hintText: null),
          ),
        ),
        feedback: Text(
          widget.textOverlay.text,
          key: widget.globalKey,
          style: TextOverlay.baseTextStyle,
        ),
        childWhenDragging: SizedBox(),
      ),
    );
  }
}

class _Overlay extends StatefulWidget {
  const _Overlay(this.cubit) : assert(cubit != null);
  final EditCubit cubit;

  @override
  _OverlayState createState() => _OverlayState();
}

class _OverlayState extends State<_Overlay> {
  var dragTargetColor = Colors.white;
  static final _scrimColor = Colors.black.withOpacity(0.2);
  static const _scrimHeight = kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._buildScrims(),
        Positioned(left: 0, top: 0, child: CloseButton()),
        Positioned(
            right: 0, top: 0, child: _buildTextOverlayCreateDeleteButton()),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _buildFab(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTextOverlayCreateDeleteButton() {
    return widget.cubit.isDraggingTextOverlay
        ? Padding(
            padding: const EdgeInsets.all(8),
            child: DragTarget<int>(
              onMove: (_) {
                setState(() => dragTargetColor = Colors.red);
              },
              onLeave: (_) {
                setState(() => dragTargetColor = Colors.white);
              },
              onAccept: (data) {
                setState(() => dragTargetColor = Colors.white);
                widget.cubit.deleteTextOverlay(data);
              },
              builder: (context, candidates, rejects) => Icon(
                Icons.delete,
                color: dragTargetColor,
              ),
            ),
          )
        : IconButton(
            onPressed: widget.cubit.createTextOverlay,
            icon: Icon(Icons.text_fields),
          );
  }

  List<Widget> _buildScrims() {
    final colors = [_scrimColor, Colors.transparent];

    return [
      Positioned(
        left: 0,
        top: 0,
        right: 0,
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_scrimColor, Colors.transparent],
              ),
            ),
            child: SizedBox(height: _scrimHeight),
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: colors,
              ),
            ),
            child: SizedBox(height: _scrimHeight),
          ),
        ),
      ),
    ];
  }

  Widget _buildFab(BuildContext context) {
    return Theme(
      data: AppTheme.primary(context.theme.brightness),
      child: FancyFab.extended(
        isEnabled: widget.cubit.canPost,
        isLoading: widget.cubit.isPosting,
        loadingIndicator: SizedBox.fromSize(
          size: Size.square(18),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            value: widget.cubit.postingProgress,
            valueColor: AlwaysStoppedAnimation<Color>(
              context.theme.highEmphasisOnPrimary,
            ),
          ),
        ),
        onPressed: () async {
          if (!await widget.cubit.post()) return;
          context.navigator..pop()..pop();
        },
        icon: Icon(Icons.send),
        label: Text('Posten'),
        reverseChildren: true,
      ),
    );
  }
}
