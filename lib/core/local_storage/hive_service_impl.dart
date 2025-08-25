import 'package:crud_product/core/local_storage/local_storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveServiceImpl implements LocalStorageService {
  static const _tokenBoxName = 'auth_box';
  static const _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    final box = await Hive.openBox(_tokenBoxName);
    await box.put(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final box = await Hive.openBox(_tokenBoxName);
    return box.get(_tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    final box = await Hive.openBox(_tokenBoxName);
    await box.delete(_tokenKey);
  }
}
