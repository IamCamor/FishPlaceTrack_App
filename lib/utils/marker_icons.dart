import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MarkerIcons {
  static Future<Uint8List> createCustomMarker({
    required Color color,
    required IconData icon,
    double size = 80,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Рисуем фон маркера
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Основная форма маркера
    final path = Path();
    path.addOval(Rect.fromCircle(center: Offset(size / 2, size / 2), radius: size / 3));
    canvas.drawPath(path, paint);
    
    // Рисуем белую окантовку
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(path, borderPaint);
    
    // Рисуем иконку
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size / 3,
        fontFamily: icon.fontFamily,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size / 2 - textPainter.width / 2,
        size / 2 - textPainter.height / 2,
      ),
    );
    
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
  
  static Future<Uint8List> getFishingSpotIcon() async {
    return createCustomMarker(
      color: const Color(0xFF2E7D32), // Зеленый
      icon: Icons.location_on,
    );
  }
  
  static Future<Uint8List> getShopIcon() async {
    return createCustomMarker(
      color: const Color(0xFFE65100), // Оранжевый
      icon: Icons.store,
    );
  }
  
  static Future<Uint8List> getBaseIcon() async {
    return createCustomMarker(
      color: const Color(0xFF1565C0), // Синий
      icon: Icons.home,
    );
  }
  
  static Future<Uint8List> getSlipIcon() async {
    return createCustomMarker(
      color: const Color(0xFF7B1FA2), // Фиолетовый
      icon: Icons.anchor,
    );
  }
  
  static Future<Uint8List> getFarmIcon() async {
    return createCustomMarker(
      color: const Color(0xFFAD1457), // Розовый
      icon: Icons.agriculture,
    );
  }
  
  static Future<Uint8List> getPierIcon() async {
    return createCustomMarker(
      color: const Color(0xFFF57F17), // Желтый
      icon: Icons.deck,
    );
  }
  
  static Future<Uint8List> getCurrentLocationIcon() async {
    return createCustomMarker(
      color: const Color(0xFF0277BD), // Голубой
      icon: Icons.my_location,
    );
  }
  
  static Future<Uint8List> getFishIcon(String fishType) async {
    Color color;
    IconData icon;
    
    switch (fishType.toLowerCase()) {
      case 'щука':
        color = const Color(0xFF2E7D32);
        icon = Icons.water_drop;
        break;
      case 'судак':
        color = const Color(0xFF1565C0);
        icon = Icons.waves;
        break;
      case 'окунь':
        color = const Color(0xFFE65100);
        icon = Icons.water;
        break;
      case 'карп':
        color = const Color(0xFFF57F17);
        icon = Icons.bubble_chart;
        break;
      default:
        color = const Color(0xFF37474F);
        icon = Icons.location_on;
    }
    
    return createCustomMarker(color: color, icon: icon);
  }
}