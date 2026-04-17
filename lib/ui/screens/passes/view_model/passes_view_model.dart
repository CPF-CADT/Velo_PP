import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/model/pass.dart';
import 'package:velo_pp/model/user.dart';
import 'package:velo_pp/model/user_pass.dart';
import 'package:velo_pp/core/utils/async_value.dart';

enum PassStatus {
  available,
  active,
  expired,
  purchasing,
}

class PassesData {
  final User user;
  final List<Pass> passes;
  final UserPass? activePass;

  const PassesData({
    required this.user,
    required this.passes,
    required this.activePass,
  });
}

class PassesViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final PassesRepository _passesRepository;

  AsyncValue<PassesData> passes = AsyncValue.loading();
  String? _buyingPassId;
  String? _errorMessage;
  PassesViewModel({
    required AuthRepository authRepository,
    required PassesRepository passesRepository,
  }) : _authRepository = authRepository,
       _passesRepository = passesRepository{
        loadPasses();
       }
       

  Future<void> loadPasses() async {
    passes = AsyncValue.loading();
    notifyListeners();

    try {
      final user = _authRepository.currentUser;
      final items = _passesRepository.getPasses();
      final active = _passesRepository.getActivePassForUser(user.id);
      passes = AsyncValue.success(
        PassesData(user: user, passes: items, activePass: active),
      );
    } catch (e) {
      passes = AsyncValue.error(e);
    }

    notifyListeners();
  }
  // buy pass
  Future<void> buyPass(String passId, {bool addDuration = false}) async{
    _buyingPassId = passId;  // store the purchase pass
    notifyListeners();   

    try{
      final user = _authRepository.currentUser;
      await _passesRepository.purchasePass(user.id, passId);  // create new pass

      await loadPasses();  // refresh the data to show new pass 

    }catch(e){
      _errorMessage = e.toString();
      print("fail to buy: $e");
    }

    _buyingPassId = null;
    notifyListeners();
  }

  PassStatus getPassStatus(String passId){
    if(_buyingPassId == passId){    // status for showing being purchase state
      return PassStatus.purchasing;
    }
    UserPass? activePass;
    if(passes.state == AsyncValueState.success){
      activePass = passes.data?.activePass; // get current active pass
    }
    if(activePass != null && activePass.passId == passId){
      return activePass.isExpired ? PassStatus.expired : PassStatus.active;  
    }
    return PassStatus.available;
  }

  int? getActiveDaysRemaining(){
    if(passes.state == AsyncValueState.success) {
    final active = passes.data?.activePass; // get current active pass
    if(active == null || active.isExpired) return null;  
        return active.remainingDays; // return the day remaining  
    }
    return null;
  }
}
