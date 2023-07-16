abstract class ErrorListener {

  //definisce un contratto al fine di gestire gli errori di rete all'interno dell'applicazione

  void errorNetworkOccurred(String message);//chiamato quando si verifica un errore di rete
  void errorNetworkGone();//chiamato quando l'errore di rete viene risolto


}