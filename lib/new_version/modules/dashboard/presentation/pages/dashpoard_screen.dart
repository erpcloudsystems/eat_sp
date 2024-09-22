import 'package:NextApp/screen/other/notification_screen.dart';
import 'package:NextApp/widgets/custom_loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../bloc/dasboard_bloc.dart';
import '../widgets/get_total_widget.dart';
import '../bloc/total_bloc/total_bloc.dart';
import '../widgets/chart_dashboard_widget.dart';
import '../../../../core/utils/error_dialog.dart';
import '../../../../core/utils/request_state.dart';
import '../bloc/transaction_bloc/transaction_bloc.dart';
import '../../../../../provider/user/user_provider.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../data/models/get_total_sales_invoice_filters.dart';
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
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state.getDashboardState == RequestState.error) {
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
          if (state.getDashboardState == RequestState.loading) {
            return const CustomLoadingWithImage();
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                elevation: 0,
                title: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      /// User profile
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
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                "${context.read<UserProvider>().url}${state.dashboardEntity.userImage!}",
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              state.dashboardEntity.userFullName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const NotificationScreen();
                                },
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications,
                            size: 30,
                          )),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const GetTotalWidget(),
                    const SizedBox(height: 10),
                    ChartDashboardWidget(
                      data: state.dashboardEntity.barChart!,
                    ),
                    // const SizedBox(
                    //   height: 700,
                    //   child: DashboardTapView(),
                    // ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
