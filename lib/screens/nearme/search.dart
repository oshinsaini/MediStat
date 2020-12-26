import 'package:dbapp/models/place.dart';
import 'package:dbapp/services/geolocatorservice.dart';
import 'package:dbapp/services/markerservice.dart';
import 'package:dbapp/services/placeservice.dart';
import 'package:dbapp/shared/drawer.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/shared/colors.dart';
import 'package:url_launcher/url_launcher.dart';

final myDrawer _drawer = new myDrawer();

class Search extends StatelessWidget {
  @override
  Widget build(context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final geoService = GeoLocatorService();
    final markerService = MarkerService();
    // final placesProvider = Provider.of<PlacesService>(context , listen:false ).getPlaces;

    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _drawer,
        body: (currentPosition != null)
            ? Consumer<List<Place>>(builder: (_, places, __) {
                var markers = (places != null)
                    ? markerService.getMarkers(places)
                    : List<Marker>();
                print("HELLO");
                // print(places.length);
                print(currentPosition.latitude);
                print(currentPosition.longitude);
                return (places != null)
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 8),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15.0, 42, 0, 0),
                              child: Row(children: [
                                IconButton(
                                    icon: Icon(Icons.menu),
                                    onPressed: () {
                                      _scaffoldKey.currentState.openDrawer();
                                    }),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                                  child: Text(
                                    "Near you",
                                    style: kTitleTextstyle,
                                  ),
                                )
                              ]),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                markers: Set<Marker>.of(markers),
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(currentPosition.latitude,
                                        currentPosition.longitude),
                                    zoom: 16.0),
                                zoomGesturesEnabled: true,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                              child: Text(
                                "Hospitals around you",
                                style: kTitleTextstyle,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                           
                          ],
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              })
            : Center(
                child: Loading(),
              ),
      ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch url';
    }
  }
}
