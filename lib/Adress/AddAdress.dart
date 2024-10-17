import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final CollectionReference address = FirebaseFirestore.instance.collection('Address');

  Future addaddres() async{
    final data ={
      "name":name.text,
      'address':adress.text,
      'phone':phone.text,
      'pincode':pin.text
    };
    await address.add(data);
  }

  TextEditingController name = TextEditingController();
  TextEditingController adress = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Address'),
        ),
        body: SingleChildScrollView(
          child: Column(
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
                  controller: adress,
                  minLines: 5,
                  maxLines: 6,
                  cursorColor:Colors.orangeAccent,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                    ),
                    hintText: 'Address',
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
                  controller:phone,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  cursorColor:Color(0xff057d05),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                    ),
                    hintText: 'Phone Number',
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
                      cursorColor:Color(0xff8a92cd),
                      decoration: InputDecoration(
                        prefixIcon:Icon(Icons.gps_fixed,color: Colors.indigo,),
                        border: OutlineInputBorder(
                        ),
                        hintText: 'Current Location',
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
                padding: const EdgeInsets.only(left: 18.0,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Address',
                    style: TextStyle(
                      color:Colors.red.shade900,
                      fontSize: 18
                    ),),
                  ],
                ),
              ),
              Row(
                children: [
                 Padding(
                   padding: const EdgeInsets.only(left: 18.0,top: 18),
                   child: MaterialButton(
                     height: 50,
                     minWidth: 100,
                       onPressed: (){},
                   child: Text('Home'),
                     shape:Border.all(
                       width: 2,
                       color:Color(0xff057d05),
                     ),
                   ),
                 ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0,top: 18),
                    child: MaterialButton(
                      height: 50,
                      minWidth: 100,
                      onPressed: (){},
                      child: Text('Office'),
                      shape:Border.all(
                        width: 2,
                        color:Colors.orangeAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0,top: 18),
                    child: MaterialButton(
                      height: 50,
                      minWidth:100,
                      onPressed: (){},
                      child: Text('Others'),
                      shape:Border.all(
                        width: 2,
                        color:Colors.red.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              MaterialButton(
                color:Color(0xff8a92cd),
                  onPressed: (){
              setState(() {
                addaddres();
                Navigator.pop(context);
              });
                  },
              child: Text('Save Address'),)
            ],
          ),
        ),
      ),
    );
  }
}
