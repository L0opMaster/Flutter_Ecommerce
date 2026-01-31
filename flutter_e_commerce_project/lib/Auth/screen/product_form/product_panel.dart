import 'package:e_commerce/Auth/model/productdata.dart';
import 'package:e_commerce/Auth/screen/product_form/create_product.dart';
import 'package:e_commerce/Auth/screen/product_form/update_product.dart';
import 'package:e_commerce/Auth/service/product_service.dart';
import 'package:flutter/material.dart';

class ProductPanel extends StatefulWidget {
  final String adminEmail;
  const ProductPanel({super.key, required this.adminEmail});

  @override
  State<ProductPanel> createState() => _ProductPanelState();
}

class _ProductPanelState extends State<ProductPanel> {
  final ProductService productService = ProductService();

  late Future<List<Productdata>> productFuture;
  Productdata? selectedProduct;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      productFuture = productService.getAllProduct();
      selectedProduct = null;
    });
  }

  // 🔴 CONFIRM DELETE
  void _confirmDelete(Productdata product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete "${product.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await productService.deleteProduct(
                  product.id!,
                  widget.adminEmail,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted')),
                );
                _loadProducts();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Delete failed: $e')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Panel'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔵 ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CreateProduct(adminEmail: widget.adminEmail),
                      ),
                    );
                    _loadProducts();
                  },
                  child: const Text('Create'),
                ),
                ElevatedButton(
                  onPressed: selectedProduct == null
                      ? null
                      : () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UpdateProduct(
                                product: selectedProduct!,
                                adminEmail: widget.adminEmail,
                              ),
                            ),
                          );
                          _loadProducts();
                        },
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: selectedProduct == null
                      ? null
                      : () => _confirmDelete(selectedProduct!),
                  child: const Text('Delete'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<Productdata>>(
                future: productFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  final products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final isSelected = selectedProduct?.id == product.id;

                      return Card(
                        color: isSelected ? Colors.blue.shade50 : null,
                        child: ListTile(
                          leading: Image.network(
                            product.imageUrl,
                            width: 60,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                          title: Text(product.name),
                          subtitle: Text(
                              '\$${product.price} | Stock: ${product.stock}'),
                          onTap: () {
                            setState(() {
                              selectedProduct = product;
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
