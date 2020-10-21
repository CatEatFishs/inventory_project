import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///界面跳转路由
///
/// 返回到根
/// Navigator.of(context).popUntil(ModalRoute.withName('/'));
/// Navigator.of(context).popUntil((r) => r.settings.isInitialRoute);

class NavigatorRoute {
  /// 移除所有路由包括根路由
  static pushAndRemoveAllRoute(BuildContext context, Widget newWidget,
      {String pageName}) {
    if (Platform.isAndroid) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return newWidget;
            },
            settings: RouteSettings(name: pageName),
          ),
          (route) => route == null);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) {
              return newWidget;
            },
            settings: RouteSettings(name: pageName),
          ),
          (route) => route == null);
    }
  }

  ///跳转新的路由,移除指定的路由栈
  static pushAndRemoveUntilRouteName(
      BuildContext context, Widget newWidget, String oldRouteName,
      {String pageName}) {
    if (Platform.isAndroid) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return newWidget;
            },
            settings: RouteSettings(name: pageName),
          ), (Route<dynamic> route) {
        return route.settings.name == oldRouteName;
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) {
              return newWidget;
            },
            settings: RouteSettings(name: pageName),
          ), (Route<dynamic> route) {
        return route.settings.name == oldRouteName;
      });
    }
  }

  /*
  ///跳转新的路由,移除根路由外所有的路由
  static pushAndRemoveOtherRoot(BuildContext context, Widget newRouteWidget, {String pageName, Object arguments}) {
    if (Platform.isAndroid) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return newRouteWidget;
            },
            settings: RouteSettings(name: pageName),
          ), (Route<dynamic> route) {
        return route.settings.name == RouteName.rootRoute;
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) {
              return newRouteWidget;
            },
            settings: RouteSettings(name: pageName),
          ), (Route<dynamic> route) {
        return route.settings.name == RouteName.rootRoute;
      });
    }
  }


   */

  ///普通的跳转
  ///- pageName：页面在路径中的名字，可以pop到指定pageName页面
  ///- rootNavigator: 是否为根路由
  static Future<T> push<T extends Object>(
      BuildContext context, Widget newWidget,
      {@required String pageName, bool rootNavigator = false}) {
    if (Platform.isAndroid) {
      return Navigator.of(context, rootNavigator: rootNavigator).push(
        MaterialPageRoute(
          builder: (context) {
            return newWidget;
          },
          settings: RouteSettings(name: pageName),
        ),
      );
    } else {
      return Navigator.of(context, rootNavigator: rootNavigator).push(
        CupertinoPageRoute(
          builder: (context) {
            return newWidget;
          },
          settings: RouteSettings(name: pageName),
        ),
      );
    }
  }

  ///替换栈顶的引用
  static Future<T> pushReplacement<T extends Object>(
      BuildContext context, Widget newWidget,
      {@required String pageName}) {
    if (Platform.isAndroid) {
      return Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return newWidget;
        },
        settings: RouteSettings(name: pageName),
      ));
    } else {
      return Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (context) {
          return newWidget;
        },
        settings: RouteSettings(name: pageName),
      ));
    }
  }

  /// 退回到之前某一个栈中
  static void popUntilWithName(BuildContext context, String routeName) {
    if (routeName != null && routeName != '') {
      Navigator.popUntil(context, (Route<dynamic> route) {
        return !route.willHandlePopInternally &&
            route is ModalRoute &&
            route.settings.name == routeName;
      });
    } else {
      Navigator.of(context).pop();
    }
  }
}
