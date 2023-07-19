import 'package:NextApp/bloc/custom_form_bloc/cubit/custom_from_cubit_cubit.dart';
import 'package:NextApp/new_version/modules/new_item/presentation/bloc/new_item_bloc.dart';

import '../../modules/dashboard/presentation/bloc/dasboard_bloc.dart';
import '../../modules/dashboard/presentation/bloc/total_bloc/total_bloc.dart';
import '../../modules/reports/features/accounts_reports/presentation/bloc/general_ledger_bloc/general_ledger_bloc.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/item_price_bloc/item_price_bloc.dart';

import '../../modules/dashboard/presentation/bloc/transaction_bloc/transaction_bloc.dart';
import '../../modules/reports/common/GeneralReports/presentation/bloc/generalreports_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../global/dependency_container.dart' as di;
import '../../../provider/user/user_provider.dart';
import '../../../provider/module/module_provider.dart';
import '../../modules/faq/presentation/bloc/faq_bloc.dart';
import '../../modules/user_profile/presentation/bloc/user_profile_bloc.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/stock_ledger_bloc/stock_ledger_bloc.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/stock_warehouse_report/stockreports_bloc.dart';

class StateManagement {
  static dynamic stateManagement = [
    ChangeNotifierProvider<ModuleProvider>(
      create: (_) => ModuleProvider(),
    ),
    ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
    BlocProvider(create: (_) => di.sl<GeneralReportsBloc>()),
    BlocProvider(create: (_) => di.sl<GeneralLedgerBloc>()),
    BlocProvider(create: (_) => di.sl<StockReportsBloc>()),
    BlocProvider(create: (_) => di.sl<StockLedgerBloc>()),
    BlocProvider(create: (_) => di.sl<ItemPriceBloc>()),
    BlocProvider(create: (_) => di.sl<FaqBloc>()),
    BlocProvider(
        create: (context) => di.sl<UserProfileBloc>()
          ..add(GetUserProfileDataEvent(
              userName: context.read<UserProvider>().userId))),
    BlocProvider(create: (_) => di.sl<TotalBloc>()),
    BlocProvider(create: (_) => di.sl<DashboardBloc>()),
    BlocProvider(create: (_) => di.sl<TransactionBloc>()),
    BlocProvider(create: (_) => CustomFromCubitCubit()),
    BlocProvider(create: (_) => di.sl<NewItemBloc>()),
  ];
}
