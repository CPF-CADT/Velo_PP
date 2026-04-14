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
      id: 'st_eden',
      name: 'Eden Garden Station',
      location: const LatLng(11.5622, 104.9152),
      capacity: 12,
      bikesAvailable: 4,
      address: 'Eden Garden',
    ),
    StationDto(
      id: 'st_central',
      name: 'Central Market Station',
      location: const LatLng(11.5695, 104.9210),
      capacity: 16,
      bikesAvailable: 7,
      address: 'Phsar Thmei',
    ),
    StationDto(
      id: 'st_riverside',
      name: 'Riverside Station',
      location: const LatLng(11.5735, 104.9292),
      capacity: 10,
      bikesAvailable: 3,
      address: 'Sisowath Quay',
    ),
    StationDto(
      id: 'st_university',
      name: 'University Station',
      location: const LatLng(11.5529, 104.9166),
      capacity: 14,
      bikesAvailable: 6,
      address: 'Russian Blvd',
    ),
    StationDto(
      id: 'st_nightmarket',
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
      id: 'dock_eden_01',
      stationId: 'st_eden',
      bikeId: 'bike_001',
      slotNumber: '01',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_eden_02',
      stationId: 'st_eden',
      bikeId: 'bike_002',
      slotNumber: '02',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_eden_03',
      stationId: 'st_eden',
      bikeId: '',
      slotNumber: '03',
      status: 'available',
    ),
    const DockDto(
      id: 'dock_central_01',
      stationId: 'st_central',
      bikeId: 'bike_004',
      slotNumber: '01',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_central_02',
      stationId: 'st_central',
      bikeId: 'bike_006',
      slotNumber: '02',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_central_03',
      stationId: 'st_central',
      bikeId: 'bike_007',
      slotNumber: '03',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_river_01',
      stationId: 'st_riverside',
      bikeId: 'bike_008',
      slotNumber: '01',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_university_01',
      stationId: 'st_university',
      bikeId: 'bike_005',
      slotNumber: '01',
      status: 'occupied',
    ),
    const DockDto(
      id: 'dock_university_02',
      stationId: 'st_university',
      bikeId: '',
      slotNumber: '02',
      status: 'available',
    ),
    const DockDto(
      id: 'dock_night_01',
      stationId: 'st_nightmarket',
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
    ),
    const PassDto(
      id: 'pass_month',
      name: 'Monthly Pass',
      price: 25.0,
      durationHours: 720,
    ),
    const PassDto(
      id: 'pass_year',
      name: 'Annual Pass',
      price: 120.0,
      durationHours: 8760,
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
      startStationId: 'st_eden',
      endStationId: 'st_central',
      status: 'active',
      paymentMethod: 'wallet',
      timeToPickup: DateTime.now().add(const Duration(minutes: 15)),
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    BookingDto(
      id: 'bk_002',
      userId: 'user_001',
      bikeId: 'bike_004',
      startStationId: 'st_central',
      endStationId: 'st_riverside',
      status: 'completed',
      paymentMethod: 'card',
      timeToPickup: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
  ];
}
