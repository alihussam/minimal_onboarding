import 'package:flutter/material.dart';
import 'package:minimal_onboarding/src/onboarding_page_model.dart';

/// Create a single onboarding pageView slide
class OnboardingPage extends StatelessWidget {
  final OnboardingPageModel _page;
  OnboardingPage(this._page);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: Center(child: Image.asset(_page.imagePath))),
        Container(
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(_page.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              SizedBox(height: 20),
              Text(_page.text, textAlign: TextAlign.center),
            ],
          ),
        ),
      ],
    );
  }
}
