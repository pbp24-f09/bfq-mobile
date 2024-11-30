import 'package:flutter/material.dart';
import 'package:bfq/widgets/left_drawer.dart';

class CategoriesPage extends StatefulWidget {
    const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      drawer: const LeftDrawer(),
      // body: 
    );
  }
}