import 'package:e_commerce/Product/CardService/card_service.dart';
import 'package:e_commerce/Product/cartproduct/ConfirmCheckOut/confirm_checkout.dart';
import 'package:e_commerce/Product/model/cart_items.dart';
// import 'package:e_commerce/product/model/product_data_model.dart';
import '../Image/ticketimage.dart';
import 'package:flutter/material.dart';

class CartProduct extends StatefulWidget {
  const CartProduct({super.key});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: _cartService.cartNotifier,
        builder: (context, cartItems, child) {
          if(cartItems.isEmpty){
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.grey,
                    size: 100,
                  ),
                  Text(
                    'Your Cart is Empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ValueListenableBuilder<List <CartItems>>(
                  valueListenable: _cartService.cartNotifier,
                  builder: (context, cartItems, child) {
                    return ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        // final product = cartItems[index];
                        // final int productId = int.tryParse(product['id'].toString()) ?? -1;
                        // final quantity = _cartService.getQuantity(productId);
                        return _buildItemProduct(cartItems[index]);
                      },
                    );
                  }
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: const Color(0xFF353534).withOpacity(0.39),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total :',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$ ${_cartService.totalCost.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => const ConfirmCheckout(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildItemProduct(CartItems cartItems) {
    final product = cartItems.product;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 7.0, right: 7.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 254, 245),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: const Color(0xFF353534).withOpacity(0.39),
              offset: const Offset(0, 0),
              blurRadius: 8,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Ticketimage(
              scr: product.imageUrl,
              height: 80,
              boxFit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$ ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // setState(() {
                //   _cartService.decrease(int.tryParse(product['id'].toString()) ?? -1);
                // });
                _cartService.updateQuantity(cartItems.product.id!, cartItems.quantity - 1);
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('${cartItems.quantity}'),
            IconButton(
              onPressed: () {
                _cartService.updateQuantity(cartItems.product.id!, cartItems.quantity + 1);
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
