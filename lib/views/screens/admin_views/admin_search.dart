import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/entities/Product.dart';
import '../../../model/model.dart';
import '../../../model/widgets/InputField.dart';
import '../user_views/user_product_card.dart';
import 'admin_product_card.dart';


class AdminSearch extends StatefulWidget {
  const AdminSearch({Key? key}) : super(key: key);

  @override
  State<AdminSearch> createState() => _State();
}

class _State extends State<AdminSearch> {

  bool _searching = false;
  late List<Product> _products = List.empty();

  TextEditingController _searchFiledController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              children: [
                top(),
                bottom()
              ],
            )
        )
    );
  }

  Widget top() {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          children: [
            Flexible(
              child: InputField(
                  labelText: "search",
                  textAlign: TextAlign.center,
                  controller: _searchFiledController,
                  onSubmit: (value) {
                    _search();
                  }
              ),
            )
          ],
        )
    );
  }

  Widget bottom(){
    return !_searching?
    _products == null?
    SizedBox.shrink():
    _products.length == 0 ?
    noResults():
    yesResults():
    CircularProgressIndicator();

  }

  Widget noResults(){
    return Text("no result");
  }

  Widget yesResults() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Numero di colonne desiderate
          crossAxisSpacing: 10, // Spazio orizzontale tra le colonne
          mainAxisSpacing: 10, // Spazio verticale tra le righe
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return AdminProductCard(
            product: _products[index],
          );
        },
      ),
    );
  }


  void _search() {
    setState(() {
      _searching = true;
    });

    Model.sharedInstance.searchProduct(_searchFiledController.text).then((result) {//prendiamo il testo dal controller e lo mandiamo al server

      //poiché rileva che è asincrona, lo stacca del thread principale
      //successivamente eseguirà il codice specificato in then
      setState(() {
        _searching = false;
        _products = result!;
      });
    });
  }



}



