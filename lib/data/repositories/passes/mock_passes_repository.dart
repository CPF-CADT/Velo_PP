import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/dtos/pass_dto.dart';
import 'package:velo_pp/data/dtos/user_pass_dto.dart';
import 'package:velo_pp/data/mock/mock_data.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/model/pass.dart';
import 'package:velo_pp/model/user_pass.dart';

class MockPassesRepository extends ChangeNotifier implements PassesRepository {
  int _passCounter = 1;  // couter id
  final List<PassDto> _passes = List<PassDto>.from(MockData.passes); //copy list of pass
  final List<UserPassDto> _userPasses = List<UserPassDto>.from(   // copy list of userPass for modified
    MockData.userPasses,
  );

  @override
  List<Pass> getPasses() => _passes.map((pass) => pass.toModel()).toList();

  @override
  Pass? getPassById(String id) {
    final pass = _passes.where((item) => item.id == id).toList();
    return pass.isEmpty ? null : pass.first.toModel();
  }

  @override
  UserPass? getActivePassForUser(String userId) {
    final active = _userPasses
        .where((item) => item.userId == userId && item.isActive)
        .toList();
    return active.isEmpty ? null : active.first.toModel();
  }
  // get list all User Passes
  @override
   List<UserPass> getAllUserPasses(String userId) {
    return _userPasses
        .where((item) => item.userId == userId)
        .map((dto) => dto.toModel())
        .toList();
  }
  // purchase method
  @override
 Future<UserPass> purchasePass(String userId, String passId) async{
    await Future.delayed(const Duration(milliseconds: 1500));

    final pass = getPassById(passId);
    if(pass == null){
      throw Exception("pass not found");

    }
    // detivate old active pass
    final activePassIndex = _userPasses.indexWhere((item) => item.userId == userId && item.isActive);
    
    if(activePassIndex != -1){
      final oldPass = _userPasses[activePassIndex];
      _userPasses[activePassIndex]  =
       UserPassDto(id: oldPass.id, 
       userId: oldPass.userId,
        passId: oldPass.passId, 
        startDate: oldPass.startDate, 
        endDate: oldPass.endDate, 
        isActive: false);
    }

    //create new pass
    final newUserPassDto = UserPassDto(
      id: 'userpass_${_passCounter++}',  // update the new id with couter 
      userId: userId, 
      passId: passId,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(hours: pass.durationHours)),
      isActive: true, 
    );
    _userPasses.add(newUserPassDto);
    
    return newUserPassDto.toModel();
  }
}
