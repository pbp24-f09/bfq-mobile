import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu_admin.dart';

class ProductEditPage extends StatefulWidget {
  final String productId; // UUID sebagai string

  const ProductEditPage({super.key, required this.productId});

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _price = 0;
  String _restaurant = "";
  String _location = "";
  String _contact = "";
  String _category = "";
  Uint8List? _imageData;
  XFile? _pickedFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  // Fetch product details
  Future<void> _fetchProductDetails() async {
    var uri = Uri.parse("http://127.0.0.1:8000/product-json/${widget.productId}/");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final product = data[0]['fields'];
          setState(() {
            _name = product['name'];
            _price = product['price'];
            _restaurant = product['restaurant'];
            _location = product['location'];
            _contact = product['contact'];
            _category = product['cat'];
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch product details.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Function to Pick an Image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes();
      setState(() {
        _pickedFile = pickedFile;
        _imageData = imageData;
      });
    }
  }

  // Function to Submit Form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var uri = Uri.parse("http://127.0.0.1:8000/edit-flutter/${widget.productId}");
      var request = http.MultipartRequest('POST', uri);

      // Add form fields
      request.fields['name'] = _name;
      request.fields['price'] = _price.toString();
      request.fields['restaurant'] = _restaurant;
      request.fields['location'] = _location;
      request.fields['contact'] = _contact;
      request.fields['cat'] = _category;

      // Add image file if updated
      if (_pickedFile != null) {
        final imageBytes = await _pickedFile!.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: _pickedFile!.name,
          ),
        );
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product successfully updated!")),
          );
          // Redirect to MenuAdminPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuAdminPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update product.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Edit Product'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    hintText: "Product Name",
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              // Price Field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _price.toString(),
                  decoration: InputDecoration(
                    hintText: "Price",
                    labelText: "Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _price = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Price cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Price must be a valid number!";
                    }
                    return null;
                  },
                ),
              ),
              // Restaurant Field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Restaurant",
                    labelText: "Restaurant",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _restaurant = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Restaurant cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              // Location Field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Location",
                    labelText: "Location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _location = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Location cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              // Contact Field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contact",
                    labelText: "Contact",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _contact = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Contact cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              // Category Field with Dropdown
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Category",
                    labelText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _category.isEmpty ? null : _category, // Initial value
                  items: [
                    'Makanan Berat dan Nasi',
                    'Olahan Ayam dan Daging',
                    'Mie, Pasta, dan Spaghetti',
                    'Makanan Ringan dan Cemilan',
                  ].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Category cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),

              // Image Picker Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Select New Image (Optional)"),
                ),
              ),

              // Display Selected Image
              if (_imageData != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.memory(
                    _imageData!,
                    height: 150,
                  ),
                ),

              // Submit Button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white),
                    ),
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
