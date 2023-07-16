import 'package:flutter/material.dart';
import '../../../model/entities/Product.dart';
import '../../../model/model.dart';
import '../../../model/support/globals.dart';
import 'user_product_card.dart';

class UserAllProducts extends StatefulWidget {
  const UserAllProducts({Key? key}) : super(key: key);

  @override
  State<UserAllProducts> createState() => _UserAllProductsState();
}

class _UserAllProductsState extends State<UserAllProducts> {
  late List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
    print('Accesso effettuato da utente corrente: $currentUser');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildProductList(),
    );
  }

  Widget _buildProductList() {
    if (_products.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: UserProductCard(
              product: _products[index],
            ),
          );
        },
      );
    }
  }

  void _fetchAllProducts() {
    Model.sharedInstance.getAllProducts().then((result) {
      setState(() {
        _products = result!;
      });
    });
  }
}
