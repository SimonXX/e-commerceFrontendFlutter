class User {
  int? id;
  String? firstName;
  String? lastName;
  String? telephoneNumber;
  String? email;
  String? address;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.telephoneNumber,
    this.email,
    this.address,
  });

  User.empty(); // Costruttore vuoto


  //metodo factory di conversione da Json e User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      telephoneNumber: json['telephoneNumber'],
      email: json['email'],
      address: json['address'],
    );
  }

  //conversione da User a Json
  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'telephoneNumber': telephoneNumber,
    'email': email,
    'address': address,
  };

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, telephoneNumber: $telephoneNumber, email: $email, address: $address}';
  }

//stampa dell'utente



}