import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:swipable_stack/swipable_stack.dart';

import 'widget/bottom_buttons.dart';
import 'widget/exercise_card.dart';
import 'widget/card_overlay.dart';

const _images = [
  'images/image_3.jpeg',
  'images/image_3.jpeg',
  'images/image_3.jpeg',
];

class PopupOnSwipeExample extends StatefulWidget {
  const PopupOnSwipeExample({Key? key}) : super(key: key);

  static const routeName = '/tinder';

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const PopupOnSwipeExample(),
    );
  }

  @override
  _PopupOnSwipeExampleState createState() => _PopupOnSwipeExampleState();
}

class _PopupOnSwipeExampleState extends State<PopupOnSwipeExample> {
  late final SwipableStackController _controller;

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pointCount = 10;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SwipableStack(
                  controller: _controller,
                  stackClipBehaviour: Clip.none,
                  onWillMoveNext: (index, direction) {
                    switch (direction) {
                      case SwipeDirection.right:
                        Future(() async {
                          await _PopUp.show(context: context);
                        });
                        return false;
                      case SwipeDirection.left:
                        return true;
                      case SwipeDirection.up:
                      case SwipeDirection.down:
                        return false;
                    }
                  },
                  onSwipeCompleted: (index, direction) {
                    if (kDebugMode) {
                      print('$index, $direction');
                    }
                  },
                  horizontalSwipeThreshold: 0.8,
                  verticalSwipeThreshold: 0.8,
                  overlayBuilder: (
                    context,
                    properties,
                  ) =>
                      CardOverlay(
                    swipeProgress: properties.swipeProgress,
                    direction: properties.direction,
                  ),
                  builder: (context, properties) {
                    final itemIndex = properties.index % _images.length;
                    return ExerciseCard(
                      name: 'Sample No.${itemIndex + 1}',
                      assetPath: _images[itemIndex],
                    );
                  },
                ),
              ),
            ),
            BottomButtonsRow(
              onSwipe: (direction) async {
                _controller.next(swipeDirection: direction);
              },
              onRewindTap: _controller.rewind,
              canRewind: _controller.canRewind,
            ),
          ],
        ),
      ),
    );
  }
}

class _PopUp {
  const _PopUp._();

  static Future<void> show({
    required BuildContext context,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Give your opinion'),
        content: RatingBar.builder(
          initialRating: 5,
          itemCount: 5,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return const Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return const Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return const Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return const Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return const Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
            }
            return Container();
          },
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white10),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Rate'),
          ),
        ],
      ),
    );
  }
}
