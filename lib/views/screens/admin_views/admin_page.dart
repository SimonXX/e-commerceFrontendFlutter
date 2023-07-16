import 'package:flutter/material.dart';
import '../../../model/entities/Product.dart';
import '../../../model/model.dart';
import '../../../model/support/globals.dart';
import 'admin_add_product.dart';
import 'admin_all_users_order.dart';
import 'admin_product_card.dart';

class AdminAllProducts extends StatefulWidget {
  const AdminAllProducts({Key? key}) : super(key: key);

  @override
  State<AdminAllProducts> createState() => _AdminAllProductsState();
}

class _AdminAllProductsState extends State<AdminAllProducts> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminAddProductPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductList() {
    if (_products.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Numero di colonne desiderate
          crossAxisSpacing: 10, // Spazio orizzontale tra le colonne
          mainAxisSpacing: 10, // Spazio verticale tra le righe
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            height: 200,
            child: AdminProductCard(
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
