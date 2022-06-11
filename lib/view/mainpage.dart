import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/model/user.dart';
import '../config.dart';
import '../model/subject.dart';
import 'package:http/http.dart' as http;
import 'tutorPage.dart';
import 'subscribePage.dart';
import 'favouritePage.dart';
import 'profilePage.dart';

User user = User();

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({Key? key, required this.user}) : super(key: key);
  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int selectedIndex = 1;
  late List<Widget> tabchildren;
  String maintitle = "MyTutor";
  late double screenHeight, screenWidth, resWidth;
  String titlecenter = "Loading...";
  List<Subject> subjectlist = <Subject>[];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
      return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.amber,
          child: SizedBox(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {MainPage(user: user);},
                  icon: const Icon(Icons.menu_book,
                  color: Colors.white,
                  size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext content) => const TutorPage()));
                  },
                  icon: const Icon(Icons.school,
                  color: Colors.white,
                  size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext content) => const SubscribePage()));},
                  icon: const Icon(Icons.notifications,
                  color: Colors.white,
                  size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext content) => const FavouritePage()));},
                  icon: const Icon(Icons.favorite_border,
                  color: Colors.white,
                  size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext content) => const ProfilePage()));},
                  icon: const Icon(Icons.person,
                  color: Colors.white,
                  size: 35,
                  ),
                ),
              ]
              
            ),
          ),
        ),
        body: subjectlist.isEmpty ? 
      Center(
        child: Text(titlecenter, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
      ) : Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0,10,0,0),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(subjectlist.length, (index) {
                return Card(
                  child: Column(
                    children: [
                      Flexible(
                        flex: 6, 
                        child: CachedNetworkImage(
                          imageUrl: Config.server + "/mytutor/php/mobile/assets/assets/courses/" + subjectlist[index].subjectId.toString() + '.png',
                          fit: BoxFit.cover,
                          width: resWidth,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Column(
                          children: [
                            Text(subjectlist[index].subjectName.toString())
                          ],
                        ),
                      )
                    ],
                  )
                );
              })),
            ),
        ]
      )
      );
  }

void initState() {
    super.initState();
    loadSubject();

  }

  void loadSubject() {
    http.post(Uri.parse(Config.server + "/mytutor/php/mobile/php/load_subject.php"),
    body: {}
      
      ).then((response) {
        var jsondata = jsonDecode(response.body);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];

          if (extractdata['subject'] != null) {
            subjectlist = <Subject>[];
            extractdata['subject'].forEach((v) {
              subjectlist.add(Subject.fromJson(v));
            });
            setState(() {});
          } else {
            setState(() {});
          }
        }
      });
  }
}