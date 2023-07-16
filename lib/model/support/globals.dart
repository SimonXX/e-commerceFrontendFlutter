import 'dart:convert';
import 'dart:io';//consente di interagire con il sistema operativo
import 'package:flutterapp/model/support/Constants.dart';
import 'package:http/http.dart' as http;
import '../entities/Favorite.dart';
import '../entities/ProductInPurchase.dart';
import '../entities/User.dart';
import 'keycloack/authentication_data.dart';


User currentUser = User.empty();
List<ProductInPurchase> productsInPurchase = [];
List<Favorite> favorites = [];

class Globals {
  static String username = '';
  static String clientSecret = '';




  static Future<String> setToken() async {




    String contentType="application/x-www-form-urlencoded";
    Map<String, String> headers = Map();
    headers[HttpHeaders.contentTypeHeader] = contentType;

    final Uri tokenEndpoint = Uri.parse(Constants.keycloack);

    Map<String, String> body = {
      'grant_type': "password",
      'client_id': Constants.client_id,
      'username': username,
      'password': clientSecret,
    };

    final response = await http.post(tokenEndpoint, headers: headers, body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      AuthenticationData authenticationData = AuthenticationData.fromJson(
          jsonResponse);

      AuthenticationData.instance =
          authenticationData; // Assegna l'istanza a AuthenticationData.instance


    }else{

    }

    return AuthenticationData.getInstance().getAccessToken();


  }

}