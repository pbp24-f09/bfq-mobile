// To parse this JSON data, do
//
//     final productEntry = productEntryFromJson(jsonString);

import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
    Model model;
    String pk;
    Fields fields;

    ProductEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    dynamic user;
    String name;
    int price;
    String restaurant;
    String location;
    String contact;
    String cat;
    String image;

    Fields({
        required this.user,
        required this.name,
        required this.price,
        required this.restaurant,
        required this.location,
        required this.contact,
        required this.cat,
        required this.image,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        name: json["name"],
        price: json["price"],
        restaurant: json["restaurant"],
        location: json["location"],
        contact: json["contact"],
        cat: json["cat"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
        "price": price,
        "restaurant": restaurant,
        "location": location,
        "contact": contact,
        "cat": cat,
        "image": image,
    };
}

enum Model {
    MAIN_PRODUCT
}

final modelValues = EnumValues({
    "main.product": Model.MAIN_PRODUCT
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
