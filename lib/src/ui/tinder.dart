import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:translator/translator.dart';
import 'package:workoutbuddy/src/data/repositories/exercise_repository.dart';

import '../data/models/exercises/exercise.dart';
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
  int globalItemIndex = 0;

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getData(globalItemIndex);
    _controller = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  ExercisesRepository repo = ExercisesRepository([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        return true;
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
                    _getData(index);
                    globalItemIndex++;
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
                    if (repo.items.isEmpty) {
                      return Text("UP: unknown. RIGHT: like. LEFT: dislike.");
                    }
                    // if (repo.items.length > properties.index) {
                    //   return FutureBuilder<Exercise>(
                    //     future: _getData(globalItemIndex),
                    //     builder: (
                    //       BuildContext context,
                    //       AsyncSnapshot<Exercise> snapshot,
                    //     ) {
                    //       if (!snapshot.hasData) {
                    //         return const CircularProgressIndicator();
                    //       } else if (snapshot.hasError) {}
                    //       return ExerciseCard(
                    //         name: 'Item. ${snapshot.data?.name}',
                    //         url: 'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                    //       );
                    //     },
                    //   );
                    // }
                    return ExerciseCard(
                      exercise: repo.items[properties.index],
                      url: 'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
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

  Future<Exercise> _getData(int itemIndex) async {
    for (var i = 1; i < 10; i++) {
      try {
        await repo.fetchAndSetExercise(itemIndex + i);
      } catch (e) {}
    }
    print(globalItemIndex);
    // return Exercise(id: 1, uuid: "1", creationDate: DateTime.now(), name: "test", description: "test");
    return repo.items[globalItemIndex];
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
