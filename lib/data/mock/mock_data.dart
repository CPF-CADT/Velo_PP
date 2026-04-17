import 'package:latlong2/latlong.dart';

import '../dtos/bike_dto.dart';
import '../dtos/booking_dto.dart';
import '../dtos/dock_dto.dart';
import '../dtos/pass_dto.dart';
import '../dtos/station_dto.dart';
import '../dtos/user_dto.dart';
import '../dtos/user_pass_dto.dart';

class MockData {
  static final List<UserDto> users = [
    const UserDto(
      id: 'user_001',
      displayName: 'Sok Dara',
      email: 'sok.dara@example.com',
      phone: '+855 12 345 678',
    ),
  ];

  static final List<StationDto> stations = [
    StationDto(
      id: 'st_01',
      name: 'Eden Garden Station',
      location: const LatLng(11.5622, 104.9152),
      capacity: 12,
      bikesAvailable: 4,
      address: 'Eden Garden',
    ),
    StationDto(
      id: 'st_02',
      name: 'Central Market Station',
      location: const LatLng(11.5695, 104.9210),
      capacity: 16,
      bikesAvailable: 7,
      address: 'Phsar Thmei',
    ),
    StationDto(
      id: 'st_03',
      name: 'Riverside Station',
      location: const LatLng(11.5735, 104.9292),
      capacity: 10,
      bikesAvailable: 3,
      address: 'Sisowath Quay',
    ),
    StationDto(
      id: 'st_04',
      name: 'University Station',
      location: const LatLng(11.5529, 104.9166),
      capacity: 14,
      bikesAvailable: 6,
      address: 'Russian Blvd',
    ),
    StationDto(
      id: 'st_05',
      name: 'Night Market Station',
      location: const LatLng(11.5754, 104.9263),
      capacity: 8,
      bikesAvailable: 2,
      address: 'Night Market',
    ),
  ];

  static final List<BikeDto> bikes = [
    const BikeDto(
      id: 'bike_001',
      model: 'Urban Glide Pro',
      status: 'available',
    ),
    const BikeDto(id: 'bike_002', model: 'City Sprint', status: 'available'),
    const BikeDto(id: 'bike_003', model: 'Simple Bike', status: 'maintenance'),
    const BikeDto(id: 'bike_004', model: 'Eco Ride', status: 'available'),
    const BikeDto(id: 'bike_005', model: 'City Sprint', status: 'in_use'),
    const BikeDto(
      id: 'bike_006',
      model: 'Urban Glide Pro',
      status: 'available',
    ),
    const BikeDto(id: 'bike_007', model: 'Eco Ride', status: 'available'),
    const BikeDto(id: 'bike_008', model: 'City Sprint', status: 'available'),
  ];

  static final List<DockDto> docks = [
    const DockDto(
      id: 'dock_01_01',
      stationId: 'st_01',
      bikeId: 'bike_001',
      slotNumber: '01',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_01_02',
      stationId: 'st_01',
      bikeId: 'bike_002',
      slotNumber: '02',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_01_03',
      stationId: 'st_01',
      bikeId: '',
      slotNumber: '03',
      status: 'available',
    ),
    const DockDto(
      id: 'dock_02_01',
      stationId: 'st_02',
      bikeId: 'bike_004',
      slotNumber: '01',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_02_02',
      stationId: 'st_02',
      bikeId: 'bike_006',
      slotNumber: '02',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_02_03',
      stationId: 'st_02',
      bikeId: 'bike_007',
      slotNumber: '03',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_03_01',
      stationId: 'st_03',
      bikeId: 'bike_008',
      slotNumber: '01',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_04_01',
      stationId: 'st_04',
      bikeId: 'bike_005',
      slotNumber: '01',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_04_02',
      stationId: 'st_04',
      bikeId: '',
      slotNumber: '02',
      status: 'available',
    ),
    const DockDto(
      id: 'dock_05_01',
      stationId: 'st_05',
      bikeId: 'bike_003',
      slotNumber: '01',
      status: 'occupied',
    ),
  ];

  static final List<PassDto> passes = [
    
    const PassDto(
      id: 'pass_day',
      name: 'Day Pass',
      price: 5.0,
      durationHours: 24,
      features: ['Unlimited 30-min rides'],
    ),
    const PassDto(
      id: 'pass_month',
      name: 'Monthly Pass',
      price: 25.0,
      durationHours: 720,
      features: ['Unlimited 60min rides', 'Priority Bike Access'],
    ),
    const PassDto(
      id: 'pass_year',
      name: 'Annual Pass',
      price: 120.0,
      durationHours: 8760,
      features: [
        'Unlimited rides',
        'Priority bike access',
        'Free bike parking',
        'Priority support',
      ],
    ),
  ];

  static final List<UserPassDto> userPasses = [
    UserPassDto(
      id: 'up_001',
      userId: 'user_001',
      passId: 'pass_month',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      isActive: true,
    ),
  ];

  static final List<BookingDto> bookings = [
    BookingDto(
      id: 'bk_001',
      userId: 'user_001',
      bikeId: 'bike_001',
      startStationId: 'st_01',
      endStationId: 'st_02',
      status: 'active',
      paymentMethod: 'wallet',
      timeToPickup: DateTime.now().add(const Duration(minutes: 15)),
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    BookingDto(
      id: 'bk_002',
      userId: 'user_001',
      bikeId: 'bike_004',
      startStationId: 'st_02',
      endStationId: 'st_03',
      status: 'completed',
      paymentMethod: 'card',
      timeToPickup: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
  ];
}
