import 'dart:ui';

class Constants {

  //rappresenta indirizzo del server
  static final String ADDRESS_STORE_SERVER = "localhost:8081";

  //richieste al server
  static final String REQUEST_ADD_USER = "/users";//percorso per effettuare richiesta di aggiunta di un utente
  static final String REQUEST_SEARCH_PRODUCTS="/products/search/by_name";
  static final String REQUEST_PRODUCTS="/products";
  static final String REQUEST_SEARCH_USER="/users/search";
  static final String REQUEST_ADD_PURCHASE="/purchases";
  static final String REQUEST_USER_ORDERS="/purchases/user";
  static final String REQUEST_ALL_USERS_ORDERS="/purchases";
  static final String REQUEST_ALL_USERS_REGISTERED="/users";
  static final String REQUEST_ADD_PRODUCT="/products";
  static final String REQUEST_GET_PRODUCT_REVIEWS="reviews/view/product";
  static final String REQUEST_ADD_PRODUCT_REVIEW="/reviews";
  static final String REQUEST_ADD_FAVORITE="/favorites";
  static final String REQUEST_GET_WISHLIST="/favorites/view/favorite";
  static final String REQUEST_DELETE_FAVORITE="/favorites/favorite";
  static final String REQUEST_UPDATE_PRODUCT="/products/edit";


  // states
  static final String STATE_CLUB = "club";//rappresenta lo stato del club

  // responses
  static final String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "ERROR_MAIL_USER_ALREADY_EXISTS";//rappresenta messaggio di errore che indica
  //che un utente con stessa mail esiste

  static final String  RESPONSE_ERROR_BARCODE_ALREADY_EXISTS = "ERROR_BARCODE_ALREADY_EXISTS";

  // messages
  static final String MESSAGE_CONNECTION_ERROR = "connection_error";//messaggio di errore relativo ad un problema di connessione



  static final keycloack = "http://localhost:8080/realms/SIMONE/protocol/openid-connect/token";
  static final String client_id = 'simone-rest-api';



}

const Color APP_COLOR = Color(0xff5b3bfe);

// ignore: constant_identifier_names
const int PAGE_LIMIT = 10;

enum SortTypes {
  // ignore: constant_identifier_names
  ASC,
  // ignore: constant_identifier_names
  DESC,
}

enum GetTypes {
  // ignore: constant_identifier_names
  FILTER,
  // ignore: constant_identifier_names
  PAGING,
}