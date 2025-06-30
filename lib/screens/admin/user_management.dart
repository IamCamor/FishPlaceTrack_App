import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/user.dart';
import '../../widgets/user_avatar.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = AdminService.getUsers();
  }

  void _toggleBan(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.isBanned ? 'Разблокировать пользователя?' : 'Заблокировать пользователя?'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'Причина',
            hintText: user.isBanned ? 'Причина разблокировки' : 'Причина блокировки',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              AdminService.toggleUserBan(user.id, !user.isBanned);
              Navigator.pop(context);
              setState(() {
                _usersFuture = AdminService.getUsers();
              });
            },
            child: Text('Подтвердить'),
          ),
        ],
      ),
    );
  }

  void _toggleGoldBadge(User user) {
    AdminService.toggleGoldBadge(user.id, !user.hasMonthlyGoldBadge);
    setState(() {
      _usersFuture = AdminService.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Управление пользователями')),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
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
                    if (user.hasMonthlyGoldBadge)
                      Icon(Icons.star, color: Colors.amber),
                    if (user.isBanned)
                      Icon(Icons.block, color: Colors.red),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'view',
                          child: Text('Просмотреть профиль'),
                        ),
                        PopupMenuItem(
                          value: 'ban',
                          child: Text(user.isBanned ? 'Разблокировать' : 'Заблокировать'),
                        ),
                        PopupMenuItem(
                          value: 'badge',
                          child: Text(user.hasMonthlyGoldBadge 
                              ? 'Убрать золотую отметку' 
                              : 'Дать золотую отметку'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'ban') _toggleBan(user);
                        if (value == 'badge') _toggleGoldBadge(user);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}