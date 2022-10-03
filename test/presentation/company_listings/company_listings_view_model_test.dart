import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stock_app/data/data_source/local/company_listing_entity.dart';
import 'package:stock_app/data/data_source/local/stock_dao.dart';
import 'package:stock_app/data/data_source/remote/stock_api.dart';
import 'package:stock_app/data/repository/stock_repository_impl.dart';
import 'package:stock_app/presentation/company_listings/company_listings_view_model.dart';

void main() {
  test('company_listings_view_model 생성시 데이터를 잘 가져와야 한다', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider_macos');
    channel.setMockMethodCallHandler((methodCall) async {
      return ".";
    });
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.registerAdapter(CompanyListingEntityAdapter());
    Hive.init(appDocumentDirectory.path);
    final _api = StockApi();
    final _dao = StockDao();
    final viewModel = CompanyListingsViewModel(StockRepositoryImpl(_api, _dao));

    await Future.delayed(Duration(seconds: 3));

    expect(viewModel.state.companies.length != 0, true);
  });
}
