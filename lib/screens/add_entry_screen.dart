import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/fishing_entry.dart';
import '../services/api_service.dart';
import '../widgets/companion_selector.dart';
import '../services/user_provider.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

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
  String _bait = 'Червь';
  String _tackle = 'Удочка';
  String _weather = 'Солнечно';
  double _locationRating = 3.0;
  bool _isPublic = true;
  List<String> _companionIds = [];
  final List<String> _availableBaits = ['Червь', 'Опарыш', 'Мотыль', 'Блесна', 'Воблер'];
  final List<String> _availableTackles = ['Удочка', 'Спиннинг', 'Фидер', 'Донка'];
  final List<String> _weatherTypes = ['Солнечно', 'Облачно', 'Дождь', 'Ветрено'];

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
        latitude: 0.0, // Реальные координаты из карты
        longitude: 0.0,
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

      File? imageFile = _image != null ? File(_image!.path) : null;
      final id = await ApiService.addEntry(entry, imageFile);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Улов успешно добавлен!'))
      );
      Navigator.pop(context);
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить улов')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поля для данных об улове
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Место рыбалки'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Укажите место';
                  }
                  return null;
                },
              ),
              
              // Выбор даты
              ListTile(
                title: Text('Дата рыбалки'),
                subtitle: Text(DateFormat.yMd().format(_selectedDate)),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              
              // Выбор вида рыбы
              TextFormField(
                controller: _fishTypeController,
                decoration: InputDecoration(labelText: 'Вид рыбы'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Укажите вид рыбы';
                  }
                  return null;
                },
              ),
              
              // Вес и длина
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Вес (кг)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Укажите вес';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lengthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Длина (см)'),
                    ),
                  ),
                ],
              ),
              
              // Приманка и снасти
              DropdownButtonFormField<String>(
                value: _bait,
                decoration: InputDecoration(labelText: 'Приманка'),
                items: _availableBaits.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _bait = value!),
              ),
              
              DropdownButtonFormField<String>(
                value: _tackle,
                decoration: InputDecoration(labelText: 'Снасти'),
                items: _availableTackles.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _tackle = value!),
              ),
              
              // Погода
              DropdownButtonFormField<String>(
                value: _weather,
                decoration: InputDecoration(labelText: 'Погода'),
                items: _weatherTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _weather = value!),
              ),
              
              // Рейтинг места
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Оценка места: ${_locationRating.toStringAsFixed(1)}'),
                    Slider(
                      value: _locationRating,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _locationRating.toStringAsFixed(1),
                      onChanged: (value) => setState(() => _locationRating = value),
                    ),
                  ],
                ),
              ),
              
              // С кем рыбачил
              CompanionSelector(
                onCompanionsChanged: (ids) => _companionIds = ids,
              ),
              
              // Фото
              if (_image != null)
                Image.file(File(_image!.path), height: 200),
              
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text('Сделать фото улова'),
                onPressed: _pickImage,
              ),
              
              // Публичность
              SwitchListTile(
                title: Text('Публичная запись'),
                value: _isPublic,
                onChanged: (value) => setState(() => _isPublic = value),
              ),
              
              // Кнопка сохранения
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    child: Text('Сохранить улов'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}