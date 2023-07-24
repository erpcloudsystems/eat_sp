import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../entities/faq_entity.dart';

abstract class FaqBaseRepo {
  Future<Either<Failure, List<Faq>>> getFaqs({String? tag});
}
