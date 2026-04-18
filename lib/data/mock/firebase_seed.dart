import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirebaseSeed {
  static Future<void> seedFromJson() async {
    final String response = await rootBundle.loadString('lib/data/mock/mock.json');
    final data = await json.decode(response) as Map<String, dynamic>;

    final firestore = FirebaseFirestore.instance;

    // Users
    if (data.containsKey('users')) {
      for (var user in data['users']) {
        await firestore.collection('users').doc(user['id']).set({
          'displayName': user['displayName'],
          'email': user['email'],
          'phone': user['phone'],
        });
      }
    }

    // Stations
    if (data.containsKey('stations')) {
      for (var station in data['stations']) {
        await firestore.collection('stations').doc(station['id']).set({
          'name': station['name']?.toString().replaceAll(RegExp(r'[^\x00-\x7F]+'), ''), // removes emoji
          'capacity': station['capacity'],
          'bikesAvailable': station['bikesAvailable'],
          'address': station['address']?.toString().replaceAll(RegExp(r'[^\x00-\x7F]+'), ''),
          'location': {
            'lat': station['location']['lat'],
            'lng': station['location']['lng'],
          },
        });
      }
    }

    // Bikes
    if (data.containsKey('bikes')) {
      for (var bike in data['bikes']) {
        await firestore.collection('bikes').doc(bike['id']).set({
          'model': bike['model']?.toString().replaceAll(RegExp(r'[^\x00-\x7F]+'), ''),
          'status': bike['status'],
        });
      }
    }

    // Docks
    if (data.containsKey('docks')) {
      for (var dock in data['docks']) {
        await firestore.collection('docks').doc(dock['id']).set({
          'stationId': dock['stationId'],
          'bikeId': dock['bikeId'],
          'slotNumber': dock['slotNumber'],
          'status': dock['status'],
        });
      }
    }

    // Bookings
    if (data.containsKey('bookings')) {
      for (var booking in data['bookings']) {
        await firestore.collection('bookings').doc(booking['id']).set({
          'userId': booking['userId'],
          'bikeId': booking['bikeId'],
          'startStationId': booking['startStationId'],
          'endStationId': booking['endStationId'],
          'status': booking['status'],
          'paymentMethod': booking['paymentMethod'],
          'timeToPickup': booking['timeToPickup'],
          'createdAt': booking['createdAt'],
        });
      }
    }

    // Passes
    if (data.containsKey('passes')) {
      for (var pass in data['passes']) {
        List<String> cleanFeatures = (pass['features'] as List)
            .map((f) => f.toString().replaceAll(RegExp(r'[^\x00-\x7F]+'), ''))
            .toList();
        
        await firestore.collection('passes').doc(pass['id']).set({
          'name': pass['name']?.toString().replaceAll(RegExp(r'[^\x00-\x7F]+'), ''),
          'price': pass['price'],
          'durationHours': pass['durationHours'],
          'features': cleanFeatures,
        });
      }
    }

    // User Passes
    if (data.containsKey('userPasses') && data['userPasses'] != null) {
      for (var userPass in data['userPasses']) {
        await firestore.collection('userPasses').doc(userPass['id']).set({
          'userId': userPass['userId'],
          'passId': userPass['passId'],
          'purchaseDate': userPass['purchaseDate'],
          'isActive': userPass['isActive'],
          'expirationDate': userPass['expirationDate'],
        });
      }
    }

    print(' Firebase Seed Complete (inserted all users, stations, bikes, docks, passes, userPasses, bookings without emojis)');
  }
}
