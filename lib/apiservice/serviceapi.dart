import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:doctorapp/model/hissmodel.dart';
import 'package:doctorapp/model/periksamodel.dart';
import 'package:http/http.dart' as http;
import 'package:doctorapp/utils/constant.dart';
import 'package:doctorapp/model/usermodel.dart';
import 'package:doctorapp/model/pasienmodel.dart';
import '../model/dataHomePageModel.dart';

class UserApiService {
  static Future<UserProfile> getUser(String uid, String pass) async {
    Map databody = {'User': uid, 'Pass': pass};
    String bodyRaw = json.encode(databody);
    Map<String, String> header = {};
    header["X-Api-Token"] = "a";
    header["token"] = "a";
    Uri url = Uri.parse('${URLS.BASE_URL}/_api_soap/act_login_dokter.php');
    final response = await http.post(url, body: bodyRaw);

    Map<String, dynamic> data = json.decode(response.body);
    return UserProfile.fromJson(data);
  }

  static Future<GetVitalSignPx> getHasilICD10(
      String mrNo, String regNo, String visitNo) async {
    Map<String, String> header = {};

    header["X-Api-Token"] = "a";
    header["token"] = "a";

    Uri url = Uri.parse('${URLS.BASE_URL}/_api_soap/get_icd10_px.php');

    Map databody = {'act': mrNo, 'src_icd': regNo};

    String bodyRaw = json.encode(databody);
    try {
      final response = await http.post(
        url,
        body: bodyRaw,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        return GetVitalSignPx.fromJson(map);
      } else {
        return GetVitalSignPx();
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<GetVitalSignPx> getVitalSignPasienPost(
      String mrNo, String regNo, String visitNo) async {
    Map<String, String> header = {};

    header["X-Api-Token"] = "a";
    header["token"] = "a";

    Uri url = Uri.parse('${URLS.BASE_URL}/_api_soap/get_vital_sign_px.php');
    // var response = await Dio().get(
    //   url.toString(),
    //   queryParameters: queryParameters, //{"kd": tp},
    // );

    Map databody = {
      'no_mr': mrNo,
      'no_registrasi': regNo,
      'no_kunjungan': visitNo
    };

    String bodyRaw = json.encode(databody);
    try {
      final response = await http.post(
        url,
        body: bodyRaw,
      );
      List<GetVitalSignPx> myModels = [];

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);

        return GetVitalSignPx.fromJson(map);
      } else {
        return GetVitalSignPx();
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<GetVitalSignPx> getDetaiMRPasienPost(String regNo) async {
    Map<String, String> header = {};

    header["X-Api-Token"] = "a";
    header["token"] = "a";

    Uri url = Uri.parse('${URLS.BASE_URL}/_api_soap/get_detail_mr.php');
    // var response = await Dio().get(
    //   url.toString(),
    //   queryParameters: queryParameters, //{"kd": tp},
    // );

    Map databody = {
      'no_registrasi': regNo,
    };

    try {
      String bodyRaw = json.encode(databody);

      final response = await http.post(
        url,
        body: bodyRaw,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        return GetVitalSignPx.fromJson(map);
      } else {
        return GetVitalSignPx();
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<GetVitalSignPx> getMRDetailPasienPost(
      String mrNo, String regNo, String visitNo) async {
    GetVitalSignPx? userReturn = GetVitalSignPx();
    Map<String, String> header = {};

    header["X-Api-Token"] = "a";
    header["token"] = "a";

    Uri url = Uri.parse('${URLS.BASE_URL}/_api_soap/get_detail_mr.php');
    // var response = await Dio().get(
    //   url.toString(),
    //   queryParameters: queryParameters, //{"kd": tp},
    // );

    Map databody = {
      'no_registrasi': regNo,
    };

    String bodyRaw = json.encode(databody);
    try {
      final response = await http.post(
        url,
        body: bodyRaw,
      );
      List<GetVitalSignPx> myModels = [];

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);

        return GetVitalSignPx.fromJson(map);
      } else {
        return GetVitalSignPx();
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<AntrianPasienProfile>> getPasienAntri(
      String search, String idDokter) async {
    try {
      UserProfile? userReturn = UserProfile();
      Map<String, String> header = {};

      header["X-Api-Token"] = "a";
      header["token"] = "a";

      final queryParameters = {
        'search': search,
        'kode_dokter': idDokter,
      };

      Uri url =
          Uri.parse('${URLS.BASE_URL}/_api_soap/get_antrian_dokter_soap.php');
      var response = await Dio().get(
        url.toString(),
        queryParameters: queryParameters,
      );

      List<AntrianPasienProfile> myModels = [];

      final data = response.data;
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        var result = map["code"];

        if (result.toString() == "500" || result == null) {
        } else {
          var dataUser = map["dt_antrian"];
          final parsed = List<Map<String, dynamic>>.from(dataUser).toList();
          print(parsed);
          myModels = parsed
              .map<AntrianPasienProfile>(
                  (parsed) => AntrianPasienProfile.fromJson(parsed))
              .toList();
        }
      }

      return myModels;
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<AntrianPasienProfile>> getPasienMRDokterList(
      String search, String idDokter) async {
    try {
      UserProfile? userReturn = UserProfile();
      Map<String, String> header = {};

      header["X-Api-Token"] = "a";
      header["token"] = "a";

      final queryParameters = {
        'search': search,
        'kode_dokter': idDokter,
      };

      Uri url =
          Uri.parse('${URLS.BASE_URL}/_api_soap/get_antrian_dokter_soap.php');
      var response = await Dio().get(
        url.toString(),
        queryParameters: queryParameters,
      );

      List<AntrianPasienProfile> myModels = [];

      final data = response.data;
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        var result = map["code"];
        if (result.toString() == "500" || result == null) {
        } else {
          var dataUser = map["dt_antrian"];
          final parsed = List<Map<String, dynamic>>.from(dataUser).toList();
          print(parsed);
          myModels = parsed
              .map<AntrianPasienProfile>(
                  (parsed) => AntrianPasienProfile.fromJson(parsed))
              .toList();
        }
      }

      return myModels;
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<AntrianPasienProfile>> getPasienMRPasienList(
      String tanggal, String idPasien, String regNo) async {
    try {
      Map<String, String> header = {};

      header["X-Api-Token"] = "a";
      header["token"] = "a";

      final queryParameters = {
        'tgl': tanggal,
        'no_mr': idPasien,
      };

      Uri url = Uri.parse('${URLS.BASE_URL}/_api_soap/get_list_mr.php');
      var response = await Dio().get(
        url.toString(),
        queryParameters: queryParameters,
      );

      List<AntrianPasienProfile> myModels = [];

      final data = response.data;
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        var result = map["code"];

        if (result.toString() == "500" || result == null) {
        } else {
          var dataUser = map["res"];
          final parsed = List<Map<String, dynamic>>.from(dataUser).toList();
          print(parsed);
          myModels = parsed
              .map<AntrianPasienProfile>(
                  (parsed) => AntrianPasienProfile.fromJsonMR(parsed))
              .toList();
          print('jumlah record ${myModels.length}');
        }
      }

      return myModels;
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<AntrianPasienProfile>> getPasienMRPasienDetail(
      String search, String idDokter) async {
    try {
      Map<String, String> header = {};

      header["X-Api-Token"] = "a";
      header["token"] = "a";

      final queryParameters = {
        'search': search,
        'kode_dokter': idDokter,
      };

      Uri url =
          Uri.parse('${URLS.BASE_URL}/_api_soap/get_antrian_dokter_soap.php');
      var response = await Dio().get(
        url.toString(),
        queryParameters: queryParameters,
      );

      List<AntrianPasienProfile> myModels = [];

      final data = response.data;
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        var result = map["code"];
        if (result.toString() == "500" || result == null) {
        } else {
          var dataUser = map["dt_antrian"];
          final parsed = List<Map<String, dynamic>>.from(dataUser).toList();
          print(parsed);
          myModels = parsed
              .map<AntrianPasienProfile>(
                  (parsed) => AntrianPasienProfile.fromJson(parsed))
              .toList();
        }
      }

      return myModels;
    } catch (error) {
      rethrow;
    }
  }

  static Future<bool> postvitalSignPasienAntri(
      GetVitalSignPx data, AntrianPasienProfile dataprofile) async {
    Uri url = Uri.parse('${URLS.BASE_URL}/_api_soap/edit_vital_sign.php');
    bool okeh = false;
    Map databody = {
      "no_mr": dataprofile.no_mr,
      "no_registrasi": dataprofile.no_registrasi,
      "no_kunjungan": dataprofile.no_kunjungan,
      "keadaan_umum": data.dataVitalSign!.keadaanUmum,
      "kesadaran_pasien": data.dataVitalSign!.kesadaranPasien,
      "tekanan_darah": data.dataVitalSign!.tekananDarah,
      "nadi": data.dataVitalSign!.nadi,
      "suhu": data.dataVitalSign!.suhu,
      "pernafasan": data.dataVitalSign!.pernafasan,
      "berat_badan": data.dataVitalSign!.beratBadan,
      "tinggi_badan": data.dataVitalSign!.tinggiBadan,
      "heart_rate": data.dataVitalSign!.heartRate,
      "lingkar_perut": data.dataVitalSign!.lingkarPerut,
    };
    String bodyRaw = json.encode(databody);
    try {
      final response = await http.post(
        url,
        body: bodyRaw,
      );

      if (response.statusCode == 200) {
        okeh = true;
      } else {
        okeh = false;
      }

      return okeh;
    } catch (error) {
      rethrow;
    }
  }

  static Future<bool> postTindakanPasien(Map isiEntry) async {
    bool okeh = false;

    Uri? url = Uri.parse('${URLS.BASE_URL}/_api_soap/add_tindakan.php');
    Map databody = isiEntry;

    databody = {
      "no_registrasi": "212",
      "no_kunjungan": "111",
      "kode_bagian_tujuan": "268",
      "kode_dokter": "1",
      "no_mr": "12-19-00464",
      "nama_pasien": "Musa",
      "kode_tarif": "20290",
      "jumlah_tindakan": "2",
      "kode_brg": "23",
      "jumlah_obat": "3",
      "id_user": "1",
    };

    String bodyRaw = json.encode(databody);
    try {
      final response = await http.post(
        url,
        body: bodyRaw,
      );

      if (response.statusCode == 200) {
        okeh = true;
      } else {
        okeh = false;
      }

      return okeh;
    } catch (error) {
      rethrow;
    }
  }

  static Future<bool> postvitalSOAPPasienAntri(
      GetVitalSignPx data, AntrianPasienProfile dataprofile, bool isEdit,
      {String? noRegistrasi,
      String? noKunjungan,
      String? kesimpulan,
      String? saran}) async {
    bool okeh = false;
    try {
      Uri? url =
          Uri.parse('${URLS.BASE_URL}/_api_soap/addedit_soap_dokter.php');
      Map databody = {};

      if (isEdit == true) {
        databody = {
          "act": 'edit',
          "id_user": dataprofile.dokterid,
          "id_tc_status_pasien": data.dataSoap!.idTcStatusPasien,
          "id_tc_soap": data.dataSoap!.idTcSoap,
          "no_mr": dataprofile.no_mr,
          "subjectiv": data.dataSoap!.subjektif,
          "terapi": data.dataSoap!.assesment,
          "keterangan": data.dataSoap!.objektif
        };
      } else {
        databody = {
          "act": "add",
          "no_mr": dataprofile.no_mr,
          "no_registrasi": noRegistrasi,
          "no_kunjungan": noKunjungan,
          "kode_dokter": dataprofile.dokterid,
          "subjectiv": data.dataSoap!.subjektif,
          "id_user": dataprofile.dokterid,
          "terapi": data.dataSoap!.assesment,
          "keterangan": data.dataSoap!.objektif,
          "kesimpulan": kesimpulan,
          "saran": saran,
        };
      }

      String bodyRaw = json.encode(databody);

      final response = await http.post(
        url,
        body: bodyRaw,
      );

      if (response.statusCode == 200) {
        okeh = true;
      } else {
        okeh = false;
      }

      return okeh;
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<HISSData>> getHISSNamaPenyakit(String kelompok) async {
    String uidMember = "dr_harry";
    String passMember = "averin";

    Map databody = {'src_penyakit': kelompok};
    String bodyRaw = json.encode(databody);

    try {
      Map<dynamic, dynamic> header = {};

      // header["X-Api-Token"] = "a";
      // header["token"] = "a";

      Uri url =
          Uri.parse('${URLS.BASE_URL}/_api_soap/get_nama_penyakit_hiss.php');

      final response = await http.post(
        url,
        body: bodyRaw,
      );

      List<HISSData> myModels = [];

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);

        var result = map["code"];

        if (result.toString() == "500") {
        } else {
          Map<dynamic, dynamic> maps = json.decode(response.body);
          var Data = maps["list"];
          print(Data);

          final parsed = List<Map<dynamic, dynamic>>.from(Data).toList();
          //header = parsed;
          //print(parsed);
          // //.where((element) => );
          myModels = Data.map<HISSData>((parsed) => HISSData.fromJson(parsed))
              .toList();
        }
      }

      return myModels;
    } catch (error) {
      rethrow;
    }
  }

  static Future<GetHomePage> getHomePage({
    required String bulan,
    required String idDokter,
  }) async {
    final response = await http.post(
        Uri.parse('${URLS.BASE_URL}/_api_soap/get_homepage.php'),
        headers: {
          'X-Api-Token': '',
          'token': '',
        },
        body: json.encode({"bln": bulan, "kode_dokter": idDokter}));
    print(response.body);
    return GetHomePage.fromJson(jsonDecode(response.body));
  }
}
