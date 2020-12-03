import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'R.dart';

class UtilsWidget {
  /// 刷新header
  static Header refreshHeader() {
    return ClassicalHeader(
      refreshText: "下拉刷新",
      refreshReadyText: "松开刷新",
      refreshingText: "刷新中...",
      refreshedText: "刷新完成",
      refreshFailedText: "刷新失败",
      noMoreText: "没有更多数据了",
      infoText: '上次刷新 %T',
      infoColor: R.color_green_3CB71D,
    );
  }

  /// 刷新footer
  static Footer refreshFooter() {
    return ClassicalFooter(
      loadText: "上拉加载数据",
      loadReadyText: "松开加载",
      loadingText: "加载中...",
      loadedText: "加载完成",
      loadFailedText: "加载失败",
      noMoreText: "没有更多数据了",
      infoText: "上次刷新 %T",
      infoColor: R.color_green_3CB71D,
      enableInfiniteLoad: false,
    );
  }
}
