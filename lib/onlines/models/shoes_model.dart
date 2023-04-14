class ShoesModel {
  final String idshoes;
  final String nameshoes;
  final List<String> image;
  final int imagenumber;
  final int price;
  final int amount;
  final double rating;
  final String brand;
  final int minSize;
  final int maxSize;
  final String color;
  final String dateadd;
  final int sale;

  ShoesModel(
      {required this.idshoes,
      required this.nameshoes,
      required this.image,
      required this.imagenumber,
      required this.price,
      required this.amount,
      required this.rating,
      required this.brand,
      required this.minSize,
      required this.maxSize,
      required this.color,
      required this.dateadd,
      required this.sale});

  factory ShoesModel.fromJson(Map<String, dynamic> json) => ShoesModel(
      idshoes: json['idshoes'],
      nameshoes: json['nameshoes'],
      image: json['image'],
      imagenumber: json['imagenumber'],
      price: json['price'],
      amount: json['amount'],
      rating: json['rating'],
      brand: json['brand'],
      minSize: json['minsize'],
      maxSize: json['maxsize'],
      color: json['color'],
      dateadd: json['dateadd'],
      sale: json['sale']);

  Map<String, dynamic> toJson() => {
        'idshoes': idshoes,
        'nameshoes': nameshoes,
        'image': image,
        'imagenumber': imagenumber,
        'price': price,
        'amount': amount,
        'rating': rating,
        'brand': brand,
        'minsize': minSize,
        'maxsize': maxSize,
        'color': color,
        'dateadd': dateadd,
        'sale': sale
      };
}
