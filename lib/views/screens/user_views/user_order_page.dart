import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/entities/Purchase.dart';
import 'package:flutterapp/model/model.dart';
import 'package:flutterapp/model/support/globals.dart';
import 'package:intl/intl.dart';

class UserOrdersPage extends StatefulWidget {
  @override
  _UserOrdersPageState createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  List<Purchase> _userOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Orders'),
      ),
      body: _buildOrderGrid(),
    );
  }

  Widget _buildOrderGrid() {
    if (_userOrders.isEmpty) {
      return Center(
        child: Text(
          'No orders available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Numero di colonne desiderate
          crossAxisSpacing: 16, // Spazio orizzontale tra le colonne
          mainAxisSpacing: 16, // Spazio verticale tra le righe
        ),
        itemCount: _userOrders.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Purchase Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${DateFormat('yyyy-MM-dd HH:mm:ss').format(_userOrders[index].purchaseTime!)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${_userOrders[index].productsInPurchase?.length ?? 0}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Numero di colonne desiderate
                      crossAxisSpacing: 8, // Spazio orizzontale tra le colonne
                      mainAxisSpacing: 8, // Spazio verticale tra le righe
                    ),
                    itemCount: _userOrders[index].productsInPurchase?.length ?? 0,
                    itemBuilder: (context, productIndex) {
                      final product = _userOrders[index].productsInPurchase![productIndex].product;
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: Image.network(
                                  product?.image ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Product Name: ${product?.name}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Quantity: ${_userOrders[index].productsInPurchase![productIndex].quantity}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _fetchUserOrders() {
    Model.sharedInstance.getUserOrders(currentUser).then((result) {
      _userOrders.sort((a, b) => b.purchaseTime!.compareTo(a.purchaseTime!));

      setState(() {
        _userOrders = result;
      });
    });
  }
}
