import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/user_provider.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/user_avatar.dart';
import '../widgets/entry_card.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  
  const ProfileScreen({super.key, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User?> _userFuture;
  late Future<List<FishingEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = widget.userId ?? authService.currentUser?.id;
    
    if (userId != null) {
      _userFuture = ApiService.getUser(userId);
      _entriesFuture = ApiService.getEntriesByUser(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isCurrentUser = widget.userId == null || 
        widget.userId == authService.currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return const Center(child: Text('Пользователь не найден'));
          }
          
          final user = userSnapshot.data!;
          
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      if (user.isGuide)
                        Chip(
                          label: const Text('Гид'),
                          avatar: const Icon(Icons.tour, size: 18),
                          backgroundColor: Colors.blue[100],
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn('Уловы', '${user.totalCatches}'),
                          _buildStatColumn('Вес', '${user.totalWeight} кг'),
                          _buildStatColumn('Друзья', '${user.friendsCount}'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (isCurrentUser)
                        ElevatedButton(
                          onPressed: _editProfile,
                          child: const Text('Редактировать профиль'),
                        ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Достижения',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: _buildAchievementsSection(user),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Последние уловы',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              _buildEntriesSection(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection(User user) {
    // В реальном приложении получаем достижения пользователя
    final achievements = [
      Achievement(
        id: '10_fishing',
        title: 'Новичок',
        description: '10 рыбалок',
        icon: Icons.fishing_rounded,
        progressRequired: 10,
      ),
      Achievement(
        id: '50_fishing',
        title: 'Опытный',
        description: '50 рыбалок',
        icon: Icons.emoji_events_rounded,
        progressRequired: 50,
        color: Colors.blue,
      ),
    ];
    
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => AchievementBadge(achievement: achievements[index]),
        childCount: achievements.length,
      ),
    );
  }

  Widget _buildEntriesSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return FutureBuilder<List<FishingEntry>>(
            future: _entriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Пока нет записей о рыбалках'),
                );
              }
              
              final entries = snapshot.data!;
              return EntryCard(entry: entries[index]);
            },
          );
        },
        childCount: 5, // Показываем первые 5 записей
      ),
    );
  }

  void _editProfile() {
    // Реализация экрана редактирования профиля
  }
}