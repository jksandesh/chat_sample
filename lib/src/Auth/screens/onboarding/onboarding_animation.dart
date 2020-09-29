import 'package:flutter/material.dart';
import 'package:chat_sample/src/Auth/utility/app_constant.dart';
import 'package:chat_sample/src/Auth/utility/color_utility.dart';

class OnBoardingEnterAnimation {
  OnBoardingEnterAnimation(this.controller)
      : colorAnimation = new ColorTween(
          begin: Color(getColorHexFromStr(COLOR_WELCOME)),
          end: Color(getColorHexFromStr(COLOR_LOGIN)),
        ).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.0,
              0.2,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        );

  final AnimationController controller;
  final Animation<Color> colorAnimation;
}
