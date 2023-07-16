import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/model/entities/User.dart';
import 'package:flutterapp/views/screens/Search.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'admin_views/admin_intermediate_page.dart';
import 'login.dart';
import 'user_views/user_intermediate_page.dart';
import '../../model/model.dart';
import '../../model/support/Constants.dart';
import '../../model/support/globals.dart';
import '../../model/support/keycloack/authentication_data.dart';


class KeycloakLoginScreen extends StatefulWidget {
  final String username;
  final String clientSecret;

  KeycloakLoginScreen({required this.username, required this.clientSecret});

  @override
  _KeycloakLoginScreenState createState() => _KeycloakLoginScreenState();
}

class _KeycloakLoginScreenState extends State<KeycloakLoginScreen> {
  String? accessToken;
  String? userRole;
  bool isLoading = true;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    login();
    startTimer();
  }

  void startTimer() {
    timer = Timer(Duration(seconds: 3), () {
      if (isLoading) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Invalid Credentials'),
            content: Text('The login credentials are not valid.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> login() async {
    Globals.username = widget.username;
    Globals.clientSecret = widget.clientSecret;

    accessToken = await Globals.setToken();

    setState(() {
      final decodedToken = JwtDecoder.decode(accessToken!);
      userRole = decodedToken['resource_access'][Constants.client_id]['roles'][0]; // Assumendo che il ruolo sia il primo nella lista dei ruoli
      print('Ruolo: $userRole');
      isLoading = false;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Torna alla pagina di login quando viene premuto il pulsante Indietro

        Globals.username = '';
        Globals.clientSecret = '';
        AuthenticationData.instance?.reset();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        return false; // Imposta il valore su "false" per evitare che venga eseguito il comportamento predefinito
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Keycloak Login'),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : accessToken != null
              ? FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Gestisci l'errore in modo appropriato
                return Text('Error: ${snapshot.error}');
              } else {
                if (userRole == 'client_admin') {
                  _fetchCurrentUser();
                  _navigateToPage(context, 'client_admin');
                } else if (userRole == 'client_user') {
                  _fetchCurrentUser();
                  _navigateToPage(context, 'client_user');
                }

                return CircularProgressIndicator();
              }
            },
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _fetchCurrentUser() {
    Model.sharedInstance.getUserByEmail(Globals.username).then((result) {
      currentUser = result!;
    });
  }

  void _navigateToPage(BuildContext context, String role) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Effettua la navigazione alla nuova pagina
      if (role == 'client_admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminIntermediatePage()),
        );
      } else if (role == 'client_user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserIntermediatePage()),
        );
      } else {
        // Ruolo sconosciuto, gestisci il caso in modo appropriato
      }
    });
  }
}
