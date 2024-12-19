import 'package:flutter/material.dart';
import 'package:bfq/widgets/left_drawer.dart';
import 'package:bfq/categories/models/product_cat.dart'; // Adjust the import path as necessary
import 'package:bfq/categories/screens/categories_admin.dart';

class CategoriesCustomerPage extends StatefulWidget {
  const CategoriesCustomerPage({super.key});

  @override
  State<CategoriesCustomerPage> createState() => _CategoriesCustomerPageState();
}

class _CategoriesCustomerPageState extends State<CategoriesCustomerPage> {
  late Future<List<ProductEntry>> _productEntries;
  final ProductService _service = ProductService();
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedRange = [];
  List<String> selectedCat = [];
  String? priceOrder;

  @override
  void initState() {
    super.initState();
    _loadProducts();    // Load product di awal
  }

  void _loadProducts({String? query, List<String>? range, List<String>? category, String? order}) {
    setState(() {
      _productEntries = _service.fetchProductEntries(
        query: query, 
        range: range, 
        category: category,
        order: order,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search for Foods',
          style: TextStyle(color: Colors.white)
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(                            // Searchbar
              controller: _searchController,
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

              onSubmitted: (value)  {
                // Fetch filtered products based on the search query
                _loadProducts(
                  query: value.isNotEmpty ? value : null,
                  range: selectedRange, 
                  category: selectedCat,
                  order: priceOrder,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(                   // Filter button
                  onPressed: () {
                    showFilterForm(context);
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
                DropdownButton(                   // Price sort dropdown
                  value: priceOrder,
                  hint: const Text("Sort Price"),
                  items: const [
                    DropdownMenuItem(
                      value: "Lowest",
                      child: Text("Lowest Price"),
                    ),
                    DropdownMenuItem(
                      value: "Highest",
                      child: Text("Highest Price"),
                    ),
                  ], 
                  onChanged: (value) {
                    setState(() {
                      priceOrder = value;
                      _loadProducts(
                        query: _searchController.text,
                        range: selectedRange,
                        category: selectedCat,
                        order: priceOrder,
                      );
                    });
                  }
                ),
              ]
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ProductEntry>>(
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
                  return GridView.builder(
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
                  );
                }
              }
            )
          )
        ],
      )
    );
  }

  final List<String> rangeOptions = ["Less than 50.000", "50.000 - 100.000", "100.000 - 150.000", "More than 150.000"];
  final List<String> catOptions = ["Makanan Berat dan Nasi", "Olahan Ayam dan Daging", "Mie, Pasta, dan Spaghetti", "Makanan Ringan dan Cemilan"];

  List<bool> rangeVal = [false, false, false, false];
  List<bool> catVal = [false, false, false, false];

  void showFilterForm(BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text("What Types Are You Searching For?"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15)
                    ),
                    const Text("By Price Range"),               // Select by Price Range
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8)
                    ),
                    CheckboxListTile(                             // Testing checkboxes
                      value: rangeVal[0], 
                      title: Text(rangeOptions[0]),
                      onChanged: (value){
                        setState(() {
                          rangeVal[0] = value ?? false;
                        });
                      }
                    ),
                    CheckboxListTile(
                      value: rangeVal[1], 
                      title: Text(rangeOptions[1]),
                      onChanged: (value){
                        setState(() {
                          rangeVal[1] = value ?? false;
                        });
                      }
                    ),
                    CheckboxListTile(
                      value: rangeVal[2], 
                      title: Text(rangeOptions[2]),
                      onChanged: (value){
                        setState(() {
                          rangeVal[2] = value ?? false;
                        });
                      }
                    ),
                    CheckboxListTile(
                      value: rangeVal[3], 
                      title: Text(rangeOptions[3]),
                      onChanged: (value){
                        setState(() {
                          rangeVal[3] = value ?? false;
                        });
                      }
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15)
                    ),
                    const Text("By Category"),                     // Select by Category
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8)
                    ),
                    CheckboxListTile(
                      value: catVal[0], 
                      title: Text(catOptions[0]),
                      onChanged: (value){
                        setState(() {
                          catVal[0] = value ?? false;
                        });
                      }
                    ),
                    CheckboxListTile(
                      value: catVal[1], 
                      title: Text(catOptions[1]),
                      onChanged: (value){
                        setState(() {
                          catVal[1] = value ?? false;
                        });
                      }
                    ),
                    CheckboxListTile(
                      value: catVal[2], 
                      title: Text(catOptions[2]),
                      onChanged: (value){
                        setState(() {
                          catVal[2] = value ?? false;
                        });
                      }
                    ),
                    CheckboxListTile(
                      value: catVal[3], 
                      title: Text(catOptions[3]),
                      onChanged: (value){
                        setState(() {
                          catVal[3] = value ?? false;
                        });
                      }
                    ),
                  ],
                )
              );
            }
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                selectedRange.clear();
                selectedCat.clear();

                for (int i = 0; i < rangeOptions.length; i++){
                  if (rangeVal[i] == true){
                    selectedRange.add(rangeOptions[i]);
                  }
                  
                  if (catVal[i] == true){
                    selectedCat.add(catOptions[i]);
                  }
                }

                _loadProducts(
                  query: _searchController.text,
                  range: selectedRange,
                  category: selectedCat,
                  order: priceOrder,
                );
              }, 
              child: const Text("Filterize"),
            ),
          ],
        );
      }
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
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
                            product.fields.cat,
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
              ],
            )
          ),
        );
      },
    );
  }
}