import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_app/data/data_source/remote/dto/company_info_dto.dart';

class StockApi {
  static const baseUrl = 'https://www.alphavantage.co';
  static const apiKey = 'R6HAI3NEA6VE2D8N';

  final http.Client _client;

  StockApi({http.Client? client}) : _client = (client ?? http.Client());

  Future<http.Response> getListings({String apiKey = apiKey}) async {
    return await _client.get(
        Uri.parse('$baseUrl/query?function=LISTING_STATUS&apikey=$apiKey'));
  }

  Future<CompanyInfoDto> getCompanyInfo(
      {required String symbol, String apiKey = apiKey}) async {
    final respose = await _client.get(Uri.parse(
        '$baseUrl/query?function=OVERVIEW&symbol=$symbol&apikey=$apiKey'));

    return CompanyInfoDto.fromJson(jsonDecode(respose.body));
  }
}
