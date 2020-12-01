class ResidueGoodModel {
  String model;
  String time;
  String price;
  int sumNum;

  ResidueGoodModel({this.model, this.time, this.price, this.sumNum});

  ResidueGoodModel.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    time = json['time'];
    price = json['price'];
    sumNum = json['sum(num)'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['time'] = this.time;
    data['price'] = this.price;
    data['sum(num)'] = this.sumNum;
    return data;
  }
}
