import 'package:flutter/material.dart';
import 'package:blockchain/data/models/onboarding_model.dart';
import 'package:blockchain/shared/constants/assets_path.dart';
import 'package:blockchain/shared/styles/colors.dart';

List<OnBoardingModel> onboardinglist = const [
  OnBoardingModel(
    img: MyAssets.onboradingone,
    title: 'Manage Your Certificates in Blockchain',
    description:
        'With this app you secure your certificates with the help of Blockchain',
  ),
];

const List<Color> colors = [Appcolors.bleu, Appcolors.pink, Appcolors.yellow];

const List<String> profileimages = [
  MyAssets.profileicon1,
  MyAssets.profileicon2,
  MyAssets.profileicon3,
  MyAssets.profileicon4,
];

int profileimagesindex = 0;
