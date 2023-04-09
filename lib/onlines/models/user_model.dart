class UserModel {
  final String name;
  final String phone;
  final String address;
  final List cart;
  final String birthday;
  final int role;
  final String imageAvatar;
  final bool disable;
  int wallet;

  UserModel(
      {required this.name,
      required this.phone,
      required this.address,
      required this.cart,
      required this.imageAvatar,
      required this.wallet,
      required this.birthday,
      required this.disable,
      required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      birthday: json['birthday'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      cart: json['cart'],
      imageAvatar: json['imageAvatar'],
      wallet: json['wallet'],
      role: json['role'],
      disable: json['disable']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'address': address,
        'cart': cart,
        'wallet': wallet,
        'role': role,
        'imageAvatar': imageAvatar,
        'birthday': birthday,
        'disable': disable
      };
}
