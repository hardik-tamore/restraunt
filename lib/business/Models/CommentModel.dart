class CommentModel {
  final img;
  final name;
  final comment;
  CommentModel({
    this.img,
    this.name,
    this.comment,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      img: json["img"],
      name: json["name"],
      comment: json["comment"],
    );
  }
}
