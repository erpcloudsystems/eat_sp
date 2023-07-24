import 'package:dio/dio.dart';

import '../../../../core/network/api_constance.dart';
import '../../../../core/network/dio_helper.dart';
import '../models/faq_model.dart';

abstract class FaqBaseDataSource {
  Future<List<FaqModel>> getFaq(String? tag);
}

class FaqDataSourceByDio implements FaqBaseDataSource {
  final BaseDioHelper _dio;

  const FaqDataSourceByDio(this._dio);

  @override
  Future<List<FaqModel>> getFaq(String? tag) async {
    final response = await _dio.get(
        endPoint: ApiConstance.getFaqs,
        query: {if (tag != null) 'tag': tag}) as Response;
    final List<FaqModel> faqs = List.from(response.data['message'])
        .map((e) => FaqModel.fromJson(e))
        .toList();
    return faqs;
  }
}
