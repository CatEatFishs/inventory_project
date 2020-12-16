//已出库存model
class OutGoodModel {
  String model;
  String time;
  int outNum;
  double price;
  double outPrice;

  OutGoodModel({this.model, this.time, this.outNum, this.price, this.outPrice});

  OutGoodModel.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    time = json['time'];
    outNum = json['outNum'];
    price = json['price'];
    outPrice = json['outPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['time'] = this.time;
    data['outNum'] = this.outNum;
    data['price'] = this.price;
    data['outPrice'] = this.outPrice;
    return data;
  }
}
