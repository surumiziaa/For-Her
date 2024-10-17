import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          appBar:AppBar(
            title: Text('Help Center',
              style: TextStyle(
                fontSize: 30,
                fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                color: Color(0xff00295d),
              ),),
          ),
          body:Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0,top: 10),
                child: Text('How Can I Help You ?',
                  style: TextStyle(
                    fontSize: 18,
                  ),),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.blueGrey,
                  child:ListTile(
                    title:Text('Make a Call?'),
                    trailing:IconButton(
                      onPressed: ()async{
                        final url = Uri(scheme: 'tel', path: '7356476921');
                        if(await canLaunchUrl(url)){
                          launchUrl(url);
                        }
                      },
                      icon:Icon(
                        Icons.call,
                        color: Colors.green,
                      ),
                    )
                  )
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                    elevation: 5,
                    shadowColor: Colors.blueGrey,
                    child:ListTile(
                        title:Text('Sent a Message ?'),
                        trailing:IconButton(
                          onPressed: ()async{
                            final url = Uri(scheme: 'sms', path: '7356476921');
                            if(await canLaunchUrl(url)){
                              launchUrl(url);
                            }
                          },
                          icon:Icon(
                            Icons.message,
                            color: Colors.blue,
                          ),
                        )
                    )
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                    elevation: 5,
                    shadowColor: Colors.blueGrey,
                    child:ListTile(
                        title:Text('Sent a Mail ?'),
                        trailing:IconButton(
                          onPressed: ()async{
                            final url = Uri(scheme: 'mailto', path: 'surumizia631@gmail.com',
                            queryParameters:{
                              "Subject":"Problem Facing on",
                              'body':'Dear sir'
                            });
                            if(await canLaunchUrl(url)){
                              launchUrl(url);
                            }
                          },
                          icon:Icon(
                            Icons.email,
                            color: Colors.orangeAccent,
                          ),
                        )
                    )
                ),
              ),
            ],
          ),
        )
    );
  }
}
