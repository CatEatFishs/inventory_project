///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2019-11-08 10:53
///
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'bx_provider.dart';
import 'ds_provider.dart';
import 'kt_provider.dart';
import 'rqz_provider.dart';
import 'rsq_provider.dart';
import 'xyj_provider.dart';
import 'yyj_provider.dart';

export 'package:provider/provider.dart';

ChangeNotifierProvider<T> buildProvider<T extends ChangeNotifier>(T value) {
  return ChangeNotifierProvider<T>.value(value: value);
}

List<SingleChildWidget> get providers => _providers;

final _providers = [
  buildProvider<BxProvide>(BxProvide()),
  buildProvider<DsProvide>(DsProvide()),
  buildProvider<KtProvide>(KtProvide()),
  buildProvider<RsqProvide>(RsqProvide()),
  buildProvider<RqzProvide>(RqzProvide()),
  buildProvider<XyjProvide>(XyjProvide()),
  buildProvider<YyjProvide>(YyjProvide()),
];
