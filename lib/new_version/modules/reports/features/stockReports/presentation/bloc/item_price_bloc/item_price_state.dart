import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/item_price_entity.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../../core/utils/request_state.dart';

class ItemPriceState extends Equatable {
  final RequestState getItemPriceReportsState;
  final String getItemPriceReportMessage;
  final bool hasReachedMax;
  final List<ItemPriceEntity> getItemPriceReportData;

  const ItemPriceState({
    this.getItemPriceReportsState = RequestState.loading,
    this.getItemPriceReportMessage = '',
    this.getItemPriceReportData = const [],
    this.hasReachedMax = false,
  });

  ItemPriceState copyWith({
    RequestState? getItemPriceReportsState,
    String? getItemPriceReportMessage,
    List<ItemPriceEntity>? getItemPriceReportData,
    bool? hasReachedMax,
  }) =>
      ItemPriceState(
        getItemPriceReportsState:
            getItemPriceReportsState ?? this.getItemPriceReportsState,
        getItemPriceReportMessage:
            getItemPriceReportMessage ?? this.getItemPriceReportMessage,
        getItemPriceReportData:
            getItemPriceReportData ?? this.getItemPriceReportData,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        getItemPriceReportsState,
        getItemPriceReportMessage,
        getItemPriceReportData,
        hasReachedMax,
      ];
}
