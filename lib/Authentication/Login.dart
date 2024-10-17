import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_her/Authentication/Forgott.dart';
import 'package:for_her/Authentication/phone.dart';
import 'package:for_her/Home/Home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Signup.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _obscure = true;
  TextEditingController email =TextEditingController();
  TextEditingController password =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  child: Lottie.asset('assets/animation/login.json',
                      height:300,
                      width: 300,
                    fit: BoxFit.fill
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    hintText: 'Enter your email',
                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'Enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@gmail\.com$').hasMatch(value)) {
                      return 'Please enter a valid Gmail address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: password,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                      icon: _obscure
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: 'Password',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext) =>Forgot()));
                      },
                      child: Text('Forgot Password'))
                ],
              ),
              MaterialButton(
                onPressed: () {
                  login();
                },
                color: Colors.teal[300],
                child: Text('LOGIN'),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      sigin();
                    },
                    child: Image(
                      image: AssetImage('lib/images/img.png'),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext) => Phone()));
                    },
                    child: Image(
                      image: AssetImage('lib/images/phone-call.png'),
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account ?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUp()));
                      },
                      child: Text('Signup')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future login()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor:Colors.teal[300],
              duration: Duration(
                  seconds: 2
              ),
              content:Text('Login Successfull') )
      );
      final SharedPreferences preferences =
      await SharedPreferences.getInstance();
      preferences.setBool('islogged', true);

      Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Home()));
    } on FirebaseAuthException catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor:Color(0xffa91515),
          duration: Duration(
              seconds: 2
          ),
          content:Text('Login Failed error  : ${e}')
      ));
    }
  }

  //Google signin

  Future sigin() async {
    try {
      final google = GoogleSignIn();

      final user = await google.signIn().catchError((onerror) {});
      if (user == null) return;
      final auth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      final SharedPreferences preferences =
      await SharedPreferences.getInstance();
      preferences.setBool('islogged', true);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>Home(),
          ));
    } catch (e) {
      print("ERROR ::: $e");
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xffa91515),
        duration: Duration(seconds: 2),
        content: Text("ERROR ::: $e"),
      ));
    }
  }
}
