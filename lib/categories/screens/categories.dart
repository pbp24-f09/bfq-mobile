import 'package:flutter/material.dart';
import 'package:bfq/widgets/left_drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bfq/categories/models/product_cat.dart'; // Adjust the import path as necessary

class ProductService {
  // final String baseUrl;

  // ProductService(this.baseUrl);

  Future<List<ProductEntry>> fetchProductEntries() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/json/'));

    if (response.statusCode == 200) {
      return productEntryFromJson(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<ProductEntry>> _productEntries;

  @override
  void initState() {
    super.initState();
    final service = ProductService();
    _productEntries = service.fetchProductEntries();
  }

  void _showProductDetails(BuildContext context, ProductEntry product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Close button and title section
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Title
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 40, 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Text(
                        product.fields.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    // Close button
                    Positioned(
                      right: 8,
                      top: 8,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF8B4513),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Product Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: AspectRatio(
                      aspectRatio: 1.0, // Ensures 1:1 aspect ratio
                      child: product.fields.image.isNotEmpty
                          ? Image.network(
                              'http://127.0.0.1:8000/media/${product.fields.image}',
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                ),
                // Product Details
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                  child: Column(
                    children: [
                      // Price
                      Text(
                        "${product.fields.price} IDR",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B4332),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Details with smaller text and icons
                      _buildDetailRow(
                        Icons.restaurant,
                        'Restaurant',
                        product.fields.restaurant,
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        Icons.category,
                        'Categories',
                        catValues.reverse[product.fields.cat]!,
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        Icons.location_on,
                        'Location',
                        product.fields.location.toUpperCase(),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        Icons.phone,
                        'Contact',
                        product.fields.contact,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

    Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the row contents
      mainAxisSize: MainAxisSize.min, // Make row wrap its contents
      children: [
        Icon(
          icon,
          size: 16, // Smaller icon size
          color: const Color(0xFF666666),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12, // Smaller label text
                color: Color(0xFF999999),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13, // Smaller value text
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    String searchText = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search for Foods',
          style: TextStyle(color: Colors.white)
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<ProductEntry>>(
        future: _productEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            final products = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Enter food or restaurant",   // use "hintText" for placeholder
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),

                    onSubmitted: (value) async {
                      if (value.isNotEmpty){
                        final response = await http.post(
                          Uri.parse("http://127.0.0.1:8000/search-filter/"),
                          body: {'value': value},
                          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        );

                        if (response.statusCode == 200) {
                          // Successfully sent the query
                          print('Search query sent successfully: ${response.body}');
                        } else {
                          print('Failed to send query. Status code: ${response.statusCode}');
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Icon(
                          Icons.display_settings_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8)
                      ),
                      ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                        ),                      ),
                    ]
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    // shrinkWrap: true, // Add this
                    // physics: const NeverScrollableScrollPhysics(), // Add this
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () => _showProductDetails(context, product),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 220, // Set desired width
                                height: 220, // Set desired height
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: product.fields.image.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                'http://127.0.0.1:8000/media/${product.fields.image}'
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: product.fields.image.isEmpty
                                        ? const Icon(Icons.image_not_supported, size: 50, color: Colors.white)
                                        : null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      product.fields.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Rp ${product.fields.price}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                )
              ]
            );
               // return ListView.builder(
            //   itemCount: products.length,
            //   itemBuilder: (context, index) {
            //     final product = products[index];
            //     return Card(
            //       child: ListTile(
            //         leading: Image.network(
            //           'http://127.0.0.1:8000/media/${product.fields.image}',
            //           errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
            //           fit: BoxFit.cover,
            //           width: 50,
            //           height: 50,
            //         ),
            //         title: Text(product.fields.name),
            //         subtitle: Text(product.fields.restaurant),
            //       ),
            //     );
            //   },
            // );
          }
        },
      ),
    );
  }
}