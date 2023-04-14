class UserModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final List cart;
  final String birthday;
  final int role;
  final String imageAvatar;
  final bool disable;

  UserModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.address,
      required this.cart,
      required this.imageAvatar,
      required this.birthday,
      required this.disable,
      required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      birthday: json['birthday'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      cart: json['cart'],
      imageAvatar: json['imageAvatar'],
      role: json['role'],
      disable: json['disable']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'address': address,
        'cart': cart,
        'role': role,
        'imageAvatar': imageAvatar,
        'birthday': birthday,
        'disable': disable
      };
}
