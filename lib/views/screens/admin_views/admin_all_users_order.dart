import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/entities/Purchase.dart';
import 'package:flutterapp/model/model.dart';
import 'package:flutterapp/model/support/globals.dart';
import 'package:intl/intl.dart';

class AdminUsersOrderPage extends StatefulWidget {
  @override
  _AdminUsersOrderPageState createState() => _AdminUsersOrderPageState();
}

class _AdminUsersOrderPageState extends State<AdminUsersOrderPage> {
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
        title: Text('All Users Orders'),
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
      return ListView.builder(
        itemCount: _userOrders.length,
        itemBuilder: (context, index) {
          final purchase = _userOrders[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User: ${purchase.buyer?.email ?? ''}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Purchase Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${DateFormat('yyyy-MM-dd HH:mm:ss').format(purchase.purchaseTime!)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${purchase.productsInPurchase?.length ?? 0}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: purchase.productsInPurchase?.map((productInPurchase) {
                      final product = productInPurchase.product;
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Image.network(
                                product?.image ?? '',
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Product Name: ${product?.name}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Quantity: ${productInPurchase.quantity}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList() ?? [],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _fetchUserOrders() {
    Model.sharedInstance.getAllUsersOrders().then((result) {

      print(result.toString());
      setState(() {
        _userOrders = result;
      });
    });
  }
}
