import '../../provider/module/module_provider.dart';
import '../other/notification_screen.dart';
import '../page/generic_page.dart';
import '../../service/service_constants.dart';
import '../../widgets/tow_value_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/list_models/stock_list_model/item_table_model.dart';
import '../../service/service.dart';
import '/models/list_models/list_model.dart';
import '/widgets/item_card.dart';
import '/widgets/list_card.dart';
import '/widgets/snack_bar.dart';
import 'custom_generic_list.dart';
import 'generic_list_screen.dart';

class SingleValueTile extends StatelessWidget {
  final String value;
  final void Function(BuildContext context)? onTap;

  const SingleValueTile(this.value, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff1665D8),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(value[0].toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                SizedBox(width: 12),
                Text(value,
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
          Divider(color: Colors.grey, height: 1, thickness: 0.7, indent: 56),
        ],
      ),
    );
  }
}

class SingleValueTileReturnMap extends StatelessWidget {
  final Map<String, String?> value;
  final void Function(BuildContext context)? onTap;

  const SingleValueTileReturnMap(this.value, {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff1665D8),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(value['name'].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                    child: Text(value['name'].toString(),
                        style: TextStyle(color: Colors.black, fontSize: 16))),
              ],
            ),
          ),
          Divider(color: Colors.grey, height: 1, thickness: 0.7, indent: 56),
        ],
      ),
    );
  }
}

class AddressTile extends StatelessWidget {
  final Map<String, String?> data;
  final void Function(BuildContext context)? onTap;

  const AddressTile(this.data, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color(0xff1665D8),
                          borderRadius: BorderRadius.circular(55),
                        ),
                        child: Center(
                            child: Text(data['city'] ?? tr('none'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15))),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Chip(
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone,
                                color: Colors.grey.shade800, size: 22),
                            SizedBox(width: 10),
                            Text(data['phone'] ?? tr('none'),
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Text(data['address_title'] ?? tr('none'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Text(data['address_line1'] ?? tr('none'),
                        textAlign: TextAlign.center)),
              ],
            ),
          ),
          Divider(color: Colors.grey, height: 10, thickness: 0.7, indent: 60),
        ],
      ),
    );
  }
}

class CurrencyTile extends StatelessWidget {
  final String value;
  final String circleValue;
  final void Function(BuildContext context)? onTap;

  const CurrencyTile(this.value, this.circleValue, {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff1665D8),
                  radius: 23,
                  child: Text(circleValue.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                SizedBox(width: 12),
                Text(value,
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
          Divider(color: Colors.grey, height: 1, thickness: 0.7, indent: 56),
        ],
      ),
    );
  }
}

Widget territoryScreen() => GenericListScreen<String>(
      title: 'Select Territory',
      service: APIService.TERRITORY,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget customerGroupScreen() => GenericListScreen<String>(
      title: 'Select Customer Group',
      service: APIService.CUSTOMER_GROUP,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget supplierGroupScreen() => GenericListScreen<String>(
      title: 'Select Supplier Group',
      service: APIService.SUPPLIER_GROUP,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget marketSegmentScreen() => GenericListScreen<String>(
      title: 'Select Market Segment',
      service: APIService.MARKET_SEGMENT,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget industryScreen() => GenericListScreen<String>(
      title: 'Select Industry',
      service: APIService.INDUSTRY,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget opportunityTypeScreen() => GenericListScreen<String>(
      title: 'Select Opportunity Type',
      service: APIService.OPPORTUNITY_TYPE,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget userTypeScreen() => GenericListScreen<String>(
      title: 'Select Opportunity Type',
      service: APIService.USER_TYPE,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget countryScreen() => GenericListScreen<String>(
      title: 'Select Country',
      service: APIService.COUNTRY,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget contactScreen(String customerId) =>
    GenericListScreen<Map<String, String?>>(
      title: 'Select Contact',
      service: APIService.FILTERED_CONTACT,
      filterById: customerId,
      listItem: (value) => SingleValueTileReturnMap(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<Map<String, String?>> _list = [];
        List.from(data['message']).forEach(
            (element) => _list.add(Map<String, String?>.from(element)));
        return ListModel<Map<String, String?>>(_list);
      },
    );

Widget campaignScreen() => GenericListScreen<String>(
      title: 'Select Campaign',
      service: APIService.CAMPAIGN,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget sourceScreen() => GenericListScreen<String>(
      title: 'Select Source',
      service: APIService.SOURCE,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget customerAddressScreen(String customerId) =>
    GenericListScreen<Map<String, String?>>(
      title: 'Select Customer Address',
      service: APIService.FILTERED_ADDRESS,
      filterById: customerId,
      listItem: (value) => AddressTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<Map<String, String?>> _list = [];
        List.from(data['message']).forEach(
            (element) => _list.add(Map<String, String?>.from(element)));
        return ListModel<Map<String, String?>>(_list);
      },
    );

Widget supplierAddressScreen(String supplierId) =>
    GenericListScreen<Map<String, String?>>(
      title: 'Select Supplier Address',
      service: APIService.FILTERED_ADDRESS,
      filterById: supplierId,
      listItem: (value) => AddressTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<Map<String, String?>> _list = [];
        List.from(data['message']).forEach(
            (element) => _list.add(Map<String, String?>.from(element)));
        return ListModel<Map<String, String?>>(_list);
      },
    );

Widget paymentTermsScreen() => GenericListScreen<String>(
      title: 'Select Payment Terms',
      service: APIService.PAYMENT_TERMS,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget currencyListScreen() => GenericListScreen<String>(
      title: 'Select Currency',
      service: APIService.CURRENCY,
      listItem: (value) => CurrencyTile(value, value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message']).forEach((element) => _list
            .add(Map<String, String?>.from(element)['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget priceListScreen() => GenericListScreen<Map<String, String?>>(
      title: 'Select Price List',
      service: APIService.PRICE_LIST,
      listItem: (value) => CurrencyTile(
          value['name'] ?? tr('none'), value['currency'] ?? '-',
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<Map<String, String?>> _list = [];
        List.from(data['message']).forEach(
            (element) => _list.add(Map<String, String?>.from(element)));
        return ListModel<Map<String, String?>>(_list);
      },
    );

Widget buyingPriceListScreen() => GenericListScreen<Map<String, String?>>(
      title: 'Select Buying Price List',
      service: APIService.BUYING_PRICE_LIST,
      listItem: (value) => CurrencyTile(
          value['name'] ?? tr('none'), value['currency'] ?? '-',
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<Map<String, String?>> _list = [];
        List.from(data['message']).forEach(
            (element) => _list.add(Map<String, String?>.from(element)));
        return ListModel<Map<String, String?>>(_list);
      },
    );

Widget termsConditionScreen() => GenericListScreen<String>(
      title: 'Select Terms',
      service: APIService.TERMS_CONDITION,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      // listItem: (value) => TermsWidget(value['name'] ?? tr('none'), value['terms'] ?? tr('none'), onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name']));
        return ListModel<String>(_list);
      },
    );

Widget selectCustomerScreen() => Builder(builder: (context) {
      return GenericListScreen<Map<String, String?>>(
        title: 'Select Customer',
        service: APIService.CUSTOMER,
        listItem: (value) => ListCard(
            onPressed: (_) => Navigator.of(context).pop(value),
            id: value['name'] ?? tr('none'),
            title: value['customer_name'] ?? tr('none'),
            names: [
              'Group'.tr(),
              'Type'.tr(),
              'Territory'.tr(),
              'Mobile'.tr()
            ],
            values: [
              value['customer_group'] ?? tr('none'),
              value['customer_type'] ?? tr('none'),
              value['territory'] ?? tr('none'),
              value['mobile_no'] ?? tr('none')
            ]),
        serviceParser: (data) {
          List<Map<String, String?>> _list = [];
          List.from(data['message']).forEach(
              (element) => _list.add(Map<String, String?>.from(element)));
          return ListModel<Map<String, String?>>(_list);
        },
      );
    });

Widget selectSupplierScreen() => Builder(builder: (context) {
      return GenericListScreen<Map<String, String?>>(
        title: 'Select Supplier',
        service: APIService.SUPPLIER,
        listItem: (value) => ListCard(
            onPressed: (_) => Navigator.of(context).pop(value),
            id: value['name'] ?? tr('none'),
            title: value['supplier_name'] ?? tr('none'),
            names: [
              'Group'.tr(),
              'Type'.tr(),
              'Country'.tr(),
              'Mobile'.tr()
            ],
            values: [
              value['supplier_group'] ?? tr('none'),
              value['supplier_type'] ?? tr('none'),
              value['country'] ?? tr('none'),
              value['mobile_no'] ?? tr('none')
            ]),
        serviceParser: (data) {
          List<Map<String, String?>> _list = [];
          List.from(data['message']).forEach(
              (element) => _list.add(Map<String, String?>.from(element)));
          return ListModel<Map<String, String?>>(_list);
        },
      );
    });

Widget selectEmployeeScreen() => Builder(builder: (context) {
      return GenericListScreen<Map<String, String?>>(
        title: 'Select Employee',
        service: APIService.EMPLOYEE,
        listItem: (value) => ListCard(
            onPressed: (_) => Navigator.of(context).pop(value),
            id: value['name'] ?? tr('none'),
            title: value['employee_name'] ?? tr('none'),
            names: [
              'Branch'.tr(),
              'Designation'.tr(),
              'Attendance Device Id'.tr(),
              'Department'.tr(),
            ],
            values: [
              value['branch'] ?? tr('none'),
              value['designation'] ?? tr('none'),
              value['attendance_device_id'] ?? tr('none'),
              value['department'] ?? tr('none'),
            ]),
        serviceParser: (data) {
          List<Map<String, String?>> _list = [];
          List.from(data['message']).forEach(
              (element) => _list.add(Map<String, String?>.from(element)));
          return ListModel<Map<String, String?>>(_list);
        },
      );
    });

Widget selectLeadScreen() => Builder(builder: (context) {
      return GenericListScreen<Map<String, String?>>(
        title: 'Select Lead',
        service: APIService.LEAD,
        listItem: (value) => ListCard(
            onPressed: (context) => Navigator.of(context).pop(value),
            id: value['name'] ?? tr('none'),
            title: value['lead_name'] ?? tr('none'),
            status: value['status'] ?? tr('none'),
            names: [
              'Company'.tr(),
              'Territory'.tr(),
              'Source'.tr(),
              'Segment'.tr()
            ],
            values: [
              value['company_name'] ?? tr('none'),
              value['territory'] ?? tr('none'),
              value['source'] ?? tr('none'),
              value['market_segment'] ?? tr('none')
            ]),
        serviceParser: (data) {
          List<Map<String, String?>> _list = [];
          List.from(data['message']).forEach(
              (element) => _list.add(Map<String, String?>.from(element)));
          return ListModel<Map<String, String?>>(_list);
        },
      );
    });

/// old =========================================
Widget itemListScreen(String priceList) => Builder(builder: (context) {
      return CustomListScreen<ItemSelectModel>(
        title: 'Select Items',
        service: GET_ITEM_LIST + '?price_list=$priceList',
        listItem: (item) => ItemCard(
          values: [item.itemName, item.itemCode, item.group, item.stockUom],
          imageUrl: item.imageUrl,
          onPressed: (_) => Navigator.pop(context, item),
        ),
        serviceParser: (data) {
          List<ItemSelectModel> _list = [];
          // print(data['message']);
          //
          // print(data);
          List.from(data['message']).forEach((element) => _list.add(
              ItemSelectModel.fromJson(Map<String, dynamic>.from(element))));

          return ListModel<ItemSelectModel>(_list);
        },
      );
    });

Widget warehouseScreen([String? selectedWarehouse]) =>
    Builder(builder: (context) {
      return GenericListScreen<Map<String, dynamic>>(
        title: 'Select Warehouse',
        service: APIService.WAREHOUSE,
        listItem: (value) => ListCard(
            onPressed: (_) {
              if (selectedWarehouse != null &&
                  selectedWarehouse == value['name']) {
                showSnackBar('Already selected!', context);
                return;
              }
              Navigator.of(context).pop(value['name']);
            },
            id: value['name'] ?? tr('none'),
            title: value['warehouse_name'] ?? tr('none'),
            names: const [
              'Parent Warehouse',
              'type'
            ],
            values: [
              value['parent_warehouse'] ?? tr('none'),
              value['warehouse_type'] ?? tr('none')
            ]),
        serviceParser: (data) {
          List<Map<String, dynamic>> _list = [];
          List.from(data['message']).forEach((element) => _list.add(element));
          return ListModel<Map<String, dynamic>>(_list);
        },
      );
    });

Widget projectScreen() => Builder(builder: (context) {
      return GenericListScreen<Map<String, dynamic>>(
        title: 'Select Project',
        service: APIService.PROJECT,
        listItem: (value) => ListCard(
            onPressed: (context) => Navigator.of(context).pop(value['name']),
            id: value['name'] ?? tr('none'),
            title: value['project_name'] ?? tr('none'),
            names: [],
            values: [],
            status: value['status'] ?? tr('none')),
        serviceParser: (data) {
          List<Map<String, dynamic>> _list = [];
          List.from(data['message']).forEach((element) => _list.add(element));
          return ListModel<Map<String, dynamic>>(_list);
        },
      );
    });

Widget modeOfPaymentScreen([String? previous]) => GenericListScreen<String>(
    title: 'Select Mode of Payment',
    service: APIService.MODE_OF_PAYMENT,
    listItem: (value) => SingleValueTile(value, onTap: (context) {
          if (previous == value)
            showSnackBar(
                'Already selected!, please select another one', context);
          else
            Navigator.of(context).pop(value);
        }),
    serviceParser: (data) {
      List<String> _list = [];
      List.from(data['message'])
          .forEach((element) => _list.add(element['name']));
      return ListModel<String>(_list);
    });

Widget costCenterScreen() => Builder(builder: (context) {
      return GenericListScreen<Map<String, dynamic>>(
        title: 'Select Cost Center',
        service: APIService.COST_CENTER,
        listItem: (value) => ListCard(
            onPressed: (context) => Navigator.of(context).pop(value['name']),
            id: value['name'] ?? tr('none'),
            title: value['cost_center_name'] ?? tr('none'),
            names: ['Parent Cost Center'],
            values: [value['parent_cost_center'] ?? tr('none')]),
        serviceParser: (data) {
          List<Map<String, dynamic>> _list = [];
          List.from(data['message']).forEach((element) => _list.add(element));
          return ListModel<Map<String, dynamic>>(_list);
        },
      );
    });

Widget supplierListScreen() => Builder(builder: (context) {
      return GenericListScreen<Map<String, dynamic>>(
        title: 'Select Supplier',
        service: APIService.SUPPLIER,
        listItem: (value) => ListCard(
          onPressed: (context) => Navigator.of(context).pop(value),
          id: value['name'] ?? tr('none'),
          title: value['supplier_name'] ?? tr('none'),
          values: [
            value['supplier_group'] ?? tr('none'),
            value['supplier_type'] ?? tr('none'),
            value['country'] ?? tr('none'),
            value['mobile_no'] ?? tr('none')
          ],
          names: ['Group', 'Type', 'Country', 'Mobile'],
        ),
        serviceParser: (data) {
          List<Map<String, dynamic>> _list = [];
          List.from(data['message']).forEach((element) => _list.add(element));
          return ListModel<Map<String, dynamic>>(_list);
        },
      );
    });

Widget salesPartnerScreen() => GenericListScreen<Map<String, dynamic>>(
      title: 'Select Sales Partner',
      service: APIService.SALES_PARTNER,
      listItem: (value) => CurrencyTile(
        value['name'],
        value['commission_rate'].toString(),
        onTap: (context) => Navigator.of(context).pop(value['name']),
      ),
      serviceParser: (data) {
        List<Map<String, dynamic>> _list = [];
        List.from(data['message']).forEach((element) => _list.add(element));
        return ListModel<Map<String, dynamic>>(_list);
      },
    );

Widget userListScreen() => GenericListScreen<Map<String, dynamic>>(
      title: 'Select User',
      service: 'User',
      listItem: (value) {
        return TowValueCard(
          value['name'],
          value['full_name'] ?? tr('none'),
          onTap: (context) => Navigator.of(context).pop(value['name']),
        );
      },
      serviceParser: (data) {
        List<Map<String, dynamic>> _list = [];
        List.from(data['message']).forEach((element) => _list.add(element));
        return ListModel<Map<String, dynamic>>(_list);
      },
    );

Widget itemGroupScreen() => GenericListScreen<String>(
      title: 'Select Item Group',
      service: 'Item Group',
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget uomListScreen() => GenericListScreen<String>(
      title: 'Select UoM',
      service: 'UOM',
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget filteredUOMListScreen(String itemCode) =>
    GenericListScreen<Map<String, dynamic>>(
      title: 'Select UoM',
      service: 'UOM',
      customServiceURL: 'method/ecs_mobile.general.get_item_uoms',
      filters: {'item_code': itemCode},
      listItem: (value) => SingleValueTile(value['uom'],
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<Map<String, dynamic>> _list = [];
        List.from(data['message']).forEach((element) => _list.add(element));
        return ListModel<Map<String, dynamic>>(_list);
      },
    );

Widget brandListScreen() => GenericListScreen<String>(
      title: 'Select Brand',
      service: 'Brand',
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget assetCategoryListScreen() => Builder(builder: (context) {
      return GenericListScreen<Map<String, dynamic>>(
        title: 'Select Asset Category',
        service: APIService.ASSET_CATEGORY,
        listItem: (value) => ListCard(
            onPressed: (context) => Navigator.of(context).pop(value['name']),
            id: value['name'] ?? tr('none'),
            title: value['asset_category_name'] ?? tr('none'),
            names: [],
            values: [],
            status: value['status'] ?? tr('none')),
        serviceParser: (data) {
          List<Map<String, dynamic>> _list = [];
          List.from(data['message']).forEach((element) => _list.add(element));
          return ListModel<Map<String, dynamic>>(_list);
        },
      );
    });

Widget departmentListScreen() => GenericListScreen<String>(
      title: 'Select Department',
      service: APIService.DEPARTMENT,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget designationListScreen() => GenericListScreen<String>(
      title: 'Select Designation',
      service: APIService.DESIGNATION,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget branchListScreen() => GenericListScreen<String>(
      title: 'Select Branch',
      service: APIService.BRANCH,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget employmentTypeListScreen() => GenericListScreen<String>(
      title: 'Select Employment Type',
      service: APIService.EMPLOYMENT_TYPE,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget genderListScreen() => GenericListScreen<String>(
      title: 'Select Gender',
      service: APIService.GENDER,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget leaveTypeListScreen() => GenericListScreen<String>(
    title: 'Select Leave Type',
    service: APIService.LEAVE_TYPE,
    listItem: (value) => SingleValueTile(value,
        onTap: (context) => Navigator.of(context).pop(value)),
    serviceParser: (data) {
      List<String> _list = [];
      List.from(data['message'])
          .forEach((element) => _list.add(element['name']));
      return ListModel<String>(_list);
    });

Widget companyListScreen() => GenericListScreen<Map<String, dynamic>>(
      title: 'Select Company',
      service: APIService.COMPANY,
      listItem: (value) => TowValueCard(
        value['name'],
        value['round_off_cost_center'] ?? tr('none'),
        onTap: (context) => Navigator.of(context).pop(value),
      ),
      serviceParser: (data) {
        List<Map<String, dynamic>> _list = [];
        List.from(data['message']).forEach((element) => _list.add(element));
        return ListModel<Map<String, dynamic>>(_list);
      },
    );

Widget holidayListScreen() => GenericListScreen<String>(
      title: 'Select Holiday',
      service: APIService.HOLIDAY_LIST,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget shiftTypeListScreen() => GenericListScreen<String>(
      title: 'Select Shift Type',
      service: APIService.DEFAULT_SHIFT,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget leaveApproverScreen() => GenericListScreen<String>(
    title: 'Select Leave Approver',
    service: APIService.LEAVE_APPROVER,
    listItem: (value) => SingleValueTile(value,
        onTap: (context) => Navigator.of(context).pop(value)),
    serviceParser: (data) {
      List<String> _list = [];
      List.from(data['message'])
          .forEach((element) => _list.add(element['name']));
      return ListModel<String>(_list);
    });

Widget accountListScreen({Map<String, dynamic>? filters}) =>
    Builder(builder: (context) {
      return GenericListScreen<Map<String, String?>>(
        title: 'Select Account',
        service: APIService.ACCOUNT,
        filters: (filters != null) ? filters : null,
        listItem: (value) => ListCard(
            onPressed: (_) => Navigator.of(context).pop(value),
            id: value['name'] ?? tr('none'),
            title: value['account_type'] ?? tr('none'),
            names: [
              'Root Type'.tr(),
              'Account Currency'.tr(),
              'Parent Account'.tr(),
            ],
            values: [
              value['root_type'] ?? tr('none'),
              value['account_currency'] ?? tr('none'),
              value['parent_account'] ?? tr('none'),
            ]),
        serviceParser: (data) {
          List<Map<String, String?>> _list = [];
          List.from(data['message']).forEach(
              (element) => _list.add(Map<String, String?>.from(element)));
          return ListModel<Map<String, String?>>(_list);
        },
      );
    });

Widget expenseClaimTypeScreen() => GenericListScreen<String>(
    title: 'Select Expense Claim Type',
    service: APIService.EXPENSE_CLAIM_TYPE,
    listItem: (value) => SingleValueTile(value,
        onTap: (context) => Navigator.of(context).pop(value)),
    serviceParser: (data) {
      List<String> _list = [];
      List.from(data['message'])
          .forEach((element) => _list.add(element['name']));
      return ListModel<String>(_list);
    });

Widget loanTypeListScreen() => GenericListScreen<Map<String, dynamic>>(
      title: 'Select Loan Type',
      service: APIService.LOAN_TYPE,
      listItem: (value) => TowValueCard(
        value['name'],
        value['rate_of_interest'].toString(),
        onTap: (context) => Navigator.of(context).pop(value),
      ),
      serviceParser: (data) {
        List<Map<String, dynamic>> _list = [];
        List.from(data['message']).forEach((element) => _list.add(element));
        return ListModel<Map<String, dynamic>>(_list);
      },
    );

Widget bankAccountScreen() => GenericListScreen<String>(
      title: 'Select Bank Account ',
      service: APIService.BANK_ACCOUNT,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget journalEntryPartyTypeListScreen(
        {Map<String, dynamic>? filters, String? account}) =>
    Builder(builder: (context) {
      return GenericListScreen<Map<String, String?>>(
        title: 'Select Party Type',
        service: APIService.ACCOUNT,
        filters: (filters != null) ? filters : null,
        listItem: (value) => ListCard(
            onPressed: (_) => Navigator.of(context).pop(value),
            id: value['name'] ?? tr('none'),
            title: value['account_type'] ?? tr('none'),
            names: [
              'Root Type'.tr(),
              'Account Currency'.tr(),
              'Parent Account'.tr(),
            ],
            values: [
              value['root_type'] ?? tr('none'),
              value['account_currency'] ?? tr('none'),
              value['parent_account'] ?? tr('none'),
            ]),
        serviceParser: (data) {
          List<Map<String, String?>> _list = [];
          List.from(data['message']).forEach(
              (element) => _list.add(Map<String, String?>.from(element)));
          return ListModel<Map<String, String?>>(_list);
        },
      );
    });

///Party type list
Widget partyTypeListScreen() => GenericListScreen<String>(
      title: 'Select Party Type',
      service: 'Party Type',
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

/// Party List
Widget partyListScreen(
    { String? partyType}) =>
    Builder(builder: (context) {
      return GenericListScreen<Map<String, String?>>(
        title: 'Select Party Type',
        service: partyType!,
        listItem: (value) => ListCard(
            onPressed: (_) => Navigator.of(context).pop(value),
            id: value['name'] ?? tr('none'),
            title: value['customer_name'] ?? tr('none'),
            names: [
              'Customer Group'.tr(),
              'Territory'.tr(),
              'Customer Type'.tr(),
            ],
            values: [
              value['customer_group'] ?? tr('none'),
              value['territory'] ?? tr('none'),
              value['customer_type'] ?? tr('none'),
            ]),
        serviceParser: (data) {
          List<Map<String, String?>> _list = [];
          List.from(data['message']).forEach(
                  (element) => _list.add(Map<String, String?>.from(element)));
          return ListModel<Map<String, String?>>(_list);
        },
      );
    });
// Widget partyListScreen({String? partyType}) => GenericListScreen<String>(
//   title: 'Select Party',
//   service: partyType!,
//   listItem: (value) => SingleValueTile(value,
//       onTap: (context) => Navigator.of(context).pop(value)),
//   serviceParser: (data) {
//     List<String> _list = [];
//     List.from(data['message'])
//         .forEach((element) => _list.add(element['name'] ?? tr('none')));
//     return ListModel<String>(_list);
//   },
// );

Widget getNotificationListScreen() => Builder(builder: (context) {
      return GenericListScreen<Map<String, dynamic>>(
        title: 'Notification',
        service: APIService.NOTIFICATION_LOG,
        disableAppBar: true,
        listItem: (value) => NotificationCard(
          onPressed: (_) {
            context.read<ModuleProvider>().setModule =
                value['document_type'].toString();
            context
                .read<ModuleProvider>()
                .pushPage(value['document_name'].toString());
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GenericPage(),
              // settings:
              // isFirstRoute(context) ? null : RouteSettings(name: CONNECTION_ROUTE),
            ));
          },
          id: value['name'] ?? tr('none'),
          for_user: value['for_user'] ?? tr('none'),
          from_user: value['from_user'] ?? tr('none'),
          document_name: value['document_name'] ?? tr('none'),
          document_type: value['document_type'] ?? tr('none'),
          read: value['read'] ?? tr('none'),
          subject: value['subject'] ?? tr('none'),
          email_content: value['email_content'] ?? tr('none'),
          type: value['type'] ?? tr('none'),
        ),
        serviceParser: (data) {
          List<Map<String, dynamic>> _list = [];
          List.from(data['message']).forEach(
              (element) => _list.add(Map<String, dynamic>.from(element)));
          return ListModel<Map<String, dynamic>>(_list);
        },
      );
    });

/// Project Lists
Widget issueListScreen() => GenericListScreen<String>(
      title: 'Select Issue',
      service: APIService.ISSUE,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );

Widget typeListScreen() => GenericListScreen<String>(
      title: 'Select Type',
      service: APIService.TASK_TYPE,
      listItem: (value) => SingleValueTile(value,
          onTap: (context) => Navigator.of(context).pop(value)),
      serviceParser: (data) {
        List<String> _list = [];
        List.from(data['message'])
            .forEach((element) => _list.add(element['name'] ?? tr('none')));
        return ListModel<String>(_list);
      },
    );
