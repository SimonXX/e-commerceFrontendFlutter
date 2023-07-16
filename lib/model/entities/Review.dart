import 'Product.dart';
import 'User.dart';

class Review {
  int? id;
  String? comment;
  int? rating;
  User user;
  Product? product;

  Review({
    this.id,
    this.comment,
    this.rating,
    required this.user,
    this.product,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      comment: json['comment'],
      rating: json['rating'],
      user: User.fromJson(json['user']),
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'rating': rating,
      'user': user.toJson(),
      'product': product?.toJson(),
    };
  }
}



