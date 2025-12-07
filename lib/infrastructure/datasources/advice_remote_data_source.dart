import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/exceptions/exceptions.dart';
import '../models/advice_model.dart';

abstract class AdviceRemoteDataSource {
  /// Ruft einen zufälligen Ratschlag von der Advice Slip API ab.
  Future<AdviceModel> getRandomAdviceFromApi();
}

class AdviceRemoteDataSourceImpl implements AdviceRemoteDataSource {
  final http.Client client;

  AdviceRemoteDataSourceImpl({required this.client});

  @override
  Future<AdviceModel> getRandomAdviceFromApi() async {
    final response = await client.get(
      Uri.parse('https://api.adviceslip.com/advice'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return AdviceModel.fromJson(decoded);
  }
}

