import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/admin_service.dart';
import '../../widgets/user_avatar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<User>> _usersFuture;
  late Future<List<Report>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _usersFuture = AdminService.getUsers();
      _reportsFuture = AdminService.getReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Админ-панель'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Пользователи'),
              Tab(icon: Icon(Icons.report), text: 'Жалобы'),
              Tab(icon: Icon(Icons.settings), text: 'Настройки'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUsersTab(),
            _buildReportsTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return FutureBuilder<List<User>>(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData) {
          return const Center(child: Text('Ошибка загрузки данных'));
        }
        
        final users = snapshot.data!;
        
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: UserAvatar(user: user, size: 40),
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user.isBanned)
                    const Icon(Icons.block, color: Colors.red),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editUser(user),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReportsTab() {
    return FutureBuilder<List<Report>>(
      future: _reportsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData) {
          return const Center(child: Text('Ошибка загрузки данных'));
        }
        
        final reports = snapshot.data!;
        
        return ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return ListTile(
              leading: const Icon(Icons.report_problem, color: Colors.orange),
              title: Text('Жалоба на ${report.targetType}'),
              subtitle: Text(report.reason),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => _showReportDetails(report),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Push-уведомления'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () => _managePushNotifications(),
        ),
        ListTile(
          leading: const Icon(Icons.map),
          title: const Text('Управление местами'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () => _managePlaces(),
        ),
        ListTile(
          leading: const Icon(Icons.event),
          title: const Text('Соревнования'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () => _manageCompetitions(),
        ),
      ],
    );
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Редактировать ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Заблокирован'),
              value: user.isBanned,
              onChanged: (value) => _toggleBan(user, value),
            ),
            SwitchListTile(
              title: const Text('Золотая отметка'),
              value: user.hasMonthlyGoldBadge,
              onChanged: (value) => _toggleGoldBadge(user, value),
            ),
            SwitchListTile(
              title: const Text('Статус гида'),
              value: user.isGuide,
              onChanged: (value) => _toggleGuideStatus(user, value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              AdminService.updateUser(user);
              Navigator.pop(context);
              _loadData();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _toggleBan(User user, bool value) {
    user.isBanned = value;
    setState(() {});
  }

  void _toggleGoldBadge(User user, bool value) {
    user.hasMonthlyGoldBadge = value;
    setState(() {});
  }

  void _toggleGuideStatus(User user, bool value) {
    user.isGuide = value;
    setState(() {});
  }

  void _showReportDetails(Report report) {
    // Реализация просмотра деталей жалобы
  }

  void _managePushNotifications() {
    // Реализация управления push-уведомлениями
  }

  void _managePlaces() {
    // Реализация управления местами
  }

  void _manageCompetitions() {
    // Реализация управления соревнованиями
  }
}