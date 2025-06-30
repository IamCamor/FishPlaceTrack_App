import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';

class CompanionSelector extends StatefulWidget {
  final ValueChanged<List<String>> onCompanionsChanged;

  const CompanionSelector({super.key, required this.onCompanionsChanged});

  @override
  _CompanionSelectorState createState() => _CompanionSelectorState();
}

class _CompanionSelectorState extends State<CompanionSelector> {
  final List<String> _selectedCompanions = [];

  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<UserProvider>(context).friends;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('С кем рыбачил:', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: friends.map((friend) {
            final isSelected = _selectedCompanions.contains(friend.id);
            return FilterChip(
              label: Text(friend.name),
              avatar: CircleAvatar(
                backgroundImage: NetworkImage(friend.avatarUrl ?? ''),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCompanions.add(friend.id);
                  } else {
                    _selectedCompanions.remove(friend.id);
                  }
                  widget.onCompanionsChanged(_selectedCompanions);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}