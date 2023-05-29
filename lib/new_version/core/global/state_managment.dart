import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../global/dependency_container.dart' as di;
import '../../../provider/user/user_provider.dart';
import '../../../provider/module/module_provider.dart';
import '../../modules/user_profile/presentation/bloc/user_profile_bloc.dart';
import '../../modules/reports/common/GeneralReports/presentation/bloc/generalreports_bloc.dart';
import '../../modules/reports/features/accounts_reports/presentation/bloc/general_ledger_bloc/general_ledger_bloc.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/item_price_bloc/item_price_bloc.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/stock_ledger_bloc/stock_ledger_bloc.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/stock_warehouse_report/stockreports_bloc.dart';

class StateManagement {
  static dynamic stateManagement = [
    ChangeNotifierProvider<ModuleProvider>(create: (_) => ModuleProvider()),
    ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
    BlocProvider(create: (_) => di.sl<GeneralReportsBloc>()),
    BlocProvider(create: (_) => di.sl<GeneralLedgerBloc>()),
    BlocProvider(create: (_) => di.sl<StockReportsBloc>()),
    BlocProvider(create: (_) => di.sl<StockLedgerBloc>()),
    BlocProvider(create: (_) => di.sl<ItemPriceBloc>()),
    BlocProvider(
        create: (context) => di.sl<UserProfileBloc>()
          ..add(GetUserProfileDataEvent(
              userName: context.read<UserProvider>().userId))),
  ];
}
