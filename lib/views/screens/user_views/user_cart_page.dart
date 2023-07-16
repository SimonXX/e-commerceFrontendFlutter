import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/entities/ProductInPurchase.dart';
import 'package:flutterapp/views/screens/user_views/user_cart_page.dart';
import 'package:flutterapp/views/screens/user_views/user_intermediate_page.dart';
import 'package:intl/intl.dart';

import '../../../model/entities/Purchase.dart';
import '../../../model/model.dart';
import '../../../model/support/globals.dart';

class CartPage extends StatefulWidget {

  final List<ProductInPurchase> cartItems;

  const CartPage({Key? key, required this.cartItems, }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          ElevatedButton.icon(

            onPressed: _buyAll,
            icon: Icon(Icons.confirmation_num),
            label: Text('Buy All'),
          ),

        ],
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final productInPurchase = widget.cartItems[index];

          return ListTile(
            leading: Image.network(
              productInPurchase.product?.image ?? '',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
            title: Text(productInPurchase.product?.name ?? ''),
            subtitle: Text('Quantity: ${productInPurchase.quantity}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Rimuovi l'elemento dal carrello
                _removeItemFromCart(widget.cartItems[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _removeItemFromCart(ProductInPurchase p) {
    widget.cartItems.remove(p);

    setState(() {

    });
  }

  void _buyAll(){


    if(productsInPurchase.isNotEmpty){

      DateTime now = DateTime.now();
      String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(now);
      print(formattedDate);

      Purchase p = Purchase(purchaseTime: now, buyer: currentUser, productsInPurchase: productsInPurchase);
      print(p.toJson());

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Order '),
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
      productsInPurchase = [];

      Model.sharedInstance.addPurchase(p).then((result) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserIntermediatePage()),
        );
      });
    }else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Insert at least one elemente into the cart'),
          content: Text('Order not success'),
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

  }


}
