import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double size;
  
  const UserAvatar({super.key, required this.user, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[200],
      backgroundImage: user.avatarUrl != null
          ? CachedNetworkImageProvider(user.avatarUrl!)
          : null,
      child: user.avatarUrl == null
          ? Icon(Icons.person, size: size * 0.6)
          : null,
    );
  }
}