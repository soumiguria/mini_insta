import 'dart:convert';
import 'package:assignment/screens/post_page.dart';
import 'package:assignment/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.mocklets.com/p6903/getProfileAPI'));

      if (response.statusCode == 200) {
        try {
          setState(() {
            profileData = json.decode(response.body);
          });
        } catch (e) {
          print('Error decoding JSON: $e');
          _showErrorSnackbar('Failed to load profile data.');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        _showErrorSnackbar('Failed to fetch profile. Please try again.');
      }
    } catch (e) {
      print('Network Error: $e');
      _showErrorSnackbar('No internet connection. Please check your network.');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (profileData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          profileData!['username'],
          style: theme.textTheme.titleLarge
              ?.copyWith(color: theme.colorScheme.onBackground),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.facebookMessenger,
                size: 28,
                color: theme.iconTheme.color,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profileData!['profile_pic']),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          "Smollan",
                          style: TextStyle(
                            fontSize: 20,
                            color: theme.textTheme.bodyLarge!.color,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildStats(profileData!['posts'], 'Posts', context),
                          SizedBox(width: 20),
                          _buildStats(
                              profileData!['followers'], 'Followers', context),
                          SizedBox(width: 20),
                          _buildStats(
                              profileData!['following'], 'Following', context),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profileData!['bio']['designation'],
                    style: TextStyle(
                        color: theme.textTheme.bodyLarge!.color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(profileData!['bio']['description'],
                    style: TextStyle(
                        color: theme.textTheme.bodyMedium!.color,
                        fontSize: 14)),
                SizedBox(height: 5),
                Text(profileData!['bio']['website'],
                    style: TextStyle(color: Colors.blue, fontSize: 14)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildButton('Follow', Colors.blue, false, theme),
                SizedBox(width: 10),
                _buildButton('Message', Colors.transparent, true, theme),
                SizedBox(width: 10),
                _buildButton('Contact', Colors.transparent, true, theme),
              ],
            ),
            SizedBox(height: 15),
            _buildHighlights(),
            SizedBox(height: 15),
            _buildGallery(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      String text, Color color, bool isOutlined, ThemeData theme) {
    return SizedBox(
      width: 110,
      child: isOutlined
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: BorderSide(color: theme.colorScheme.primary),
              ),
              onPressed: () {},
              child: Text(text,
                  style: TextStyle(color: theme.colorScheme.primary)),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {},
              child: Text(text, style: TextStyle(color: Colors.white)),
            ),
    );
  }

  Widget _buildHighlights() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: profileData!['highlights'].map<Widget>((highlight) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(highlight['cover']),
                ),
                SizedBox(height: 5),
                Text(highlight['title'], style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGallery() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
      itemCount: profileData!['gallery'].length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (index == 0) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PostPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.network(
              profileData!['gallery'][index]['image'],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStats(int value, String label, BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
