import 'User.dart';
import 'Product.dart';

class Favorite{
  int? id;
  User user;
  Product product;

  Favorite({
    this.id,
    required this.user,
    required this.product,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      user: User.fromJson(json['user']),
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user.toJson(),
    'product': product.toJson(),
  };


}
