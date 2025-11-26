import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramadancompanionapp/widgets/custom_button.dart';
import 'dart:math' as math;

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  bool _hasPermission = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchPermission();
  }

  void _fetchPermission() async {
    print('fetching permission');
    Permission.locationWhenInUse.request().then((status) {
      if (mounted) {
        print(status);
        setState(() {
          _hasPermission =
              (status == PermissionStatus.granted);
        });
        _getLocation();
      }
    });
  }

  void _getLocation() async {
    if (_hasPermission) {
      try {
        _currentPosition =
            await Geolocator.getCurrentPosition();
        setState(() {});
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error getting location: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 17,
        children: [
          Center(
            child: Text(
              'Qibla Finder',
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              if (_hasPermission) {
                return _buildCompass();
              } else {
                return _buildPermission();
              }
            }),
          ),
        ],
      ),
    );
  }

  // compass widget
  Widget _buildCompass() {
    //fall back central Malaysia lat long
    final latitude =
        _currentPosition?.latitude ?? '3.494480';
    final longitude =
        _currentPosition?.longitude ?? '102.221129';
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius:
                      BorderRadius.circular(32.0)),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        //loading
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius:
                      BorderRadius.circular(32.0)),
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          );
        }

        double? direction = snapshot.data!.heading;
        if (direction == null) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius:
                      BorderRadius.circular(32.0)),
              child: Text(
                'Device not supported',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // return compass
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(32.0)),
            child: Transform.rotate(
              angle: direction * (math.pi / 180) * -1,
              child: Image.network(
                'https://api.aladhan.com/v1/qibla/$latitude/$longitude/compass',
                loadingBuilder:
                    (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress
                                  .expectedTotalBytes !=
                              null
                          ? loadingProgress
                                  .cumulativeBytesLoaded /
                              loadingProgress
                                  .expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Icon(Icons.error,
                          color: Colors.red));
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // permission widget
  Widget _buildPermission() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () {
                Permission.locationWhenInUse
                    .request()
                    .then((value) {
                  _fetchPermission();
                });
              },
              text: 'Request Permission',
            ),
          ],
        ),
      ),
    );
  }
}
