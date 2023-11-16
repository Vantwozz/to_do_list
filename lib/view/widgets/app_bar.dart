import 'dart:math';
import 'package:flutter/material.dart';

int paddingConst = 88545359; //constants that used for calculating padding
double secondPaddingConst = 233 / 37;

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    required this.showCompleted,
    required this.completed,
    required this.onEyePressed,
    Key? key,
  }) : super(key: key);
  final bool showCompleted;
  final Function() onEyePressed;
  final int completed;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      //backgroundColor: const Color(0xFFF7F6F2),
      collapsedHeight: 80,
      expandedHeight: 200,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var top = constraints.biggest.height;
          return FlexibleSpaceBar(
            expandedTitleScale: 1.26,
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          'My tasks',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                    Visibility(
                      child: SizedBox(
                        height: pow(top, 4) / paddingConst,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        !widget.showCompleted
                            ? Icons.visibility
                            : Icons.visibility_off,
                        //color: const Color.fromRGBO(0, 122, 255, 1),
                        size: 19,
                      ),
                      onPressed: () {
                        widget.onEyePressed();
                      },
                    ),
                  ],
                ),
              ],
            ),
            background: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 52,
                    ),
                    Text(
                      "Completed - ${widget.completed}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                SizedBox(
                  height: top / secondPaddingConst,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
