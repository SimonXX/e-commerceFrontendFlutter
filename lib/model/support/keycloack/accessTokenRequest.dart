import 'dart:convert';

import 'package:http/http.dart' as http;

class AccessTokenRequest {
  static Future<String?> getAccessToken() async {
    String grantType = "client_credentials";
    String clientId = "demo-api-client";
    String clientSecret = "rXIDCs7qAdJrNoAUIQP1cwjpLogHkqe1";
    String tokenUrl = "http://localhost:8080/realms/SIMONE/protocol/openid-connect/token";

    print(clientSecret);

    Map<String, String> requestBody = {
      "grant_type": grantType,
      "client_id": clientId,
      "client_secret": clientSecret,
    };

    final response = await http.post(Uri.parse(tokenUrl), body: requestBody);

    print(response.toString());
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse["access_token"];
    } else {
      print("Error response code: ${response.statusCode}");
      return null;
    }
  }
}
