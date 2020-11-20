class SubCategories {
  final name;
  final id;
  SubCategories({this.name,this.id});

  factory SubCategories.fromJson(Map<String, dynamic> json){
    return SubCategories(
      name: json["name"],
      id: json["id"],
    );
  }
}