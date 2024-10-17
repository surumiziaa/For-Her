import 'package:flutter/material.dart';
import 'package:for_her/Category/CategoryDropdown.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}
List images =[
  'lib/Category/skincare.webp',
  'lib/Category/makeup.webp',
  'lib/Category/hair.webp',
  'lib/Category/fragrance.jpg',
  'lib/Category/bath and body1.webp',
];

List data =[
  'Skin Care',
  'Make Up',
  'Hair Care',
  'Fragrance',
  'Body and Wash'
];
List <String> products =[
  'Lip Care',
  'Eye Care',
  'Cleansers',
  'Moisturizers',
  'SunScreens'
];

// List Navi = [
//   CDrop(brandcategory: ,),
//   CDrop(brandcategory: '',),
//   CDrop(brandcategory: '',),
//   CDrop(),
//   CDrop(),
// ];
String ? selected ;
class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height:MediaQuery.of(context).size.height*1.4,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: images.length,
            itemBuilder:(BuildContext,int index){
              return  Column(
                children: [
                  Text(data[index],
                  style:TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.bold
                  ),),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height:200,
                      width:double.infinity,
                      decoration: BoxDecoration(
                        image:DecorationImage(
                            image: AssetImage(images[index]),
                            fit: BoxFit.cover
                        )
                      ),
                      child:Padding(
                        padding: const EdgeInsets.only(
                            left:10,top: 18,right: 200),
                        child: DropdownButtonFormField(
                          value: selected,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              hintText: 'Products'
                          ),
                          items:products.map((String value){
                            return DropdownMenuItem(
                              child: Text(value),value: value,);
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selected=value;
                            });
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>CDrop(brandcategory: products[index],)));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}
