import 'package:e_commerce/Auth/model/productdata.dart';
import 'package:e_commerce/Auth/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/Auth/service/auth_service.dart';

class CreateProduct extends StatefulWidget {
  final String adminEmail;

  const CreateProduct({super.key, required this.adminEmail});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final _formKey = GlobalKey<FormState>();
  final ProductService productService = ProductService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  bool isLoading = false;

  Future<void> createProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final product = Productdata(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.parse(priceController.text),
        imageUrl: imageController.text.trim(),
        stock: int.parse(stockController.text),
      );

      final createdProduct = await productService.createProduct(
        product,
        widget.adminEmail,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product created successfully')),
      );

      Navigator.pop(context, createdProduct);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create product: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                enableInteractiveSelection: true,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter product name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Enter valid price'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid stock'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        isLoading ? null : createProduct();
                      },
                      child: const Text('Create Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
