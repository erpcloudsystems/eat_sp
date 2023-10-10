import 'dart:io';

import '../../models/list_models/list_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/cloud_system_widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../test/pdf_screen.dart';
import 'module_type.dart';
import '../../service/service.dart';
import '../user/user_provider.dart';
import '../../widgets/snack_bar.dart';
import '../../screen/page/page_screen.dart';
import '../../service/server_exception.dart';
import '../../service/service_constants.dart';
import '../../widgets/dialog/loading_dialog.dart';

class ModuleProvider extends ChangeNotifier {
  ModuleType? _currentModule;

  /// store current module and page_models data here temporary until the user pop the connection list
  final Map<String, dynamic> _oldData = {};

  Map<String, dynamic> _pageData = {};

  Map<String, dynamic> _createFromPageData = {};

  // detect weather the form need to load any data,
  // in order to update the page_models instead of creating new form
  bool _editPage = false;

  bool _createFromPage = false;

  bool _isLoading = false;

  bool _availablePdfFormat = false;

  bool _amendDoc = false;

  bool _isAmended = false;

  bool _duplicateMode = false;

  /// id of the pushing page_models
  String _pageId = '';
  String _previousPageId = '';
  String _totalListCount = '';
  String _loadCount = '';

  /// these to handle connections
  /// list service asks for extra parameters when querying for connection items
  String? _connection, _filterById;

  int? _pageSubmitStatus;

  /// this to handle filters data from FilterScreen
  Map<String, dynamic> _filter = {};

  /// Getters ///

  String get totalListCount => _totalListCount;

  String get loadCount => _loadCount;

  //Workflow list
  List<dynamic> workflowStates = [];
  List<dynamic> workflowTransitions = [];

  void setWorkflowStateList(Map<String, dynamic> data) {
    workflowStates.add(data);
    notifyListeners();
  }

  void setWorkflowTransitionsList(Map<String, dynamic> data) {
    workflowTransitions.add(data);
    notifyListeners();
  }

  /// Workflow ----------------------------------------------------------------
  bool getWorkflow = false;

  bool get hasWorkflow => getWorkflow;

  Future checkDocTypeWorkflow() async {
    getWorkflow =
        await APIService().hasWorkflow(docTypeName: currentModule.title);
    notifyListeners();
  }

  List<dynamic> actionsList = [];

  Future<void> getActionList() async {
    var response = await APIService().genericGet(
      WORKFLOW_ACTION_LIST,
      {
        'doctype': currentModule.title,
        'docname': pageId,
      },
    );
    actionsList = response['message'] ?? [];
    notifyListeners();
  }

  String? workflowStatus;
  Future<void> getWorkflowStatus() async {
    var response = await APIService().genericGet(
      WORKFLOW_STATUS,
      {
        'doctype': currentModule.title,
        'docname': pageId,
      },
    );
    workflowStatus = response['message'];
    notifyListeners();
  }

  //---------------------------------------------------------------------------
  //----------------------- New Items------------------------------------------
  List<Map<String, dynamic>> newItemList = [];
  double netTotal = 0.0;

  void set setNetTotal(double value) {
    netTotal = value;

    notifyListeners();
  }

  void setItemToList(Map<String, dynamic> item) {
    newItemList.add(item);
    item['amount'] = item['qty'] * item['rate'];

    notifyListeners();
  }

  List<String> getUOMList = [];

  Future<void> getUOM({required String itemCode}) async {
    var response = await APIService().genericGet(
      'method/ecs_mobile.general.get_item_uoms',
      {
        'item_code': itemCode,
      },
    );
    print(response);
    getUOMList = response['message']['uom'];
    notifyListeners();
  }
  //---------------------------------------------------------------------------

  int? get pageSubmitStatus => _pageSubmitStatus;

  Map<String, dynamic> get filter => _filter;

  bool get isEditing => _editPage;

  bool get isCreateFromPage => _createFromPage;

  String get pageId => _pageId;

  String get previousPageId => _previousPageId;

  bool get availablePdfFormat => _availablePdfFormat;

  bool get isLoading => _isLoading;

  bool get isAmendingMode => _amendDoc;

  bool get isAmended => _isAmended;

  bool get duplicateMode => _duplicateMode;

  /// used for connection card, to know if it is the first connection route to push or not
  bool get isSecondModule => _oldData.isNotEmpty;

  /// used for push create from page
  bool get isSecondCreateFromPage => _createFromPageData.isNotEmpty;

  set setCurrentModule(ModuleType module) => _currentModule = module;

  // pass by value not by reference
  Map<String, dynamic> get pageData => {..._pageData};

  Map<String, dynamic> get createFromPageData => {..._createFromPageData};

  Map<String, dynamic> get updateData {
    final data = pageData;
    data['set_posting_time'] = 1;

    data.remove('attachments');
    data.remove('comments');
    data.remove('print_formats');
    data.remove('conn');
    data.remove('payment_schedule');
    return data;
  }

  List<Map<String, dynamic>> get attachments =>
      List<Map<String, dynamic>>.from(_pageData['attachments'] ?? []);

  List<String> get pdfFormats =>
      List<Map<String, dynamic>>.from(_pageData['print_formats'] ?? {})
          .map((e) => e['name'].toString())
          .toList();

  ModuleType get currentModule => _currentModule!;

  Color? get color {
    Color? color = statusColor(_pageData['status'] ?? 'none');
    if (color == Colors.transparent) color = null;
    return color;
  }

  /// Setters ///
  set setLoadCount(String count) {
    _loadCount = count;
  }

  List<Map<String, dynamic>> _timeSheetData = [];

  set setTimeSheet(Map<String, dynamic> data) {
    _timeSheetData.add(data);
    notifyListeners();
  }

  set clearTimeSheet(List<Map<String, dynamic>> data) {
    _timeSheetData = data;
    notifyListeners();
  }

  List<Map<String, dynamic>> get getTimeSheetData => _timeSheetData;

// BOM Operations
  List<Map<String, dynamic>> _bomOperations = [];

  set setBomOperations(Map<String, dynamic> data) {
    _bomOperations.add(data);
    notifyListeners();
  }

  set clearBomOperations(List<Map<String, dynamic>> data) {
    _bomOperations = data;
    notifyListeners();
  }

  List<Map<String, dynamic>> get getBomOperations => _bomOperations;

  set filter(Map<String, dynamic> value) {
    _filter = value;
    notifyListeners();
  }

  void iAmCreatingAForm() {
    _editPage = false;
    _createFromPage = false;
  }

  void editThisPage() => _editPage = true;

  void createFromThisPage() => _createFromPage = true;

  set amendDoc(bool initialize) => _amendDoc = initialize;

  set NotifyAmended(bool amended) => _isAmended = amended;

  set setDuplicateMode(bool setMode) => _duplicateMode = setMode;

  set setEditingMode(bool setEdit) => _editPage = setEdit;

  set setModule(String doctype) {
    switch (doctype) {
      // Selling
      case APIService.LEAD:
        _currentModule = ModuleType.lead;
        break;
      case APIService.OPPORTUNITY:
        _currentModule = ModuleType.opportunity;
        break;
      case APIService.CUSTOMER:
        _currentModule = ModuleType.customer;
        break;
      case APIService.QUOTATION:
        _currentModule = ModuleType.quotation;
        break;
      case APIService.SALES_ORDER:
        _currentModule = ModuleType.salesOrder;
        break;
      case APIService.SALES_INVOICE:
        _currentModule = ModuleType.salesInvoice;
        break;
      case APIService.PAYMENT_ENTRY:
        _currentModule = ModuleType.paymentEntry;
        break;
      case APIService.CUSTOMER_VISIT:
        _currentModule = ModuleType.customerVisit;
        break;
      case APIService.ADDRESS:
        _currentModule = ModuleType.address;
        break;
      case APIService.CONTACT:
        _currentModule = ModuleType.contact;
        break;

      // Stock
      case APIService.ITEM:
        _currentModule = ModuleType.item;
        break;
      case APIService.STOCK_ENTRY:
        _currentModule = ModuleType.stockEntry;
        break;
      case APIService.DELIVERY_NOTE:
        _currentModule = ModuleType.deliveryNote;
        break;
      case APIService.PURCHASE_RECEIPT:
        _currentModule = ModuleType.purchaseReceipt;
        break;

      case APIService.MATERIAL_REQUEST:
        _currentModule = ModuleType.materialRequest;
        break;

      // Buying
      case APIService.SUPPLIER:
        _currentModule = ModuleType.supplier;
        break;
      case APIService.SUPPLIER_QUOTATION:
        _currentModule = ModuleType.supplierQuotation;
        break;
      case APIService.PURCHASE_INVOICE:
        _currentModule = ModuleType.purchaseInvoice;
        break;
      case APIService.PURCHASE_ORDER:
        _currentModule = ModuleType.purchaseOrder;
        break;
// HR
      case APIService.EMPLOYEE:
        _currentModule = ModuleType.employee;
        break;
      case APIService.LEAVE_APPLICATION:
        _currentModule = ModuleType.leaveApplication;
        break;
      case APIService.EMPLOYEE_CHECKIN:
        _currentModule = ModuleType.employeeCheckin;
        break;
      case APIService.ATTENDANCE_REQUEST:
        _currentModule = ModuleType.attendanceRequest;
        break;
      case APIService.EMPLOYEE_ADVANCE:
        _currentModule = ModuleType.employeeAdvance;
        break;
      case APIService.EXPENSE_CLAIM:
        _currentModule = ModuleType.expenseClaim;
        break;
      case APIService.LOAN_APPLICATION:
        _currentModule = ModuleType.loanApplication;
        break;
      case APIService.JOURNAL_ENTRY:
        _currentModule = ModuleType.journalEntry;
        break;

// Project
      case APIService.TASK:
        _currentModule = ModuleType.task;
        break;
      case APIService.TIMESHEET:
        _currentModule = ModuleType.timesheet;
        break;
      case APIService.PROJECT:
        _currentModule = ModuleType.project;
        break;
      case APIService.ISSUE:
        _currentModule = ModuleType.issue;
        break;

      case APIService.WORKFLOW:
        _currentModule = ModuleType.workflow;
        break;

// Manufacturing
      case APIService.BOM:
        _currentModule = ModuleType.bom;
        break;

      case APIService.JOBCARD:
        _currentModule = ModuleType.jobCard;
        break;
    }
    _filter.clear();
    notifyListeners();
  }

  /// used to load page_models page_models data and store it in the provider
  Future<void> loadPage() async {
    _isLoading = true;
    notifyListeners();
    final data =
        await APIService().getPage(_currentModule!.pageService, _pageId);
    if (data['message'] != null && data['message'] is Map) {
      _pageData = Map<String, dynamic>.from(data['message']);
      _pageSubmitStatus = data['message']['docstatus'];
      _availablePdfFormat = (_pageData['print_formats'] ?? []).isNotEmpty;
    }
    _isLoading = false;
    notifyListeners();
  }

  void pushPage(String pageId) {
    _availablePdfFormat = false;
    _pageData = {};
    _isLoading = true;
    _editPage = false;
    _pageId = pageId;
    loadPage();
  }

  /// used to create doc from doc
  void pushCreateFromPage(
      {required Map<String, dynamic> pageData, required String doctype}) {
    _createFromPage = true;
    _editPage = false;
    _createFromPageData = pageData;

    _createFromPageData['_pageData'] = _pageData;
    _createFromPageData['_pageId'] = _pageId;
    _createFromPageData['_availablePdfFormat'] = _availablePdfFormat;
    _createFromPageData['_currentModule'] = _currentModule;

    // this going to notify Listeners
    setModule = doctype;
  }

  void removeCreateFromPage() {
    //retrieve old data
    _pageData = _createFromPageData['_pageData'];
    _pageId = _createFromPageData['_pageId'];
    _availablePdfFormat = _createFromPageData['_availablePdfFormat'];
    _currentModule = _createFromPageData['_currentModule'];

    //to reset [_createFromPageData]
    _createFromPageData.clear();
    notifyListeners();
  }

  /// used to push new connection list route
  void pushConnection(String connection) {
    _filterById = _pageId;
    _connection = _currentModule!.genericListService;

    // to save the first route only (list & page_models)
    if (!isSecondModule) {
      _oldData['_pageData'] = _pageData;
      _oldData['_pageId'] = _pageId;
      _oldData['_availablePdfFormat'] = _availablePdfFormat;
      _oldData['_currentModule'] = _currentModule;
    }

    // this going to notify Listeners
    setModule = connection;
  }

  /// used to remove current connection module and retrieve the previous module
  void removeConnection() {
    _filterById = null;
    _connection = null;

    // retrieve old data
    _pageData = _oldData['_pageData'];
    _pageId = _oldData['_pageId'];
    _availablePdfFormat = _oldData['_availablePdfFormat'];
    _currentModule = _oldData['_currentModule'];

    // very important since it is used for [_isSecondModule] logic
    _oldData.clear();
    notifyListeners();
  }

  /// gets data for the [GenericListScreen]
  Future<ListModel?> listService({required int page, String? search}) async {
    return await APIService().getList(
      _currentModule!.genericListService,
      page,
      _currentModule!.serviceParser,
      search: search,
      filterById: _filterById,
      connection: _connection,
      filters: _filter,
    );
  }

  /// gets List Count of [GenericListScreen]
  Future<String> listCount({String? service, String? search}) async {
    String count;
    count = await APIService().getListCount(
        service: service ?? _currentModule!.genericListService,
        filters: _filter,
        search: search);
    _totalListCount = count;
    return count;
  }

   Future<void> submitDocument(BuildContext context) async {
    final res = await checkDialog(context,
        'Are you sure to submit ${_currentModule!.genericListService} $_pageId');
    if (res == false) loadPage();

    if (res != null && res == true) {
      showLoadingDialog(
          context, 'Submitting ${_currentModule!.genericListService}');

      final response = await handleRequest(
          () => APIService()
              .submitDoc(_pageId, _currentModule!.genericListService),
          context);

      if (response != null && response == true) {
        _pageSubmitStatus = 1;
        final x = _filter;
        filter = {'notifyListeners': true};
        filter = x;
        loadPage();
        Navigator.pop(context);
        showSnackBar('Submitted Successfully', context);
      }
    }
  }

  Future<void> cancelledDocument(BuildContext context) async {
    final res = await checkDialog(context,
        'Are you sure to cancel ${_currentModule!.genericListService} $_pageId');
    if (res == false) loadPage();

    if (res != null && res == true) {
      showLoadingDialog(
          context, 'canceling ${_currentModule!.genericListService}');

      final response = await handleRequest(
          () => APIService()
              .cancelDoc(_pageId, _currentModule!.genericListService),
          context);

      if (response != null && response == true) _pageSubmitStatus = 1;
      final x = _filter;
      filter = {'notifyListeners': true};
      filter = x;
      loadPage();
      Navigator.pop(context);
      showSnackBar('canceled Successfully', context);
    }
  }

  Widget submitDocumentWidget() {
    switch (_pageSubmitStatus) {
      case (0):
        return const SubmitButton();
      case (1):
        return const CancelButton();
      case (2):
        return const AmendButton();

      default:
        return const SizedBox();
    }
  }

  Future<void> updatePage(Map<String, dynamic> data) async {
    await APIService()
        .updatePage('${_currentModule!.genericListService}/$_pageId', data);
    await loadPage();
  }

  Future<bool> addComment(BuildContext context, String comment) async {
    showLoadingDialog(context, 'Uploading comment');
    bool? response;
    try {
      response =
          await APIService().comment(_currentModule!.title, _pageId, comment);
    } catch (_) {}
    Navigator.pop(context);

    if (response != null && response == true) {
      ((_pageData['comments'] as List?) ?? []).add({
        "creation": DateTime.now().toIso8601String(),
        "owner": context.read<UserProvider>().username,
        "content": comment
      });
      loadPage();
      return true;
    }

    Fluttertoast.showToast(msg: 'something went wrong');
    return false;
  }

  Future<void> addAttachment(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      showLoadingDialog(context, 'Uploading Your File');

      final server = APIService();

      final res = await handleRequest(
          () async => await server.postFile(
              _currentModule!.genericListService, _pageId, file),
          context);
      Navigator.pop(context);
      Navigator.pop(context);

      try {
        if (res['message']['name'] != null) {
          loadPage();
          Future.delayed(const Duration(seconds: 1), () {
            showSnackBar('File Uploaded Successfully', context);
          });
        }
      } catch (e) {}
    }
  }

  Future<Map<String, dynamic>?> uploadImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      showLoadingDialog(context, 'Uploading Your Image');
      final server = APIService();

      final res = await handleRequest(
          () async => await server.postFile(
              _currentModule!.genericListService, _pageId, file),
          context);

      Navigator.pop(context);

      try {
        if (res['message']['name'] != null) {
          showSnackBar('File Uploaded Successfully', context);
          return {
            "imageUrl": res['message']['file_url'],
            "imageFile": file,
          };
        }
      } catch (e) {
        print('No Image URL Found: ${res['message']['name']}');
      }
    }
    return null;
  }

  void printPdf(BuildContext context) async {
    if (pdfFormats.length == 1) {
      APIService().printInvoice(
          context: context,
          docType: _currentModule!.genericListService,
          id: _pageId,
          format: pdfFormats[0]);
    } else {
      await showDialog(
          context: context,
          builder: (_) => SelectFormatDialog(
              formats: pdfFormats,
              title: 'Select Print Format')).then((format) {
        if (format == null) return;
        APIService().printInvoice(
            context: context,
            docType: _currentModule!.genericListService,
            id: _pageId,
            format: format);
      });
    }
  }

  void downloadPdf(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    //make sure for storage permission
    if (!userProvider.storageAccess) {
      await userProvider.checkPermission();

      //return if it's not guaranteed
      if (!userProvider.storageAccess) {
        showSnackBar('Storage Access Required!', context, color: Colors.red);
        return;
      }
    }

    try {
      File? file;

      if (pdfFormats.length == 1) {
        showLoadingDialog(context, 'Downloading PDF ...');
        file = await APIService().downloadFile(
          '${userProvider.url}/api/$PRINT_INVOICE',
          '$_pageId.pdf',
          queryParameters: {
            'doctype': _currentModule!.genericListService,
            'name': _pageId,
            'format': pdfFormats[0]
          },
          path: null,
        );
      } else {
        final format = await showDialog(
            context: context,
            builder: (_) => SelectFormatDialog(
                formats: pdfFormats, title: 'Select PDF Format'));
        if (format == null) return;
        showLoadingDialog(context, 'Downloading PDF ...');
        file = await APIService().downloadFile(
          '${userProvider.url}/api/$PRINT_INVOICE',
          '$_pageId-$format' '.pdf',
          queryParameters: {
            'doctype': _currentModule!.genericListService,
            'name': _pageId,
            'format': format
          },
          path: null,
        );
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => PDFScreen(path: file!.path)));
    } on ServerException catch (e) {
      print(e);
      Navigator.pop(context);
      showSnackBar(e.message, context, color: Colors.red);
    } on PlatformException catch (e) {
      print(e);
      Navigator.pop(context);
      showSnackBar('Could\'t save file!', context, color: Colors.red);
    } catch (e) {
      print(e);
      Navigator.pop(context);
      showSnackBar('something went wrong!', context, color: Colors.red);
    }
  }

  void initializeAmendingFunction(
      BuildContext context, Map<String, dynamic> data) {
    if (isAmendingMode) {
      data['doctype'] = currentModule.title;
      data['amended_from'] = data['name'];
      _previousPageId = data['name'];
      data.remove('name');
      NotifyAmended = true;
    }
  }

  void initializeDuplicationMode(Map<String, dynamic> data) {
    if (duplicateMode) {
      data['doctype'] = currentModule.title;
      data.remove('name');
      if (data['amended_from'] != null) data.remove('amended_from');
    }
  }

  /// This function reset the creation form to clear all the data after leaving it
  void resetCreationForm() {
    _editPage = false;
    _amendDoc = false;
    _duplicateMode = false;
    newItemList.clear();
  }
}
