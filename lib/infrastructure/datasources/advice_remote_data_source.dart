import 'dart:math';

import '../../core/exceptions/exceptions.dart';
import '../models/advice_model.dart';

abstract class AdviceRemoteDataSource {
  /// Simuliert einen Netzwerkanruf und liefert einen zufälligen Ratschlag.
  /// Wir nutzen hier noch keine echte API, um die Architektur zu zeigen.
  Future<AdviceModel> getRandomAdviceFromApi();
}

class AdviceRemoteDataSourceImpl implements AdviceRemoteDataSource {
  final _advices = const [
    "Don't eat yellow snow.",
    "Simplicity is the ultimate sophistication.",
    "Never trust a computer you can't throw out a window.",
    "Measure twice, cut once.",
    "If in doubt, log it out.",
  ];

  @override
  Future<AdviceModel> getRandomAdviceFromApi() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final random = Random();
    // 20% Fehlerrate simulieren
    final isError = random.nextInt(5) == 0;
    if (isError) throw ServerException();

    final adviceText = _advices[random.nextInt(_advices.length)];
    final id = random.nextInt(1000);
    return AdviceModel(advice: adviceText, id: id);
  }
}

