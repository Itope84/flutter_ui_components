import 'package:flutter/material.dart';
import 'package:flutter_ui_components/widgets/buttons.dart';

class OnboardingLayout extends StatefulWidget {
  static final String routeName = '/';
  final List<Widget> slides;
  final bool showFlatSkipButton;
  final Function onGetStarted, onSkip;
  final String getStartedText, skipText;
  final Color getStartedColor;

  OnboardingLayout({
    this.slides,
    this.showFlatSkipButton = true,
    this.onGetStarted,
    this.onSkip,
    this.skipText,
    this.getStartedText,
    this.getStartedColor,
  });

  @override
  _OnboardingLayoutState createState() => _OnboardingLayoutState();
}

class _OnboardingLayoutState extends State<OnboardingLayout> {
  int _activePage = 0;
  PageController _controller = new PageController(initialPage: 0);
  TextStyle buttonTextStyle = TextStyle(
      fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: PageView(
                controller: _controller,
                onPageChanged: (int page) {
                  setState(() {
                    _activePage = page;
                  });
                },
                children: widget.slides,
              ),
            ),
            // indicators
            _buildIndicators(),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: StyledBlockButton(
                color: widget.getStartedColor ?? Theme.of(context).accentColor,
                onPressed: widget.onGetStarted ?? () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 25.0,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Text(
                          widget.getStartedText ?? "Get started",
                          style: buttonTextStyle,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Icon(Icons.arrow_forward),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            widget.showFlatSkipButton
                ? Center(
                    child: FlatButton(
                      child: Text(widget.skipText ?? "Skip",
                          style: buttonTextStyle),
                      onPressed: widget.onSkip ?? () {},
                    ),
                  )
                : Container(),
            // Button
            // flatbutton
          ],
        ));
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.slides
          .asMap()
          .map(
            (index, element) => MapEntry(
              index,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.5),
                child: _activePage == index
                    ? _activePageIndicator()
                    : _pageIndicator(index),
              ),
            ),
          )
          .values
          .toList(),
    );
  }

  Widget _pageIndicator(index) {
    return InkWell(
      child: Container(
        width: 15.0,
        height: 15.0,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.white60),
      ),
      onTap: () {
        _controller.animateToPage(
          index,
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 500),
        );
        setState(() {
          _activePage = index;
        });
      },
    );
  }

  Widget _activePageIndicator() {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: Colors.white60),
      ),
      padding: EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
