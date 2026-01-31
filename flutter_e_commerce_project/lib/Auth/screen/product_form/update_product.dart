import 'package:flutter/material.dart';
import 'package:e_commerce/Auth/model/productdata.dart';
import 'package:e_commerce/Auth/service/product_service.dart';

class UpdateProduct extends StatefulWidget {
  final Productdata product;
  final String adminEmail;

  const UpdateProduct({
    super.key,
    required this.product,
    required this.adminEmail,
  });

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final _formKey = GlobalKey<FormState>();
  final ProductService productService = ProductService();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController imageController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    descriptionController =
        TextEditingController(text: widget.product.description);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    stockController =
        TextEditingController(text: widget.product.stock.toString());
    imageController = TextEditingController(text: widget.product.imageUrl);
  }

  Future<void> updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final updated = Productdata(
        id: widget.product.id,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.parse(priceController.text),
        imageUrl: imageController.text.trim(),
        stock: int.parse(stockController.text),
      );

      final result = await productService.updateProduct(
        widget.product.id!,
        updated,
        widget.adminEmail,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );

      Navigator.pop(context, result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (v) =>
                    double.tryParse(v!) == null ? 'Invalid price' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
                validator: (v) =>
                    int.tryParse(v!) == null ? 'Invalid stock' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: updateProduct,
                      child: const Text('Update Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
