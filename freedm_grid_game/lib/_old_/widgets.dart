import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Generic picture:
class Picture extends StatelessWidget {

  final double width, height;
  final String pictureURL;
  Picture({Key key, this.pictureURL, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var assetsImage = new AssetImage(pictureURL);
    var image = new Image(image: assetsImage, width: this.width, height: this.height);
    return Container(child: image);
  }

}/// Buttons:
class Button extends StatefulWidget {

  final GestureTapCallback onPressed;
  final IconData iconData;
  final Color fillColor, splashColor, iconColor;
  final double width, height;
  final String name;

  Button(@required this.onPressed, this.name, this.iconData, this.fillColor, this.splashColor, this.iconColor, this.width, this.height);

  @override
  ButtonState createState() => ButtonState();
}

class ButtonState extends State<Button> {

  IconData picture;

  @override
  void initState() {
    super.initState();
    picture = widget.iconData;
  }

  @override
  Widget build(BuildContext context){
    return ButtonTheme(
      minWidth: (widget.width*0.15),
      height: (widget.height*0.1),
      child: FlatButton(
        child: Stack(
        children: <Widget>[

          Text(widget.name),

          Icon(
              picture,
              color: widget.iconColor,
            ),
          ]
        ),
        onPressed: widget.onPressed,
        color: widget.fillColor,
      ),
    );
  }
}