import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_pp/data/repositories/auth/auth_repository.dart';
import 'package:velo_pp/data/repositories/passes/passes_repository.dart';
import 'package:velo_pp/ui/screens/passes/view_model/passes_view_model.dart';
import 'package:velo_pp/ui/screens/passes/widget/pass_content.dart';

class PassesScreen extends StatelessWidget {
  const PassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PassesViewModel(
        authRepository: context.read<AuthRepository>(),
        passesRepository: context.read<PassesRepository>(),
      ),
      child: const PassContent(),
    
    );
  }
}