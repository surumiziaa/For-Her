import 'package:flutter/material.dart';
import 'package:for_her/Home/Home.dart';
import 'package:lottie/lottie.dart';
class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          body: Column(
            children: [
              Center(
                child: Lottie.asset('assets/animation/animation.json',
                repeat: true,
                width: 300,
                height:350,
                  fit:BoxFit.fill
                ),
              ),
              SizedBox(
                height: 100,
              ),
              MaterialButton(
                minWidth: 300,
                  onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                  },
                color:Color(0xff057d05),
              child: Text('Back'),
              )
            ],
          ),
        ));
  }
}
