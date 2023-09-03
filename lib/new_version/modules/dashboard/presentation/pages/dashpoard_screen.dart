import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/dasboard_bloc.dart';
import '../widgets/get_total_widget.dart';
import '../widgets/dashboard_tap_view.dart';
import '../bloc/total_bloc/total_bloc.dart';
import '../../../../../core/constants.dart';
import '../../../../core/resources/routes.dart';
import '../widgets/chart_dashboard_widget.dart';
import '../../../../core/utils/error_dialog.dart';
import '../../../../core/utils/request_state.dart';
import '../bloc/transaction_bloc/transaction_bloc.dart';
import '../../../../../provider/user/user_provider.dart';
import '../../data/models/get_total_sales_invoice_filters.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../user_profile/presentation/pages/user_profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    final totalBloc = BlocProvider.of<TotalBloc>(context);
    final tabViewBloc = BlocProvider.of<TransactionBloc>(context);

    dashboardBloc.add(GetDashboardDataEvent(
      dateFilter: TotalFilters(
        fromDate: DateTime.now().formatDateYMD(),
        toDate: DateTime.now().formatDateYMD(),
      ),
    ));
    return RefreshIndicator(
      onRefresh: () async {
        totalBloc.add(
          GetTotalEvent(
            totalSalesInvoiceFilters: TotalFilters(
              fromDate: DateTime.now().formatDateYMD(),
              toDate: DateTime.now().formatDateYMD(),
            ),
          ),
        );
        dashboardBloc.add(GetDashboardDataEvent(
          dateFilter: TotalFilters(
            fromDate: DateTime.now().formatDateYMD(),
            toDate: DateTime.now().formatDateYMD(),
          ),
        ));
        tabViewBloc.add(const GetTaskEvent());
        tabViewBloc.add(const GetLeaveApplicationEvent());
        tabViewBloc.add(const GetEmployeeCheckingEvent());
        tabViewBloc.add(const GetAttendanceRequestEvent());
        return Future.delayed(const Duration(seconds: 3), () {});
      },
      child: Scaffold(
        body: BlocConsumer<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state.getDashboardState == RequestState.error) {
              Navigator.of(context).pushReplacementNamed(Routes.noDataScreen);
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  errorMessage: state.getDashboardMessage,
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              previous.dashboardEntity != current.dashboardEntity,
          builder: (context, state) {
            return Stack(
              children: [
                /// Const background image
                Container(
                  height: 230,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: APPBAR_COLOR,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    right: 10,
                    left: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          /// User profile
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              "${context.read<UserProvider>().url}${state.dashboardEntity.userImage!}",
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.dashboardEntity.userFullName!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Let's go back to work.".tr(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const UserProfileScreen();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 100.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.amberAccent,
                              ),
                              child: Center(
                                child: Text(
                                  'Profile'.tr(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const GetTotalWidget(),
                            const SizedBox(height: 10),
                            ChartDashboardWidget(
                                data: state.dashboardEntity.barChart!,),
                            const SizedBox(
                              height: 700,
                              child: DashboardTapView(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
