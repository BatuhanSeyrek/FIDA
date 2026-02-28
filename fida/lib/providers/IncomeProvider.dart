import 'package:fida/services/IncomeService.dart';
import 'package:flutter/material.dart';
import '../models/IncomeModel.dart';

class IncomeProvider with ChangeNotifier {
  final IncomeService _service = IncomeService();
  IncomeModel? _currentIncome;
  bool _isLoading = false;

  IncomeModel? get currentIncome => _currentIncome;
  double get incomeAmount => _currentIncome?.income ?? 0.0;
  bool get isLoading => _isLoading;

  // Başlangıçta geliri yükle
  Future<void> loadIncome() async {
    _isLoading = true;
    notifyListeners();
    _currentIncome = await _service.fetchIncome();
    _isLoading = false;
    notifyListeners();
  }

  // YENİ GELİR KAYDETME AKIŞI
  Future<void> saveNewIncome(double amount) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Mevcut geliri sil (Backend'deki delete metodunu tetikler)
      await _service.deleteIncome();

      // 2. Yeni geliri record et
      bool isSaved = await _service.recordIncome(amount);

      if (isSaved) {
        // 3. Başarılıysa güncel veriyi tekrar çek
        await loadIncome();
      }
    } catch (e) {
      debugPrint("Gelir güncelleme hatası: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
