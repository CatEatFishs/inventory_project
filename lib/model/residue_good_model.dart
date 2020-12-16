class ResidueGoodModel {
  String model;
  String time;
  double price;
  int residueNum;

  ResidueGoodModel({this.model, this.time, this.price, this.residueNum});

  ResidueGoodModel.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    time = json['time'];
    price = json['price'];
    residueNum = json['residueNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['time'] = this.time;
    data['price'] = this.price;
    data['residueNum'] = this.residueNum;
    return data;
  }
}
