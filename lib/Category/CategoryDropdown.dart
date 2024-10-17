import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class CDrop extends StatefulWidget {
  final String brandcategory;
  const CDrop({super.key, required this.brandcategory});

  @override
  State<CDrop> createState() => _CDropState();
}


class _CDropState extends State<CDrop> {
  bool isIconSelected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        appBar: AppBar(
          title: Text(widget.brandcategory),
        ),
        body:Column(
          children: [
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left:35)),
                Text('New Arrivals',
                style: TextStyle(
                  fontSize:20,
                  color:Color(0xff7b0001),
                ),),
              ],
            ),
            SizedBox(height: 10,),
           StreamBuilder(
             stream:FirebaseFirestore.instance.collection('Products').where('Categories',isEqualTo: widget.brandcategory).snapshots(),
             builder: (context, snapshot) {
               if(snapshot.hasError){
                 return Text('Error');
               }else if (ConnectionState==ConnectionState.waiting){
                 return CircularProgressIndicator();
               }
               return CarouselSlider(
                   items:[
                            ListView.builder(
                               itemCount:snapshot.data!.docs.length,
                               shrinkWrap: true,
                               scrollDirection:Axis.horizontal,
                               itemBuilder:(context,int index ){

                                 final snap = snapshot.data!.docs[index];
                                 return Padding(
                                   padding: const EdgeInsets.only(left:18.0,),
                                   child: GestureDetector(
                                     onTap:(){},
                                     child: Padding(
                                       padding: const EdgeInsets.only(left:10.0,),
                                       child: Container(
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(25),
                                           color:Color(0xff8a92cd),
                                         ),
                                         height: 400,
                                         width:200,
                                         child: Column(
                                           children: [
                                             SizedBox(height: 12,),
                                             ClipRRect(
                                               child: Image(
                                                   image:NetworkImage(snap['image'][0]),
                                                   height: 200,
                                                   width: 170,
                                                   fit: BoxFit.cover
                                               ),
                                             ),
                                             Text(snap['ProductName'],
                                               style: TextStyle(
                                                   overflow: TextOverflow.ellipsis,
                                                   fontSize: 20,
                                                   color: Colors.white,
                                                   fontWeight: FontWeight.w500
                                               ),),
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                                                 MaterialButton(
                                                   onPressed: (){},
                                                   color: Colors.white,
                                                   child:Text('Add to cart'),),
                                                 Padding(
                                                   padding: const EdgeInsets.only(left: 8.0),
                                                   child: IconButton(
                                                     onPressed: (){
                                                      setState(() {
                                                       setState(() {
                                                         isIconSelected=!isIconSelected;
                                                       });
                                                      });
                                                     },
                                                     icon: Icon(Icons.favorite,
                                                       color: isIconSelected
                                                           ? Color(0xff7b0001): Colors.white,// Change color based on selection
                                                       size: 30.0, // Customize the icon size
                                                     ),),
                                                 )
                                               ],
                                             ),
                                           ],
                                         ),
                                       ),
                                     ),
                                   ),
                                 );
                               } )


                   ],
                   options:CarouselOptions(
                     height: 300,
                     animateToClosest: false,
                     disableCenter: true,
                     autoPlay: true,
                     padEnds: true,
                     viewportFraction: 1,
                   )
               );
             }
           ),
            SizedBox(height: 15,),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left:35)),
                Text('Top Selling',
                  style: TextStyle(
                    fontSize:20,
                    color:Color(0xff057d05),
                  ),),
              ],
            ),
        SizedBox(height: 10,),
        StreamBuilder(
            stream:FirebaseFirestore.instance.collection('Products').where('Categories',isEqualTo: widget.brandcategory).where('topselling',isEqualTo: true).snapshots(),
          builder: (context, snapshot) {
            return CarouselSlider(
              items:[
            ListView.builder(
            itemCount:snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection:Axis.horizontal,
                itemBuilder:(context,int index ){
                  if(snapshot.hasError){
                    return Text('Error');
                  }else if (ConnectionState==ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  final snap = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.only(left:18.0,),
                    child: GestureDetector(
                      onTap:(){},
                      child: Padding(
                        padding: const EdgeInsets.only(left:10.0,),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color:Color(0xff8a92cd),
                          ),
                          height: 400,
                          width:200,
                          child: Column(
                            children: [
                              SizedBox(height: 12,),
                              ClipRRect(
                                child: Image(
                                    image:NetworkImage(snap['image'][0]),
                                    height: 200,
                                    width: 170,
                                    fit: BoxFit.cover
                                ),
                              ),
                              Text(snap['ProductName'],
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500
                                ),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    onPressed: (){},
                                    color: Colors.white,
                                    child:Text('Add to cart'),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: IconButton(
                                      onPressed: (){
                                        setState(() {
                                          isIconSelected=!isIconSelected;
                                        });
                                      },
                                      icon: Icon(Icons.favorite,
                                        color: isIconSelected!
                                            ? Color(0xff7b0001)
                                            : Colors.white,// Change color based on selection
                                        size: 30.0, // Customize the icon size
                                      ),),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } )

              ],
              options:CarouselOptions(
              height: 300,
              animateToClosest: false,
              disableCenter: true,
              autoPlay: true,
              padEnds: true,
              viewportFraction: 1,
            ),
            );
          }
        ) ,
        ],)
      ),
    );
  }
}
