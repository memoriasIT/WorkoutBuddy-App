import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({Key? key}) : super(key: key);

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text('swipable_stack demo'),
            ),
            body: ListView(
              children: [
                ListTile(
                  title: const Text('BasicExample'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   BasicExample.route(),
                    // );
                  },
                ),
                ListTile(
                  title: const Text('IgnoreVerticalSwipeExample'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   IgnoreVerticalSwipeExample.route(),
                    // );
                  },
                ),
                ListTile(
                  title: const Text('PopupOnSwipeExample'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   PopupOnSwipeExample.route(),
                    // );
                  },
                ),
                ListTile(
                  title: const Text('SwipeAnchorExample'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   SwipeAnchorExample.route(),
                    // );
                  },
                ),
                ListTile(
                  title: const Text('DetectableDirectionsExample'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   DetectableDirectionsExample.route(),
                    // );
                  },
                ),
              ],
            ),
          );
  }
}
