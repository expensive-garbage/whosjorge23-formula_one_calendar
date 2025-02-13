import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:formula_one_calendar/viewmodels/race_viewmodel.dart';
import 'package:latlong2/latlong.dart';

import '../models/race_data.dart';

class RaceDetailsView extends StatefulWidget {
  final Race race;

  RaceDetailsView({required this.race});

  @override
  _RaceDetailsViewState createState() => _RaceDetailsViewState();
}

class _RaceDetailsViewState extends State<RaceDetailsView> {
  late LatLng _initialCameraPosition;
  MapController mapController = MapController();
  RaceListViewModel viewModel = RaceListViewModel();

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = LatLng(
      double.parse(widget.race.circuit.location.lat),
      double.parse(widget.race.circuit.location.long),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.race.raceName),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 300,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(_initialCameraPosition!.latitude, _initialCameraPosition!.longitude),
                  zoom: 13.0,
                ),
                children: [
                  TileLayer(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  // "https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg",
                  subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(_initialCameraPosition!.latitude, _initialCameraPosition!.longitude),
                        builder: (context) => Icon(Icons.location_on),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text('Date: ${viewModel.formatDate(widget.race.date)}'),
            Text('Time: ${viewModel.formatTimeInGMT(widget.race.time)}'),
            Text('Circuit: ${widget.race.circuit.circuitName}'),
            Text(
                'Location: ${widget.race.circuit.location.locality}, ${widget.race.circuit.location.country} ${viewModel.countryFlag(widget.race.circuit.location.country)}'),
            Container(color: Colors.black12,child: Center(child: Image.network('${viewModel.circuitPic(widget.race.circuit.circuitName)}',scale: 1.5,))),
          ],
        ),
      ),
    );
  }
}

// Rest of the code...
