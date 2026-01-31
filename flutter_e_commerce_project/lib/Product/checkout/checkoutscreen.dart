import 'package:e_commerce/Product/CardService/card_service.dart';
import 'package:e_commerce/Product/Home_Screen/home_screen.dart';
import 'package:flutter/material.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Checkout Successful'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: ListView(
          children: [
            _buildThankYouSection(),
            _buildOrderSummary(),
            _backToHomeScreen(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYouSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.check_circle_outline_outlined,
          color: Colors.green,
          size: 100,
        ),
        SizedBox(height: 20),
        Text(
          'Thank You for Your Order!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          'Your purchase has been confirmed. A summary of your order is below.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, color: Colors.grey),
        ),
      ],
    );
  }

Widget _buildOrderSummary() {
  final cartItems = _cartService.cartNotifier.value;

  double totalPrice = 0;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.34),
            offset: const Offset(0, 0),
            blurRadius: 13,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1, height: 2, color: Colors.grey),
            const SizedBox(height: 15),

            // List all cart products dynamically
            ...cartItems.map((item) {
              final quantity = item.quantity;
              final price = item.product.price;
              final itemTotal = price * quantity;
              totalPrice += itemTotal;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product.name} (x$quantity)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('\$${itemTotal.toStringAsFixed(2)}'),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 10),
            const Divider(thickness: 1, height: 2, color: Colors.grey),
            const SizedBox(height: 15),

            // Total price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}


  ElevatedButton _backToHomeScreen(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // _cartService.clearCart(); // Clear the cart after checkout
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Text(
          'Back to Store',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
