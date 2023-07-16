import 'dart:io';//consente di interagire con il sistema operativo
import 'dart:convert';//consente di codificare e decodificare i json

import 'package:http/http.dart';

import '../support/Constants.dart';
import '../support/ErrorListener.dart';
import '../support/keycloack/accessTokenRequest.dart';

enum TypeHeader {//definisce due tipi di intestazione per specificare il tipo di contenuto dei dati inviati nella richiesta HTTP
  json,
  urlencoded
}

//gestisce le richieste http verso un server remoto
class RestManager {
  late ErrorListener delegate;//ascoltatore di errori
  late String token;//token di autenticazione


  Future<String> _makeRequest(String serverAddress, String servicePath, String method, TypeHeader type, {Map<String, String>? value, dynamic body}) async {
    //esegue la richiesta HTTP

    //prende in input l'indirizzo del server, il percorso del servizio, il metodo http da utilizzare, il tipo di intestazione,
    // eventuali parametri di valore ed un payload


    print(value);
    //creiamo un uri usando l'indirizzo del server, il percorso del servizio ed i parametri di valore
    Uri uri = Uri.http(serverAddress, servicePath, value);

    print(uri.toString());
    bool errorOccurred = false;
    while ( true ) {
      try {
        var response;
        // setting content type
        String contentType="";
        dynamic formattedBody;

        //abbiamo 2 differenziazioni per il contentType
        //in base al tipo di intestazione abbiamo una formattazione come json o dati url codificati
        if ( type == TypeHeader.json ) {
          //quando comunichiamo con il nostro server Spring, il nostro content Type è un json
          contentType = "application/json;charset=utf-8";
          formattedBody = json.encode(body);//lo formattiamo in json
        }
        else if ( type == TypeHeader.urlencoded ) {
          //quando facciamo la richiesta a KeyCloak per l'autenticazione
          contentType = "application/x-www-form-urlencoded";
          formattedBody = body.keys.map((key) => "$key=${body[key]}").join("&");
        }


        //si impostano gli headers della richiesta
        // setting headers
        Map<String, String> headers = Map();
        headers[HttpHeaders.contentTypeHeader] = contentType;

        String token = (await AccessTokenRequest.getAccessToken())!;
        if ( token != null ) {
          //se disponibile, si imposta il token di autenticazione
          headers[HttpHeaders.authorizationHeader] = 'bearer $token';//se abbiamo il token, lo inseriamo all'interno dell'header
        }

        //in base al metodo fornito, si effettua una richiesta http
        // making request
        switch ( method ) {//facciamo la richiesta http
          case "post":
            response = await post(
              uri,
              headers: headers,
              body: formattedBody,
            );
            break;
          case "get":
            response = await get(
              uri,
              headers: headers,
            );

            break;
          case "put":
            response = await put(
              uri,
              headers: headers,
            );
            break;
          case "delete":
            response = await delete(
              uri,
              headers: headers,
            );
            break;
        }//arriverà la richiesta al server e riceveremo la risposta


        //gestisce enventuali errore e ritenta dopo un ritardo di 5 secondi
        //stiamo usando il pattern delegate
        // if ( delegate != null && errorOccurred ) {//una sorta di patten Observer
        //
        //   delegate.errorNetworkGone();//quando finisce l'errore di rete
        //   errorOccurred = false;
        // }

        return response.body;//se va tutto a buon fine, riceviamo il response


      } catch(err) {//se c'è un errore si arresta per 5 secondi e dopo riprova a fare la richiesta
        if ( delegate != null && !errorOccurred ) {
          delegate.errorNetworkOccurred(Constants.MESSAGE_CONNECTION_ERROR);//il RestManager non conosce la classe della grafica (siamo in un layer sottostante)
          //però possiamo tramite delegazione chiamare un metodo che è nell'interfaccia grafica, passando un messaggio
          errorOccurred = true;
        }
        await Future.delayed(const Duration(seconds: 5), () => null); // not the best solution
      }
    }
  }

  Future<String> makePostRequest(String serverAddress, String servicePath, dynamic value, {TypeHeader type = TypeHeader.json}) async {


    return _makeRequest(serverAddress, servicePath, "post", type, body: value);
  }

  Future<String> makeGetRequest(String serverAddress, String servicePath, Map<String, String>? value, {TypeHeader type = TypeHeader.json}) async {

    return _makeRequest(serverAddress, servicePath, "get", type, value: value);
  }

  Future<String> makePutRequest(String serverAddress, String servicePath, [Map<String, String>? value, TypeHeader? type]) async {
    return _makeRequest(serverAddress, servicePath, "put", type!, value: value);
  }

  Future<String> makeDeleteRequest(String serverAddress, String servicePath, Map<String, String>? value, {TypeHeader type = TypeHeader.json}) async {

    print(servicePath);
    return _makeRequest(serverAddress, servicePath, "delete", type, value: value);
  }
}
