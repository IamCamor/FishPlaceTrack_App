import 'package:flutter/material.dart';
import '../models/fishing_entry.dart';
import '../services/api_service.dart';

class SocialActions extends StatefulWidget {
  final FishingEntry entry;
  
  const SocialActions({super.key, required this.entry});

  @override
  _SocialActionsState createState() => _SocialActionsState();
}

class _SocialActionsState extends State<SocialActions> {
  bool _isLiked = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.entry.isLiked;
    _likesCount = widget.entry.likesCount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : null,
              ),
              onPressed: _toggleLike,
            ),
            Text('$_likesCount'),
            
            IconButton(
              icon: const Icon(Icons.comment),
              onPressed: _showComments,
            ),
            Text('${widget.entry.commentsCount}'),
            
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareEntry,
            ),
            Text('${widget.entry.shareCount}'),
          ],
        ),
        
        // Список друзей, с которыми рыбачили
        if (widget.entry.companionIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 8,
              children: [
                const Text('С кем рыбачил:'),
                ...widget.entry.companionIds.map((id) {
                  // В реальном приложении получаем данные пользователя
                  return Chip(
                    label: Text('Рыболов #${id.substring(0, 4)}'),
                    avatar: const CircleAvatar(
                      radius: 12,
                      child: Icon(Icons.person, size: 14),
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  void _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
    
    await ApiService.toggleLike(
      widget.entry.id!,
      _isLiked,
    );
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommentSection(entryId: widget.entry.id!),
    );
  }

  void _shareEntry() {
    // Реализация шаринга
    setState(() {
      widget.entry.shareCount++;
    });
    
    // Отправка на сервер
    ApiService.shareEntry(widget.entry.id!);
  }
}