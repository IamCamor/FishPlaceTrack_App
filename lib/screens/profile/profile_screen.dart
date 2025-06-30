import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/user_provider.dart';
import '../../widgets/achievement_badge.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/stat_badge.dart';

class ProfileScreen extends StatelessWidget {
  final String? userId;
  
  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isCurrentUser = userId == null || userId == authService.currentUser?.id;
    final user = isCurrentUser 
        ? authService.currentUser 
        : Provider.of<UserProvider>(context).getUserById(userId!);
    
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Аватар и основная информация
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      UserAvatar(user: user, size: 100),
                      if (user.hasMonthlyGoldBadge)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user.isGuide)
                    Chip(
                      label: const Text('Гид'),
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                    ),
                  const SizedBox(height: 16),
                  
                  // Статистика
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatBadge(
                        icon: Icons.fishing,
                        value: user.totalCatches.toString(),
                        label: 'Уловы',
                      ),
                      StatBadge(
                        icon: Icons.scale,
                        value: '${user.totalWeight} кг',
                        label: 'Общий вес',
                      ),
                      StatBadge(
                        icon: Icons.emoji_events,
                        value: user.achievementsCount.toString(),
                        label: 'Награды',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Достижения
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Достижения',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // ... (список достижений)
                ],
              ),
            ),
            
            // Последние уловы
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Последние уловы',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // ... (список последних уловов)
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isCurrentUser
          ? FloatingActionButton(
              child: const Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(user: user),
                ),
              ),
            )
          : null,
    );
  }
}