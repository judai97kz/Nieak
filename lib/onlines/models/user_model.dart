class UserModel {
  final String name;
  final String phone;
  final String address;
  final String idcart;
  final int role;
  final String imageAvatar;
  int wallet;

  UserModel(
      {required this.name,
      required this.phone,
      required this.address,
      required this.idcart,
      required this.imageAvatar,
      required this.wallet,
      required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      idcart: json['idcart'],
      imageAvatar: json['imageAvatar'],
      wallet: json['wallet'],
      role: json['role']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'address': address,
        'idcart': idcart,
        'wallet': wallet,
        'role': role,
        'imageAvatar':imageAvatar
      };
}
