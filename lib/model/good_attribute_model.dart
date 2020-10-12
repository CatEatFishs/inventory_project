//商品属性
class GoodAttributeModel {
  String intAndOut; //出入库
  String type; //类型
  String model; //型号
  String price; //价格
  String num; //数量
  String time; //出入库时间

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      intAndOut: intAndOut,
      type: type,
      model: model,
      price: price,
      num: num,
      time: time
    };
    return map;
  }

  GoodAttributeModel(
      {this.intAndOut, this.type, this.model, this.price, this.num, this.time});

  GoodAttributeModel.fromMap(Map<String, dynamic> map) {
    intAndOut = map[intAndOut];
    type = map[type];
    model = map[model];
    price = map[price];
    num = map[num];
    time = map[time];
  }
}
