import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtils {

  static push(BuildContext context, Widget routeWidget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => routeWidget));

  static pop(BuildContext context) => Navigator.pop(context);
}
