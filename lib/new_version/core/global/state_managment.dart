import '../../modules/reports/common/GeneralReports/presentation/bloc/generalreports_bloc.dart';

import '../../modules/project/doctypes/task/presentation/bloc/task_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../provider/module/module_provider.dart';
import '../../../provider/user/user_provider.dart';
import '../../modules/reports/features/stockReports/presentation/bloc/stockreports_bloc.dart';
import '../global/dependency_container.dart' as di;

class StateManagement {
  static dynamic stateManagement = [
    ChangeNotifierProvider<ModuleProvider>(create: (_) => ModuleProvider()),
    ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
    BlocProvider(create: (_) => di.sl<GeneralReportsBloc>()),
    BlocProvider(create: (_) => di.sl<StockReportsBloc>()),
    BlocProvider(create: (_) => di.sl<TaskBloc>()),
  ];
}
