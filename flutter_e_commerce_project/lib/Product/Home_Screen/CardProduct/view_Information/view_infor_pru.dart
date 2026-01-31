import 'package:e_commerce/Auth/model/productdata.dart';
import 'package:e_commerce/Product/Image/ticketimage.dart';
import 'package:e_commerce/Product/cartproduct/cartproduct.dart';
import 'package:e_commerce/Product/model/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/Product/CardService/card_service.dart';

class InformationProduct extends StatefulWidget {
  final Productdata hee;

  const InformationProduct({
    super.key,
    required this.hee,
  });

  @override
  State<InformationProduct> createState() => _InformationProductState();
}

// final CartService _cartService = CartService();
// final List<int> cart = [1];
@override
// void initState() {
//   initState();
//   // Initialize quantities (if not already)
//   for (var id in cart) {
//     if (_cartService.getQuantity(id) == 0) {
//       _cartService.setQuantity(id, 1);
//     }
//   }
// }
class _InformationProductState extends State<InformationProduct> {
  final CartService _cartService = CartService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
        // automaticallyImplyLeading: false,
        actions: [_buildcartIcon(context)],
      ),
      // List products = snapshot.data!.take(1).toList();
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                clipBehavior: Clip.hardEdge,
                child: Ticketimage(
                  scr: widget.hee.imageUrl,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.hee.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${widget.hee.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Available to add: 7 (Total stock: ${widget.hee.stock})',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.green.shade700),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: Divider(thickness: 1, height: 1),
                  ),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.hee.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Quantity:',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          final item =
                              _cartService.cartNotifier.value.firstWhere(
                            (e) => e.product.id == widget.hee.id,
                          );
                          if (item.quantity > 0) {
                            _cartService.updateQuantity(
                                item.product.id!, item.quantity - 1);
                          }
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.grey,
                        ),
                      ),

                      ValueListenableBuilder<List<CartItems>>(
                        valueListenable: _cartService.cartNotifier,
                        builder: (context, cartItems, _) {
                          final item = cartItems.firstWhere(
                            (e) => e.product.id == widget.hee.id,
                            orElse: () =>
                                CartItems(product: widget.hee, quantity: 0),
                          );
                          return Text('${item.quantity}',
                              style: TextStyle(fontSize: 20));
                        },
                      ),
                      // Text(
                      //   '${_cartService.getQuantity(1)}',
                      //   style: TextStyle(fontSize: 25),
                      // ),
                      IconButton(
                        onPressed: () {
                          final item =
                              _cartService.cartNotifier.value.firstWhere(
                            (e) => e.product.id == widget.hee.id,
                          );
                          if (item.quantity > 0) {
                            _cartService.updateQuantity(
                                item.product.id!, item.quantity + 1);
                          }
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: ElevatedButton.icon(
                      onPressed: widget.hee.stock > 0
                          ? () {
                              // ✅ Add product to cart using CartService
                              // CartService().addToCart(productaa);
                              final cartService = CartService();
                              cartService.addProduct(widget.hee);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('${widget.hee.name} added to cart'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(
                        Icons.shopping_cart_checkout,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text('Add To Cart'),
                      style: ElevatedButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
