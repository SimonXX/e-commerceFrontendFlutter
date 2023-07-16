import 'package:flutter/material.dart';
import 'package:flutterapp/views/screens/admin_views/admin_intermediate_page.dart';
import '../../../model/entities/Product.dart';
import '../../../model/model.dart';
import '../../../model/support/globals.dart';
import 'admin_page.dart';

class AdminAddProductPage extends StatefulWidget {
  @override
  _AdminAddProductPageState createState() => _AdminAddProductPageState();
}

class _AdminAddProductPageState extends State<AdminAddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _barCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _barCodeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _barCodeController,
                decoration: InputDecoration(labelText: 'Barcode'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a barcode';
                  }
                  if (!_isNumeric(value)) {
                    return 'Invalid barcode';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (!_isPriceValid(value)) {
                    return 'Invalid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (!_isNumeric(value)) {
                    return 'Invalid quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newProduct = Product(
                      barCode: _barCodeController.text,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      image: _imageController.text,
                      price: double.parse(_priceController.text),
                      quantity: int.parse(_quantityController.text),
                    );
                    _addProduct(newProduct);
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProduct(Product product) {
    Model.sharedInstance.addProduct(product).then((success) {
      if (success != null) {
        Navigator.pushReplacement( // Naviga alla pagina AdminAllProducts e la sostituisce nello stack
          context,
          MaterialPageRoute(builder: (context) => AdminIntermediatePage()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add product. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }


  bool _isNumeric(String value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  bool _isPriceValid(String value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final regex = RegExp(r'^\d+(\.\d+)?$');
    return regex.hasMatch(value);
  }
}
