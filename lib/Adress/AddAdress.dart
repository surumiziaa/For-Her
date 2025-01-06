
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {

String ?address ;
  TextEditingController name = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController house = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pin = TextEditingController();
  Future addaddress()async{
    try{
      await FirebaseFirestore.instance.collection('Address').add({
        'address':"${name.text.toLowerCase()}"
            "+${phone.text.toLowerCase()}+${house.text.toLowerCase()}(H)+"
            "${street.text.toLowerCase()}+"
            "${city.text.toLowerCase()}+${district.text.toLowerCase()}"
            "+${pin.text.toLowerCase()}",
         'userId':FirebaseAuth.instance.currentUser!.email,
        'phone':phone.text
      });
    }catch (e) {
      log(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings as Map;
    print(args.toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Address'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // StreamBuilder(
              //   stream:FirebaseFirestore.instance.collection("Address").
              //   where("userId",
              //       isEqualTo:FirebaseAuth.instance.currentUser!.email)
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasError) {
              //       log(snapshot.error.toString());
              //     }
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     }
              //     return ListView.builder(
              //         itemCount: snapshot.data!.docs.length,
              //         shrinkWrap: true,
              //         itemBuilder: (context, index) {
              //           final snap = snapshot.data!.docs[index];
              //           return RadioListTile(
              //               value: snap['address'] + '*' + snap['phone'],
              //               title: Text(snap['address'].split('+').join('\n'),
              //               ),
              //               groupValue: address,
              //               onChanged: (value) {
              //                 setState(() {
              //                   address = value;
              //                   print(address.toString());
              //                 });
              //               });
              //         }
              //     );
              //   }),
                  SizedBox(height: 10,),
                    MaterialButton(
                      color:Color(0xff8a92cd),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder:(context)=>
                          AlertDialog(
                            title: Text('Add Address'),
                            content:Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: name,
                                    cursorColor:Color(0xff7b0001),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                      ),
                                      hintText: 'Name',
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color:Color(0xff7b0001),
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color:Color(0xff7b0001),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: phone,
                                    minLines: 5,
                                    maxLines: 6,
                                    cursorColor:Colors.orangeAccent,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                      ),
                                      hintText: 'Contact Number',
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color:Colors.orangeAccent,
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color:Colors.orangeAccent,
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller:house,
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    cursorColor:Color(0xff057d05),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                      ),
                                      hintText: 'House Name',
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color:Color(0xff057d05),
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color:Color(0xff057d05),
                                          )
                                      ),
                                    ),
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height:100,
                                      width: 160,
                                      child: TextFormField(
                                        controller: street,
                                        cursorColor:Color(0xff8a92cd),
                                        decoration: InputDecoration(
                                          prefixIcon:Icon(Icons.gps_fixed,color: Colors.indigo,),
                                          border: OutlineInputBorder(
                                          ),
                                          hintText: 'Street',
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 2,
                                                color:Color(0xff8a92cd),
                                              )
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 2,
                                                color:Color(0xff8a92cd),
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      width: 160,
                                      child: TextFormField(
                                        maxLength: 6,
                                        controller:city,
                                        keyboardType: TextInputType.number,
                                        cursorColor:Color(0xff8a92cd),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                          ),
                                          hintText: 'City',
                                          enabledBorder:OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 2,
                                                color:Color(0xff8a92cd),
                                              )
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 2,
                                                color:Color(0xff8a92cd),
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      width: 160,
                                      child: TextFormField(
                                        maxLength: 6,
                                        controller:pin,
                                        keyboardType: TextInputType.number,
                                        cursorColor:Color(0xff8a92cd),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                          ),
                                          hintText: 'Pin Code',
                                          enabledBorder:OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 2,
                                                color:Color(0xff8a92cd),
                                              )
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 2,
                                                color:Color(0xff8a92cd),
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller:district,
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    cursorColor:Color(0xff057d05),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                      ),
                                      hintText: 'District',
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color:Color(0xff057d05),
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color:Color(0xff057d05),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                 MaterialButton(
                                   color:Color(0xff8a92cd),
                                   onPressed: (){
                                    if(name.text.isNotEmpty&&
                                    phone.text.isNotEmpty &&
                                    house.text.isNotEmpty&&
                                    street.text.isNotEmpty&&
                                    city.text.isNotEmpty&&
                                    pin.text.isNotEmpty&&
                                    district.text.isNotEmpty){
                                      setState(() {
                                        addaddress();
                                      });
                                    }else{
                                      showDialog(
                                          context:context,
                                          builder: (context)=>AlertDialog(
                                            content: Text("Fill the feilds"),
                                            actions: [
                                              TextButton(
                                                  onPressed:(){
                                                    Navigator.pop(context);
                                                  },
                                                  child:Text('Back'))
                                            ],
                                          ));
                                    }
                                   },
                                   child: Text('Save Address'),
                                 )

                              ],
                            ),
                          ));
                        },
                    child: Text('Add Address'),
                    ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: MaterialButton(
                  onPressed: (){
                    final addres = address!.split('*');
                    String selectyouraddress = addres[0];
                    String phone = addres[1];
                    Navigator.pushNamed(context, "singlecheckout",
                    arguments: {
                      "address":address== ''?
                          "Add New Address":selectyouraddress,
                      'phone':phone,
                      'ProductId':args['ProductId'],
                      'ProductName': args['ProductName'],
                      'image': args['image'],
                      'Price': args['Price'],
                      'Description': args['Description'],
                      'Brand': args['Brand'],
                      'Categories': args['Categories'],
                      'Rating': args['Rating'],
                      'Stock': args['Stock'],
                      'userId': FirebaseAuth.instance.currentUser!.email,
                    });
                  },
                  color:Color(0xff8a92cd),
                  child:Text('Ok') ,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
