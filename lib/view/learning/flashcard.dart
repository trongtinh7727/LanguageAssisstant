import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/utils/app_icons.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view/learning/component/fillter_menu.dart';
import 'package:languageassistant/view/learning/component/flashcard_widget.dart';
import 'package:languageassistant/view/learning/component/learning_progress.dart';
import 'package:languageassistant/view_model/learning_view_model.dart';
import 'package:languageassistant/widget/bottomsheet_widget.dart';
import 'package:provider/provider.dart';

class FlashCardScreen extends StatefulWidget {
  final TopicModel? editTopicModel;

  const FlashCardScreen({super.key, this.editTopicModel});
  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  late LearningViewModel learningViewModel;
  final flipCardController = FlipCardController();
  Color cardColor = Colors.white; // Màu ban đầu của card
  bool selected = false;
  int animationSpeed = 400; // Thiết lập tốc độ ban đầu là 2 giây
  double initial_x = 50;
  double initial_y = 8;
  late double x = initial_x;
  late double y = initial_y;
  bool isAutoPlay = false;
  Timer? autoPlayTimer;

  void showNextCard({required int isMastered}) {
    setState(() {
      x += 300 * isMastered;
    });
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        learningViewModel.showNextCard(
            isMastered: isMastered == 1, context: context);
        x = initial_x;
      });
    });
  }

  void autoPlayCards() {
    autoPlayTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (isAutoPlay) {
        flipCardController.flipcard();

        Timer(Duration(seconds: 2), () {
          flipCardController.flipcard();
          showNextCard(isMastered: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  void toggleAutoPlay() {
    setState(() {
      isAutoPlay = !isAutoPlay;
      if (isAutoPlay) {
        autoPlayCards();
      } else {
        autoPlayTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    autoPlayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    learningViewModel = Provider.of<LearningViewModel>(context);
    initial_x = (MediaQuery.of(context).size.width - 395) / 2 + 8;

    var flipCardContainer = Material(
        child: FlipCard(
      onTapFlipping: true,
      axis: FlipAxis.vertical,
      rotateSide: RotateSide.right,
      controller: flipCardController,
      frontWidget: FlashCardWidget(
        backgroundColor: cardColor, // S
        learningViewModel: learningViewModel,
        isFont: true,
      ),
      backWidget: FlashCardWidget(
        backgroundColor: cardColor, // S
        learningViewModel: learningViewModel,
        isFont: false,
      ),
    ));

    return Scaffold(
        appBar: AppBar(
          title: Text('Flashcard'),
          actions: [FillterMenu(learningViewModel: learningViewModel)],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              LearningProgress(learningViewModel: learningViewModel),
              SizedBox(
                width: 395,
                height: 460,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    AnimatedPositioned(
                      top: y,
                      left: x,
                      duration: Duration(milliseconds: animationSpeed),
                      curve: Curves.fastOutSlowIn,
                      child: Draggable<int>(
                        key: const Key('mywidgetkey'),
                        onDragStarted: () {},
                        onDragUpdate: (details) {
                          setState(() {
                            animationSpeed = 0;
                            x = x + details.delta.dx;
                            y = y + details.delta.dy;
                          });
                        },
                        onDraggableCanceled: (velocity, offset) {
                          setState(() {
                            animationSpeed = 400;
                            x = initial_x;
                            y = initial_y;
                          });
                        },
                        onDragEnd: (details) {
                          if (details.offset.dx > 200) {
                            showNextCard(isMastered: 1);
                          } else if (details.offset.dx < -200) {
                            showNextCard(isMastered: -1);
                          }
                        },
                        data: 10,
                        feedback: FlashCardWidget(
                          backgroundColor: AppStyle.tabUnselectedColor, // S
                          learningViewModel: learningViewModel,
                          isFont: true,
                        ),
                        childWhenDragging: Container(),
                        child: flipCardContainer,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: learningViewModel.showPreviousCard,
                              child: Icon(
                                Icons.arrow_circle_left_outlined,
                                color: learningViewModel.currentIndex > 0
                                    ? AppStyle.activeText
                                    : AppStyle.lightText,
                                size: 35,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showNextCard(isMastered: -1);
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                color: AppStyle.redColor,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                showNextCard(isMastered: 1);
                              },
                              child: Icon(
                                Icons.check_circle_outline,
                                color: AppStyle.successColor,
                                size: 35,
                              ),
                            ),
                            InkWell(
                              onTap: toggleAutoPlay,
                              child: Icon(
                                isAutoPlay
                                    ? Icons.pause_circle_outline
                                    : Icons.play_circle_outline,
                                color: AppStyle.activeText,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
        ));
  }
}
