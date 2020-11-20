class ProductModel {
  final img;
  final title;
  final id;
  final price;
  final c_price;
  final unit;
  final desc;
  final qty;
  final amount;

  ProductModel({this.img,this.title,this.id,this.price,this.c_price, this.unit,this.desc,this.qty,this.amount});

  factory ProductModel.fromJson(Map<String, dynamic> json){
    return ProductModel(
      img: json["img"],
      title: json["title"],
      id: json["id"],
      price: json["price"],
      unit:json["unit"],
      c_price: json["c_price"],
      desc: json["desc"],
      qty: json["qty"],
      amount: json["amount"],
    );
  }
}