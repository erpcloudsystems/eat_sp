import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/strings_manager.dart';
import 'transaction_card.dart';
import '../../../../../core/constants.dart';
import '../../../../../provider/module/module_provider.dart';
import '../../../../../widgets/custom-button.dart';
import '../bloc/transaction_bloc/transaction_bloc.dart';
import '../../domain/entities/tap_view_entity/task_entity.dart';

class DashboardTapView extends StatelessWidget {
  const DashboardTapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TransactionBloc>(context);

    bloc.add(const GetTaskEvent());
    bloc.add(const GetLeaveApplicationEvent());
    bloc.add(const GetAttendanceRequestEvent());
    bloc.add(const GetEmployeeCheckingEvent());

    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 800),
      length: 4,
      child: BlocConsumer<TransactionBloc, TransactionState>(
        // listenWhen: (previous, current) =>
        //     previous.getTaskState != current.getTaskState &&
        //     previous.getAttendanceState != current.getAttendanceState &&
        //     previous.getEmployeeState != current.getEmployeeState &&
        //     previous.getLeaveState != current.getLeaveState,
        // buildWhen: (previous, current) =>
        //     previous.getTaskList != current.getTaskList &&
        //     previous.getAttendanceRequestList !=
        //         current.getAttendanceRequestList &&
        //     previous.getEmployeeCheckingList !=
        //         current.getEmployeeCheckingList &&
        //     previous.getLeaveApplicationList != current.getLeaveApplicationList,
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: const TabBar(
                  unselectedLabelColor: Colors.black38,
                  labelStyle: TextStyle(
                    fontSize: 18,
                  ),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      icon: Text(DocTypesName.task),
                    ),
                    Tab(
                      icon: Text(DocTypesName.leaveApplication),
                    ),
                    Tab(
                      icon: Text(StringsManager.employeeCheckIn),
                    ),
                    Tab(
                      icon: Text(DocTypesName.attendanceRequest),
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                ///Task
                customListView(
                  listData: state.getTaskList,
                  title: DocTypesName.task,
                  context: context,
                ),

                /// Leave Application
                customListView(
                  listData: state.getLeaveApplicationList,
                  title: DocTypesName.leaveApplication,
                  context: context,
                ),

                /// Employee Checkin
                customListView(
                  listData: state.getEmployeeCheckingList,
                  title: DocTypesName.employeeCheckin,
                  context: context,
                ),

                /// Attendance Request
                customListView(
                  listData: state.getAttendanceRequestList,
                  title: DocTypesName.attendanceRequest,
                  context: context,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget customListView({
    required List<TapViewEntity> listData,
    required String title,
    required BuildContext context,
  }) {
    var moduleProvider = Provider.of<ModuleProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listData.length,
            itemBuilder: (context, index) {
              return TransactionCard(
                docType: title,
                title: listData[index].title,
                subTitle: listData[index].subtitle,
                name: listData[index].name,
                status: listData[index].status,
                type: listData[index].type,
                image: 'assets/$title.png',
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomButton(
            text: title == DocTypesName.employeeCheckin
                ? 'Create ${StringsManager.employeeCheckIn}'
                : "Create $title",
            color: APPBAR_COLOR,
            onPressed: () {
              moduleProvider.setModule = title;
              moduleProvider.iAmCreatingAForm();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      moduleProvider.currentModule.createForm!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
