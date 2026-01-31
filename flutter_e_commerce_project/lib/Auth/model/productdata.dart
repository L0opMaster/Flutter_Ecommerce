// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Productdata {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  int stock;
  Productdata({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });

  Productdata copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? stock,
  }) {
    return Productdata(
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
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
    };
  }

  factory Productdata.fromMap(Map<String, dynamic> map) {
    return Productdata(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
      stock: map['stock'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Productdata.fromJson(String source) =>
      Productdata.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Productdata(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, stock: $stock)';
  }

  @override
  bool operator ==(covariant Productdata other) {
    if (identical(this, other)) return true;

    return other.id == id &&
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
