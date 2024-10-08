import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:NextApp/new_version/core/extensions/html_reponse.dart';
import 'package:NextApp/new_version/core/network/api_constance.dart';

import '../models/list_models/statistics_model.dart';
import '../models/new_version_models/check_url_validation_model.dart';
import '../new_version/core/global/global_variables.dart';
import '../new_version/core/resources/strings_manager.dart';
import '../new_version/core/utils/error_dialog.dart';
import '../provider/module/module_type.dart';
import 'server_exception.dart';
import 'service_constants.dart';
import '../widgets/snack_bar.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../widgets/dialog/loading_dialog.dart';
import '../../core/constants.dart';
import '../models/list_models/list_model.dart';

class APIService {
  //Selling model
  static const LEAD = 'Lead';
  static const OPPORTUNITY = 'Opportunity';
  static const OPPORTUNITY_TYPE = 'Opportunity Type';
  static const CUSTOMER = 'Customer';
  static const CUSTOMER_GROUP = 'Customer Group';
  static const QUOTATION = 'Quotation';
  static const SALES_ORDER = 'Sales Order';
  static const SALES_INVOICE = 'Sales Invoice';
  static const PAYMENT_ENTRY = 'Payment Entry';
  static const CUSTOMER_VISIT = 'Customer Visit';

  //Stock model
  static const ITEM = 'Item';
  static const STOCK_ENTRY = 'Stock Entry';
  static const DELIVERY_NOTE = 'Delivery Note';
  static const PURCHASE_RECEIPT = 'Purchase Receipt';
  static const MATERIAL_REQUEST = 'Material Request';
  static const DRIVER = 'Driver';
  static const VEHICLE = 'Vehicle';

  //Buying module
  static const SUPPLIER = 'Supplier';
  static const SUPPLIER_GROUP = 'Supplier Group';
  static const SUPPLIER_QUOTATION = 'Supplier Quotation';
  static const PURCHASE_INVOICE = 'Purchase Invoice';
  static const PURCHASE_ORDER = 'Purchase Order';

  // HR
  static const EMPLOYEE = 'Employee';
  static const LEAVE_APPLICATION = 'Leave Application';
  static const EMPLOYEE_CHECKIN = 'Employee Checkin';
  static const ATTENDANCE_REQUEST = 'Attendance Request';
  static const EMPLOYEE_ADVANCE = 'Employee Advance';
  static const EXPENSE_CLAIM = 'Expense Claim';
  static const LOAN_APPLICATION = 'Loan Application';
  static const JOURNAL_ENTRY = 'Journal Entry';
  static const COMPANY = 'Company';
  static const HOLIDAY_LIST = 'Holiday List';
  static const DEFAULT_SHIFT = 'Default Shift';

  static const NOTIFICATION_LOG = 'Notification Log';
  static const TERRITORY = 'Territory';
  static const COUNTRY = 'Country';
  static const CURRENCY = 'Currency';
  static const PRICE_LIST = 'Price List';
  static const BUYING_PRICE_LIST = 'Buying Price List';
  static const FILTERED_ADDRESS = 'Filtered Address';
  static const ADDRESS = 'Address';
  static const FILTERED_CONTACT = 'Filtered Contact';
  static const CONTACT = 'Contact';
  static const COST_CENTER = 'Cost Center';
  static const MODE_OF_PAYMENT = 'Mode of Payment';
  static const ASSET_CATEGORY = 'Asset Category';
  static const TERMS_CONDITION = 'Terms and Conditions';
  static const PAYMENT_TERMS = 'Payment Terms Template';
  static const WAREHOUSE = 'Warehouse';
  static const SOURCE = 'Lead Source';
  static const CAMPAIGN = 'Campaign';
  static const MARKET_SEGMENT = 'Market Segment';
  static const INDUSTRY = 'Industry Type';
  static const SALES_PERSON = 'Sales Person';
  static const USER_TYPE = 'User';
  static const SALES_PARTNER = 'Sales Partner';
  static const DEPARTMENT = 'Department';
  static const PROJECT_TEMPLATE = 'Project Template';
  static const DESIGNATION = 'Designation';
  static const BRANCH = 'Branch';
  static const LEAVE_TYPE = 'Leave Type';
  static const EMPLOYMENT_TYPE = 'Employment Type';
  static const LEAVE_APPROVER = 'User';
  static const EXPENSE_CLAIM_TYPE = 'Expense Claim Type';
  static const GENDER = 'Gender';
  static const ACCOUNT = 'Account';
  static const LOAN_TYPE = 'Loan Type';
  static const BANK_ACCOUNT = 'Bank Account';

  // Project module
  static const TASK = 'Task';
  static const PROJECT = 'Project';
  static const PROJECT_TYPE = 'Project Type';
  static const TIMESHEET = 'Timesheet';
  static const ISSUE = 'Issue';
  static const ISSUE_TYPE = 'Issue Type';
  static const TASK_TYPE = 'Task Type';
  static const STATUS = 'Status';
  static const ACTIVITY = 'Activity Type';
  static const ITEM_GROUP = 'Item Group';

  //Workflow
  static const WORKFLOW = 'Workflow';

  static const DOC_TYPE = 'DocType';

  // Reports
  static const REPORTS = 'Mobile Report';

  // Manufacturing
  static const QUALITY_INSPECTION_TEMPLATE = 'Quality Inspection Template';
  static const WORKSTATION = 'Workstation';
  static const WORK_ORDER = 'Work Order';
  static const OPERATION = 'Operation';
  static const JOBCARD = 'Job Card';
  static const BATCH = 'Batch';
  static const BOM = 'BOM';

  final BaseOptions options = BaseOptions(
    connectTimeout: ApiConstance.connectionTimeOut,
    receiveTimeout: ApiConstance.connectionTimeOut,
    followRedirects: false,
    validateStatus: (status) => true,
  );
  Dio dio = Dio();

  Map<String, String> _cookie = {};

  var cookieJar = CookieJar(ignoreExpires: true);
  static final APIService _instance = APIService._();

  factory APIService() => _instance;

  APIService._() {
    dio = Dio(options);
    dio.interceptors.add(CookieManager(cookieJar));
    GlobalVariables().setCookiesForNewVersion = cookieJar;
  }

  void changeUrl(String url) {
    _instance.dio.options.baseUrl = '$url/api/';
    print('☕️ ${dio.options.baseUrl}');

    // Here we set the Base url for the new version services.
    final globalVariables = GlobalVariables();
    globalVariables.setBaseUrl = '$url/api/';
  }

  Map<String, String> get getHeaders => _cookie;

  Future<void> logout(String url) async {
    final response = await dio.get(url);
    print('Logout out : ${response.realUri}');
    print('Logout out : ${response.data}');
    print('Logout out successfully');
  }

  Future<bool> checkUrlValidation(String url) async {
    try {
      final response = await dio.get(
          'https://nextapp.mobi/api/method/ecs_ecs.api.check_domain?url=$url');
      log(response.toString());
      final CheckUrlValidationModel data =
          CheckUrlValidationModel.fromJson(response.data);
      if (data.message == 'Domain Is Active') {
        return true;
      }
      if (data.message == 'Domain Is Inactive') {
        return false;
      }
    } on DioException catch (error) {
      log(error.message ?? StringsManager.unknownError,
          name: 'check url error');
      throw ServerException(error.message ?? StringsManager.unknownError);
    }
    return false;
  }

  Future<Map<String, dynamic>?> login(
      String url, Map<String, dynamic> body) async {
    try {
      final response = await dio.get(url, queryParameters: body);
      print('statusCode: ${response.statusCode}');
      print(response.data['message']);
      print(response.data);

      print(response.headers);

      //get cooking from response
      final cok = response.headers.map['set-cookie']?.first;
      _cookie = {'Cookie': cok ?? ''};

      print('☕️### cookies: $_cookie');
      //   print(response?.headers.toString());

      if (response.statusCode == 200) {
        print("login request${response.data}");
        print("login response$response");

        return Map<String, dynamic>.from(response.data);
      } else if (response.data['message'] != null) {
        throw ServerException((response.data['message']).toString());
      }
    } on ServerException catch (e) {
      rethrow;
    } on DioException catch (ex) {
      print(ex.type);
      if (ex.type == DioExceptionType.connectionTimeout) {
        throw const ServerException("Connection Timeout");
      } else if (ex.type == DioExceptionType.unknown) {
        throw const ServerException("Connection Timeout");
      }

      print(ex.message);
      throw Exception(ex.message);
    } catch (error, stacktrace) {
      print("login Exception occurred: $error stackTrace: $stacktrace");
      throw Exception("something went wrong");
    }
    return null;
  }

  Future<ListModel<T>?> getList<T>(
    String service,
    int pageCount,
    ListModel<T> Function(Map<String, dynamic>) dataParser, {
    String? filterById,
    String? connection,
    String? search,
    String? customServiceURL,
    ModuleType? module,
    Map<String, dynamic>? filters,
  }) async {
    if (search != null && search.isNotEmpty) print('search: $search');
    try {
      var response = await dio.get(
          customServiceURL ?? 'method/eat_mobile.general.general_service',
          queryParameters: {
            if (customServiceURL == null) 'doctype': service,
            if (filterById != null) "cur_nam": filterById,
            if (connection != null) "con_doc": connection,
            if (search != null && search.isNotEmpty) 'search_text': '%$search%',
            if (filters != null) ...filters,
            "start": pageCount,
            "page_length": PAGINATION_PAGE_LENGTH
          });
      print('getList filters:');
      print(filters);
      print("getList request ${response.realUri}");
      print(response.data);
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        print("getList response$response");
        if (myMap['message'] is String) {
          return ListModel<T>(<T>[]);
        }
        return dataParser(myMap);
      }
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "getList Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "getList Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return null;
  }

  Future<String> getListCount<T>({
    required String service,
    String? search,
    Map<String, dynamic>? filters,
  }) async {
    try {
      var response = await dio
          .get('method/eat_mobile.count.general_service', queryParameters: {
        'doctype': service,
        "page_length": 0,
        if (search != null && search.isNotEmpty) 'search_text': '%$search%',
        if (filters != null) ...filters
      });
      print("getListCount request ${response.realUri}");
      print(response.data);
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        print("getList response$response");
        return myMap['message']['count'].toString();
      }
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "getListCount Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "getListCount Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return '0';
  }

  Future<Map<String, dynamic>> getPage(String url, String id) async {
    try {
      var response = await dio.get(url, queryParameters: {"name": id});
      print("request${response.realUri.path}");
      print(response.realUri);
      print(response.requestOptions.uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        print("request${response.realUri.path}");
        print("response$response");

        print(myMap);
        return response.data;
      } else {
        print("response$response");
        return {};
      }
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return {};
  }

  Future<ListModel<T>?> getCustomList<T>(String url, int pageCount,
      ListModel<T> Function(Map<String, dynamic>) dataParser,
      {String search = ""}) async {
    try {
      var response = await dio.get(url, queryParameters: {
        if (search.isNotEmpty) 'search_text': '%$search%',
        "start": pageCount,
        "page_length": PAGINATION_PAGE_LENGTH
      });
      print("getCustomList request${response.realUri}");
      print(response.data);
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        print("getCustomList response$response");

        if (myMap['message'] is String) return null;
        return dataParser(myMap);
      }
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "getCustomList Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "getCustomList Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> genericGet(String url,
      [Map<String, dynamic>? queryParameters]) async {
    try {
      var response = await dio.get(url,
          queryParameters: (queryParameters != null) ? queryParameters : {});
      print("genericGet request${response.realUri.path}");
      print("genericGet request ${response.realUri}");

      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        print("genericGet request${response.realUri.path}");
        print("genericGet request ${response.realUri}");
        print("genericGet response$response");

        print(myMap);
        return response.data;
      } else {
        return {};
      }
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "genericGet Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "genericGet Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return {};
  }

  Future postRequest(String url, Map<String, dynamic> data) async {
    print('⚠️ Post this data: $data');
    try {
      final response = await dio.post(url, data: data);
      print(response.requestOptions.uri);
      print("request${response.realUri.path}");
      print("response$response");
      print(response.data);
      print('${response.statusCode}');

      if (response.statusCode == 200) return response.data;

      throw ServerException('something went wrong!!$response');
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        }
        print(
            "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        throw const ServerException('something went wrong :(');
      }
    }
  }

  Future patchRequest(String url, Map<String, dynamic> data) async {
    print('⚠️ Post this data: $data');
    try {
      final response = await dio.patch(url, data: data);
      print(response.requestOptions.uri);
      print("request${response.realUri.path}");
      print("response$response");
      print(response.data);
      print('${response.statusCode}');

      if (response.statusCode == 200) return response.data;

      throw ServerException('something went wrong!!$response');
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        }
        print(
            "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        throw const ServerException('something went wrong :(');
      }
    }
  }

  ///Check doc type has workflow
  Future hasWorkflow({String? docTypeName}) async {
    try {
      final response = await dio.post(
        'method/eat_mobile.workflow.has_workflow',
        data: {
          'doctype': docTypeName,
        },
      );
      print('_____________________AAAAAAAAA_____________________');
      print(response.data);
      print('_____________________AAAAAAAAA_____________________');
      if (response.statusCode == 200) return response.data['message'];

      throw ServerException('something went wrong!!$response');
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        }
        print(
            "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        throw const ServerException('something went wrong :(');
      }
    }
  }

  Future updatePage(String moduleId, Map<String, dynamic> data) async {
    try {
      final response = await dio.put('resource/$moduleId', data: data);
      print('request data: ');
      print(data);
      print(response.requestOptions.uri);
      print("request${response.realUri.path}");
      print("response$response");
      print(response.data);
      print(response.statusCode);

      if (response.statusCode == 200) return response.data;
      throw ServerException('something went wrong!!$response');
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        }
        print(
            "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        throw const ServerException('something went wrong :(');
      }
    }
  }

  Future<void> postFile(String docType, String id, File attachment) async {
    //encoding the file to base64 String
    final bytes = await attachment.readAsBytes();
    String encodedFile = base64Encode(bytes);

    ///file name
    String fileName = attachment.uri.pathSegments.last;

    try {
      final response = await dio.post(ATTACH_FILE, data: {
        'doctype': docType,
        'docname': id,
        'filename': fileName,
        'filedata': encodedFile,
        'decode_base64': 1
      });
      print(dio.options.baseUrl);
      print("PostFile Request${response.realUri}");
      print(response.requestOptions.uri);
      print("PostFile Response $response");
      print(response.data);
      print(response.statusCode);

      if (response.statusCode == 200) return response.data;

      throw const ServerException('something went wrong :(');
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        }
        print(
            "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        throw const ServerException('something went wrong :(');
      }
    }
  }

  Future<bool?> submitDoc(String id, String docType) async {
    try {
      var response = await dio
          .put(SUBMIT_DOC, queryParameters: {'doctype': docType, 'name': id});

      print("request ${response.realUri.path}");
      print(response.statusCode);
      print("response$response");

      if (response.statusCode == 200) {
        print("request${response.realUri.path}");

        final data = Map<String, dynamic>.from(response.data);

        if (data['message']['success_key'] == true) return true;
      } else {
        throw SubmitException(
            title: response.data['exc_type'],
            message: response.data['exception']);
      }
    } on SubmitException catch (e) {
      throw SubmitException(title: e.title, message: e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          log("Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          log("Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return null;
  }

  Future<bool?> cancelDoc(String id, String docType) async {
    try {
      var response = await dio
          .put(CANCEL_DOC, queryParameters: {'doctype': docType, 'name': id});

      print("request ${response.realUri.path}");
      print(response.statusCode);
      print("response$response");

      if (response.statusCode == 200) {
        print("request${response.realUri.path}");

        final data = Map<String, dynamic>.from(response.data);

        if (data['message']['success_key'] == true) return true;
      }
      throw const ServerException('something went wrong :(');
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return null;
  }

  void printInvoice({
    required BuildContext context,
    required String docType,
    required String id,
    required String format,
  }) async {
    showLoadingDialog(context, 'Printing ...');

    try {
      final response = await dio.get(
        PRINT_INVOICE,
        queryParameters: {'doctype': docType, 'name': id, 'format': format},
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: ApiConstance.receiveTimeOut, // 30 seconds
          validateStatus: (status) {
            if (status == null) return false;
            return status < 500;
          },
        ),
      );
      Navigator.pop(context);

      debugPrint(response.realUri.origin);
      debugPrint(response.realUri.path);
      debugPrint({'doctype': docType, 'name': id, 'format': format}.toString());

      await Printing.layoutPdf(
          onLayout: (format) async => response.data, format: PdfPageFormat.a4);
    } catch (e) {
      Navigator.pop(context);
      debugPrint(e.toString());
      if (e is DioException &&
          (e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout)) {
        Fluttertoast.showToast(msg: 'connection time out');
      } else {
        Fluttertoast.showToast(msg: 'something went wrong :(');
      }
    }
  }

  Future<void> openFile(
      {required String url,
      required String fileName,
      required BuildContext context,
      Map<String, dynamic>? queryParameters}) async {
    showLoadingDialog(context, 'Opening $fileName');
    await handleRequest(
        () async {
          debugPrint('open file method: ');
          debugPrint(url);
          debugPrint(fileName);
          debugPrint(queryParameters.toString());

          await downloadFile(url, fileName, queryParameters: queryParameters);
        },
        context,
        () {
          Fluttertoast.showToast(msg: 'something went wrong :(');
        }).then((file) {
      Navigator.pop(context);
      if (file is File) OpenFile.open(file.path);
    });
  }

  Future<List<StatisticsModel>?> getStatisticsList({String? docType}) async {
    try {
      final response = await dio.get(
        'method/eat_mobile.doctype_statistics.doc_stats',
        queryParameters: {
          'doctype': docType,
        },
      );
      if (response.statusCode == 200) {
        print('-------------------$docType-------------------------');
        print(response.data['message']);
        return List<StatisticsModel>.from(
          (response.data['message'] as List).map(
            (e) => StatisticsModel.fromJson(e),
          ),
        );
      }
      throw const ServerException('something went wrong :(');
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return null;
  }

  /// Download file into private folder not visible to user
  Future<File?> downloadFile(String url, String name,
      {Map<String, dynamic>? queryParameters, String? path}) async {
    debugPrint(url);

    try {
      path ??= (await getApplicationDocumentsDirectory()).path;

      debugPrint(url);
      debugPrint(path);
      debugPrint(name);
      debugPrint(queryParameters.toString());

      final file = File('$path/$name');
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: ApiConstance.receiveTimeOut, // 30 seconds
          validateStatus: (status) {
            if (status == null) return false;
            return status < 500;
          },
        ),
      );

      debugPrint("request ${response.realUri.path}");
      debugPrint(response.statusCode.toString());

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      raf.closeSync();
      return file;
    } on DioException catch (e) {
      debugPrint(e.message);
      if (e.type == DioExceptionType.connectionTimeout) {
        throw const ServerException('connection time out');
      } else {
        throw const ServerException('something went wrong :(');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw const ServerException('something went wrong :(');
    }
  }

  Future<bool?> comment(String module, String id, String comment) async {
    print(module);
    print(id);
    try {
      var response = await dio.post(COMMENT, data: {
        "data": {
          "doctype": "Comment",
          "comment_type": "Comment",
          "reference_doctype": module,
          "reference_name": id,
          "content": comment,
        }
      });

      print("request ${response.realUri.path}");
      print(response.statusCode);
      print(response.data);
      print("response$response");

      if (response.statusCode == 200) {
        print("request${response.realUri.path}");

        final data = Map<String, dynamic>.from(response.data);

        if (data['message']['success_key'] == true) return true;
      } else {
        throw const ServerException('something went wrong :(');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return false;
  }

  Future<bool?> sendNotificationToken(
      String token, String userId, String deviceType) async {
    print('➡️ Sending Device Token "$token" ');
    try {
      var response = await dio.post(NOTIFICATION, data: {
        "data": {
          "doctype": "Push Notification Details",
          "device_token": token,
          "user_id": userId,
          "device_type": deviceType,
        }
      });

      print("Send Notification Token request ${response.realUri.path}");
      print(response.statusCode);
      print(response.data);
      print("Send Notification Token request $response");

      if (response.statusCode == 200) {
        print("Send Notification Token request ${response.realUri.path}");

        final data = Map<String, dynamic>.from(response.data);

        if (data['message']['success_key'] == true) return true;
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return false;
  }

  Future updateNotificationToken(
      String token, String userId, String deviceType) async {
    print('➡️ Updating Device Token "$token" ');
    String name;
    final res = await genericGet(
        PUSH_NOTIFICATION_FILTER_USER_DEVICES, {'user_id': userId});
    if (res != {}) {
      name = res['message']['name'];
      print('➡️ name is: "$name" ');

      try {
        var response = await dio.put(
            UPDATE_NOTIFICATION_TOKEN + name.toString(),
            data: {"device_token": token});

        print("Updating Notification Token request ${response.realUri.path}");
        print(response.statusCode);
        print(response.data);
        print("Updating Notification Token request $response");

        if (response.statusCode == 200) {
          print("Updating Notification Token request ${response.realUri.path}");
          return Map<String, dynamic>.from(response.data);
        }
      } on ServerException catch (e) {
        throw ServerException(e.message);
      } catch (error, stacktrace) {
        if (error is DioException) {
          if (error.response?.data != null) {
            print(
                "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
          } else {
            print(
                "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
          }
        }
      }
    } else {
      return {};
    }
  }

  Future getImage(String image) async {
    try {
      var response = await dio.get(
        image,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: ApiConstance.receiveTimeOut,
          validateStatus: (status) {
            if (status == null) return false;
            return status < 500;
          },
        ),
      );
      print("request${response.realUri.path}");
      print(response.realUri);
      print(response.requestOptions.uri);

      if (response.statusCode == 200) {
        print("request${response.realUri.path}");
        print("response$response");

        return response.data;
      } else {
        print("response$response");
        return [];
      }
    } catch (error, stacktrace) {
      if (error is DioException) {
        if (error.response?.data != null) {
          print(
              "Exception occurred: ${error.response?.data.toString()} stackTrace: $stacktrace");
        } else {
          print(
              "Exception occurred: ${error.toString()} stackTrace: $stacktrace");
        }
      }
    }
    return {};
  }
}

///this function handles any API request & show snackBar on Exception
Future<dynamic> handleRequest(
    Future Function() serverRequest, BuildContext context,
    [VoidCallback? onException]) async {
  try {
    return await serverRequest();
  } on SubmitException catch (e) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) =>
          ErrorDialog(errorMessage: e.message.removeAllHtmlTags()),
    );
  } on ServerException catch (e) {
    print('HttpException: $e');
    showErrorSnackBar(
        e.message.split('!!').first, e.message.substring(22), context,
        color: Colors.red);
  } on TimeoutException catch (e) {
    // A timeout occurred.
    print('timeout exception: $e');
    showSnackBar('connection lost', context);
  } on SocketException catch (_) {
    print('SocketException: $_');
    showSnackBar('connection lost', context);
  } catch (e) {
    print('*** unhandled exception! ***: $e');
  }
  if (onException != null) onException();
  return false;
}
