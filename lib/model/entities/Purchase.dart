import 'package:flutterapp/model/entities/ProductInPurchase.dart';
import 'package:flutterapp/model/support/extension.dart';
import 'package:intl/intl.dart';

import 'User.dart';

class Purchase{
  int? id;
  DateTime? purchaseTime;
  User? buyer;
  List<ProductInPurchase>? productsInPurchase;

  Purchase({
    this.purchaseTime,
    this.buyer,
    this.productsInPurchase

});

  factory Purchase.fromJson(Map<String, dynamic> json){


    List<ProductInPurchase> productList = (json['productsInPurchase'] as List<dynamic>)
        .map((json) => ProductInPurchase.fromJson(json))
        .toList();
    
    String timestamp=json['purchaseTime'].toString();

    return Purchase(
      purchaseTime: DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)),
      buyer: User.fromJson(json['buyer']),

      productsInPurchase:  productList
    );
  }

  Map<String, dynamic> toJson() =>{


    'purchaseTime': DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(purchaseTime!).toString(),
    'buyer': buyer?.toJson(),
    'productsInPurchase': listToJson(productsInPurchase!)
  };

  @override
  String toString(){
    return purchaseTime.toString() + " " + buyer.toString() + " " + productsInPurchase.toString();
  }
}