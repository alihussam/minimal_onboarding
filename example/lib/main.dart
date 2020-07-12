import 'package:flutter/material.dart';
import 'package:minimal_onboarding/minimal_onboarding.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<OnboardingPageModel> onboardingPages = [
    OnboardingPageModel('images/aes_hands.png',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus at est rhoncus, posuere enim mollis, accumsan odio. '),
    OnboardingPageModel('images/aes_hands1.jpg',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus at est rhoncus, posuere enim mollis, accumsan odio. '),
    OnboardingPageModel('images/aes_hands2.jpg',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus at est rhoncus, posuere enim mollis, accumsan odio. '),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal Onboarding example',
      home: MinimalOnboarding(
          onboardingPages: onboardingPages,
          onFinishButtonPressed: () => print('Onboarding finished')),
    );
  }
}
