import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/view/profilePage.dart';
import 'package:mytutor/view/subscribePage.dart';
import '../config.dart';
import '../model/tutor.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import 'favouritePage.dart';
import 'mainpage.dart';

User user = User();

class TutorPage extends StatefulWidget {
  const TutorPage({Key? key}) : super(key:key);

  @override
  State<TutorPage> createState() => TutorPageState();
}

class TutorPageState extends State<TutorPage> {
  List<Tutor> tutorlist = <Tutor>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  // var tapPosition, numOfPage, curPage = 1, color;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) { resWidth = screenWidth; } 
    else { resWidth = screenWidth * 0.75; }
    return Scaffold (
      appBar: AppBar(
        title: const Text('My Tutor'),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.amber,
          child: SizedBox(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext content) => MainPage(user: user)));
                  },
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
      body: tutorlist.isEmpty ? 
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
              children: List.generate(tutorlist.length, (index) {
                return Card(
                  child: Column(
                    children: [
                      Flexible(
                        flex: 6, 
                        child: CachedNetworkImage(
                          imageUrl: Config.server + "/mytutor/php/mobile/assets/assets/tutors/" + tutorlist[index].tutorId.toString() + '.jpg',
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
                            Text(tutorlist[index].tutorName.toString())
                          ],
                        ),
                      )
                    ],
                  )
                );
              })),
            ),
        ]
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadTutor();
    // loadTutor(1);
    // loadTutor(1,search,"All");
  }

  // void loadTutor(int pageNo) {
  void loadTutor() {
    // curPage = pageNo;
    // numOfPage ?? 1;

    http.post(Uri.parse(Config.server + "/mytutor/php/mobile/php/load_tutor.php"),
    body: {}
      // body: { 'pageNo': pageNo.toString()}
      
      ).then((response) {
        var jsondata = jsonDecode(response.body);
        // print(jsondata);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          // numOfPage = int.parse(jsondata['numOfPage']);

          if (extractdata['tutor'] != null) {
            tutorlist = <Tutor>[];
            extractdata['tutor'].forEach((v) {
              tutorlist.add(Tutor.fromJson(v));
            });
            setState(() {});
          } else {
            setState(() {});
          }
        }
      });
  }
}