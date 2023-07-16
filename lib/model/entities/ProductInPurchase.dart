import 'package:flutterapp/model/entities/Product.dart';
import 'package:flutterapp/model/entities/Purchase.dart';

class ProductInPurchase{
  int? id;

  int? quantity;
  Product? product;

  ProductInPurchase({

    this.quantity,
    this.product
});

  factory ProductInPurchase.fromJson(Map<String, dynamic> json){
    return ProductInPurchase(

      quantity: json['quantity'],
      product: Product.fromJson(json['product'])
    );
  }

  Map<String, dynamic> toJson()=>{

    'quantity': quantity,
    'product': product?.toJson()
  };

  @override
  String toString(){
    return  quantity.toString() + " " + product.toString();
  }
}