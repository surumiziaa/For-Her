import 'package:flutter/material.dart';

class Tutorials extends StatefulWidget {
  const Tutorials({super.key});

  @override
  State<Tutorials> createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {

  List images=[
    'lib/images/nybae.webp',
    'lib/images/mamaearth.webp',
    'lib/images/loreal.webp',
    'lib/images/lakme.webp',
    'lib/images/goodvibes.webp',
    'lib/images/apls.webp',
    'lib/images/maybe.webp',
    'lib/images/minimalist.webp',
    'lib/images/minimalist.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 12,right: 12),
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.9,
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: images.length,
            shrinkWrap: true,
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 10,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 250.0
            ) ,
            itemBuilder:(BuildContext ,int index){
              return Container(
                height: 300,
                width: 150,
                decoration:BoxDecoration(
                  image: DecorationImage(
                      image:AssetImage(images[index]),
                    fit: BoxFit.cover )
                ),
                child: IconButton(
                  onPressed: (){},
                  icon:Icon(
                      Icons.play_circle_fill,
              size:35,
              color: Colors.white,
                )
                )
              );
            }
        ),
      ),
    );
  }
}

