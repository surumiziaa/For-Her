import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:for_her/Home/Home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _obscure=true;
  bool _obscure1=true;

  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  final CollectionReference user = FirebaseFirestore.instance.collection('Users');

  Future addaddres() async{
    final data ={
      "name":name.text,
      'email':email.text,
      'phone':phone.text,
      'image':img
    };
    await user.add(data);
  }

  bool confirmPassword() {
    if (password.text == confirm.text) {
      return true;
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xffa91515),
          duration: Duration(seconds: 2),
          content: Text('Password does not match'),
        ),
      );
      return false;
    }
  }


  String img = '';

  Future<String> imgpick(File path) async {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    DateTime now = DateTime.now();
    String Timestamp = now.microsecondsSinceEpoch.toString();
    firebase_storage.Reference reference =
    storage.ref().child('images/$Timestamp');
    firebase_storage.UploadTask task = reference.putFile(path);
    await task;
    String url = await reference.getDownloadURL();
    print(url);
    setState(() {
      img = url;
    });

    return img;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 15,),
                  Center(
                    child: ClipRRect(
                      child: Lottie.asset('assets/animation/sigin.json',
                          height:250,
                          width: 300,
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(img),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: ()async{
                          final pickedfile = await ImagePicker().pickImage(
                              source: ImageSource.gallery
                          );
                          if(pickedfile == null){
                            return;
                          }else{
                            File path = File(pickedfile.path);
                            img = await imgpick(path);
                            setState(() {

                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        hintText: 'Username',
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
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
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: password,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _obscure=!_obscure;
                            });
                          },
                          icon: _obscure?Icon(Icons.visibility_off):Icon(Icons.visibility),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        hintText: 'Password',

                      ),
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return 'Enter your password';
                        } if(value.length < 6){
                          return 'Password must be at least 6 characters';
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: confirm,
                      obscureText: _obscure1,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _obscure1=!_obscure1;
                            });
                          },
                          icon: _obscure1?Icon(Icons.visibility_off):Icon(Icons.visibility),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        hintText: 'Confirm password',
                      ),
                      validator: (value){
                        if(value==null ||value.isEmpty){
                          return 'Enter confirm password here';
                        }
                        if(value!=password.text){
                          return 'Password you entered is correct';
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: phone,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        hintText: 'Phone Number',
                      ),
                      validator: (value){
                        if( value==null || value.isEmpty){
                          return 'Please enter a phone number';
                        }
                        if (value.length !=10){
                          return 'Phone number must be 10 digits';
                        }
                      },
                    ),
                  ),
                  MaterialButton(
                    color: Colors.teal[300],
                    onPressed: (){
                      setState(() {
                        if (confirmPassword()) {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              Signup();
                              addaddres();
                            });
                          }
                        }
                      });
                    },
                    child: Text('Signup'),)
                ],
              ),
            ),
          ),
        ),
      ),
    ) ;

  }
  Future Signup()async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (BuildContext)=>Home()));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor:Colors.teal[300],
              duration: Duration(
                  seconds: 2
              ),
              content:Text('Successfully Created ') )
      );
      final SharedPreferences preferences =
        await SharedPreferences.getInstance();
      preferences.setBool('islogged', true);
      Navigator.push(
          context, MaterialPageRoute(builder: (BuildContext)=>Home()));
    } on FirebaseAuthException catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor:Color(0xffa91515),
          duration: Duration(
              seconds: 2
          ),
          content:Text('Creation Failed error  : ${e}')
      ));
    }
  }
}
