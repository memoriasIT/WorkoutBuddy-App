import 'package:flutter/material.dart';
import 'package:workoutbuddy/src/data/models/exercises/exercise.dart';

import 'bottom_buttons.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    required this.url,
    required this.exercise,
    Key? key,
  }) : super(key: key);

  final String url;
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image: NetworkImage(exercise.getMainImage?.url ?? "https://wallpaperaccess.com/full/3898677.jpg"),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 26,
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black12.withOpacity(0),
                    Colors.black12.withOpacity(.4),
                    Colors.black12.withOpacity(.82),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: theme.textTheme.headline3!.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Category: ' + exercise.categoryObj.name,
                  style: theme.textTheme.headline5!.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Muscles: ' + exercise.muscles.join(", "),
                  style: theme.textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  exercise.description,
                  style: theme.textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: BottomButtonsRow.height)
              ],
            ),
          ),
        ],
      ),
    );
  }
}