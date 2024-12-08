// New ArticleDetailPage widget
import 'package:bfq/blog/models/blog_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF3EAD8),
      body: SingleChildScrollView( // Add SingleChildScrollView for long content
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Topic: ${article.topic}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'By: ${article.author}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Created at: ${DateFormat('yyyy-MM-dd HH:mm').format(article.time)}', 
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              article.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}