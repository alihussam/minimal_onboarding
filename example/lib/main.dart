import 'package:flutter/material.dart';
import 'package:minimal_onboarding/minimal_onboarding.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<OnboardingPageModel> onboardingPages = [
    OnboardingPageModel('images/page1.png', 'Onboarding Page 1',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus at est rhoncus, posuere enim mollis, accumsan odio. '),
    OnboardingPageModel('images/page2.png', 'Onboarding Page 2',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus at est rhoncus, posuere enim mollis, accumsan odio. '),
    OnboardingPageModel('images/page3.png', 'Onboarding Page 3',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus at est rhoncus, posuere enim mollis, accumsan odio. '),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal Onboarding example',
      home: MinimalOnboarding(
          onboardingPages: onboardingPages,
          dotsDecoration: DotsDecorator(
            activeColor: Color(0xFF4E67EB),
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
          onFinishButtonPressed: () => print('Onboarding finished')),
    );
  }
}
