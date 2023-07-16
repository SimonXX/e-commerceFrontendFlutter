import 'package:flutter/material.dart';
import '../../../model/support/globals.dart';
import '../../../model/support/keycloack/authentication_data.dart';
import '../login.dart';
import 'admin_all_users_order.dart';
import 'admin_all_users_registered.dart';
import 'admin_page.dart';
import 'admin_search.dart';



class AdminIntermediatePage extends StatefulWidget {
  @override
  _AdminIntermediatePageState createState() => _AdminIntermediatePageState();
}
class _AdminIntermediatePageState extends State<AdminIntermediatePage> with SingleTickerProviderStateMixin {
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
        title: Text('Admin Page'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.list), text: 'All Products'),
            Tab(icon: Icon(Icons.search), text: 'Search')
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context), // Chiamata al metodo di logout
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Naviga alla pagina con i dati dello user corrente
             Navigator.push(context, MaterialPageRoute(builder: (context) => AllUsersRegistered()));
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Naviga alla pagina con gli ordini effettuati dall'utente corrente
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUsersOrderPage()));
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AdminAllProducts(),
          AdminSearch()
        ],
      ),
    );
  }


  void _logout(BuildContext context) {
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
