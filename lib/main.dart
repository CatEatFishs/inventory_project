import 'package:flutter/material.dart';
import 'package:inventoryproject/model/home_page.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'provider/bx_provider.dart';
import 'provider/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    permissionRequest();
    AdaptUtils.init(750, 1334);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MultiProvider(
      providers: providers,
      child: Consumer<BxProvide>(builder: (context, providers, _) {
        return MaterialApp(
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
      }),
    ));
  }


  permissionRequest() async {
    PermissionStatus status = await Permission.storage.request();
  }
}
