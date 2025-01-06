import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Addresspage extends StatefulWidget {
  const Addresspage({super.key});

  @override
  State<Addresspage> createState() => _AddresspageState();
}

class _AddresspageState extends State<Addresspage> {
  final CollectionReference address = FirebaseFirestore.instance.collection('Address');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add New Address',
            style: TextStyle(
              fontSize:25,
              fontFamily: GoogleFonts.playfairDisplay().fontFamily,
              color: const Color(0xff00295d),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAddress()));
                  },
                  leading:Icon(Icons.add_circle_outline),
                  title:Text('Add Address',
                  style: TextStyle(
                    fontSize: 18
                  ),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child:Container(
                  height:250,
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StreamBuilder(
                          stream:address.snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                               itemBuilder:(context, int index) {
                                 final  DocumentSnapshot snap = snapshot.data!.docs[index];
                                  return Column(
                                    children: [
                                      SizedBox(height: 20,),
                                      Text(snap['name'],
                                        style: TextStyle(
                                            fontSize: 18
                                        ),),
                                      SizedBox(height: 20,),
                                      Text("Address :",
                                        style: TextStyle(
                                            fontSize: 18
                                        ),),
                                      SizedBox(height: 20,),
                                      Text("PinCode :",
                                        style: TextStyle(
                                            fontSize: 18
                                        ),),
                                      SizedBox(height: 20,),
                                      Text("Mobile  :",
                                        style: TextStyle(
                                            fontSize: 18
                                        ),),

                                    ],
                                  );
                                }
                              );
                            }
                            return CircularProgressIndicator();
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
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
