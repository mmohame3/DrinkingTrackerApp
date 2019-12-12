import 'package:flutter/material.dart';


class PopupLayout extends ModalRoute {
  final Widget child;
  double top;
  double bottom;
  double left;
  double right;

  @override
  Duration get transitionDuration => Duration(milliseconds: 0);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  PopupLayout(
      {Key key,
        @required this.child,
        this.top,
        this.bottom,
        this.left,
        this.right});

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    if (top == null) this.top = 50;
    if (bottom == null) this.bottom = 50;
    if (left == null) this.left = 30;
    if (right == null) this.right = 30;
    return GestureDetector(
      onTap: () {
        //SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: this.top,
          bottom: this.bottom,
          left: this.left,
          right: this.right),
      child: child,
    );
  }
}

class PopupContent extends StatefulWidget {
  final Widget content;

  PopupContent({Key key, this.content}) : super(key: key);

  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.content,
    );
  }
}