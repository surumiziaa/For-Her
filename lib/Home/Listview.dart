import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:for_her/images/Engage/EngageProduct.dart';


NavigatorPage(context,pp){
  Navigator.push(context,MaterialPageRoute(builder: (context)=>pp) );
}

class Homecontainer extends StatefulWidget {
  const Homecontainer({super.key});

  @override
  State<Homecontainer> createState() => _HomecontainerState();
}

class _HomecontainerState extends State<Homecontainer> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height:MediaQuery.of(context).size.height*0.8,
        child: StreamBuilder(
          stream:FirebaseFirestore.instance.collection('Brand').where('listbrand',isEqualTo: true).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Text('ERROR');
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
                itemBuilder:(BuildContext,int index){
                final snap = snapshot.data!.docs[index];
                  return  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: (){
                        NavigatorPage(
                            context,HomeScreenListProduct(
                          brand:snap['Brands']));
                      },
                      child: Container(
                        color: Colors.yellow,
                        height:150,
                        width:double.infinity,
                        child: ClipRRect(
                          child: Image(
                              image:NetworkImage(snap['image']),
                              fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ),
                  );
                }
            );
          }
        ),
      ),
    );
  }
}
