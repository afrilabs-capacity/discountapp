import 'package:flutter/material.dart';

class GreenButton extends StatelessWidget {
  GreenButton({@required this.buttonTitle, this.onTap});
  final String buttonTitle;
  final Function onTap;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(buttonTitle,style: (TextStyle(color: Colors.white)),),
          ),
          decoration: BoxDecoration(
            //color: Color(0xFF21BFBD),
              color: Colors.green,
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: [new BoxShadow(
                color: Colors.grey,
                blurRadius: 20.0,
              ),]
          ),
        ),

      ),
    );
  }
}