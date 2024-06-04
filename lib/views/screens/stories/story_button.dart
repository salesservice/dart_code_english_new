import 'package:flutter/material.dart';
import 'package:flutter_isell_new/core/constants/sellx_colors.dart';
import 'package:flutter_isell_new/views/screens/stories/set_state_after_frame_mixin.dart';
import 'package:flutter_isell_new/views/screens/stories/story_page_transform.dart';

import 'first_build_mixin.dart';
import 'story_page_container_view.dart';

class StoryButton extends StatefulWidget {
  final StoryButtonData buttonData;
  final ValueChanged<StoryButtonData> onPressed;

  /// [allButtonDatas] required to be able to page through
  /// all stories
  final List<StoryButtonData> allButtonDatas;
  final IStoryPageTransform? pageTransform;
  final ScrollController storyListViewController;

  const StoryButton({
    Key? key,
    required this.onPressed,
    required this.buttonData,
    required this.allButtonDatas,
    required this.storyListViewController,
    this.pageTransform,
  }) : super(key: key);

  @override
  State<StoryButton> createState() => _StoryButtonState();
}

class _StoryButtonState extends State<StoryButton>
    with SetStateAfterFrame, FirstBuildMixin
    implements IButtonPositionable, IWatchMarkable {
  double? _buttonWidth;

  @override
  void initState() {
    _updateDependencies();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StoryButton oldWidget) {
    _updateDependencies();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didFirstBuildFinish(BuildContext context) {
    setState(() {
      _buttonWidth = context.size?.width;
    });
  }

  void _updateDependencies() {
    widget.buttonData._buttonPositionable = this;
    widget.buttonData._iWatchMarkable = this;
  }

  Widget _buildChild() {
    if (_buttonWidth == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: _buttonWidth,
      child: widget.buttonData.child,
    );
  }

  @override
  Offset? get centerPosition {
    if (!mounted) {
      return null;
    }
    final renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(
      Offset(
        renderBox.paintBounds.width * .5,
        renderBox.paintBounds.height * .5,
      ),
    );
  }

  @override
  Offset? get rightPosition {
    if (!mounted) {
      return null;
    }
    final renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(
      Offset(
        renderBox.paintBounds.width,
        0.0,
      ),
    );
  }

  @override
  Offset? get leftPosition {
    if (!mounted) {
      return null;
    }
    final renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(
      Offset.zero,
    );
  }

  void _onTap() {
    setState(() {
      widget.buttonData.markAsWatched();
    });
    widget.onPressed.call(widget.buttonData);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: widget.buttonData.aspectRatio,
          child: Container(
            decoration: widget.buttonData._isWatched
                ? null
                : widget.buttonData.borderDecoration,
            child: Padding(
              padding: EdgeInsets.all(
                widget.buttonData.borderOffset,
              ),
              child: ClipRRect(
                borderRadius:
                    widget.buttonData.buttonDecoration.borderRadius?.resolve(
                          null,
                        ) ??
                        const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: widget.buttonData.buttonDecoration,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashFactory: widget.buttonData.inkFeatureFactory ??
                            InkRipple.splashFactory,
                        onTap: _onTap,
                        child: const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildChild(),
      ],
    );
  }

  @override
  void markAsWatched() {
    safeSetState(() {});
  }
}

const int kStoryTimerTickMillis = 50;

enum StoryWatchedContract {
  onStoryStart,
  onStoryEnd,
  onSegmentEnd,
}

typedef IsVisibleCallback = bool Function();

class StoryButtonData {
  static bool defaultIsVisibleCallback() {
    return true;
  }

  /// This affects a border around button
  /// after the story was watched
  /// the border will disappear
  bool _isWatched = false;
  void markAsWatched() {
    _isWatched = true;
    _iWatchMarkable?.markAsWatched();
  }

  int currentSegmentIndex = 0;

  IButtonPositionable? _buttonPositionable;
  IWatchMarkable? _iWatchMarkable;

  final StoryTimelineController? storyController;
  final StoryWatchedContract storyWatchedContract;
  final Curve? pageAnimationCurve;
  final Duration? pageAnimationDuration;
  final double aspectRatio;
  final BoxDecoration buttonDecoration;
  final BoxDecoration borderDecoration;
  final double borderOffset;
  final InteractiveInkFeatureFactory? inkFeatureFactory;
  final Widget child;
  final List<Widget> storyPages;
  final Widget? closeButton;
  final Duration segmentDuration;
  final BoxDecoration containerBackgroundDecoration;
  final Color timelineFillColor;
  final Color timelineBackgroundColor;
  final Color defaultCloseButtonColor;
  final double timelineThikness;
  final double timelineSpacing;
  final EdgeInsets? timlinePadding;
  final IsVisibleCallback isVisibleCallback;

  /// Usualy this is required for the final story
  /// to pop it out to its button mosition
  Offset? get buttonCenterPosition {
    return _buttonPositionable?.centerPosition;
  }

  Offset? get buttonLeftPosition {
    return _buttonPositionable?.leftPosition;
  }

  Offset? get buttonRightPosition {
    return _buttonPositionable?.rightPosition;
  }

  /// [storyWatchedContract] When you want the story to be marked as
  /// watch [StoryWatchedContract.onStoryEnd] means it will be marked only
  /// when you watched the last segment of the story
  /// [StoryWatchedContract.onSegmentEnd] the story will be marked as
  /// read after you have watched at least one segment
  /// [StoryWatchedContract.onStoryStart] the story will be marked as read
  /// right when you open it
  /// [segmentDuration] Duration of each segment in this story
  /// [isVisibleCallback] if this callback returns false
  /// the button will not appear in button list. It might be necessary
  /// if you need to hide it for some reason
  StoryButtonData({
    this.storyWatchedContract = StoryWatchedContract.onStoryEnd,
    this.storyController,
    this.aspectRatio = 1,
    this.timelineThikness = 2.0,
    this.timelineSpacing = 8.0,
    this.timlinePadding,
    this.inkFeatureFactory,
    this.pageAnimationCurve,
    this.isVisibleCallback = defaultIsVisibleCallback,
    this.pageAnimationDuration,
    this.timelineFillColor = Myisellcolors.hvit,
    this.defaultCloseButtonColor = Myisellcolors.hvit,
    this.timelineBackgroundColor = Myisellcolors.hvit,
    this.closeButton,
    required this.storyPages,
    required this.child,
    required this.segmentDuration,
    this.containerBackgroundDecoration = const BoxDecoration(
      color: Myisellcolors.blak,
    ),
    this.buttonDecoration = const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
      color: Myisellcolors.hvit,
    ),
    this.borderDecoration = const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(15.0),
      ),
      border: Border.fromBorderSide(
        BorderSide(
          color: Color.fromARGB(255, 176, 176, 176),
          width: 1.7,
        ),
      ),
    ),
    this.borderOffset = 2.0,
  }) : assert(
          segmentDuration.inMilliseconds % kStoryTimerTickMillis == 0 &&
              segmentDuration.inMilliseconds >= 1000,
          'Segment duration in milliseconds must be a multiple of $kStoryTimerTickMillis and not less than 1000 milliseconds',
        );
}

abstract class IWatchMarkable {
  void markAsWatched();
}

abstract class IButtonPositionable {
  Offset? get centerPosition;
  Offset? get leftPosition;
  Offset? get rightPosition;
}
