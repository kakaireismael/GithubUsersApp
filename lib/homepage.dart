import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:githubusers/user_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart'

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  // const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState ();
}

class _HomePageState  extends State<HomePage>{

  final TextEditingController _controller = TextEditingController();
  List _users = [];
  bool _hasSearched = false;

  // Future<void> _launchURL(String url) async{
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200){
  //
  //   }
  // }


  Future<void> _searchUsers(String query) async {

    if (query.isEmpty){
      if (kDebugMode) {
        print('Searching');
      }
    }
    // final response = await http.get(Uri.parse("https://api.github.com/search/users?q=location:{location}"));
    final response = await http.get(Uri.parse("https://api.github.com/search/users?q=location:$query"));
    if (kDebugMode) {
      print(response);
    }

    if (response.statusCode == 200){
      final data = json.decode(response.body);
      if (kDebugMode) {
        print(response);
      }
      setState(() {
        _users = data['items'] ?? [];
        _hasSearched = true;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner : false,


        home: Scaffold(
        appBar: AppBar(
        title: const Text('Search for GitHub Users'),
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
    ),


        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [

            const SizedBox(height: 20.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0)
                    ),
                    hintText: 'Enter Country',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton( onPressed: (){
                      _searchUsers(_controller.text);
                    }, icon: const Icon(Icons.search)
                      ,)
                ),
              ),
            ),

            Expanded(
                child: _hasSearched && _users.isNotEmpty ? listOfNames()
                    : baseBackground()),


          ],
        ),

      ),

    );

  }
  Widget listOfNames(){

    return ListView.builder(
      itemBuilder: (context, index){
        return MouseRegion(
          onEnter: (event){
            setState(() {
              _users[index]['isHovered'] = true;

            });
          },
          onExit: (event) {
            setState(() {
              _users[index]['isHovered'] = false;
            });
          },
          child: GestureDetector(
            onTap: () {
              // _launchURL(_users[index]['html_url']);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (counter)=> UserProfile(user: _users[index])
                  ));
            },
            child: Container(
              color: _users[index]['isHovered'] == true ? Colors.orangeAccent[50] : Colors.transparent,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_users[index]['avatar_url']),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(_users[index]['login']),
                ),              ),
            ),          ),
          );
        },
    );
  }
  Widget baseBackground(){
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ImageIcon("")
      ],
    );
  }

}