import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutterapp/model/entities/Favorite.dart';
import 'package:flutterapp/model/entities/Product.dart';
import 'package:flutterapp/model/entities/ProductEdit.dart';
import 'package:flutterapp/model/entities/Purchase.dart';
import 'package:flutterapp/model/entities/Review.dart';
import 'package:flutterapp/model/support/Constants.dart';

import 'entities/User.dart';
import 'managers/RestManager.dart';

class Model{

  static Model sharedInstance = Model();//rappresenta istanza condivisa della classe Model

  RestManager _restManager = RestManager();


  Future<void> deleteFavorite(Favorite f) async {

    String id = f.id.toString();


    await _restManager.makeDeleteRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_DELETE_FAVORITE + "/" + id, null);

  }

  Future<Product?> editProduct(ProductEdit p) async{

    String id = p.id.toString();

    await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_UPDATE_PRODUCT + "/" + id, p);

  }


  Future<List<Favorite?>> getFavorites(User u) async{

    List<Favorite> favorites = [];

    final response = json.decode(await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_GET_WISHLIST, u));

    for(var json in response){
      Favorite f = Favorite.fromJson(json);

      favorites.add(f);

    }

    return favorites;
  }


  Future<List<Review?>> getProductReviews(Product p) async{

    List<Review> reviews = [];

    final response = json.decode(await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_GET_PRODUCT_REVIEWS, p));

    for(var json in response){
      Review r = Review.fromJson(json);

      reviews.add(r);
    }

    return reviews;

  }



  Future<List<Purchase>> getAllUsersOrders() async{

    List<Purchase> purchases = [];

    final response = json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ALL_USERS_ORDERS, null));

    for(var json in response){
      Purchase p = Purchase.fromJson(json);

      purchases.add(p);
      print(p.toString());

    }




    return purchases;

  }

  Future<List<User>> getAllUsers() async{

    List<User> users = [];

    final response = json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ALL_USERS_REGISTERED, null));

    for(var json in response){
      User u = User.fromJson(json);
      users.add(u);
    }

    return users;

  }

  Future<List<Purchase>> getUserOrders(User u) async{

    List<Purchase> purchases = [];

    final response = json.decode(await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_USER_ORDERS, u));

    for(var json in response){
      print(json);
      Purchase p = Purchase.fromJson(json);

      purchases.add(p);

    }


    print(purchases);

    return purchases;

  }



  Future<Favorite?> addFavorite(Favorite favorite) async{

    String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_FAVORITE, favorite);

    return Favorite.fromJson(jsonDecode(rawResult));

  }

  Future<Review?> addReview(Review r) async{


    String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_PRODUCT_REVIEW, r);


      return Review.fromJson(jsonDecode(rawResult));

  }

  Future<Product?> addProduct(Product p) async{


    try{

    String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_PRODUCT, p);


    if ( rawResult.contains(Constants.RESPONSE_ERROR_BARCODE_ALREADY_EXISTS) ) {
      return null; // not the best solution
    }
    else {
      return Product.fromJson(jsonDecode(rawResult));
    }
  }
  catch (e) {
    return null; // not the best solution
  }


  }

  //per aggiungere un nuovo utente nel server
  Future<User?> addUser(User user) async {
    try {

      String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_USER, user);


      if ( rawResult.contains(Constants.RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS) ) {
        return null; // not the best solution
      }
      else {
        return User.fromJson(jsonDecode(rawResult));
      }
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<Purchase?> addPurchase(Purchase p) async{
    try{
      String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_PURCHASE, p);



    } catch (e) {
      return null; // not the best solution
    }
  }



  Future<List<Product>?> searchProduct(String name) async{

    Map<String, String> params = Map();
    params["name"] = name;


    try{

      final response = json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_PRODUCTS, params));
      //print(response);


      List<Product> products = [];

      for(var json in response){
        Product p = Product.fromJson(json);
        products.add(p);
      }

      print(products);

      //List<Product> prodotti = List<Product>.from(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_PRODUCTS, params)).map((i) => Product.fromJson(i)).toList());


      //print(prodotti.toString());
      return products;


    }catch(e){
      return null;
    }

  }

  Future<User?> getUserByEmail(String email) async{

    print('--------');
    Map<String, String> params = Map();
    params["email"] = email;

    try{
      final response = json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_USER , params));

      User u = User.fromJson(response);
      print('utente ottenuto: $u');

      return u;

    }catch(e){
      return null;
    }

  }


  Future<List<Product>?> getAllProducts() async{

    Map<String, String> params = Map();
    params["name"] = "";


    try{

      final response = json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_PRODUCTS, params));
      //print(response);


      List<Product> products = [];

      for(var json in response){
        Product p = Product.fromJson(json);
        products.add(p);
      }

      print(products);

      //List<Product> prodotti = List<Product>.from(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_PRODUCTS, params)).map((i) => Product.fromJson(i)).toList());


      //print(prodotti.toString());
      return products;


    }catch(e){
      return null;
    }

  }

}