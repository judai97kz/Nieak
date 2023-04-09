class BillModel {
  final String iduser;
  final String datecreate;
  final int allprice;
  final List content;
  final bool acceptstate;
  final bool receivestate;
  final String idbill;
  BillModel(
      {required this.iduser,
      required this.datecreate,
      required this.content,
      required this.allprice,
      required this.acceptstate,
      required this.receivestate,
      required this.idbill});

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
      iduser: json['iduser'],
      datecreate: json['datecreate'],
      allprice: json['allprice'],
      content: json['content'],
      acceptstate: json['acceptstate'],
      receivestate: json['receivestate'],
      idbill: json['idbill']);

  Map<String, dynamic> toJson() => {
        'iduser': iduser,
        'datecreate': datecreate,
        'allprice': allprice,
        'content': content,
        'acceptstate': acceptstate,
        'receivestate': receivestate,
    'idbill':idbill
      };
}
