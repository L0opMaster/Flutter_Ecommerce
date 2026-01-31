// import 'dart:convert';
import 'package:e_commerce/Auth/model/productdata.dart';
import 'package:e_commerce/Auth/screen/auth_login_signout.dart/auth_screen.dart';
import 'package:e_commerce/Auth/service/product_service.dart';
import 'package:e_commerce/Product/CardService/card_service.dart';
import 'package:e_commerce/Product/Home_Screen/CardProduct/cardproduct.dart';
import 'package:e_commerce/Product/cartproduct/cartproduct.dart';
// import 'package:e_commerce/product/model/cart_items.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Function to fetch product data
  late Future<List<Productdata>> _productsFuture;
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();

  @override
  void initState() {
    _loadProducts();
    super.initState();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = _productService.getAllProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('E-Commerce'),
        actions: [
          Row(
            children: [
              _buildcartIcon(context),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AuthScreen()));
                  },
                  icon: Icon(Icons.exit_to_app_sharp)),
            ],
          )
        ],
      ),
      body: FutureBuilder<List>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }
          // List products = snapshot.data!.take(10).toList();
          List products = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                // final product = products[index]; // This is a Product object
                return CardProduct(productaa: products[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildcartIcon(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: _cartService.notifier,
        builder: (context, cartItems, child) {
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                _cartService.clearbadge();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartProduct()),
                );
              },
              icon: cartItems > 0
                  ? Stack(
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          size: 30,
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              // width: 40,
                              // height: 40,
                              padding: EdgeInsets.only(left: 2, right: 2),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12)),
                              constraints: BoxConstraints(
                                minHeight: 16,
                                minWidth: 16,
                              ),
                              child: Text(
                                '$cartItems',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ],
                    )
                  : Icon(Icons.shopping_cart),
            ),
          );
        });
  }
}
