import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/entities/User.dart';
import '../../model/model.dart';
import '../../model/support/keycloack/accessTokenRequest.dart';
import '../../model/support/keycloack/keycloakUserCreation.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {


  bool _adding = false;
  late User? _justAddedUser;


  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  late String accessToken;



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Torna alla pagina di login quando viene premuto il pulsante Indietro
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        return false; // Imposta il valore su "false" per evitare che venga eseguito il comportamento predefinito
      }, // update here
      child: Scaffold(
          appBar: AppBar(
            title: Text('Registration'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),

                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'phone'),

                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),

                SizedBox(height: 16.0),
                ElevatedButton(

                  onPressed: () async {
                    final String firstName=firstNameController.text;
                    final String lastName=lastNameController.text;
                    final String password=passwordController.text;
                    final String username=emailController.text;

                    _register();


                    accessToken = (await AccessTokenRequest.getAccessToken())!;
                    print(accessToken.toString());
                    if (accessToken != null) {
                      KeycloakUserCreation kuc = KeycloakUserCreation(firstName: firstName, lastName: lastName, password: password, username: username);

                      bool success = await kuc.createUserInKeycloak(accessToken);

                      if (success) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Success'),
                              content: Text('User created successfully.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Reindirizza alla pagina di login
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                    );
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Email already used/Fill all fields '),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Failed to obtain access token'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
    )
    ;
  }

  void _register() {

    User user = User(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      telephoneNumber: phoneController.text,
      email: emailController.text,
      address: addressController.text,
    );
    Model.sharedInstance.addUser(user);
  }

}
