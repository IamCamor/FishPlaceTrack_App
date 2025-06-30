import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/fishing_entry.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/entry_provider.dart';
import '../../screens/add_entry_screen.dart';
import '../../screens/map_screen.dart';
import '../../screens/top/top_fishers_screen.dart';
import '../../screens/top/top_fish_screen.dart';
import '../../screens/profile_screen.dart';
import '../../widgets/entry_card.dart';
import '../../widgets/achievement_badge.dart';
import '../../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<FishingEntry>> _entriesFuture;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    FeedScreen(),
    MapScreen(),
    RankingsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entriesFuture = ApiService.getEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthService>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Рыболовный дневник'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadEntries,
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MapScreen(
                  initialLocation: LatLng(55.7558, 37.6173),
                  title: "Карта рыбных мест",
                ),
              ),
            ),
          ),
          if (currentUser != null)
            IconButton(
              icon: Stack(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: currentUser.avatarUrl != null
                        ? CachedNetworkImageProvider(currentUser.avatarUrl!)
                        : null,
                    child: currentUser.avatarUrl == null
                        ? Icon(Icons.person, size: 16)
                        : null,
                  ),
                  if (currentUser.hasMonthlyGoldBadge)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Icon(Icons.star, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(userId: currentUser.id),
                ),
              ),
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _screens,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEntryScreen()),
              ).then((_) => _loadEntries()),
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Лента',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Карта',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Рейтинги',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<EntryProvider>(context);

    return RefreshIndicator(
      onRefresh: () => entryProvider.refreshEntries(),
      child: FutureBuilder<List<FishingEntry>>(
        future: entryProvider.entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки данных'));
          }
          
          final entries = snapshot.data!;
          
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fishing, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Пока нет записей',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Добавьте свой первый улов!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) => EntryCard(entry: entries[index]),
          );
        },
      ),
    );
  }
}

class RankingsScreen extends StatelessWidget {
  const RankingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Рейтинги',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 20),
        Text(
          'Лучшие рыболовы',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 10),
        _buildTopFishersSection(),
        SizedBox(height: 20),
        Text(
          'Топ по видам рыб',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 10),
        _buildTopFishSection(),
        SizedBox(height: 20),
        Text(
          'Ваши достижения',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 10),
        _buildAchievementsSection(),
      ],
    );
  }

  Widget _buildTopFishersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.emoji_events, color: Colors.amber),
              title: Text('Общий рейтинг'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TopFishersScreen()),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.blue),
              title: Text('Лучшие за месяц'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TopFishersScreen(period: 'month')),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.today, color: Colors.green),
              title: Text('Лучшие за неделю'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TopFishersScreen(period: 'week')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopFishSection() {
    final fishTypes = ['Щука', 'Судак', 'Окунь', 'Карп', 'Форель', 'Таймень'];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: fishTypes.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.fish, color: AppColors.primary),
            title: Text(fishTypes[index]),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TopFishScreen(fishType: fishTypes[index]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementsSection() {
    final currentUser = Provider.of<AuthService>(context).currentUser;
    
    if (currentUser == null) {
      return Center(child: Text('Авторизуйтесь для просмотра достижений'));
    }
    
    // Пример достижений (в реальном приложении нужно получать из сервиса)
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
        title: 'Опытный рыболов',
        description: '50 рыбалок',
        icon: Icons.emoji_events_rounded,
        progressRequired: 50,
        color: Colors.blue,
      ),
      Achievement(
        id: 'big_catch',
        title: 'Крупный улов',
        description: 'Рыба более 5 кг',
        icon: Icons.fitness_center,
        progressRequired: 1,
        color: Colors.green,
      ),
    ];
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AchievementBadge(achievement: achievements[index]),
          );
        },
      ),
    );
  }
}