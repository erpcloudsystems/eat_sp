import 'package:dartz/dartz.dart';

import 'package:NextApp/new_version/core/network/failure.dart';

import '../../../../core/global/base_use_case.dart';
import '../entities/faq_entity.dart';
import '../repositories/faq_base_repo.dart';

class GetFaqsUseCase extends BaseUseCase<List<Faq>, String?> {
  final FaqBaseRepo _faqBaseRepo;

  GetFaqsUseCase(this._faqBaseRepo);

  @override
  Future<Either<Failure, List<Faq>>> call(String? parameters) async =>
      await _faqBaseRepo.getFaqs(tag: parameters);
}
