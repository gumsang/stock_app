import 'package:flutter/material.dart';
import 'package:stock_app/domain/repository/stock_repository.dart';
import 'package:stock_app/presentation/company_info/company_info_state.dart';

class CompanyInfoViewModel with ChangeNotifier {
  final StockRepository _repository;

  CompanyInfoState _state = CompanyInfoState();

  CompanyInfoState get state => _state;

  CompanyInfoViewModel(this._repository, String symbol) {
    loadCompanyInfo(symbol);
  }

  Future<void> loadCompanyInfo(String symbol) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.getCompanyInfo(symbol);
    result.when(
      success: (info) {
        _state = state.copyWith(
          companyInfo: info,
          isLoading: false,
        );
      },
      error: (e) {
        _state = state.copyWith(
          companyInfo: null,
          isLoading: false,
          errorMessage: e.toString(),
        );
      },
    );
    notifyListeners();
  }
}
