import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

 List<dynamic> availableCategories = [];
 List<dynamic> filteredCategories = [];


class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                filterCategory(value);
              });
            },
          controller: search,
            cursorColor:Color(0xff7b0001),
            decoration: InputDecoration(
              border: OutlineInputBorder(
              ),
              hintText: 'Search Here',
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
        SizedBox(
          height: MediaQuery.of(context).size.height/1.2,
          child: StreamBuilder(
            stream:FirebaseFirestore.instance.collection('Products').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Text('Erorr ::${snapshot.hasError}');
              }else if (snapshot.hasData) {
                availableCategories = snapshot.data!.docs;
                return GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredCategories.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {

                    final snap = filteredCategories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                        context,
                        'productview',
                        arguments: {
                          'ProductId': snap.id,
                          'ProductName': snap['ProductName'],
                          'image': snap['image'],
                          'Price': snap['Price'],
                          'Description': snap['Description'],
                          'Brand': snap['Brands'],
                          'Categories': snap['Categories'],
                          'Rating': snap['Rating'],
                          'Stock': snap['Stock'],
                        },
                      );},

                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color(0xff8a92cd),
                          ),
                          height: 400,
                          width: 100,
                          child: Column(
                            children: [
                              SizedBox(height: 12),
                              ClipRRect(
                                child: Image(
                                  image: NetworkImage(snap['image'][0]),
                                  height: 230,
                                  width: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                snap['ProductName'],
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    onPressed: () {},
                                    color: Colors.white,
                                    child: Text('Add to cart'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: IconButton(
                                      onPressed: () {
                                        // if (widget.iswish == false) {
                                        //   setState(() {
                                        //     widget.iswish = true;
                                        //   });
                                        // } else {
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => WishlistPage(),
                                        //     ),
                                        //   );
                                        // }
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        color: Color(0xff7b0001),
                                        // color: widget.iswish
                                        //     ? Color(0xff7b0001)
                                        //     : Colors.white, //
                                        size: 30.0, // Customize the icon size
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 20,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 250.0,


                  ),

                );
              }
              return CircularProgressIndicator();
            }
          ),
        )
      ],
    );
  }
  void filterCategory(String query) {
    setState(() {
      filteredCategories = availableCategories.where((doc) {
        String category = doc.data()['Categories'].toLowerCase();
        return category.contains(query.toLowerCase());
      }).toList();
    });
    print(query);
    print(filteredCategories);
  }
 }
// import 'dart:developer';
// import 'package:castingcallapp/core/colors.dart';
// import 'package:castingcallapp/core/constants.dart';
// import 'package:castingcallapp/presentation/screens/director/utility/shimmer_widget.dart';
// import 'package:castingcallapp/presentation/screens/model/widgets/custom_model_search_widget.dart';
// import 'package:castingcallapp/presentation/screens/model/widgets/model_apply_tile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// List<dynamic> availableCategories = [];
// List<dynamic> filteredCategories = [];
//
// class ModelSearchScreen extends StatefulWidget {
//   const ModelSearchScreen({super.key});
//
//   @override
//   State<ModelSearchScreen> createState() => _ModelSearchScreenState();
// }
//
// class _ModelSearchScreenState extends State<ModelSearchScreen> {
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     final double postheight = (size.height - kToolbarHeight - 24) / 2.3;
//     final double postwidth = size.width / 2;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: bgcolor,
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               kheight,
//               CustomModelSearchWidget(onChanged: filterCategory),
//               kheight,
//               Expanded(
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream:
//                     FirebaseFirestore.instance.collection("posts").snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return Text("Error : ${snapshot.error}");
//                       } else if (snapshot.hasData) {
//                         log("Data occurs");
//                         availableCategories = snapshot.data!.docs;
//                         return GridView.builder(
//                           shrinkWrap: true,
//                           itemCount: filteredCategories.length,
//                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio: (postwidth / postheight),
//                             crossAxisSpacing: 16.0,
//                             mainAxisSpacing: 16.0,
//                           ),
//                           itemBuilder: (context, index) {
//                             final DocumentSnapshot postSnap =
//                             filteredCategories[index];
//                             return ModelApplyTile(
//                               id: postSnap['id'],
//                               image: postSnap['image'],
//                               jobtitle: postSnap['jobtitle'],
//                               role: postSnap['role'],
//                               category: postSnap['category'],
//                               age: postSnap['age'],
//                               skill: postSnap['skill'],
//                               contact: postSnap['contact'],
//                               deadline: postSnap['deadline'],
//                             );
//                           },
//                         );
//                       } else if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return const ShimmerEffect();
//                       }
//                       return const ShimmerEffect();
//                     },
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void filterCategory(String query) {
//     setState(() {
//       filteredCategories = availableCategories.where((doc) {
//         String category = doc.data()['category'].toLowerCase();
//         String searchLower = query.toLowerCase();
//         return category.contains(searchLower);
//       }).toList();
//     });
//   }}
