import 'package:dartz/dartz.dart';
import '../entities/advice_entity.dart';
// Failure Klasse müsste noch erstellt werden, hier als Platzhalter angenommen
// import '../../../core/failures/failures.dart'; 

abstract class AdviceRepository {
  // Wir nutzen Future<Either<Failure, AdviceEntity>> für sauberes Error Handling
  // Da wir 'dartz' noch nicht als Dependency haben, kommentiere ich es aus 
  // und nutze einen Platzhalter-Typ.
  
  // Future<Either<Failure, AdviceEntity>> getAdviceFromApi();
  Future<AdviceEntity> getAdviceFromApi();
}

