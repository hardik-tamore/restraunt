class Categories {
  final img;
  final name;
  final id;
  Categories({this.img,this.name,this.id});

  factory Categories.fromJson(Map<String, dynamic> json){
    return Categories(
      img: json["img"],
      name: json["name"],
      id: json["id"],
    );
  }
}