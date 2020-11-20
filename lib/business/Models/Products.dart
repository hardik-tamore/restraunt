class Product {
  final img;
  final title;
  final id;
  final code;
  final description;
  final rate;
  final sub;
  Product({this.img,this.title,this.id,this.code,this.description,this.rate,this.sub});

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      img: json["img"],
      title: json["title"],
      id: json["id"],
      code: json["code"],
      description: json["description"],
      rate: json["rate"],
      sub: json["sub"],
    );
  }
}