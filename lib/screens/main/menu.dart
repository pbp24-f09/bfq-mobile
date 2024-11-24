import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '/models/product.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.fetchProducts();
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
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
                        product.name,
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
                    child: SizedBox(
                      width: double.infinity,
                      height: 240, // Increased height
                      child: product.imageUrl.isNotEmpty
                        ? Image.network(
                            product.imageUrl,
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
                        "${product.price} IDR",
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
                        product.restaurant,
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        Icons.category,
                        'Categories',
                        product.category,
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        Icons.location_on,
                        'Location',
                        product.location.toUpperCase(),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        Icons.phone,
                        'Contact',
                        product.contact,
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

  // Rest of the code remains the same
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4332),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome to BFQ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Discover our delicious menu',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Products Grid
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products available.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final products = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () => _showProductDetails(context, product),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    image: product.imageUrl.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(product.imageUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  ),
                                  child: product.imageUrl.isEmpty
                                    ? const Icon(Icons.image_not_supported, size: 50)
                                    : null,
                                ),
                              ),
                              // Product Info
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Rp ${product.price}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}