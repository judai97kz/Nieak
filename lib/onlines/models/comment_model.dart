class CommentModel {
  final String iduser;
  final String idcomment;
  final String username;
  final String content;
  final String idproduct;
  final String datecomment;
  final double rating;
  CommentModel(
      {required this.iduser,
      required this.idcomment,
      required this.username,
      required this.content,
      required this.idproduct,
      required this.datecomment,
      required this.rating});

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        iduser: json['iduser'],
        idcomment: json['idcomment'],
        username: json['username'],
        content: json['content'],
        idproduct: json['idproduct'],
        datecomment: json['datecomment'],
        rating: json['rating'],
      );

  Map<String, dynamic> toJson() => {
        'iduser': iduser,
        'idcomment': idcomment,
        'username': username,
        'content': content,
        'idproduct': idproduct,
        'datecomment': datecomment,
        'rating':rating
      };
}
