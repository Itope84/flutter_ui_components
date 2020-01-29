import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () => launcher.launch(url));
}

class TextWithLink extends StatelessWidget {
  final String text;
  final Color linkColor;
  final TextStyle style;
  final TextAlign align;

  TextWithLink({@required this.text, this.style, this.align, this.linkColor});

  final urlMatcher = new RegExp(
      r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");

  /// matches https://link.here or [https://link.here](Link text)
  final mdStyleLinkMatcher = new RegExp(
      r"(\[((http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)\]\(([\wd ]+)\)|(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*))");

  bool _hasLink(String input) {
    return urlMatcher.hasMatch(input);
  }

  /// Split into a list with the links in between
  List<String> _splitWithLinks(String str) {
    List<RegExpMatch> matches = mdStyleLinkMatcher.allMatches(str).toList();
    List<String> splitStr = str.split(mdStyleLinkMatcher);

    // If there are no links
    if (matches.length < 1) {
      return [str];
    }

    // remove empty values at the beginning of the list
    if (splitStr[0].isEmpty) {
      splitStr.removeAt(0);
    }

    // Because it's possible the link started at the beginning of the string
    bool isStart = matches[0].start == 0;

    // insert the links array into the splitStr array
    for (int i = 0, insertIndex = isStart ? 0 : 1;
        i < matches.length;
        i++, insertIndex += 2) {
      splitStr.insert(insertIndex, matches[i].group(0));
    }
    return splitStr;
  }

  @override
  Widget build(BuildContext context) {
    final _style = style ?? Theme.of(context).textTheme.body2;
    final words = _splitWithLinks(text);
    List<TextSpan> span = [];
    words.forEach((word) {
      if (_hasLink(word)) {
        String url = urlMatcher.stringMatch(word);
        RegExpMatch match = mdStyleLinkMatcher.firstMatch(word);
        // for only-url matches group 1 contains the url which is also the text we wanna display
        // for md style matches, group 6 contains the linkText and group 2 contains the link
        String linkText =
            match != null ? match.group(6) ?? match.group(1) : url;
        span.add(
          new LinkTextSpan(
            text: '$linkText ',
            url: url,
            style: _style.copyWith(color: linkColor ?? Colors.blue),
          ),
        );
      } else {
        span.add(new TextSpan(text: '$word', style: _style));
      }
    });
    if (span.length > 0) {
      return new RichText(
        textAlign: align ?? TextAlign.center,
        text: new TextSpan(text: '', children: span),
      );
    } else {
      return new Text(text);
    }
  }
}
