import 'package:NextApp/new_version/core/network/api_constance.dart';
import 'package:NextApp/new_version/modules/dashboard/data/models/counter_model.dart';
import 'package:NextApp/new_version/modules/dashboard/data/models/dashboard_model.dart';
import 'package:NextApp/new_version/modules/dashboard/data/models/tap_view_models/employee_checking_model.dart';
import 'package:NextApp/new_version/modules/dashboard/data/models/tap_view_models/leave_app_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../models/get_total_sales_invoice_filters.dart';
import '../models/tap_view_models/attendace_request_model.dart';
import '../models/tap_view_models/task_model.dart';

abstract class BaseDashboardDataDataSource {
  Future<DashboardModel> getDashboardData(TotalFilters filters);

  Future<CounterModel> getTotalData(TotalFilters filters);

  Future<List<TaskModel>> getTaskList();

  Future<List<LeaveApplicationModel>> getLeaveApplicationList();

  Future<List<EmployeeCheckingModel>> getEmployeeCheckingList();

  Future<List<AttendanceRequestModel>> getAttendanceRequestList();

  // Future<CounterModel> getCustomerVisitCount(TotalFilters filters);
}

class DashboardDataSourceByDio implements BaseDashboardDataDataSource {
  final BaseDioHelper _dio;

  const DashboardDataSourceByDio(this._dio);

  @override
  Future<DashboardModel> getDashboardData(TotalFilters filters) async {
    final response = await _dio.get(
      endPoint: ApiConstance.getDashboardData,
      query: {
        'from_date': filters.fromDate,
        'to_date':filters.toDate,
      },
    ) as Response;

    final _dashboardData = DashboardModel.fromJson(response.data['message']);

    return _dashboardData;
  }

  @override
  Future<CounterModel> getTotalData(TotalFilters filters) async {
    final response = await _dio.get(
      endPoint: ApiConstance.getTotal,
      query: {
        'from': filters.fromDate,
        'to': filters.toDate,
      },
    ) as Response;

    final _totalSalesInvoice = CounterModel.fromJson(response.data['data']);

    return _totalSalesInvoice;
  }

  @override
  Future<List<TaskModel>> getTaskList() async {
    final response = await _dio.get(
      endPoint: ApiConstance.generalListEndPoint,
      query: {
        'doctype': 'Task',
        'sort_field': 'creation',
        'sort_type': 'desc',
        'page_length': 5,
      },
    ) as Response;

    final _getTaskList = List.from(response.data['message'])
        .map((e) => TaskModel.fromJson(e))
        .toList();

    return _getTaskList;
  }

  @override
  Future<List<LeaveApplicationModel>> getLeaveApplicationList() async {
    final response = await _dio.get(
      endPoint: ApiConstance.generalListEndPoint,
      query: {
        'doctype': 'Leave Application',
        'sort_field': 'creation',
        'sort_type': 'desc',
        'page_length': 5,
      },
    ) as Response;

    final _list = List.from(response.data['message'])
        .map((e) => LeaveApplicationModel.fromJson(e))
        .toList();

    return _list;
  }

  @override
  Future<List<EmployeeCheckingModel>> getEmployeeCheckingList() async {
    final response = await _dio.get(
      endPoint: ApiConstance.generalListEndPoint,
      query: {
        'doctype': 'Employee Checkin',
        'sort_field': 'creation',
        'sort_type': 'desc',
        'page_length': 5,
      },
    ) as Response;

    final _list = List.from(response.data['message'])
        .map((e) => EmployeeCheckingModel.fromJson(e))
        .toList();

    return _list;
  }

  @override
  Future<List<AttendanceRequestModel>> getAttendanceRequestList() async {
    final response = await _dio.get(
      endPoint: ApiConstance.generalListEndPoint,
      query: {
        'doctype': 'Attendance Request',
        'sort_field': 'creation',
        'sort_type': 'desc',
        'page_length': 5,
      },
    ) as Response;

    final _list = List.from(response.data['message'])
        .map((e) => AttendanceRequestModel.fromJson(e))
        .toList();

    return _list;
  }
}
