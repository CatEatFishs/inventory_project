//信息弹框
import 'package:flutter/material.dart';
import 'package:inventoryproject/utils/screens.dart';

import 'R.dart';

class InfoCustomDialog extends StatefulWidget {
  final Function confirmCallback;
  final Function dismissCallback;
  const InfoCustomDialog({Key key,this.confirmCallback,this.dismissCallback}) : super(key: key);

  @override
  _InfoCustomDialogState createState() => _InfoCustomDialogState();
}

class _InfoCustomDialogState extends State<InfoCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                height: setWidth(250),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: setWidth(60)),
                      child: Text('是否删除此条记录'),
                    ),
                   Expanded(child: SizedBox()),
                   Divider(color: Color(0xDBDBDBDB),height: setWidth(1),),
                   Container(
                     height: setWidth(89),
                     alignment: Alignment.bottomCenter,
                     child: Row(
                       children: [
                         Expanded(
                           child: GestureDetector(
                             onTap: this.widget.dismissCallback,
                             child: Container(
                               height: setWidth(109),
                               alignment: Alignment.center,
                               decoration: BoxDecoration(
                                   color: Theme.of(context).canvasColor,
                                   borderRadius: BorderRadius.circular(4.0)),
                               child: Text('取消',style: TextStyle(color: Colors.blue,fontSize: setSp(30),fontWeight: FontWeight.w500),),
                             ),
                           ),
                         ),
                         SizedBox(
                             width: setWidth(1) , child: Container(color: Color(0xDBDBDBDB))),
                         Expanded(
                           child: GestureDetector(
                             onTap: this.widget.confirmCallback,
                             child: Container(
                               height: setWidth(109),
                               alignment: Alignment.center,
                               decoration: BoxDecoration(
                                   color: Theme.of(context).canvasColor,
                                   borderRadius: BorderRadius.circular(4.0)),
                               child: Text('确定',style: TextStyle(color: Colors.blue,fontSize: setSp(30),fontWeight: FontWeight.w500),),
                             ),
                           ),
                         )
                       ],
                     ),
                   )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(4.0)),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}