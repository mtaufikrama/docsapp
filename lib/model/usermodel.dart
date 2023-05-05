class UserProfile {
  int? code;
  String? msg;
  List<DtDokter>? dtDokter;

  UserProfile({this.code, this.msg, this.dtDokter});

  UserProfile.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['dt_dokter'] != null) {
      dtDokter = <DtDokter>[];
      json['dt_dokter'].forEach((v) {
        dtDokter!.add(DtDokter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    if (dtDokter != null) {
      data['dt_dokter'] = dtDokter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DtDokter {
  String? namaPegawai;
  String? namaSpesialisasi;
  String? urlFotoKaryawan;
  String? kodeDokter;
  String? kodeBagian;
  String? idDdUser;

  DtDokter(
      {this.namaPegawai,
      this.namaSpesialisasi,
      this.urlFotoKaryawan,
      this.kodeDokter,
      this.kodeBagian,
      this.idDdUser});

  DtDokter.fromJson(Map<String, dynamic> json) {
    namaPegawai = json['nama_pegawai'];
    namaSpesialisasi = json['nama_spesialisasi'];
    urlFotoKaryawan = json['url_foto_karyawan'];
    kodeDokter = json['kode_dokter'];
    kodeBagian = json['kode_bagian'];
    idDdUser = json['id_dd_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nama_pegawai'] = namaPegawai;
    data['nama_spesialisasi'] = namaSpesialisasi;
    data['url_foto_karyawan'] = urlFotoKaryawan;
    data['kode_dokter'] = kodeDokter;
    data['kode_bagian'] = kodeBagian;
    data['id_dd_user'] = idDdUser;
    return data;
  }
}
