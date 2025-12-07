import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/advice_model.dart';
import '../../core/exceptions/exceptions.dart';

abstract class AdviceLocalDataSource {
  Future<void> cacheFavoriteAdvice(AdviceModel advice);
  Future<List<AdviceModel>> getFavoriteAdvices();
  Future<void> removeFavoriteAdvice(int id);
}

const _favoritesKey = 'favorites';

class AdviceLocalDataSourceImpl implements AdviceLocalDataSource {
  final SharedPreferences sharedPreferences;

  AdviceLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheFavoriteAdvice(AdviceModel advice) async {
    final current = await getFavoriteAdvices();
    // Avoid duplicates by id
    final filtered = current.where((a) => a.id != advice.id).toList();
    filtered.add(advice);
    final jsonList = filtered.map((a) => a.toJson()).toList();
    final encoded = jsonEncode(jsonList);
    final success = await sharedPreferences.setString(_favoritesKey, encoded);
    if (!success) throw CacheException();
  }

  @override
  Future<List<AdviceModel>> getFavoriteAdvices() async {
    final stored = sharedPreferences.getString(_favoritesKey);
    if (stored == null) return [];
    try {
      final decoded = jsonDecode(stored) as List<dynamic>;
      return decoded
          .map((e) => AdviceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> removeFavoriteAdvice(int id) async {
    final current = await getFavoriteAdvices();
    final filtered = current.where((a) => a.id != id).toList();
    final encoded = jsonEncode(filtered.map((a) => a.toJson()).toList());
    final success = await sharedPreferences.setString(_favoritesKey, encoded);
    if (!success) throw CacheException();
  }
}

