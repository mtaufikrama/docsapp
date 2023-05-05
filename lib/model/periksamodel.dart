class GetVitalSignPx {
  int? code;
  DataPx? dataPx;
  DataVitalSign? dataVitalSign;
  DataSoap? dataSoap;
  List<DtTdk>? dtTdk;
  List<DtIcd10>? dtIcd10;
  List<Resep>? resep;
  List<DtLab>? dtLab;
  String? dtRad;

  GetVitalSignPx(
      {this.code,
      this.dataPx,
      this.dataVitalSign,
      this.dataSoap,
      this.dtTdk,
      this.dtIcd10,
      this.resep,
      this.dtLab,
      this.dtRad});

  GetVitalSignPx.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    dataPx = json['data_px'] != null ? DataPx.fromJson(json['data_px']) : null;
    dataVitalSign = json['data_vital_sign'] != null
        ? DataVitalSign.fromJson(json['data_vital_sign'])
        : null;
    dataSoap =
        json['data_soap'] != null ? DataSoap.fromJson(json['data_soap']) : null;
    if (json['dt_tdk'] != null) {
      dtTdk = <DtTdk>[];
      json['dt_tdk'].forEach((v) {
        dtTdk!.add(DtTdk.fromJson(v));
      });
    }
    if (json['dt_icd10'] != null) {
      dtIcd10 = <DtIcd10>[];
      json['dt_icd10'].forEach((v) {
        dtIcd10!.add(DtIcd10.fromJson(v));
      });
    }
    if (json['resep'] != null) {
      resep = <Resep>[];
      json['resep'].forEach((v) {
        resep!.add(Resep.fromJson(v));
      });
    }
    if (json['dt_lab'] != null) {
      dtLab = <DtLab>[];
      json['dt_lab'].forEach((v) {
        dtLab!.add(DtLab.fromJson(v));
      });
    }
    dtRad = json['dt_rad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (dataPx != null) {
      data['data_px'] = dataPx!.toJson();
    }
    if (dataVitalSign != null) {
      data['data_vital_sign'] = dataVitalSign!.toJson();
    }
    if (dataSoap != null) {
      data['data_soap'] = dataSoap!.toJson();
    }
    if (dtTdk != null) {
      data['dt_tdk'] = dtTdk!.map((v) => v.toJson()).toList();
    }
    if (dtIcd10 != null) {
      data['dt_icd10'] = dtIcd10!.map((v) => v.toJson()).toList();
    }
    if (resep != null) {
      data['resep'] = resep!.map((v) => v.toJson()).toList();
    }
    if (dtLab != null) {
      data['dt_lab'] = dtLab!.map((v) => v.toJson()).toList();
    }
    data['dt_rad'] = dtRad;
    return data;
  }
}

class DataPx {
  String? namaPx;
  String? nomrPx;
  String? umurPx;
  String? genderPx;
  String? goldarahPx;
  String? alergiPx;
  String? noKtpPx;

  DataPx(
      {this.namaPx,
      this.nomrPx,
      this.umurPx,
      this.genderPx,
      this.goldarahPx,
      this.alergiPx,
      this.noKtpPx});

  DataPx.fromJson(Map<String, dynamic> json) {
    namaPx = json['nama_px'];
    nomrPx = json['nomr_px'];
    umurPx = json['umur_px'];
    genderPx = json['gender_px'];
    goldarahPx = json['goldarah_px'];
    alergiPx = json['alergi_px'];
    noKtpPx = json['no_ktp_px'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nama_px'] = namaPx;
    data['nomr_px'] = nomrPx;
    data['umur_px'] = umurPx;
    data['gender_px'] = genderPx;
    data['goldarah_px'] = goldarahPx;
    data['alergi_px'] = alergiPx;
    data['no_ktp_px'] = noKtpPx;
    return data;
  }
}

class DataVitalSign {
  String? keadaanUmum;
  String? kesadaranPasien;
  String? tekananDarah;
  String? nadi;
  String? suhu;
  String? pernafasan;
  String? beratBadan;
  String? tinggiBadan;
  String? lingkarKepala;
  String? lingkarDada;
  String? lingkarPerut;
  String? heartRate;
  String? responMata;
  String? responMotorik;
  String? responVerbal;
  String? spo2;
  String? lainLain;
  String? skalaNyeriFaceNumber;

  DataVitalSign(
      {this.keadaanUmum,
      this.kesadaranPasien,
      this.tekananDarah,
      this.nadi,
      this.suhu,
      this.pernafasan,
      this.beratBadan,
      this.tinggiBadan,
      this.lingkarKepala,
      this.lingkarDada,
      this.lingkarPerut,
      this.heartRate,
      this.responMata,
      this.responMotorik,
      this.responVerbal,
      this.spo2,
      this.lainLain,
      this.skalaNyeriFaceNumber});

  DataVitalSign.fromJson(Map<String, dynamic> json) {
    keadaanUmum = json['keadaan_umum'];
    kesadaranPasien = json['kesadaran_pasien'];
    tekananDarah = json['tekanan_darah'];
    nadi = json['nadi'];
    suhu = json['suhu'];
    pernafasan = json['pernafasan'];
    beratBadan = json['berat_badan'];
    tinggiBadan = json['tinggi_badan'];
    lingkarKepala = json['lingkar_kepala'];
    lingkarDada = json['lingkar_dada'];
    lingkarPerut = json['lingkar_perut'];
    heartRate = json['heart_rate'];
    responMata = json['respon_mata'];
    responMotorik = json['respon_motorik'];
    responVerbal = json['respon_verbal'];
    spo2 = json['spo2'];
    lainLain = json['lain_lain'];
    skalaNyeriFaceNumber = json['skala_nyeri_face_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keadaan_umum'] = keadaanUmum;
    data['kesadaran_pasien'] = kesadaranPasien;
    data['tekanan_darah'] = tekananDarah;
    data['nadi'] = nadi;
    data['suhu'] = suhu;
    data['pernafasan'] = pernafasan;
    data['berat_badan'] = beratBadan;
    data['tinggi_badan'] = tinggiBadan;
    data['lingkar_kepala'] = lingkarKepala;
    data['lingkar_dada'] = lingkarDada;
    data['lingkar_perut'] = lingkarPerut;
    data['heart_rate'] = heartRate;
    data['respon_mata'] = responMata;
    data['respon_motorik'] = responMotorik;
    data['respon_verbal'] = responVerbal;
    data['spo2'] = spo2;
    data['lain_lain'] = lainLain;
    data['skala_nyeri_face_number'] = skalaNyeriFaceNumber;
    return data;
  }
}

class DataSoap {
  String? idTcStatusPasien;
  String? subjektif;
  String? assesment;
  String? idTcSoap;
  String? objektif;

  DataSoap(
      {this.idTcStatusPasien,
      this.subjektif,
      this.assesment,
      this.idTcSoap,
      this.objektif});

  DataSoap.fromJson(Map<String, dynamic> json) {
    idTcStatusPasien = json['id_tc_status_pasien'];
    subjektif = json['subjektif'];
    assesment = json['assesment'];
    idTcSoap = json['id_tc_soap'];
    objektif = json['objektif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_tc_status_pasien'] = idTcStatusPasien;
    data['subjektif'] = subjektif;
    data['assesment'] = assesment;
    data['id_tc_soap'] = idTcSoap;
    data['objektif'] = objektif;
    return data;
  }
}

class DtTdk {
  int? noTdk;
  String? namaTindakan;

  DtTdk({this.noTdk, this.namaTindakan});

  DtTdk.fromJson(Map<String, dynamic> json) {
    noTdk = json['no_tdk'];
    namaTindakan = json['nama_tindakan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no_tdk'] = noTdk;
    data['nama_tindakan'] = namaTindakan;
    return data;
  }
}

class DtIcd10 {
  int? noIcd;
  String? icd10;

  DtIcd10({this.noIcd, this.icd10});

  DtIcd10.fromJson(Map<String, dynamic> json) {
    noIcd = json['no_icd'];
    icd10 = json['icd10'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no_icd'] = noIcd;
    data['icd10'] = icd10;
    return data;
  }
}

class Resep {
  String? namaBrg;
  String? note;
  bool? satuan;
  String? namaDosis;
  String? jumlahPesan;
  String? ket;
  int? no;

  Resep(
      {this.namaBrg,
      this.note,
      this.satuan,
      this.namaDosis,
      this.jumlahPesan,
      this.ket,
      this.no});

  Resep.fromJson(Map<String, dynamic> json) {
    namaBrg = json['nama_brg'];
    note = json['note'];
    satuan = json['satuan'];
    namaDosis = json['nama_dosis'];
    jumlahPesan = json['jumlah_pesan'];
    ket = json['ket'];
    no = json['no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nama_brg'] = namaBrg;
    data['note'] = note;
    data['satuan'] = satuan;
    data['nama_dosis'] = namaDosis;
    data['jumlah_pesan'] = jumlahPesan;
    data['ket'] = ket;
    data['no'] = no;
    return data;
  }
}

class DtLab {
  int? noUrut;
  String? urlRs;
  String? urlPdfLab;
  String? kodePenunjang;
  String? idPmTcPenunjang;
  String? diagnosa;
  String? flagCetak;
  String? noMrPx;
  int? txtKategori;

  DtLab(
      {this.noUrut,
      this.urlRs,
      this.urlPdfLab,
      this.kodePenunjang,
      this.idPmTcPenunjang,
      this.diagnosa,
      this.flagCetak,
      this.noMrPx,
      this.txtKategori});

  DtLab.fromJson(Map<String, dynamic> json) {
    noUrut = json['no_urut'];
    urlRs = json['url_rs'];
    urlPdfLab = json['url_pdf_lab'];
    kodePenunjang = json['kode_penunjang'];
    idPmTcPenunjang = json['id_pm_tc_penunjang'];
    diagnosa = json['diagnosa'];
    flagCetak = json['flag_cetak'];
    noMrPx = json['no_mr_px'];
    txtKategori = json['txt_kategori'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no_urut'] = noUrut;
    data['url_rs'] = urlRs;
    data['url_pdf_lab'] = urlPdfLab;
    data['kode_penunjang'] = kodePenunjang;
    data['id_pm_tc_penunjang'] = idPmTcPenunjang;
    data['diagnosa'] = diagnosa;
    data['flag_cetak'] = flagCetak;
    data['no_mr_px'] = noMrPx;
    data['txt_kategori'] = txtKategori;
    return data;
  }
}
