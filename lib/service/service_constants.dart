//Selling
const LEAD_PAGE = 'method/ecs_eat.eat_sp.pages.lead';
const LEAD_POST = 'method/ecs_eat.eat_sp.add.lead';
const SELECT_LEAD_FIELDS =
    '["name","lead_name","company_name","territory","source","campaign_name","market_segment","status"]';
const OPPORTUNITY_PAGE = 'method/ecs_eat.eat_sp.pages.opportunity';
const OPPORTUNITY_POST = 'method/ecs_eat.eat_sp.add.opportunity';
const CUSTOMER = 'resource/Customer'; //used for post-update in services file
const CUSTOMER_PAGE = 'method/ecs_eat.eat_sp.pages.customer';
const CUSTOMER_POST = 'method/ecs_eat.eat_sp.add.customer';
const CUSTOMER_LIST = 'resource/Customer';
const CUSTOMER_ADDRESS = 'method/ecs_eat.eat_sp.pages.filtered_address';
const CUSTOMER_ADDRESS_LIST_FIELDS =
    '["address_title","address_line1","city","phone"]';
const QUOTATION_PAGE = 'method/ecs_eat.eat_sp.pages.quotation';
const QUOTATION_POST = 'method/ecs_eat.eat_sp.add.quotation';
const SALES_ORDER_PAGE = 'method/ecs_eat.eat_sp.pages.sales_order';
const SALES_ORDER_POST = 'method/ecs_eat.eat_sp.add.sales_order';
const SALES_INVOICE_PAGE = 'method/ecs_eat.eat_sp.pages.sales_invoice';
const SALES_INVOICE_POST = 'method/ecs_eat.eat_sp.add.sales_invoice';
const PAYMENT_ENTRY_PAGE = 'method/ecs_eat.eat_sp.pages.payment_entry';
const PAYMENT_POST = 'method/ecs_eat.eat_sp.add.payment_entry';
const GET_ITEM_LIST = 'method/ecs_eat.eat_sp.general.get_item_list';
const CUSTOMER_VISIT_PAGE = 'method/ecs_eat.eat_sp.pages.customer_visit';
const CUSTOMER_VISIT_POST = 'method/ecs_eat.eat_sp.add.customer_visit';
const ADDRESS_PAGE = 'method/ecs_eat.eat_sp.pages.address';
const ADDRESS_POST = 'method/ecs_eat.eat_sp.add.address';
const CONTACT_PAGE = 'method/ecs_eat.eat_sp.pages.contact';
const CONTACT_POST = 'method/ecs_eat.eat_sp.add.contact';

//Stock
const ITEM_PAGE = 'method/ecs_eat.eat_sp.pages.item';
const ITEM_POST = 'method/ecs_eat.eat_sp.add.item';
const STOCK_ENTRY_PAGE = 'method/ecs_eat.eat_sp.pages.stock_entry';
const STOCK_ENTRY_POST = 'method/ecs_eat.eat_sp.add.stock_entry';
const DELIVERY_NOTE_PAGE = 'method/ecs_eat.eat_sp.pages.delivery_note';
const DELIVERY_NOTE_POST = 'method/ecs_eat.eat_sp.add.delivery_note';
const PURCHASE_RECEIPT_PAGE = 'method/ecs_eat.eat_sp.pages.purchase_receipt';
const PURCHASE_RECEIPT_POST = 'method/ecs_eat.eat_sp.add.purchase_receipt';
const MATERIAL_REQUEST_PAGE = 'method/ecs_eat.eat_sp.pages.material_request';
const MATERIAL_REQUEST_POST = 'method/ecs_eat.eat_sp.add.material_request';

//Buying
const SUPPLIER_PAGE = 'method/ecs_eat.eat_sp.pages.supplier';
const SUPPLIER_POST = 'method/ecs_eat.eat_sp.add.supplier';
const SUPPLIER_UPDATE = 'resource/Supplier';
const SUPPLIER_QUOTATION_PAGE =
    'method/ecs_eat.eat_sp.pages.supplier_quotation';
const SUPPLIER_QUOTATION_POST = 'method/ecs_eat.eat_sp.add.supplier_quotation';
const SUPPLIER_QUOTATION_UPDATE = '';
const PURCHASE_INVOICE_PAGE = 'method/ecs_eat.eat_sp.pages.purchase_invoice';
const PURCHASE_INVOICE_POST = 'method/ecs_eat.eat_sp.add.purchase_invoice';
const PURCHASE_INVOICE_UPDATE = '';
const PURCHASE_ORDER_PAGE = 'method/ecs_eat.eat_sp.pages.purchase_order';
const PURCHASE_ORDER_POST = 'method/ecs_eat.eat_sp.add.purchase_order';
const PURCHASE_ORDER_UPDATE = '';
//HR
const EMPLOYEE_PAGE = 'method/ecs_eat.eat_sp.pages.employee';
const EMPLOYEE_POST = 'method/ecs_eat.eat_sp.add.employee';
const LEAVE_APPLICATION_PAGE = 'method/ecs_eat.eat_sp.pages.leave_application';
const LEAVE_APPLICATION_POST = 'method/ecs_eat.eat_sp.add.leave_application';
const LEAVE_APPLICATION_UPDATE = '';
const EMPLOYEE_CHECKIN_PAGE = 'method/ecs_eat.eat_sp.pages.employee_checkin';
const EMPLOYEE_CHECKIN_POST = 'method/ecs_eat.eat_sp.add.employee_checkin';
const EMPLOYEE_CHECKIN_UPDATE = '';
const ATTENDANCE_REQUEST_PAGE =
    'method/ecs_eat.eat_sp.pages.attendance_request';
const ATTENDANCE_REQUEST_POST = 'method/ecs_eat.eat_sp.add.attendance_request';
const ATTENDANCE_REQUEST_UPDATE = '';
const EMPLOYEE_ADVANCE_PAGE = 'method/ecs_eat.eat_sp.pages.employee_advance';
const EMPLOYEE_ADVANCE_POST = 'method/ecs_eat.eat_sp.add.employee_advance';
const EMPLOYEE_ADVANCE_UPDATE = '';
const GET_PENDING_AMOUNT = 'method/ecs_eat.eat_sp.pages.get_pending_amount';
const LOAN_APPLICATION_PAGE = 'method/ecs_eat.eat_sp.pages.loan_application';
const LOAN_APPLICATION_POST = 'method/ecs_eat.eat_sp.add.loan_application';
const LOAN_APPLICATION_UPDATE = '';
const JOURNAL_ENTRY_PAGE = 'method/ecs_eat.eat_sp.pages.journal_entry';
const JOURNAL_ENTRY_POST = 'method/ecs_eat.eat_sp.add.journal_entry';
const JOURNAL_ENTRY_UPDATE = '';

const EXPENSE_CLAIM_PAGE = 'method/ecs_eat.eat_sp.pages.expense_claim';
const EXPENSE_CLAIM_POST = 'method/ecs_eat.eat_sp.add.expense_claim';
const EXPENSE_CLAIM_UPDATE = '';
const PAYABLE_ACCOUNT =
    'method/ecs_eat.eat_sp.general.general_service?doctype=Account';
const ASSIGN_TO = 'method/ecs_eat.eat_sp.doctype_assign.assign';

const CAMPAIGN = 'resource/Campaign';
const SOURCE = 'resource/Lead Source';
const MODE_OF_PAYMENT = 'resource/Mode of Payment';
const SUBMIT_DOC = 'method/ecs_eat.eat_sp.api.submit';
const CANCEL_DOC = 'method/ecs_eat.eat_sp.api.cancel';
const PRINT_INVOICE = 'method/frappe.utils.print_format.download_pdf';
const ATTACH_FILE = 'method/frappe.client.attach_file';
const COMMENT = 'method/ecs_eat.eat_sp.add.comment';
const NOTIFICATION = 'method/ecs_eat.eat_sp.notifications.device_tokens';
const UPDATE_NOTIFICATION_TOKEN = 'resource/Push Notification Details/';
const PUSH_NOTIFICATION_FILTER_USER_DEVICES =
    'method/ecs_eat.eat_sp.notifications.get_push_notification_details';
const PURCHASE_INVOICE_DEFAULT_TAX =
    'method/ecs_eat.eat_sp.pages.default_tax_template';

// Project
const TASK_POST = 'method/ecs_eat.eat_sp.add.task';
const TASK_PAGE = 'method/ecs_eat.eat_sp.pages.task';

const TIMESHEET_POST = 'method/ecs_eat.eat_sp.add.timesheet';
const TIMESHEET_PAGE = 'method/ecs_eat.eat_sp.pages.timesheet';

const PROJECT_POST = 'method/ecs_eat.eat_sp.add.project';
const PROJECT_PAGE = 'method/ecs_eat.eat_sp.pages.project';

const ISSUE_POST = 'method/ecs_eat.eat_sp.add.issue';
const ISSUE_PAGE = 'method/ecs_eat.eat_sp.pages.issue';

//Workflow
const WORKFLOW_POST = 'method/ecs_eat.eat_sp.add.workflow';
const WORKFLOW_PAGE = 'method/ecs_eat.eat_sp.pages.workflow';

const UPDATE_WORKFLOW = 'method/ecs_eat.eat_sp.workflow.update_workflow';
const WORKFLOW_ACTION_LIST =
    'method/ecs_eat.eat_sp.workflow.get_workflow_actions';
const WORKFLOW_STATUS = 'method/ecs_eat.eat_sp.workflow.get_workflow_status';

// Manufacturing
const BOM_POST = 'method/ecs_eat.eat_sp.manufacturing.addBOM';
const BOM_PAGE = 'method/ecs_eat.eat_sp.manufacturing.BOMPage';

const JOB_CARD_POST = 'method/ecs_eat.eat_sp.manufacturing.addJobCard';
const JOB_CARD_PAGE = 'method/ecs_eat.eat_sp.manufacturing.jobCardPage';

const WORK_ORDER_POST = 'method/ecs_eat.eat_sp.manufacturing.addJobCard';
const WORK_ORDER_PAGE = 'method/ecs_eat.eat_sp.manufacturing.workOrderPage';

// Location tracking
const Location_tacking = 'method/ecs_eat.eat_sp.add.add_location';
