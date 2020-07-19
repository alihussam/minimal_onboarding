import 'dart:async';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:minimal_onboarding/src/onboarding_page.dart';
import 'package:minimal_onboarding/src/onboarding_page_model.dart';

/// Entry Point Class to create an onboarding page
class MinimalOnboarding extends StatefulWidget {
  final List<OnboardingPageModel> onboardingPages;
  final VoidCallback onFinishButtonPressed;
  final VoidCallback onSkipButtonPressed;
  final String finishButtonText;
  final String skipButtonText;
  final String previousPageButtonText;
  final String nextPageButtonText;
  final bool showSkipButton;
  final Color color;
  final DotsDecorator dotsDecoration;
  static const _defaultColor = Color(0xFF4E67EB);
  static const _dotsDecoration = DotsDecorator(activeColor: _defaultColor);

  MinimalOnboarding({
    @required this.onboardingPages,
    @required this.onFinishButtonPressed,
    this.onSkipButtonPressed,
    this.finishButtonText = 'Done',
    this.skipButtonText = 'Skip',
    this.previousPageButtonText = 'Back',
    this.nextPageButtonText = 'Next',
    this.showSkipButton = true,
    this.color = _defaultColor,
    this.dotsDecoration = _dotsDecoration,
  }) : assert(onboardingPages.length != 0 && onFinishButtonPressed != null);

  @override
  _MinimalOnboardingState createState() => _MinimalOnboardingState();
}

class _MinimalOnboardingState extends State<MinimalOnboarding> {
  PageController _pageController;
  StreamController<double> _streamController;

  @override
  void initState() {
    _streamController = StreamController<double>.broadcast();
    _pageController = PageController();
    _pageController
        .addListener(() => _streamController.add(_pageController.page));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  previousPage() => _pageController.previousPage(
      duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  nextPage() => _pageController.nextPage(
      duration: Duration(milliseconds: 400), curve: Curves.easeIn);

  @override
  Widget build(BuildContext context) {
    // create app bar
    final _appBar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: StreamBuilder(
        stream: _streamController.stream,
        initialData: 0.0,
        builder: (context, snapshot) {
          return DotsIndicator(
            dotsCount: widget.onboardingPages.length,
            position: snapshot.data,
            decorator: widget.dotsDecoration,
          );
        },
      ),
      actions: widget.showSkipButton
          ? [
              FlatButton(
                child: Text(widget.skipButtonText),
                onPressed: widget.onSkipButtonPressed,
              ),
            ]
          : [],
    );

    // Create bottom navigation bar
    final _bottomNavigation = Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: _streamController.stream,
              initialData: 0.0,
              builder: (context, snapshot) {
                if (snapshot.data < 1) return Container();
                return FlatButton(
                  child: Text(widget.previousPageButtonText),
                  onPressed: previousPage,
                );
              },
            ),
          ),
          Container(
            child: StreamBuilder(
              stream: _streamController.stream,
              initialData: 0.0,
              builder: (context, snapshot) {
                return RaisedButton(
                    color: widget.color,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(18.0))),
                    child: Text(
                      snapshot.data > widget.onboardingPages.length - 2
                          ? widget.finishButtonText
                          : widget.nextPageButtonText,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: snapshot.data > widget.onboardingPages.length - 2
                        ? widget.onFinishButtonPressed
                        : nextPage);
              },
            ),
          ),
        ],
      ),
    );

    // create body
    final _body = Container(
      child: PageView(
          controller: _pageController,
          children: List.generate(
              widget.onboardingPages.length,
              (index) =>
                  OnboardingPage(widget.onboardingPages.elementAt(index)))),
    );

    // build and return main body
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar,
      bottomNavigationBar: _bottomNavigation,
      body: _body,
    );
  }
}
