import 'dart:convert';
import 'package:http/http.dart' as http;

String _key = "28eea8ec";

Future<Map> getAPI(String _search, int _movies) async{
  http.Response response;
  if(_search.isEmpty){
    response = await http.get(Uri.parse("http://www.omdbapi.com/?apikey=$_key&r=json"));
  }
  else{
    response = await http.get(Uri.parse("http://www.omdbapi.com/?apikey=$_key&s=$_search&page=$_movies&r=json"));
  }

  return json.decode(response.body);
}

Future<Map> searchById(String _id) async{
  print(_id);
  http.Response response;

  response = await http.get(Uri.parse("http://www.omdbapi.com/?apikey=$_key&i=$_id"));

  return json.decode(response.body);
}