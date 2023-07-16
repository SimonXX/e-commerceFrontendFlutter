import 'package:flutter/material.dart';
import 'package:flutterapp/model/entities/Favorite.dart';
import 'package:flutterapp/model/model.dart';

import '../../../model/support/globals.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<Favorite> _favorites = [];

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  void _getFavorites() {
    Model.sharedInstance.getFavorites(currentUser).then((favorites) {
      setState(() {
        _favorites = favorites as List<Favorite>;
      });
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch favorites. Please try again.'),
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
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wish List'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Numero di colonne desiderate
          crossAxisSpacing: 10, // Spazio orizzontale tra le colonne
          mainAxisSpacing: 10, // Spazio verticale tra le righe
        ),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final favorite = _favorites[index];
          return _buildFavoriteItem(favorite);
        },
      ),
    );
  }

  Widget _buildFavoriteItem(Favorite favorite) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              favorite.product.image ?? '',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              favorite.product.name ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _removeFavorite(favorite);
            },
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _removeFavorite(Favorite favorite) {
    Model.sharedInstance.deleteFavorite(favorite).then((result) {
      setState(() {
        _favorites.remove(favorite);
      });
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to remove favorite. Please try again.'),
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
    });
  }
}
