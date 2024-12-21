// blog_form_page.dart

import 'dart:convert';

import 'package:bfq/blog/models/blog_entry.dart';
import 'package:bfq/blog/screens/blog_list.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BlogFormPage extends StatefulWidget {
  final Article? article;

  const BlogFormPage({super.key, this.article});

  @override
  State<BlogFormPage> createState() => _BlogFormPageState();
}

class _BlogFormPageState extends State<BlogFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _topic;
  late String _content;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.article != null;
    _title = widget.article?.title ?? "";
    _topic = widget.article?.topic ?? "";
    _content = widget.article?.content ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Article' : 'Create New Article'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Title",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                  ),
                ),
                TextFormField(
                  initialValue: _title, // Set initial value
                  decoration: InputDecoration(
                    hintText: "Enter article title",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() {
                    _title = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Title cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Topic Field
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Topic",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                  ),
                ),
                TextFormField(
                  initialValue: _topic, // Set initial value
                  decoration: InputDecoration(
                    hintText: "Enter article topic",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() {
                    _topic = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Topic cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Content Field
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Content",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                  ),
                ),
                TextFormField(
                  initialValue: _content, // Set initial value
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Enter article content",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() {
                    _content = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Content cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Save/Update Button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 30.0,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_isEditing) {
                          // Edit existing article
                          final response = await request.postJson(
                            "https://redundant-raychel-bfq-f4b73b50.koyeb.app/blog/edit-article-flutter/${widget.article!.id}/",
                            jsonEncode(<String, String>{
                              'title': _title,
                              'topic': _topic,
                              'content': _content,
                            }),
                          );
                          if (context.mounted) {
                            if (response['success'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Article updated successfully'),
                                ),
                              );
                              Navigator.pop(context); // Go back to the previous page
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message'] ??
                                      'Failed to update article'),
                                ),
                              );
                            }
                          }
                        } else {
                          // Create new article
                          final response = await request.postJson(
                            "https://redundant-raychel-bfq-f4b73b50.koyeb.app/blog/create-article-flutter/",
                            jsonEncode(<String, String>{
                              'title': _title,
                              'topic': _topic,
                              'content': _content,
                            }),
                          );
                          if (context.mounted) {
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Article created successfully"),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlogListPage(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "An error occurred, please try again."),
                                ),
                              );
                            }
                          }
                        }
                      }
                    },
                    child: Text(
                      _isEditing ? 'Update' : 'Save',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF2A3A30),
    );
  }
}