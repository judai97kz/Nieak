class BillModel {
  final String iduser;
  final String username;
  final String datecreate;
  final int allprice;
  final List content;
  final bool acceptstate;
  final bool receivestate;
  final String idbill;
  final String userphone;
  final String addressreceive;
  BillModel(
      {required this.iduser,
      required this.username,
      required this.datecreate,
      required this.content,
      required this.allprice,
      required this.acceptstate,
      required this.receivestate,
      required this.idbill,
      required this.userphone,
      required this.addressreceive});

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
      iduser: json['idbill'],
      username: json['iduser'],
      datecreate: json['datecreate'],
      allprice: json['allprice'],
      content: json['content'],
      acceptstate: json['acceptstate'],
      receivestate: json['receivestate'],
      idbill: json['idbill'],
      userphone: json['userphone'],
      addressreceive: json['addressreceive']);

  Map<String, dynamic> toJson() => {
      'iduser':iduser,
        'username': username,
        'datecreate': datecreate,
        'allprice': allprice,
        'content': content,
        'acceptstate': acceptstate,
        'receivestate': receivestate,
        'idbill': idbill,
        'userphone': userphone,
        'addressreceive': addressreceive
      };
}
