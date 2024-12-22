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
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                hintText: "Enter food or restaurant",
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(12),
                )
              ),
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white
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
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 20),
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
                  child: Text(
                    "Filter",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                ),
                const Spacer(),
                DropdownMenu(                   // Price sort dropdown
                  hintText: "Sort Price",
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: "Lowest",
                      label: "Lowest Price",
                    ),
                    DropdownMenuEntry(
                      value: "Highest",
                      label: "Highest Price",
                    ),
                  ], 
                  onSelected: (value) {
                    setState(() {
                      priceOrder = value;
                      _loadProducts(
                        query: _searchController.text,
                        range: selectedRange,
                        category: selectedCat,
                        order: priceOrder,
                      );
                    });
                  },
                  menuStyle: MenuStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )
                    ),
                  ),
                  textStyle: const TextStyle(
                    decorationColor: Colors.white,
                    color: Colors.white,
                  ),
                  
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    ),
                  ),
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
                  return const Center(child: Text(
                    'No products found.',
                    style: TextStyle(color: Colors.white),
                  ));
                } else {
                  final products = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.9, 
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
                                width: 125, 
                                height: 125, 
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: product.fields.image.isNotEmpty
                                      ? Image.network(
                                          'https://redundant-raychel-bfq-f4b73b50.koyeb.app/media/${product.fields.image}',
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10), // Space between image and text
                              // Ensuring consistent text area
                              SizedBox(
                                width: 120, // Match width with image
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
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
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
          title: Text(
            "Select your Preferences",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.error,
            )
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Select by Price Range
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 12, left: 5),
                      child: Text(
                        "By Price Range",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2A5E30),
                        )
                      ),
                    ),
                    _buildCheckBox("range", 0, setState),
                    _buildCheckBox("range", 1, setState),
                    _buildCheckBox("range", 2, setState),
                    _buildCheckBox("range", 3, setState),
                    // Select by Category
                    const Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 12, left: 5),
                      child: Text(
                        "By Category",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2A5E30),
                        )
                      ),
                    ),
                    _buildCheckBox("cat", 0, setState),
                    _buildCheckBox("cat", 1, setState),
                    _buildCheckBox("cat", 2, setState),
                    _buildCheckBox("cat", 3, setState),
                  ],
                )
              );
            }
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }, 
            ),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color(0xFF306836)
                ),
              ),
              child: Text(
                "Filterize",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
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
            ),
          ],
        );
      }
    );
  }

  Widget _buildCheckBox(String category, int index, StateSetter setState){
    if (category == "range"){
      return CheckboxListTile(
        value: rangeVal[index], 
        title: Text(rangeOptions[index]),
        onChanged: (value){
          setState(() {
            rangeVal[index] = value ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: const Color(0xFF2A5E30),
        contentPadding: const EdgeInsets.only(left: 0, right: 5),
      ); 
    }
    else {
      return CheckboxListTile(
        value: catVal[index], 
        title: Text(catOptions[index]),
        onChanged: (value){
          setState(() {
            catVal[index] = value ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: const Color(0xFF2A5E30),
        contentPadding: const EdgeInsets.only(left: 0, right: 5),
      );
    }
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
                                  'https://redundant-raychel-bfq-f4b73b50.koyeb.app/media/${product.fields.image}',
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