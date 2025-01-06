import 'package:flutter/material.dart';
import 'package:for_her/Home/Home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Authentication/Login.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    getloggedData().whenComplete((){
      if(finalData == true){
        Navigator.push(context, MaterialPageRoute(builder:(context)=>
        Home()));
      }else{
        Future.delayed(Duration(seconds: 4),(){
          Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Login()));
        });
      }
    });
  }
bool ? finalData;
  Future getloggedData() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var getData = preferences.getBool('islogged');
    setState(() {
      finalData = getData;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
        Container(
          color: Color(0xff8f6152),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Center(
          child: Container(
            height: 200,
            width: 200,
            child: Column(
              children: [
                ClipRRect(
                  child: Image(
                    image: AssetImage('lib/images/make-up.png'),color: Colors.white,
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(height: 5,),
                Text('F4_Her',
                style: TextStyle(
                  fontFamily: GoogleFonts.gwendolyn().fontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white
                ),)
              ],
            ),
          ),
        )
      ]),
    );
  }
}
