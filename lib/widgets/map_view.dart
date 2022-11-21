import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMapView extends StatefulWidget {
  const CustomMapView(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  final double latitude;
  final double longitude;

  @override
  State<CustomMapView> createState() => _CustomMapViewState();
}

class _CustomMapViewState extends State<CustomMapView> {
  late final MapController _mapController;
  late final markers;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point:  LatLng(double.parse(widget.latitude.toString()),
            double.parse(widget.longitude.toString())),
        builder: (ctx) => Icon(Icons.location_on,color:Colors.redAccent,size: 40,),
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            height: 350,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(double.parse(widget.latitude.toString()),
                      double.parse(widget.longitude.toString())),
                  zoom: 14,

                   minZoom: 2,
                   maxZoom: 30,
                  // swPanBoundary: LatLng(double.parse(latitude.toString()) ,double.parse(longitude.toString())),
                  // nePanBoundary: LatLng(double.parse(latitude.toString()) ,double.parse(longitude.toString())),
                ),
                mapController: _mapController,
                children: [
                  TileLayer(
                    tileProvider: NetworkTileProvider(),
                    maxZoom: 30,
                    subdomains: ['a', 'b', 'c'],
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    // urlTemplate:'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
                  ),
                  MarkerLayer(markers: markers),

                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          bottom: 10,
          right: 10,
          child: Align(
           alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8)
              ),
              child: IconButton(
                icon: Icon(Icons.my_location,color: Colors.black87,),
                onPressed: () {
                  _mapController.move(
                      LatLng(widget.latitude, widget.longitude), 14);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
