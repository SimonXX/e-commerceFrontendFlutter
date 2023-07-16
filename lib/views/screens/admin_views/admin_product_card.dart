import 'package:flutter/material.dart';
import 'package:flutterapp/model/entities/ProductEdit.dart';
import 'package:flutterapp/model/model.dart';
import 'package:flutterapp/model/entities/Product.dart';
import 'package:flutterapp/views/screens/admin_views/admin_intermediate_page.dart';

import '../../../model/entities/Review.dart';

class AdminProductCard extends StatefulWidget {
  final Product product;

  const AdminProductCard({required this.product});

  @override
  _AdminProductCardState createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  List<Review> _productReviews = [];
  bool _isExpanded = false;

  void _getProductReviews() {
    Model.sharedInstance.getProductReviews(widget.product).then((reviews) {
      setState(() {
        _productReviews = reviews as List<Review>;
      });
    });
  }

  List<Widget> _buildReviewList() {
    return _productReviews.map((review) {
      return ListTile(
        title: Text(review.user.firstName as String),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rating: ${review.rating}'),
            Text(review.comment as String),
          ],
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name ?? '';
    _quantityController.text = widget.product.quantity.toString();
    _priceController.text = widget.product.price.toString();
    _imageController.text = widget.product.image ?? '';
    _getProductReviews();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _editProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final editedProduct = ProductEdit(
                  id: widget.product.id,
                  name: _nameController.text,
                  quantity: int.tryParse(_quantityController.text) ?? 0,
                  price: double.tryParse(_priceController.text) ?? 0.0,
                  image: _imageController.text,
                );
                Model.sharedInstance.editProduct(editedProduct);
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminIntermediatePage()),
                  );
                });

              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _editProduct(context);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.product.image ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barcode: ${widget.product.barCode ?? ''}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.product.name ?? '',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    widget.product.description ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Price: \$${widget.product.price ?? 0}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Quantity: ${widget.product.quantity ?? 0}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            if (_productReviews.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionPanelList(
                  elevation: 1,
                  expandedHeaderPadding: EdgeInsets.zero,
                  expansionCallback: (int index, bool isExpanded) {
                    _toggleExpansion();
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text('Reviews (${_productReviews.length})'),
                        );
                      },
                      body: Column(
                        children: _buildReviewList(),
                      ),
                      isExpanded: _isExpanded,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
