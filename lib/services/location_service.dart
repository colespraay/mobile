import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService{
  final String key="AIzaSyDludqPHQ7KP_4I0Rpj4xzVcG9vsS-YgPs";

  Future<String> getPlaceId(String inputSearch)async{
    final String url="https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$inputSearch&inputtype=textquery&key=$key";

    var response=await http.get(Uri.parse(url));
    var jsonnn=convert.jsonDecode(response.body);

    var placeId=jsonnn['candidates'][0]['place_id'] as String;
    return placeId;
  }

  //get the place detail
  Future<Map<String, dynamic>> getPlace(String input)async{
    final placeId=await getPlaceId(input);
    final String url="https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";

    var response=await http.get(Uri.parse(url));
    var jsonnn=convert.jsonDecode(response.body);
    var result=jsonnn['result'] as Map<String, dynamic>;

    print("result==$result  jsonnn==${jsonnn}");
    return result;
  }


  //Auto complete for google map
void placeAuthComplete(String query)async{
   Uri uri=Uri.https("maps.googleapis.com",
   "maps/api/place/autocomplete/json",{
     "input": query, //query param
         "key":key
       });

   String? response=await fetchUrl(uri);
   if(response !=null){
     print(response);
   }

}

  Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers})async{

    try{
    final response=await http.get(uri, headers: headers);
    if(response.statusCode==200){
      return response.body;
    }

    } catch (e){
      debugPrint(e.toString());
    }
    return null;

  }


}