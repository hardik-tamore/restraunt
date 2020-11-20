class Customer {
  final name;
  final email;
  final img;
  Customer({this.name,this.email,this.img});

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      name: json["name"],
      email: json["email"],
      img: json["img"],
    );
  }
}