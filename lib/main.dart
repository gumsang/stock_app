import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/data/data_source/local/stock_dao.dart';
import 'package:stock_app/data/data_source/remote/stock_api.dart';
import 'package:stock_app/data/repository/stock_repository_impl.dart';
import 'package:stock_app/presentation/company_listings/company_listings_screen.dart';
import 'package:stock_app/presentation/company_listings/company_listings_view_model.dart';
import 'package:stock_app/util/color_schemes.g.dart';

import 'data/data_source/local/company_listing_entity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.registerAdapter(CompanyListingEntityAdapter());
  Hive.init(appDocumentDirectory.path);

  // Hive.init(null);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: ((context) => CompanyListingsViewModel(
              StockRepositoryImpl(StockApi(), StockDao()))))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      themeMode: ThemeMode.system,
      home: const CompanyListingsScreen(),
    );
  }
}
