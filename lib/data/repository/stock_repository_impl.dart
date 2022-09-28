import 'package:stock_app/data/data_source/local/stock_dao.dart';
import 'package:stock_app/data/mapper/company_mapper.dart';
import 'package:stock_app/domain/model/company_listing.dart';
import 'package:stock_app/util/result.dart';

import '../../domain/repository/stock_repository.dart';
import '../data_source/remote/stock_api.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApi _api;
  final StockDao _dao;

  StockRepositoryImpl(this._api, this._dao);

  @override
  Future<Result<List<CompanyListing>>> getCompanyListings(
      bool fetchFromRemote, String query) async {
    //캐시에서 찾는다
    final localListings = await _dao.searchCompanyListing(query);

    //없으면 리모트에서 가져온다
    final isDbEmpty = localListings.isEmpty && query.isEmpty;
    final shouldJustLoadFromCache = !isDbEmpty && !fetchFromRemote;

    if (shouldJustLoadFromCache) {
      return Result.success(
          localListings.map((e) => e.toCompanyListing()).toList());
    }

    try {
      final remoteListings = await _api.getListings();
      //TODO : CSV 파싱 변환
      return Result.success([]);
    } catch (e) {
      return Result.error(Exception('데이터 로드 실패'));
    }
  }
}
