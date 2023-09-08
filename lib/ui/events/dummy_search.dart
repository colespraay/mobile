import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:spraay/components/themes.dart';

import '../../models/map_model.dart';

class DummyMapSearch extends StatefulWidget {
  const DummyMapSearch({super.key});

  @override
  State<DummyMapSearch> createState() => _DummyMapSearchState();
}

class _DummyMapSearchState extends State<DummyMapSearch> {

  PlaceApiProvider apiClient=PlaceApiProvider();
  String query="";
  TextEditingController _controller=TextEditingController();


  @override
  void initState() {
    // PlaceApiProvider().fetchSuggestions("Lekki, Lagos", "en"/*Localizations.localeOf(context).languageCode*/);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.sWhiteColor,
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          // shrinkWrap: true,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: _controller,
              // readOnly: true,
              onChanged: (value){
                query=value;
              },
              onTap: () async {
                // final Suggestion result = await showSearch(
                //   context: context,
                //   delegate: AddressSearch(sessionToken),
                // );
                // // This will change the text displayed in the TextField
                // if (result != null) {
                //   final placeDetails = await PlaceApiProvider(sessionToken)
                //       .getPlaceDetailFromId(result.placeId);
                //   setState(() {
                //     _controller.text = result.description;
                //     _streetNumber = placeDetails.streetNumber;
                //     _street = placeDetails.street;
                //     _city = placeDetails.city;
                //     _zipCode = placeDetails.zipCode;
                //   });
                // }
              },
              decoration: InputDecoration(
                icon: Container(
                  width: 10,
                  height: 10,
                  child: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                ),
                hintText: "Enter your shipping address",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
              ),
            ),



            Expanded(
              child: FutureBuilder(
                future: query == "" ? null : apiClient.fetchSuggestions(query, "en"/*Localizations.localeOf(context).languageCode*/),
                builder: (context, snapshot) => query == '' ? Container(padding: EdgeInsets.all(16.0), child: Text('Enter your address'),)
                    : snapshot.hasData
                    ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(title:
                    Text((snapshot.data?[index] as Suggestion).description),
                    onTap: () async{

                    var result=snapshot.data?[index] as Suggestion;

                      if (result != null) {
                        final placeDetails = await apiClient.getPlaceDetailFromId(result.placeId);
                        // setState(() {
                        //   _controller.text = result.description;
                        //   _streetNumber = placeDetails.streetNumber;
                        //   _street = placeDetails.street;
                        //   _city = placeDetails.city;
                        //   _zipCode = placeDetails.zipCode;
                        // });

                        getAddressCoordinates(result.description);

                        log("dscr=${result.description} streetnumber=${placeDetails.streetNumber} street=${ placeDetails.street} "
                            "city==${placeDetails.city} zipcode=${placeDetails.zipCode} ");

                      }
                    },
                  ),
                  itemCount: snapshot.data!.length,
                )
                    : Container(child: Text('Loading...')),
              ),
            ),


          ],
        ),
      ),
    );
  }

  String result = '';
  void getAddressCoordinates(String address) async {
    List<Location> locations = await locationFromAddress(address, localeIdentifier: "en");

    if (locations.isNotEmpty) {
      Location location = locations.first;
      setState(() {
        result = 'Latitude: ${location.latitude}, Longitude: ${location.longitude}';
      });

      log("latitude=${result}");
    } else {
      setState(() {
        result = 'Location not found';
      });
    }
  }

}
