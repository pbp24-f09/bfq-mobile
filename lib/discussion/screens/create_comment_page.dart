import 'package:flutter/material.dart';
import 'package:bfq/discussion/screens/comment_page.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CreateCommentPage extends StatefulWidget {
  final int discussionID;
  final String topic;
  final String comment;
  final int product_id;
  const CreateCommentPage({
    Key? key,
    required this.discussionID,
    required this.topic,
    required this.comment,
    required this.product_id,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateCommentPageState createState() => _CreateCommentPageState();
}

class _CreateCommentPageState extends State<CreateCommentPage> {
  final _formKey = GlobalKey<FormState>();
  String comment = '';

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Komentar',
          style: TextStyle(color: Colors.white), // Changed to white
        ),
        backgroundColor: Colors.green[900], // Green color
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Komentar",
                    labelText: "Komentar",
                    labelStyle: TextStyle(color: Colors.white), // Changed to white
                    hintStyle: TextStyle(color: Colors.white), // Changed to white
                  ),
                  onSaved: (String? value) {
                    comment = value!;
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Komentar tidak boleh kosong!";
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white), // Changed text color to white
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final response = await request.postJson(
                        "https://redundant-raychel-bfq-f4b73b50.koyeb.app/discussion/create_comments_flutter/${widget.discussionID}/",
                        jsonEncode({"comment": comment}),
                      );

                      // Periksa kode status HTTP dari respons
                      if (response['status'] == 'success') {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Komentar berhasil ditambahkan!",
                              style: TextStyle(color: Colors.white), // Changed to white
                            ),
                            backgroundColor: Colors.green, // Changed to green
                          ),
                        );
                        // Navigator.pop(context); // Kembali ke halaman sebelumnya
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentPage(
                                    discussionID: widget.discussionID,
                                    product_id: widget.product_id,
                                    comment: widget.comment,
                                    topic: widget.topic,
                                  )),
                        ); // Kembali ke halaman sebelumnya
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Terdapat kesalahan, silakan coba lagi.",
                              style: TextStyle(color: Colors.white), // Changed to white
                            ),
                            backgroundColor: Colors.green, // Changed to green
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[900], // Green color
                  ),
                  child: const Text(
                    "Kirim",
                    style: TextStyle(color: Colors.white), // Changed to white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
