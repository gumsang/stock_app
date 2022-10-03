import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stock_app/domain/repository/stock_repository.dart';
import 'package:stock_app/presentation/company_listings/company_listings_action.dart';
import 'package:stock_app/presentation/company_listings/company_listings_state.dart';

class CompanyListingsViewModel with ChangeNotifier {
  final StockRepository _repository;

  CompanyListingsState _state = CompanyListingsState();

  CompanyListingsState get state => _state;

  Timer? _debounce;

  void onAction(CompanyListingsAction action) {
    action.when(
      refresh: () => _getCompanyListings(fetchFromRemote: true),
      onSearchQueryChange: (query) {
        _debounce?.cancel();
        _debounce = Timer(Duration(milliseconds: 700), () {
          _getCompanyListings(query: query);
        });
      },
    );
  }

  CompanyListingsViewModel(this._repository) {
    _getCompanyListings();
  }

  Future _getCompanyListings({
    bool fetchFromRemote = false,
    String query = '',
  }) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.getCompanyListings(fetchFromRemote, query);
    result.when(
      success: (listings) {
        _state = state.copyWith(companies: listings);
      },
      error: (e) {
        print('리모트 에러 : ' + e.toString());
      },
    );

    _state = state.copyWith(isLoading: false);
    notifyListeners();
  }
}
