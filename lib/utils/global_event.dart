import 'package:event_bus/event_bus.dart';

class GlobalEvent {
  ///全局事件总线对象
  static EventBus eventBus = new EventBus();
}

// 出库或者入库event
class InAndOutEvent {
  String type; //类型
  InAndOutEvent({this.type});
}
