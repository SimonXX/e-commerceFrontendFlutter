import 'dart:convert';

List<dynamic> listToJson(List<dynamic> list) {
  return list.map((item) => item.toJson()).toList();
}

List<dynamic>? jsonListToList(List<dynamic>? jsonList, Function(Map<String, dynamic>) fromJson) {
  if (jsonList == null) {
    return null;
  }
  return jsonList.map((json) => fromJson(json)).toList();
}