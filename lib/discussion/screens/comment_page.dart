import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bfq/discussion/models/comment.dart';
import 'package:bfq/discussion/screens/create_comment_page.dart';
import 'package:bfq/discussion/models/discussion.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class CommentPage extends StatefulWidget {
  final int discussionID;
  final String topic;
  final String comment;
  final int product_id;

  const CommentPage({
    Key? key,
    required this.discussionID,
    required this.topic,
    required this.comment,
    required this.product_id,
  }) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentPage> {
  List<Comment> comments = [];
  late Discussion discussion;
  bool isProductLoaded = false;

  // Fetch comments for the specific discussion
  Future<void> fetchComments() async {
    var url = Uri.parse(
        'https://redundant-raychel-bfq-f4b73b50.koyeb.app/discussion/uniqueresponse/json/${widget.discussionID}/');

    var response = await http.get(url);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // Convert JSON data into a list of Comment objects
    setState(() {
      comments = List<Comment>.from(data.map((x) => Comment.fromJson(x)));
      isProductLoaded = true; // Set to true when data is loaded
    });
  }

  // Delete a specific comment
  Future<void> deleteComment(
      CookieRequest request, String username, int commentId) async {
    final response = await request.postJson(
        'https://redundant-raychel-bfq-f4b73b50.koyeb.app/discussion/delete_comments_flutter/$username/$commentId/',
        jsonEncode({}));

    if (response['status'] == 'success') {
      // Reload comments after deletion
      fetchComments();
    } else {
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchComments(); // Fetch comments when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Komentar Forum'),
        backgroundColor: Colors.green[900], // Change to green
        foregroundColor: Colors.white,
      ),
      body: !isProductLoaded
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.topic,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.comment,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      child: Text(
                        discussion.fields.topic,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 13, 154, 90)), // Change blue to green
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(discussion.fields.topic),
                              content: SingleChildScrollView(
                                child: Text(
                                  discussion.fields.comment,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: comments.isEmpty
                          ? const Text("Belum ada Komentar")
                          : ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                var comment = comments[index];
                                var date = DateFormat('yyyy-MM-dd')
                                    .format(comment.fields.date);
                                return Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(comment.fields.response),
                                    subtitle: Text(
                                        "Dikirim oleh: ${comment.fields.user} pada $date"),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        deleteComment(request,
                                            comment.fields.user, comment.pk);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCommentPage(
                discussionID: widget.discussionID,
                topic: widget.topic,
                comment: widget.comment,
                product_id: widget.product_id,
              ),
            ),
          );
        },
        tooltip: 'Tambah Komentar',
        backgroundColor: Colors.green[900], // Change to green
        mini: true,
        child: const Icon(Icons.add,
            color: Colors.white), // Mini button size
      ),
    );
  }
}
