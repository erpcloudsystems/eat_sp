//Selling
const LEAD_PAGE = 'method/eat_mobile.pages.lead';
const LEAD_POST = 'method/eat_mobile.add.lead';
const SELECT_LEAD_FIELDS =
    '["name","lead_name","company_name","territory","source","campaign_name","market_segment","status"]';
const OPPORTUNITY_PAGE = 'method/eat_mobile.pages.opportunity';
const OPPORTUNITY_POST = 'method/eat_mobile.add.opportunity';
const CUSTOMER = 'resource/Customer'; //used for post-update in services file
const CUSTOMER_PAGE = 'method/eat_mobile.pages.customer';
const CUSTOMER_POST = 'method/eat_mobile.add.customer';
const CUSTOMER_LIST = 'resource/Customer';
const CUSTOMER_ADDRESS = 'method/eat_mobile.pages.filtered_address';
const CUSTOMER_ADDRESS_LIST_FIELDS =
    '["address_title","address_line1","city","phone"]';
const QUOTATION_PAGE = 'method/eat_mobile.pages.quotation';
const QUOTATION_POST = 'method/eat_mobile.add.quotation';
const SALES_ORDER_PAGE = 'method/eat_mobile.pages.sales_order';
const SALES_ORDER_POST = 'method/eat_mobile.add.sales_order';
const SALES_INVOICE_PAGE = 'method/eat_mobile.pages.sales_invoice';
const SALES_INVOICE_POST = 'method/eat_mobile.add.sales_invoice';
const PAYMENT_ENTRY_PAGE = 'method/eat_mobile.pages.payment_entry';
const PAYMENT_POST = 'method/eat_mobile.add.payment_entry';
const GET_ITEM_LIST = 'method/eat_mobile.general.get_item_list';
const CUSTOMER_VISIT_PAGE = 'method/eat_mobile.pages.customer_visit';
const CUSTOMER_VISIT_POST = 'method/eat_mobile.add.customer_visit';
const ADDRESS_PAGE = 'method/eat_mobile.pages.address';
const ADDRESS_POST = 'method/eat_mobile.add.address';
const CONTACT_PAGE = 'method/eat_mobile.pages.contact';
const CONTACT_POST = 'method/eat_mobile.add.contact';

//Stock
const ITEM_PAGE = 'method/eat_mobile.pages.item';
const ITEM_POST = 'method/eat_mobile.add.item';
const STOCK_ENTRY_PAGE = 'method/eat_mobile.pages.stock_entry';
const STOCK_ENTRY_POST = 'method/eat_mobile.add.stock_entry';
const DELIVERY_NOTE_PAGE = 'method/eat_mobile.pages.delivery_note';
const DELIVERY_NOTE_POST = 'method/eat_mobile.add.delivery_note';
const PURCHASE_RECEIPT_PAGE = 'method/eat_mobile.pages.purchase_receipt';
const PURCHASE_RECEIPT_POST = 'method/eat_mobile.add.purchase_receipt';
const MATERIAL_REQUEST_PAGE = 'method/eat_mobile.pages.material_request';
const MATERIAL_REQUEST_POST = 'method/eat_mobile.add.material_request';

//Buying
const SUPPLIER_PAGE = 'method/eat_mobile.pages.supplier';
const SUPPLIER_POST = 'method/eat_mobile.add.supplier';
const SUPPLIER_UPDATE = 'resource/Supplier';
const SUPPLIER_QUOTATION_PAGE = 'method/eat_mobile.pages.supplier_quotation';
const SUPPLIER_QUOTATION_POST = 'method/eat_mobile.add.supplier_quotation';
const SUPPLIER_QUOTATION_UPDATE = '';
const PURCHASE_INVOICE_PAGE = 'method/eat_mobile.pages.purchase_invoice';
const PURCHASE_INVOICE_POST = 'method/eat_mobile.add.purchase_invoice';
const PURCHASE_INVOICE_UPDATE = '';
const PURCHASE_ORDER_PAGE = 'method/eat_mobile.pages.purchase_order';
const PURCHASE_ORDER_POST = 'method/eat_mobile.add.purchase_order';
const PURCHASE_ORDER_UPDATE = '';
//HR
const EMPLOYEE_PAGE = 'method/eat_mobile.pages.employee';
const EMPLOYEE_POST = 'method/eat_mobile.add.employee';
const LEAVE_APPLICATION_PAGE = 'method/eat_mobile.pages.leave_application';
const LEAVE_APPLICATION_POST = 'method/eat_mobile.add.leave_application';
const LEAVE_APPLICATION_UPDATE = '';
const EMPLOYEE_CHECKIN_PAGE = 'method/eat_mobile.pages.employee_checkin';
const EMPLOYEE_CHECKIN_POST = 'method/eat_mobile.add.employee_checkin';
const EMPLOYEE_CHECKIN_UPDATE = '';
const ATTENDANCE_REQUEST_PAGE = 'method/eat_mobile.pages.attendance_request';
const ATTENDANCE_REQUEST_POST = 'method/eat_mobile.add.attendance_request';
const ATTENDANCE_REQUEST_UPDATE = '';
const EMPLOYEE_ADVANCE_PAGE = 'method/eat_mobile.pages.employee_advance';
const EMPLOYEE_ADVANCE_POST = 'method/eat_mobile.add.employee_advance';
const EMPLOYEE_ADVANCE_UPDATE = '';
const GET_PENDING_AMOUNT = 'method/eat_mobile.pages.get_pending_amount';
const LOAN_APPLICATION_PAGE = 'method/eat_mobile.pages.loan_application';
const LOAN_APPLICATION_POST = 'method/eat_mobile.add.loan_application';
const LOAN_APPLICATION_UPDATE = '';
const JOURNAL_ENTRY_PAGE = 'method/eat_mobile.pages.journal_entry';
const JOURNAL_ENTRY_POST = 'method/eat_mobile.add.journal_entry';
const JOURNAL_ENTRY_UPDATE = '';

const EXPENSE_CLAIM_PAGE = 'method/eat_mobile.pages.expense_claim';
const EXPENSE_CLAIM_POST = 'method/eat_mobile.add.expense_claim';
const EXPENSE_CLAIM_UPDATE = '';
const PAYABLE_ACCOUNT =
    'method/eat_mobile.general.general_service?doctype=Account';
const ASSIGN_TO = 'method/eat_mobile.doctype_assign.assign';

const CAMPAIGN = 'resource/Campaign';
const SOURCE = 'resource/Lead Source';
const MODE_OF_PAYMENT = 'resource/Mode of Payment';
const SUBMIT_DOC = 'method/eat_mobile.api.submit';
const CANCEL_DOC = 'method/eat_mobile.api.cancel';
const PRINT_INVOICE = 'method/frappe.utils.print_format.download_pdf';
const ATTACH_FILE = 'method/frappe.client.attach_file';
const COMMENT = 'method/eat_mobile.add.comment';
const NOTIFICATION = 'method/eat_mobile.notifications.device_tokens';
const UPDATE_NOTIFICATION_TOKEN = 'resource/Push Notification Details/';
const PUSH_NOTIFICATION_FILTER_USER_DEVICES =
    'method/eat_mobile.notifications.get_push_notification_details';
const PURCHASE_INVOICE_DEFAULT_TAX =
    'method/eat_mobile.pages.default_tax_template';

// Project
const TASK_POST = 'method/eat_mobile.add.task';
const TASK_PAGE = 'method/eat_mobile.pages.task';

const TIMESHEET_POST = 'method/eat_mobile.add.timesheet';
const TIMESHEET_PAGE = 'method/eat_mobile.pages.timesheet';

const PROJECT_POST = 'method/eat_mobile.add.project';
const PROJECT_PAGE = 'method/eat_mobile.pages.project';

const ISSUE_POST = 'method/eat_mobile.add.issue';
const ISSUE_PAGE = 'method/eat_mobile.pages.issue';

//Workflow
const WORKFLOW_POST = 'method/eat_mobile.add.workflow';
const WORKFLOW_PAGE = 'method/eat_mobile.pages.workflow';

const UPDATE_WORKFLOW = 'method/eat_mobile.workflow.update_workflow';
const WORKFLOW_ACTION_LIST = 'method/eat_mobile.workflow.get_workflow_actions';
const WORKFLOW_STATUS = 'method/eat_mobile.workflow.get_workflow_status';

// Manufacturing
const BOM_POST = 'method/eat_mobile.manufacturing.addBOM';
const BOM_PAGE = 'method/eat_mobile.manufacturing.BOMPage';

const JOB_CARD_POST = 'method/eat_mobile.manufacturing.addJobCard';
const JOB_CARD_PAGE = 'method/eat_mobile.manufacturing.jobCardPage';

const WORK_ORDER_POST = 'method/eat_mobile.manufacturing.addJobCard';
const WORK_ORDER_PAGE = 'method/eat_mobile.manufacturing.workOrderPage';

// Location tracking
const Location_tacking = 'method/eat_mobile.add.add_location';
