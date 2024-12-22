import 'dart:convert';
import 'package:bfq/discussion/screens/comment_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bfq/discussion/screens/create_discussion_page.dart';
import 'package:bfq/discussion/models/discussion.dart';
import 'package:bfq/widgets/left_drawer.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({Key? key}) : super(key: key);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  List<Discussion> discussions = [];

  Future<List<Discussion>> fetchDiscussions() async {
    var url = Uri.parse(
      'https://redundant-raychel-bfq-f4b73b50.koyeb.app/discussion/json/'
    );
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    discussions = [];
    for(var d in data) {
      discussions.add(Discussion.fromJson(d));
    }
    return discussions;
  }

  /*
  void editArticle(Discussion discussion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateDiscussionPage(article: article), // Pass the article data
      ),
    ).then((_) => _refreshArticles());
  }*/

  Future<void> deleteComment(CookieRequest request, String username, int id) async {
    try {
      final response = await request.postJson(
        'https://redundant-raychel-bfq-f4b73b50.koyeb.app/discussion/delete_discussion_flutter/$username/$id/',
        jsonEncode({})
      );

      // After successful deletion, update the state
      setState(() {
        discussions.removeWhere((discussion) => discussion.pk == id);
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Discussion deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete discussion'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DiscussionPage(),
          ),
        );
      }
    }
  }

  // Add this method to your class to handle the refresh
  Future<void> refreshDiscussions() async {
    final newDiscussions = await fetchDiscussions();
    if (mounted) {
      setState(() {
        discussions = newDiscussions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A3A30),
      appBar: AppBar(
        title: const Text(
          'Discussions',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2A3A30),
      ),
      drawer: const Drawer(
        backgroundColor: Colors.white, // Set the background color here
        child: LeftDrawer(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Add a new thread',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Discussion>>(
                future: fetchDiscussions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'An error occurred.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final filteredDiscussions = snapshot.data ?? [];
                  return RefreshIndicator(
                    onRefresh: () async {
                      await fetchDiscussions();
                    },
                    child: filteredDiscussions.isEmpty
                        ? const Center(
                            child: Text(
                              'No discussions found.',
                              style: TextStyle(
                                fontSize: 18, 
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredDiscussions.length,
                            itemBuilder: (context, index) {
                              try {
                                final discussion = filteredDiscussions[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    title: Text(
                                      discussion.fields.topic,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Product: ${discussion.fields.product} • Review By ${discussion.fields.user} • ${discussion.fields.date.toLocal()}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CreateDiscussionPage(
                                                  discussion: discussion,
                                                ),
                                              ),
                                            ).then((_) => refreshDiscussions());
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            final username = discussion.fields.user;
                                            final discussionId = discussion.pk;
                                            final request = Provider.of<CookieRequest>(context, listen: false);
                                            await deleteComment(request, username, discussionId);
                                          },
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommentPage(
                                            discussionID: discussion.pk,
                                            topic: discussion.fields.topic,
                                            comment: discussion.fields.comment ?? '', // Replace with a default if null
                                            product_id: discussion.pk, // Assuming `product` is the product_id
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } catch (e) {
                                print('Error rendering discussion at index $index: $e');
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateDiscussionPage(),
            ),
          ).then((_) => fetchDiscussions());
        },
        backgroundColor: const Color(0xFFD0B799),
        child: const Icon(Icons.add),
      ),
    );
  }
}