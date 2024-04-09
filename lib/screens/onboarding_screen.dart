import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homieeee/controllers/onboarding_controller.dart';
import 'package:homieeee/utils/constants/colors.dart';
import 'package:homieeee/utils/constants/image_strings.dart';
import 'package:homieeee/utils/constants/sizes.dart';
import 'package:homieeee/utils/constants/text_strings.dart';
import 'package:homieeee/utils/device/device_utility.dart';
import 'package:homieeee/utils/helper/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                backgroundColor: Color(0xffF9B572),
                image: HImageStrings.onBoardingImage1,
                title: HTextStrings.onBoardingTitle1,
                subTitle: HTextStrings.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                backgroundColor: Color(0xffFF6363),
                image: HImageStrings.onBoardingImage2,
                title: HTextStrings.onBoardingTitle2,
                subTitle: HTextStrings.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                backgroundColor: Color(0xff72BD63),
                image: HImageStrings.onBoardingImage3,
                title: HTextStrings.onBoardingTitle3,
                subTitle: HTextStrings.onBoardingSubTitle3,
              ),
            ],
          ),
          OnBoardingSkip(),
          Container(
            alignment: const Alignment(0, 0.75),
            child: SmoothPageIndicator(
              controller: controller.pageController,
              onDotClicked: controller.dotNavigationClick,
              count: 3,
              effect: const WormEffect(activeDotColor: HColors.white, dotHeight: 10),
            ),
          ),
          OnboardingNextPage()
        ],
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.backgroundColor,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final Color backgroundColor;
  final String image;
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              image: AssetImage(image),
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(subTitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class OnboardingNextPage extends StatelessWidget {
  const OnboardingNextPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HHelperFunctions.isDarkMode(context);
    return Positioned(
        right: HSizes.defaultSpace,
        bottom: HDeviceUtils.getBottomNavigationBarHeight(),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: dark ? HColors.primary : Colors.black),
            onPressed: () => OnboardingController.instance.nextPage(),
            child: const Icon(Icons.arrow_right)));
  }
}

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top: HDeviceUtils.getAppBarHeight(), right: HSizes.defaultSpace ,child: TextButton(onPressed: () => OnboardingController.instance.skipPage(), child: const Text('Skip'),));
  }
}