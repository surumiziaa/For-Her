
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
    return  SafeArea(
      child: Column(
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
                      color: Color(0xff7b0001),
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
                          child: Card(
                            color: Colors.white,
                          shadowColor: Colors.grey,
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white70,
                              ),
                              height: 100,
                              width: 100,
                              child: Column(
                                children: [
                                  SizedBox(height: 12),
                                  ClipRRect(
                                    child: Image(
                                      image: NetworkImage(snap['image'][0]),
                                      height: 250,
                                      width: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snap['ProductName'],
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
  void filterCategory(String query) {
    setState(() {
      filteredCategories = availableCategories.where((doc) {
        String category = doc.data()['ProductName'].toLowerCase();
        return category.contains(query.toLowerCase());
      }).toList();
    });
    print(query);
    print(filteredCategories);
  }
 }
