import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AddFishingScreen extends StatefulWidget {
  const AddFishingScreen({super.key});

  @override
  State<AddFishingScreen> createState() => _AddFishingScreenState();
}

class _AddFishingScreenState extends State<AddFishingScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Добавить рыбалку'),
      ),
      body: const Center(
        child: Text(
          'Добавление рыбалки\n(В разработке)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}