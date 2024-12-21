class Product {
  final String id;
  final String name;
  final int price;
  final String restaurant;
  final String location;
  final String contact;
  final String category;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.restaurant,
    required this.location,
    required this.contact,
    required this.category,
    required this.imageUrl,
  });

  /// Factory constructor to parse JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'];
    const String mediaBaseUrl = 'https://redundant-raychel-bfq-f4b73b50.koyeb.app/media/'; // Base URL for media files
    return Product(
      id: json['pk'].toString(),
      name: fields['name'],
      price: fields['price'],
      restaurant: fields['restaurant'],
      location: fields['location'],
      contact: fields['contact'],
      category: fields['cat'],
      imageUrl: mediaBaseUrl + fields['image'], // Construct full image URL
    );
  }

  /// Convert Product to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      "model": "main.product",
      "pk": id,
      "fields": {
        "name": name,
        "price": price,
        "restaurant": restaurant,
        "location": location,
        "contact": contact,
        "cat": category,
        "image": imageUrl.replaceFirst('https://redundant-raychel-bfq-f4b73b50.koyeb.app/media/', ''), // Convert back to relative path
      },
    };
  }
}
