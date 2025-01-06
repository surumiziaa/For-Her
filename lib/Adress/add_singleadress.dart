
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SingleAddress extends StatefulWidget {
  const SingleAddress({super.key});

  @override
  State<SingleAddress> createState() => _AddressState();
}

class _AddressState extends State<SingleAddress> {
String ?address;
  TextEditingController name = TextEditingController();
  TextEditingController house = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController pin = TextEditingController();

  Future singleAdress() async{
    try{
      await FirebaseFirestore.instance.collection("SingleAddress").add({
        "address":
            "${name.text.toLowerCase()}+${phone.text.toLowerCase()}+"
                "${house.text.toLowerCase()}(H)+${street.text.toLowerCase()}+ "
                "${city.text.toLowerCase()}+${district.text.toLowerCase()}+${pin.text.toLowerCase()}",
        'userId':FirebaseAuth.instance.currentUser!.email,
        'phone':phone.text
      });
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    log(args.toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Address'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                  stream:FirebaseFirestore.instance.collection("SingleAddress")
                  .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if(snapshot.hasError){
                     print(snapshot.error.toString());
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final snap = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.blueGrey,
                            child: RadioListTile(
                              value:snap['address']+ '*'+snap['phone'],
                              title:Text(
                                snap['address'].split('+').join('\n'),
                              ),
                              groupValue:address,
                              onChanged: (value){
                                setState(() {
                                  address = value;
                                  log(address.toString());
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                },
                  ),
              MaterialButton(
                color:Color(0xff8a92cd),
                  onPressed:(){
                  final addressof = address!.split('*');
                  String selectedaddress = addressof[0];
                  String phone = addressof[1];
                  Navigator.pushNamed(context,"singlecheckout",
                   arguments: {
                      'address':address ==""
                     ?"Add +Your+Delivery Address"
                          :selectedaddress,
                     'phone':phone,
                     'ProductId':args['ProductId'],
                     'ProductName':args['ProductName'],
                     'image':args['image'],
                     'Price':args['Price'],
                     'Description':args['Description'],
                     'Brand':args['Brand'],
                     'Categories':args['Categories'],
                     'Rating':args['Rating'],
                    'Stock':args['Stock'],
                    'userId':FirebaseAuth.instance.currentUser!.email,
                   }
                  );
                  },
                child: Text('Select'),
              ),
              ListTile(
                title: Text('Add Address',
                style: TextStyle(
                  fontWeight:FontWeight.bold
                ),),
              ),
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
                  controller: house,
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
                      controller: street,
                      cursorColor:Color(0xff8a92cd),
                      decoration: InputDecoration(
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
                       controller:city,
                      cursorColor:Color(0xff8a92cd),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                        ),
                        hintText: 'city',
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
                  cursorColor:Color(0xff7b0001),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                    ),
                    hintText: 'District',
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
                  controller:pin,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  cursorColor:Colors.orangeAccent,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                    ),
                    hintText: 'Pin Code',
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

              SizedBox(
                height: 25,
              ),
              MaterialButton(
                color:Color(0xff8a92cd),
                onPressed: (){
                    if(name.text.isNotEmpty&&
                    house.text.isNotEmpty&&
                    phone.text.isNotEmpty&&
                    street.text.isNotEmpty&&
                    city.text.isNotEmpty&&
                    district.text.isNotEmpty&&
                    pin.text.isNotEmpty){
                      setState(() {
                        singleAdress();
                      });
                    }else{
                     setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor:Colors.red,
                            content:Text('Some feilds are empty'),
                        action: SnackBarAction(
                          label: 'Go Back',
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),)
                      );
                     });
                    }

                  Navigator.pop(context);
                },
                child: Text('Save Address'),)
            ],
          ),
        ),
      ),
    );
  }
}
