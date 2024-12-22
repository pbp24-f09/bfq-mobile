import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bfq/discussion/models/discussion.dart';
import 'package:bfq/discussion/screens/discussion_page.dart';
import 'package:bfq/main/services/api_service.dart';
import 'package:bfq/main/models/product.dart';

class CreateDiscussionPage extends StatefulWidget {
  final Discussion? discussion; // Add this parameter for editing mode
  const CreateDiscussionPage({Key? key, this.discussion}) : super(key: key);

  @override
  _CreateDiscussionState createState() => _CreateDiscussionState();
}

class _CreateDiscussionState extends State<CreateDiscussionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _topic = '';
  String _comment = '';
  String _selectedProduct = '';
  List<Product> _products = [];
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.discussion != null;

    // Initialize form fields if in edit mode
    if (isEditMode) {
      _topic = widget.discussion!.fields.topic;
      _comment = widget.discussion!.fields.comment;
      _selectedProduct = widget.discussion!.fields.product;
    }

    fetchProducts().then((products) {
      setState(() {
        _products = products;
        if (isEditMode) {
          // Find and set the selected product
          _selectedProduct = widget.discussion!.fields.product;
        }
      });
    });
  }

  Future<List<Product>> fetchProducts() async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/show_product_json/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Product> listItem = [];
    for (var d in data) {
      if (d != null) {
        listItem.add(Product.fromJson(d));
      }
    }
    return listItem;
  }

  Future<void> _handleSubmit(CookieRequest request) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final product = _products.firstWhere(
        (product) =>
            '${product.name} - ${product.restaurant}' == _selectedProduct,
      );

      final Map<String, dynamic> data = {
        "topic": _topic,
        "product_id": product.id,
        "comment": _comment,
      };

      final response = await request.postJson(
        isEditMode
            ? "http://127.0.0.1:8000/discussion/edit_discussion_flutter/${widget.discussion!.pk}/"
            : "http://127.0.0.1:8000/discussion/create_discussion_flutter/",
        jsonEncode(data),
      );

      if (response['success'] == true || response['status'] == 'success') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode
                    ? "Diskusi berhasil diperbarui!"
                    : "Diskusi berhasil dibuat!",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DiscussionPage(),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Terjadi kesalahan, coba lagi.",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Diskusi' : 'Buat Diskusi Baru',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[800], // Ganti warna biru menjadi hijau
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _topic,
                decoration: const InputDecoration(
                  labelText: 'Topik Diskusi',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                onSaved: (value) {
                  _topic = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Topik tidak boleh kosong';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white),
              ),
              DropdownButtonFormField<Product>(
                value: _selectedProduct.isEmpty
                    ? null
                    : _products.firstWhere(
                        (product) =>
                            '${product.name} - ${product.restaurant}' ==
                            _selectedProduct,
                        orElse: () => _products.firstWhere(
                          (product) =>
                              product.name ==
                              widget.discussion?.fields.product,
                          orElse: () => _products.first,
                        ),
                      ),
                isExpanded: true,
                onChanged: (Product? newValue) {
                  setState(() {
                    _selectedProduct =
                        '${newValue?.name} - ${newValue?.restaurant}';
                  });
                },
                items: _products.map<DropdownMenuItem<Product>>(
                  (Product product) {
                    return DropdownMenuItem<Product>(
                      value: product,
                      child: Text(
                        "${product.name} - ${product.restaurant}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ).toList(),
                selectedItemBuilder: (BuildContext context) {
                  return _products.map<Widget>((Product product) {
                    return Text(
                      "${product.name} - ${product.restaurant}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
                validator: (value) =>
                    value == null ? 'Pilih produk' : null,
                decoration: const InputDecoration(
                  labelText: 'Pilih Produk',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextFormField(
                initialValue: _comment,
                decoration: const InputDecoration(
                  labelText: 'Komentar Diskusi',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                onSaved: (value) {
                  _comment = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Komentar tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _handleSubmit(request),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[800], // Ganti warna tombol jadi hijau
                ),
                child: Text(
                  isEditMode ? "Simpan Perubahan" : "Buat Diskusi",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
