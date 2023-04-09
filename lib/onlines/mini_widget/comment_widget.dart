import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommentWidget extends StatefulWidget {
  final comment;
  const CommentWidget({Key? key,required this.comment}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  var hide = false;
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(widget.comment['username']),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: double.parse(widget.comment['rating'].toString()) ,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 15.0,
                  itemPadding:
                  const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: OverflowBar(children: [
                Text(
                  widget.comment['content'],
                  overflow: hide==true?TextOverflow.visible:TextOverflow.ellipsis,
                ),
                widget.comment['content'].length <50?SizedBox(height: 0,):  GestureDetector(onTap: (){
                  setState(() {
                    if(hide==true){
                      hide = false;
                    }else{
                      hide = true;
                    }
                  });
                },child: Text(hide==true?'Ẩn bớt':'Xem thêm'),)
              ],),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text( widget.comment['datecomment']),
            ),
          )
        ],
      ),
    );
  }
}
