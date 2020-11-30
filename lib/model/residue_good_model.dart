class ResidueGoodModel {
  String model;
  String time;
  int sumNum;

  ResidueGoodModel({this.model, this.time, this.sumNum});

  ResidueGoodModel.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    time = json['time'];
    sumNum = json['sum(num)'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['time'] = this.time;
    data['sum(num)'] = this.sumNum;
    return data;
  }
}
