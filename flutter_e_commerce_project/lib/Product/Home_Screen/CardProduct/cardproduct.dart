import 'package:e_commerce/Auth/model/productdata.dart';
import 'package:e_commerce/Product/Home_Screen/CardProduct/view_Information/view_infor_pru.dart';
import 'package:e_commerce/Product/Image/ticketimage.dart';
// import 'package:e_commerce/product/cartproduct/cartproduct.dart';
import 'package:e_commerce/Product/CardService/card_service.dart';
import 'package:flutter/material.dart';

class CardProduct extends StatelessWidget {
  final Productdata productaa;


  const 
  CardProduct({
    super.key,
    required this.productaa,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InformationProduct(hee: productaa,)),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Ticketimage(
                  scr: productaa.imageUrl,
                  // width: 100,
                  // height: 100,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productaa.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$ ${productaa.price}',
                    style: const TextStyle(color: Colors.teal),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: ElevatedButton.icon(
                onPressed: productaa.stock > 0 ? () {
                  // ✅ Add product to cart using CartService
                  // CartService().addToCart(productaa);
                  final cartService = CartService();
                  cartService.addProduct(productaa);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${productaa.name} added to cart'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }: null,
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
    );
  }
}
