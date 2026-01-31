// confirm_checkout.dart
import 'package:e_commerce/Product/checkout/checkoutscreen.dart';
import 'package:flutter/material.dart';

class ConfirmCheckout extends StatelessWidget {
  const ConfirmCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm Checkout',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Are you sure you want to proceed with your purchase?'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Confirm'),
                  onPressed: () {
                    // Handle confirmation here
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => CheckOutScreen())
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

