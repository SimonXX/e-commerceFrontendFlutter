import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/model/entities/Favorite.dart';
import 'package:flutterapp/model/entities/Product.dart';
import 'package:flutterapp/model/entities/ProductInPurchase.dart';
import 'package:flutterapp/model/entities/Review.dart';
import 'package:flutterapp/model/entities/User.dart';
import 'package:flutterapp/model/model.dart';
import 'package:flutterapp/model/support/globals.dart';

class UserProductCard extends StatefulWidget {
  final Product product;

  const UserProductCard({required this.product});

  @override
  _UserProductCardState createState() => _UserProductCardState();
}

class _UserProductCardState extends State<UserProductCard> {
  int _selectedQuantity = 1;
  bool get isProductAvailable => widget.product.quantity! > 0;
  TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;
  List<Review> _productReviews = [];

  @override
  void initState() {
    super.initState();
    _getProductReviews();
  }

  void _getProductReviews() {
    Model.sharedInstance.getProductReviews(widget.product).then((reviews) {
      setState(() {
        _productReviews = reviews as List<Review>;
      });
    });
  }

  void _addReview() {
    String comment = _commentController.text.trim();

    if (comment.isNotEmpty) {
      Review review = Review(
        comment: comment,
        rating: _rating.toInt(),
        user: currentUser,
        product: widget.product,
      );

      Model.sharedInstance.addReview(review).then((result) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Review Added'),
            content: Text('Your review has been added.'),
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
        // Refresh the product reviews
        _getProductReviews();
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add review. Please try again.'),
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Missing Comment'),
          content: Text('Please enter a comment before adding a review.'),
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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: InkWell(
          onTap: () {
            _showImageDialog();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.product.image ?? '',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
        ),
        title: Text(
          widget.product.name ?? '',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Barcode: ${widget.product.barCode ?? ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              'Price: € ${widget.product.price ?? ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              'Quantity: ${widget.product.quantity ?? ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: _decreaseQuantity,
              ),
              Text('$_selectedQuantity'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _increaseQuantity,
              ),
              ElevatedButton(
                onPressed: isProductAvailable ? _buyProduct : null,
                child: Text('Add Product to Cart'),
              ),
              ElevatedButton(
                onPressed: _addToFavorite,
                child: Text('Add To Wishlist'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Comment',
              hintText: 'Enter your comment',
            ),
          ),
          SizedBox(height: 16.0),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 24.0,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          ElevatedButton(
            onPressed: _addReview,
            child: Text('Add Review'),
          ),
          if (_productReviews.isNotEmpty) ..._buildReviewList(),
        ],
      ),
    );
  }

  void _addToFavorite() {
    Favorite favorite = Favorite(user: currentUser, product: widget.product);

    Model.sharedInstance.addFavorite(favorite).then((result) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Added'),
          content: Text('Product added to Wish List'),
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
      // Refresh the product reviews
      _getProductReviews();
    });
  }

  void _increaseQuantity() {
    setState(() {
      _selectedQuantity++;
    });
  }

  void _decreaseQuantity() {
    if (_selectedQuantity > 1) {
      setState(() {
        _selectedQuantity--;
      });
    }
  }

  void _buyProduct() {
    if (widget.product.quantity! >= _selectedQuantity) {
      print('Product ${widget.product.name} bought with quantity $_selectedQuantity');

      ProductInPurchase pip = ProductInPurchase(
        quantity: _selectedQuantity,
        product: widget.product,
      );
      print(pip.toJson());

      productsInPurchase.add(pip);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Product selected'),
          content: Text('Product added to cart'),
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Quantity not available'),
          content: Text('Product not added to cart'),
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

  List<Widget> _buildReviewList() {
    return _productReviews.map((review) {
      return ListTile(
        title: Text(review.user.firstName as String),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rating: ${review.rating}'),
            Text(review.comment as String),
          ],
        ),
      );
    }).toList();
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Image.network(
              widget.product.image ?? '',
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
