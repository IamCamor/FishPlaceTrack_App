import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../models/fishing_entry.dart';
import '../../services/api_service.dart';
import '../../services/user_provider.dart';
import '../../widgets/companion_selector.dart';

class AddEntryScreen extends StatefulWidget {
  final Point? initialLocation;
  
  const AddEntryScreen({super.key, this.initialLocation});

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _fishTypeController = TextEditingController();
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  XFile? _image;
  final String _bait = 'Червь';
  final String _tackle = 'Удочка';
  final String _weather = 'Солнечно';
  final double _locationRating = 3.0;
  final bool _isPublic = true;
  final List<String> _companionIds = [];
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _latitude = widget.initialLocation!.latitude;
      _longitude = widget.initialLocation!.longitude;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) setState(() => _image = image);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final entry = FishingEntry(
        userId: userProvider.currentUser!.id,
        date: _selectedDate,
        location: _locationController.text,
        latitude: _latitude ?? 0.0,
        longitude: _longitude ?? 0.0,
        fishType: _fishTypeController.text,
        weight: double.parse(_weightController.text),
        length: _lengthController.text.isNotEmpty
            ? double.parse(_lengthController.text)
            : null,
        bait: _bait,
        tackle: _tackle,
        weather: _weather,
        notes: _notesController.text,
        isPublic: _isPublic,
        rating: _locationRating,
        companionIds: _companionIds,
      );

      final id = await ApiService.addEntry(entry, _image?.path);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Улов успешно добавлен!'))
      );
      Navigator.pop(context);
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить улов')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ... (остальные поля как в предыдущей реализации)
                
                // Кнопка сохранения
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Сохранить улов', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
