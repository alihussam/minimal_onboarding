import 'dart:async';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:minimal_onboarding/src/onboarding_page.dart';
import 'package:minimal_onboarding/src/onboarding_page_model.dart';

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
  static const _defaultColor = Color(0xFF4E67EB);

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
    /* Create app bar */
    final _appBar = AppBar(
      title: StreamBuilder(
        stream: _streamController.stream,
        initialData: 0.0,
        builder: (context, snapshot) {
          return DotsIndicator(
            dotsCount: widget.onboardingPages.length,
            position: snapshot.data,
            decorator: DotsDecorator(activeColor: widget.color),
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

    /* Create bottom navigation bar */
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
                if (snapshot.data == 0.0) return Container();
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
                      snapshot.data == widget.onboardingPages.length - 1
                          ? widget.finishButtonText
                          : widget.nextPageButtonText,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed:
                        snapshot.data == widget.onboardingPages.length - 1
                            ? widget.onFinishButtonPressed
                            : nextPage);
              },
            ),
          ),
        ],
      ),
    );

    /* Create body */
    final _body = Container(
      child: PageView(
          controller: _pageController,
          children: List.generate(
              widget.onboardingPages.length,
              (index) =>
                  OnboardingPage(widget.onboardingPages.elementAt(index)))),
    );

    /* Return main body */
    return Scaffold(
        appBar: _appBar, bottomNavigationBar: _bottomNavigation, body: _body);
  }
}
