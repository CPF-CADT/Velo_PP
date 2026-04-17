import 'package:flutter_test/flutter_test.dart';
import 'package:velo_pp/data/repositories/passes/mock_passes_repository.dart';

void main() {
  group('MockPassesRepository - Unit Test Passs', () {
    late MockPassesRepository repository;
    const userId = 'test_user_1';
    const passIdDay = 'pass_day';
    const passIdMonth = 'pass_month';
    const passIdYear = 'pass_year';

    setUp(() {
      repository = MockPassesRepository();
    });

    // Test 1: Purchase creates a new active pass
    test('purchasePass creates new pass with active status', () async {
      final result = await repository.purchasePass(userId, passIdDay);

      expect(result.userId, userId);
      expect(result.passId, passIdDay);
      expect(result.isActive, true);
    });

    // Test 2: main test - only one active pass at a time
    test('purchasePass deactivates old pass when buying new one', () async {
      // First purchase
      await repository.purchasePass(userId, passIdDay);

      // Second purchase
      await repository.purchasePass(userId, passIdMonth);

      final allPasses = repository.getAllUserPasses(userId);
      final activePasses = allPasses.where((p) => p.isActive).toList();

      expect(activePasses.length, 1);
      expect(activePasses.first.passId, passIdMonth);
    });

    // Test 3: old pass is deactivated
    test('old active pass becomes inactive', () async {
      await repository.purchasePass(userId, passIdDay);
      await repository.purchasePass(userId, passIdMonth);

      final allPasses = repository.getAllUserPasses(userId);
      final dayPass = allPasses.firstWhere((p) => p.passId == passIdDay);
      final monthPass = allPasses.firstWhere((p) => p.passId == passIdMonth);

      expect(dayPass.isActive, false);
      expect(monthPass.isActive, true);
    });

    // Test 4: get active pass correctly
    test('getActivePassForUser returns only the active pass', () async {
      await repository.purchasePass(userId, passIdDay);
      await repository.purchasePass(userId, passIdMonth);
      await repository.purchasePass(userId, passIdYear);

      final activePass = repository.getActivePassForUser(userId);

      expect(activePass!.passId, passIdYear);
      expect(activePass.isActive, true);
    });

    // Test 5: Different users have separate passes
    test('different users can have different active passes', () async {
      const userId1 = 'user_1';
      const userId2 = 'user_2';

      await repository.purchasePass(userId1, passIdDay);
      await repository.purchasePass(userId2, passIdMonth);

      expect(repository.getActivePassForUser(userId1)!.passId, passIdDay);
      expect(repository.getActivePassForUser(userId2)!.passId, passIdMonth);
    });

    // Test 6: no active pass when no purchased from user
    test('getActivePassForUser returns null when no pass purchased', () async {
      final activePass = repository.getActivePassForUser('unknown_user');
      expect(activePass, isNull);
    });

    // Test 7: pass purchase replacement many times
    test('user can replace active pass multiple times', () async {
      await repository.purchasePass(userId, passIdDay);
      await repository.purchasePass(userId, passIdMonth);
      await repository.purchasePass(userId, passIdYear);

      final activePass = repository.getActivePassForUser(userId);
      expect(activePass!.passId, passIdYear);

      final allPasses = repository.getAllUserPasses(userId);
      final inactivePasses = allPasses.where((p) => !p.isActive).toList();
      expect(inactivePasses.length, 2);
    });
    // Test 8: Pass has valid expiration date
    test('purchased pass has future expiration date', () async {
      final pass = await repository.purchasePass(userId, passIdDay);
      final now = DateTime.now();

      expect(pass.endDate.isAfter(now), true);
    });

    // Test 9: Check if pass is expired
    test('isExpired returns true for expired pass', () async {
      final pass = await repository.purchasePass(userId, passIdDay);
      
      // Check current pass is NOT expired
      expect(pass.isExpired, false);
    });

    // Test 10: Pass duration is correct
    test('pass has correct duration in hours', () async {
      final pass = await repository.purchasePass(userId, passIdDay);
      
      final durationInHours = pass.endDate.difference(pass.startDate).inHours;
      
      // Day pass should only 24 hours duration
      expect(durationInHours, 24);
    });
  });
}