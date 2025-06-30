import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/comment.dart';
import '../services/api_service.dart';
import '../services/user_provider.dart';
import '../widgets/user_avatar.dart';

class CommentSection extends StatefulWidget {
  final String entryId;
  
  const CommentSection({super.key, required this.entryId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    setState(() {
      _commentsFuture = ApiService.getComments(widget.entryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).currentUser;
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Написать комментарий...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      _addComment(currentUser!);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Ошибка загрузки комментариев'));
                }
                
                final comments = snapshot.data!;
                
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentTile(comment: comments[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addComment(User user) {
    ApiService.addComment(
      widget.entryId,
      _commentController.text,
      user.id,
    ).then((_) {
      _commentController.clear();
      _loadComments();
    });
  }
}

class CommentTile extends StatelessWidget {
  final Comment comment;
  
  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUserById(comment.userId);
    
    return ListTile(
      leading: UserAvatar(user: user, size: 36),
      title: Text(user.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.text),
          Text(
            DateFormat.yMMMd().add_Hm().format(comment.createdAt),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}