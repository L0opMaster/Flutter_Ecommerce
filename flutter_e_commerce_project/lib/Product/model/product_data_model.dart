// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  int stock;
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      stock: stock ?? this.stock,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
      stock: map['stock'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, stock: $stock)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.price == price &&
      other.imageUrl == imageUrl &&
      other.stock == stock;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      price.hashCode ^
      imageUrl.hashCode ^
      stock.hashCode;
  }
}
// class Product {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final String imageUrl;
//   int stock;
//     Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.imageUrl,
//     required this.stock,
//   });
// }
