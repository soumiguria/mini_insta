import 'dart:convert';
import 'package:assignment/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Map<String, dynamic>? postData;
  bool isLoading = true;
  String errorMessage = '';
  bool _isLiked = false;
  int _likesCount = 0; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    fetchPostData();
  }

  Future<void> fetchPostData() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.mocklets.com/p6903/getPostAPI'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          postData = data;
          _likesCount =
              data['likes'] ?? 0; // Ensure likes count is retrieved correctly
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load post';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
        isLoading = false;
      });
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: isLoading || postData == null
            ? const Text('', style: TextStyle(color: Colors.white))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    postData!['username'],
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Post',
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        centerTitle: true,
        actions: [
          Container(
            height: 38,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onBackground),
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Follow',
                style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onBackground, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
      backgroundColor: theme.colorScheme.background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: TextStyle(color: theme.colorScheme.error)))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(postData!['profile_pic']),
                            ),
                            const SizedBox(width: 10),
                            Text(postData!['username'],
                                style: theme.textTheme.titleMedium!.copyWith(
                                    color: theme.colorScheme.onBackground)),
                            const Spacer(),
                            const Icon(Icons.more_horiz, color: Colors.white),
                          ],
                        ),
                      ),
                      Image.network(postData!['image'],
                          fit: BoxFit.cover, width: double.infinity),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.heart,
                                color: _isLiked
                                    ? Colors.red
                                    : theme.iconTheme.color,
                                size: 28,
                              ),
                              onPressed: _toggleLike,
                            ),
                            const SizedBox(width: 15),
                            Icon(FontAwesomeIcons.comment,
                                color: theme.iconTheme.color, size: 28),
                            const SizedBox(width: 15),
                            Icon(FontAwesomeIcons.paperPlane,
                                color: theme.iconTheme.color, size: 28),
                            const Spacer(),
                            Icon(FontAwesomeIcons.bookmark,
                                color: theme.iconTheme.color, size: 28),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('$_likesCount likes',
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                                fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                            '${postData!['username']} ${postData!['caption']}',
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onBackground)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(postData!['post_date'],
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.54),
                                fontSize: 12)),
                      ),
                    ],
                  ),
                ),
    );
  }
}
