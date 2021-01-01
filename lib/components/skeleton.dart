import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  final double height;
  final double width;
  final Color color;

  Skeleton({Key key, this.height = 20, this.width = 200, this.color}) : super(key: key);

  createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> with TickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.linear
      ),
    )..addListener(() {
      setState(() {});

    });


  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.repeat();
    return AnimatedSize(
      curve: Curves.fastOutSlowIn,
      child: Container(
        width:  widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(gradientPosition.value, 0),
                end: Alignment(-1, 0),
                colors:  [Colors.green[400], Colors.grey[600], Colors.green[400]]
            )
        ),
      ),vsync: this, duration: new Duration(seconds: 2),
    );
  }
}

//
//class SkeletonLoader extends StatelessWidget {
//  const SkeletonLoader({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Skeleton(width: MediaQuery.of(context).size.width-20,),
//        SizedBox(height: 30,),
//        Skeleton(width: MediaQuery.of(context).size.width-30,),
//        SizedBox(height: 30,),
//        Skeleton(width: MediaQuery.of(context).size.width-40,),
//        SizedBox(height: 30,),
//        Skeleton(width: MediaQuery.of(context).size.width-50,),
//        SizedBox(height: 30,),
//        Skeleton(width: MediaQuery.of(context).size.width-50,),
//        SizedBox(height: 30,)
//
//      ],
//    );
//  }
//}
//
