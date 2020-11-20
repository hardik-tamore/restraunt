import '../../components/component.dart';

class OrderModel {
  final id;
  final order_id;
  final items;
  final status;
  final date;

  OrderModel({this.id,this.order_id,this.items,this.status,this.date});


  factory OrderModel.fromJson(Map<String, dynamic> json){
    DateTimePicker dt = new DateTimePicker();
    var fdate = dt.dformat(json["date"]);
    return OrderModel(
      id: json["id"],
      order_id: json["order_id"],
      items: json["items"],
      status: json["status"],
      date: fdate,
    );
  }
}