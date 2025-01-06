import 'package:flutter/material.dart';
import 'package:for_her/CheckOut/OrderConfirmed.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? payment; // Using `String?` for nullable type

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.8,
                      spreadRadius: 1.5,
                      blurStyle: BlurStyle.normal,
                    )
                  ],
                ),
                child: RadioListTile<String>(
                  value: 'Cash on delivery',
                  groupValue: payment,
                  onChanged: (value) {
                    setState(() {
                      payment = value;
                    });
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderConformed()));
                  },
                  title: Row(
                    children: [
                      ClipRRect(
                        child:Image(
                          image: AssetImage('lib/Payment/delivery.png'),
                        ) ,
                      ),
                      SizedBox(width: 5,),
                      Text('Cash on delivery'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.8,
                      spreadRadius: 1.5,
                      blurStyle: BlurStyle.normal,
                    )
                  ],
                ),
                child: RadioListTile<String>(
                  value: 'RazorPay',
                  groupValue: payment,
                  onChanged: (value) {
                    setState(() {
                      payment = value;
                    });
                  },
                  title: Row(
                    children: [
                      ClipRRect(
                        child:Image(
                          height:25,
                          width:20,
                          image: AssetImage('lib/Payment/razorpay.png',),
                          fit: BoxFit.fill,
                        ) ,
                      ),
                      SizedBox(width: 5,),
                      Text('RazorPay'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
