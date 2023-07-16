class AuthenticationData {

  static AuthenticationData? instance; // Variabile statica per l'istanza globale
  //utilizzo del pattern singleton

  String accessToken;
  String refreshToken;
  int expiresIn;

  AuthenticationData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  // Restituisce l'istanza globale di AuthenticationData
  static AuthenticationData getInstance() {
    if (instance == null) {
      throw Exception('AuthenticationData non è stata ancora inizializzata');
    }
    return instance!;
  }


  factory AuthenticationData.fromJson(Map<String, dynamic> json) {
    return AuthenticationData(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
    );
  }



  void setAccessToken(String token) {
    accessToken = token;
  }

  void setRefreshToken(String token) {
    refreshToken = token;
  }


  void setExpiresIn(int seconds) {
    expiresIn = seconds;
  }

  String getAccessToken() {
    return accessToken;
  }

  String getRefreshToken() {
    return refreshToken;
  }


  int getExpiresIn() {
    return expiresIn;
  }

  void reset() {
    accessToken = '';
    refreshToken = '';
    expiresIn = 0;
  }
}