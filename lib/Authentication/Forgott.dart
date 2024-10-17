import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'Login.dart';
class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {


  TextEditingController reset = TextEditingController();

  void  Forgot()async{
    final email =reset.text;
    try{
      if(email.contains('@')){
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor:Colors.green,
                duration: Duration(
                    seconds: 2
                ),
                content: Text('Check your email ${email}'),
            )
        );
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Login()));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor:Color(0xffa91515),
            duration: Duration(
                seconds: 2
            ),
            content:Text('Incorrect email ')
        ));
      }}on FirebaseAuthException catch(e){
      showDialog(
        context: context, builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Incorrect email '),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Ok')
            ),
          ],
        );
      },
      );
    }


  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              ClipRRect(
                child: Lottie.asset('assets/animation/reset.json',
              height:300,
              width: 300,
              fit: BoxFit.fill
              ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller:reset,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email'
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                child: Text('Ok'),
                color:Colors.cyan,
                height: 40,minWidth: 150,
                onPressed: () {
                  Forgot();
                },
              )
            ],
          ),
        ));
  }

}
