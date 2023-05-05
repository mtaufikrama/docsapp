import 'package:flutter/material.dart';

import '../model/dokterPendapatan.dart';

class UserDataDokter with ChangeNotifier {
  late Pendapatan _penda;
  Pendapatan get DataPendapatan => _penda;

  void setDataUserDoketer(Pendapatan value) {
    _penda = value;
    notifyListeners();
  }
}
