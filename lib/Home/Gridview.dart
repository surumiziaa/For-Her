import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_her/product/productlist.dart';


NavigatorPage(context,pp){
  Navigator.push(context,MaterialPageRoute(builder: (context)=>pp) );
}

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {

  List images=[];
  List brands=[];
  Future fetchimages()async{
    try{
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Brand').where('listbrand',isEqualTo: false).get();
      List values = querySnapshot.docs.map((doc)=> doc['image']).toList();
      setState(() {
        images = values;
      });
    }catch(e){
      print(e);
    }
  }
  Future fetchBrands()async{
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Brand').where('listbrand',isEqualTo: false).get();
      List values = querySnapshot.docs.map((doc)=> doc['Brands']).toList();
      setState(() {
        brands = values;
      });
    }catch(e){
      print(e);
    }

  }

  @override
  void initState() {
    fetchimages();
    fetchBrands();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 12,right: 12),
      child: SizedBox(
        height: MediaQuery.of(context).size.height*1.2,
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: brands.length,
            shrinkWrap: true,
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 10,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 250.0
            ) ,
            itemBuilder:(BuildContext ,int index){
              return Refactor(
                  onTap:(){
                    NavigatorPage(
                        context,ProductList(
                      brand: brands[index],));
                  },
                  img:NetworkImage(images[index]));
            }
        ),
      ),
    );
  }
}

class Refactor extends StatelessWidget {
  Refactor({super.key,required this.onTap,required this.img});
  final Function ?onTap;
  final ImageProvider?img;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> onTap!(),
      child: Container(
        color: Colors.yellow,
        height: 300,
        width: 150,
        child: ClipRRect(
          child: Image(
              image: img!,
              fit: BoxFit.cover
          ),
        ),
      ),
    );
  }
}