import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:spraay/env/env.dart';
import 'package:uuid/uuid.dart';

class Place {
  String ?streetNumber;
  String ?street;
  String ?city;
  String? zipCode;

  Place({this.streetNumber, this.street, this.city, this.zipCode});

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  // final client = Client();

  // PlaceApiProvider();

  final sessionToken = Uuid().v4();

  // final apiKey = Platform.isAndroid ? androidKey : iosKey;

  final String apiKey= Env.apiKey;
  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    //maps.googleapis.com/maps/api/place/autocomplete/json
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:ch&key=$apiKey&sessiontoken=$sessionToken';
    // final response = await client.get(Uri.parse(request));

    Uri uri=Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json",{"input": input,"key":apiKey});

    var response=await http.get(uri);

    // var response=await http.get(Uri.parse(request));


    if (response.statusCode == 200) {

      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
    var response=await http.get(Uri.parse(request));


    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
        result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();

        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}