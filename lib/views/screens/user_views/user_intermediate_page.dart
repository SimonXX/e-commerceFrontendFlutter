import 'package:flutter/material.dart';
import 'package:flutterapp/views/screens/user_views/user_all_products.dart';
import 'package:flutterapp/views/screens/user_views/user_order_page.dart';
import 'package:flutterapp/views/screens/user_views/user_profile.dart';
import 'package:flutterapp/views/screens/user_views/user_wish_list.dart';
import 'package:intl/intl.dart';

import '../../../model/entities/Purchase.dart';
import '../../../model/model.dart';
import '../../../model/support/globals.dart';
import '../../../model/support/keycloack/authentication_data.dart';
import '../Search.dart';
import '../admin_views/admin_search.dart';
import '../login.dart';
import 'user_cart_page.dart';

class UserIntermediatePage extends StatefulWidget {
  @override
  _UserIntermediatePageState createState() => _UserIntermediatePageState();
}
class _UserIntermediatePageState extends State<UserIntermediatePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Customer Page'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.list), text: 'All Products'),
            Tab(icon: Icon(Icons.search), text: 'Search')
          ],
        ),
        actions: [
          ElevatedButton.icon(
            label: Text('Logout'),
          icon: Icon(Icons.logout),
          onPressed: () => _logout(), // Chiamata al metodo di logout
        ),
          ElevatedButton.icon(
            label: Text('Account Info'),
            icon: Icon(Icons.person),
            onPressed: () {
              // Naviga alla pagina con i dati dello user corrente
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
            },
          ),
          ElevatedButton.icon(
            label: Text('Order History'),
            icon: Icon(Icons.history),
            onPressed: () {
              // Naviga alla pagina con gli ordini effettuati dall'utente corrente
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserOrdersPage()));

            },


          ),
          ElevatedButton.icon(
            label: Text('Wish List'),
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Naviga alla pagina con gli ordini effettuati dall'utente corrente
              Navigator.push(context, MaterialPageRoute(builder: (context) => WishListPage()));

            },
          ),



          ElevatedButton.icon(
            onPressed: () => _navigateToCart(context),
            icon: Icon(Icons.shopping_cart),
            label: Text('Cart'),
          ),



        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UserAllProducts(),
          Search()
        ],
      ),
    );
  }




  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(cartItems: productsInPurchase)),
    );
  }


  void _logout() {
    // Resetta le variabili globali di autenticazione
    Globals.username = '';
    Globals.clientSecret = '';
    AuthenticationData.instance?.reset();

    // Naviga alla schermata di login principale
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }


}
