import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:doctorapp/apiservice/serviceapi.dart';
import 'package:doctorapp/model/hissmodel.dart';
import 'package:doctorapp/model/periksamodel.dart';
import 'package:doctorapp/model/usermodel.dart';
import 'package:doctorapp/pages/itemantrian.dart';
import 'package:doctorapp/provider/auth_user.dart';
import 'package:doctorapp/utils/colors.dart';
import 'package:doctorapp/utils/constant.dart';
import 'package:doctorapp/utils/strings.dart';
import 'package:doctorapp/utils/utility.dart';
import 'package:doctorapp/widgets/mysvgassetsimg.dart';
import 'package:doctorapp/widgets/mytext.dart';
import 'package:doctorapp/widgets/mytextformfield.dart';
import 'package:flutter/material.dart';
import 'package:doctorapp/provider/pasien_prov.dart';
import 'package:doctorapp/model/pasienmodel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:doctorapp/pages/pasien/component/itemantrian_pasien.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;

class TindakanDokterObat extends StatefulWidget {
  const TindakanDokterObat({Key? key}) : super(key: key);

  @override
  State<TindakanDokterObat> createState() => _TindakanDokterObatState();
}

class _TindakanDokterObatState extends State<TindakanDokterObat> {
  final _formKey = GlobalKey<FormState>();
  int pilTindakan = 1;
  List<Map<dynamic, dynamic>> dataTindakan = [];
  List<Map<dynamic, dynamic>> dataObat = [];
  late List<HISSData> listSearchObat = [];
  late List<HISSData> listSearchTindakan = [];
  Map<dynamic, dynamic> _selectedItemUserTindakan = {
    "kode_tindakan": "-",
    "nama_tindakan": "-"
  };

  Map<dynamic, dynamic> _selectedItemUserObat = {
    "jumlah_stok": "-",
    "nama_obat": "-"
  };
  final Map<dynamic, dynamic> _selectedItemUserTindakan1 = {
    "act": "get_jenis_obat"
  };
  final Map<dynamic, dynamic> _selectedItemUserTindakan2 = {
    "act": "get_aturan_pakai",
    "id_kesediaan_obat": "9"
  };

  DataTindakan isiItem = DataTindakan();
  DataICD10 isiItemICD = DataICD10();

  TextEditingController jumlahTindakan = TextEditingController();
  TextEditingController jumlahObat = TextEditingController();
  String _hasBeenPressed = '';
  late FocusNode myFocusNode;
  bool typesearch = false;
  Map<dynamic, dynamic> _selectedItemUser = {
    "kode_obat": "-",
    "nama_obat": "-"
  };
  List<Map<dynamic, dynamic>> datalist = [];
  List<Map<dynamic, dynamic>> dataTindakan1 = [];
  List<Map<dynamic, dynamic>> dataTindakan2 = [];
  List<Map<dynamic, dynamic>> dataSoap = [];
  late List<HISSData> listSearchIsi = [];

  Map<dynamic, dynamic> _selectedICD10 = {"icd_10x": "-", "nama_icdx": "-"};
  late List<DataICD10> listSearchIsiICD10 = [];
  late List<HISSData> listSearchIsiICD10Astr = [];
  List<Map<dynamic, dynamic>> datalistIcd = [];
  List<Map<dynamic, dynamic>> datalistIcdAst = [];

  final List _getAsterix = [];

  get kode_bagian_far => null;

  @override
  void initState() {
    super.initState();
    _getFirtsInfoTindakan();
    _getFirtsInfoDosis();
    Provider.of<TindakanList>(context, listen: false).resetItem();
    EasyLoading.addStatusCallback(statusCallback);
    myFocusNode = FocusNode();
  }

  Future<void> _getFirtsInfoTindakan() async {
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    AntrianPasienProfile pasien = tablesProvider.DataPeriksaProfile;
    Uri urlTindakan = Uri.parse('${URLS.BASE_URL}/_api_soap/get_resep_px.php');

    var response = await Dio().get(
      urlTindakan.toString(),
      queryParameters: {"act": "get_aturan_pakai", "id_kesediaan_obat": "9"},
    );
    _selectedItemUser = {"jumlah_stok": "--", "nama_obat": "-"};
    if (datalist.isEmpty) {
      _selectedItemUser = {"jumlah_stok": "0", "nama_obat": "tidak ada data"};
    }
    _selectedItemUser = {
      "jumlah_stok": "1",
      "nama_obat": "pilih kelompok penyakit"
    };
    try {
      final data = response.data;

      if (data != null) {
        Map<dynamic, dynamic> map = json.decode(response.data);
        var result = map["list_dosis"];

        setState(() {
          dataTindakan2 = List<Map<dynamic, dynamic>>.from(result).toList();
        });
        print(dataTindakan2);
      } else {
        print('no ');
      }
    } catch (error) {
      // showAlertDialog(
      //     context: context, title: "Error ", content: error.toString());
      print(error.toString());
      return;
      //throw error;
    }
// finally {
//       await EasyLoading.dismiss();
//     }

    // AntrianPasienList;
  }

  Future<void> _getFirtsInfoDosis() async {
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    AntrianPasienProfile pasien = tablesProvider.DataPeriksaProfile;
    Uri urlTindakan = Uri.parse('${URLS.BASE_URL}/_api_soap/get_resep_px.php');

    var response = await Dio().get(
      urlTindakan.toString(),
      queryParameters: {"act": "get_jenis_obat"},
    );

    try {
      final data = response.data;
      if (data != null) {
        Map<dynamic, dynamic> map = json.decode(response.data);
        var result = map["jns_obat"];

        setState(() {
          dataTindakan1 = List<Map<dynamic, dynamic>>.from(result).toList();
        });
        print(dataTindakan1);
      } else {
        print('no ');
      }
    } catch (error) {
      // showAlertDialog(
      //     context: context, title: "Error ", content: error.toString());
      print(error.toString());
      return;
      //throw error;
    }
// finally {
//       await EasyLoading.dismiss();
//     }

    // AntrianPasienList;
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    EasyLoading.removeCallback(statusCallback);
    super.deactivate();
  }

  void statusCallback(EasyLoadingStatus status) {
    print('Test EasyLoading Status $status');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Future<bool> _AddTindakanObat() async {
      AntrianPasienProfile pasien =
          Provider.of<AuthPasienData>(context, listen: false)
              .DataPeriksaProfile;

      bool okeh = false;
      Map dataentry = {
        "no_mr": pasien.no_mr,
        "no_registrasi": pasien.no_registrasi
      };

      Uri? url = Uri.parse('${URLS.BASE_URL}/_api_soap/get_hasil_icd10_px.php');

      String bodyRaw = json.encode(dataentry);

      final response = await http.post(
        url,
        body: bodyRaw,
      );

      if (response.statusCode == 200) {
        okeh = true;
      }

      return okeh;
    }

    DataTindakan isiItem = DataTindakan();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar(), // blue,
      body: SizedBox(
          width: size.width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              profile(),
              Container(
                  child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Container(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 90, 0, 5),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                              padding: const EdgeInsets.all(2),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ItemSearch(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      height: 150,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                              child: ListComboItemKelompok(
                                                  context, dataSoap)),
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                              child: ListComboItemJenisObat()),
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                              child: ListComboItemDosisPakai()),
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      height: 160,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                              child: ListComboItemCatatan()),
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        postData();

                                        bool valid = await _AddTindakanObat();

                                        if (valid) {
                                          Provider.of<TindakanList>(context,
                                                  listen: false)
                                              .addItem(isiItem);
                                        }

                                        String mess = valid
                                            ? 'Data berhasil di tambahkan'
                                            : 'Data gagal di tambahkan';
                                        await AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.INFO,
                                          animType: AnimType.SCALE,
                                          title: 'Simpan Data',
                                          desc: mess,
                                          autoHide: const Duration(seconds: 5),
                                        ).show();
                                        return;
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: white,
                                        backgroundColor: const Color.fromRGBO(
                                            38, 153, 249, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        textStyle: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: black),
                                      ),
                                      child: const Text('Submit')),
                                ),
                                const ListItemAdd()
                              ]),
                        ),
                      )))),
            ],
          )),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      elevation: 4,
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 35, 163, 223),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      //statusBarColor,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: MySvgAssetsImg(
          imageName: "back.svg",
          fit: BoxFit.contain,
          imgHeight: 35,
          imgWidth: 30,
        ),
      ),
      title: MyText(
        mTitle: 'ISI Resep',
        mFontSize: 18,
        mFontStyle: FontStyle.normal,
        mFontWeight: FontWeight.normal,
        mTextAlign: TextAlign.center,
        mTextColor: white,
      ),
    );
  }

  Future postData() async {
    //Change values on setState
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      var progress = false;
      isiItem.type = pilTindakan == 1
          ? _selectedItemUserTindakan['no_mr']
          : _selectedItemUserObat['no_registrasi'];
    });

    print(isiItem);
  }

  Widget bottomnavbar(GetVitalSignPx item) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.20, // 125,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            //decoration for the outer wrapper
            color: const Color.fromARGB(255, 250, 249, 248),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 253, 250, 250)
                    .withOpacity(0.5), //color of shadow
                spreadRadius: 2, //spread radius
                blurRadius: 2, // blur radius
                offset: const Offset(0, 2), // changes position of shadow
              ),
              //you can set more BoxShadow() here
            ],
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  child: Stack(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 82,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        color: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(20, 10, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      clipBehavior: Clip.antiAlias,
                      child: MyText(
                        mTitle: 'Subyektif',
                        mFontSize: 16,
                        mOverflow: TextOverflow.ellipsis,
                        mMaxLine: 1,
                        mFontWeight: FontWeight.normal,
                        mTextAlign: TextAlign.start,
                        mTextColor: textTitleColor,
                      ),
                    ),
                  ),
                ],
              )))),
    );
  }

  @override
  Widget ItemSearch() {
    final debouncer = WaitingType(milliseconds: 1000);
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: TextFormField(
          maxLines: 1,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.next,
          style: const TextStyle(
              color: Color.fromARGB(255, 19, 1, 1),
              fontSize: 14,
              fontWeight: FontWeight.bold),
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 16, 10, 0),
            suffixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 12, 11, 11),
            ),
            border: InputBorder.none,
            hintText: "Pencarian Nama Obat",
            //filled: true,
            //fillColor: Color.fromARGB(255, 238, 232, 232)
          ),
          onChanged: (data) {
            _hasBeenPressed = data;
            typesearch = true;
            debouncer.run(() async {
              if (typesearch == true) {
                await _getSearchInfo();
                FocusScope.of(context).nextFocus();
              }
              typesearch = false;
            });
          },
        ),
      ),
    );
  }

  Future postData1() async {
    //Change values on setState
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      var progress = false;
      isiItem.type = pilTindakan == 1
          ? _selectedItemUserTindakan['no_mr']
          : _selectedItemUserObat['no_registrasi'];
    });

    print(isiItem);
  }

  @override
  Widget ItemSearchRacikanObata() {
    final debouncer = WaitingType(milliseconds: 1000);
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: TextFormField(
          maxLines: 1,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.next,
          style: const TextStyle(
              color: Color.fromARGB(255, 19, 1, 1),
              fontSize: 26,
              fontWeight: FontWeight.bold),
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 0),
              suffixIcon: Icon(
                Icons.search,
                color: Color.fromARGB(255, 12, 11, 11),
              ),
              border: InputBorder.none,
              hintText: "Nama Obat",
              hintStyle: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'nunito',
              )),
          onChanged: (data) {
            _hasBeenPressed = data;
            typesearch = true;
            debouncer.run(() async {
              if (typesearch == true) {
                await _getSearchInfo();
                FocusScope.of(context).nextFocus();
              }
              typesearch = false;
            });
          },
        ),
      ),
    );
  }

  Widget _textWidgeColumn({String? title, String? value}) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(title ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'RobotoMono',
                )),
          ),
          Flexible(
            child: Text(value ?? '-',
                textAlign: TextAlign.start,
                //overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: 'RobotoMono',
                )),
          )
        ],
      ),
    );
  }

  @override
  Widget ListComboItemICD() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        builder: (context, _) => SizedBox(
              height: double.infinity,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<DataICD10> items = listSearchIsiICD10;
                //AntrianPasienList;
                return Container(
                  child: const Padding(
                    padding: EdgeInsets.only(top: 2.0, bottom: 1, right: 1),
                  ),
                );
              }),
              //)
            ));
  }

  @override
  Widget ListComboItemKelompok(
      BuildContext context, List<Map<dynamic, dynamic>> item) {
    return FutureBuilder<List<AntrianPasienProfile>>(
        //future: _getFirtsInfo,
        builder: (context, _) => SizedBox(
              height: double.infinity,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<HISSData> items = listSearchIsi;
                //AntrianPasienList;
                return Container(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 1.0, bottom: 1, right: 1, left: 10),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          //padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 80,
                                child: DropdownSearch<Map<dynamic, dynamic>?>(
                                  selectedItem: _selectedItemUser,
                                  items: datalist,
                                  mode: Mode.MENU,
                                  isFilteredOnline: true,
                                  //showClearButton: true,
                                  showSearchBox: true,
                                  dropdownSearchDecoration:
                                      const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 14.0),
                                          labelText: "Nama Obat",
                                          floatingLabelStyle: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'nunito',
                                          ),
                                          filled: true,
                                          fillColor: white),
                                  dropdownSearchBaseStyle:
                                      const TextStyle(fontSize: 16.0),
                                  dropdownBuilder: (context, selectedItem) =>
                                      ListTile(
                                    title: Text(
                                      selectedItem!["nama_obat"] ??
                                          'Belum Pilih Nama Obat',
                                      style: GoogleFonts.roboto(fontSize: 16),
                                    ),
                                  ),
                                  popupItemBuilder:
                                      (context, item, isSelected) => ListTile(
                                    title: Text(
                                      item!["nama_obat"],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),

                                  onChanged: (value) async {
                                    _selectedItemUser = value!;
                                    _getfillICD10();
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Text('Jumlah',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'RobotoMono',
                                          )),
                                    ),
                                    MyTextFormFieldEntry(
                                      mController:
                                          jumlahTindakan, //mEmailController,
                                      mObscureText: false,
                                      mMaxLine: 1,
                                      mHintTextColor: textHintColor,
                                      mTextColor: otherColor,
                                      mkeyboardType: TextInputType.number,
                                      mTextInputAction: TextInputAction.next,
                                      mWidth: 83,
                                      mHeight: 25,
                                      //mInputBorder: InputBorder.,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ))),
                );
              }),
            )
        //)
        );
  }

  @override
  Widget ListComboItemJenisObat() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        //future: _getFirtsInfo,
        builder: (context, _) => SizedBox(
              height: double.infinity,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<HISSData> items = listSearchIsi;
                //AntrianPasienList;
                return Container(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 1.0, bottom: 1, right: 1, left: 10),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          //padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 80,
                                child: DropdownSearch<Map<dynamic, dynamic>?>(
                                  selectedItem: _selectedItemUserTindakan1,
                                  items: dataTindakan1,
                                  mode: Mode.MENU,
                                  isFilteredOnline: true,
                                  //showClearButton: true,
                                  showSearchBox: true,
                                  dropdownSearchDecoration:
                                      const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 14.0),
                                          labelText: "Jenis Obat",
                                          floatingLabelStyle: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'nunito',
                                          ),
                                          filled: true,
                                          fillColor: white),
                                  dropdownSearchBaseStyle:
                                      const TextStyle(fontSize: 16.0),
                                  dropdownBuilder: (context, selectedItem) =>
                                      ListTile(
                                    title: Text(
                                      selectedItem!["jenis_obat"] ??
                                          'Belum Pilih Jenis Obat',
                                      style: GoogleFonts.roboto(fontSize: 16),
                                    ),
                                  ),
                                  popupItemBuilder:
                                      (context, item, isSelected) => ListTile(
                                    title: Text(
                                      item!["jenis_obat"],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),

                                  onChanged: (value) async {
                                    _selectedItemUser = value!;
                                    _getfillICD10();
                                  },
                                ),
                              ),
                            ],
                          ))),
                );
              }),
            )
        //)
        );
  }

  @override
  Widget ListComboItemDosisPakai() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        //future: _getFirtsInfo,
        builder: (context, _) => SizedBox(
              height: double.infinity,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<HISSData> items = listSearchIsi;
                //AntrianPasienList;
                return Container(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 1.0, bottom: 1, right: 1, left: 10),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          //padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 80,
                                child: DropdownSearch<Map<dynamic, dynamic>?>(
                                  selectedItem: _selectedItemUserTindakan2,
                                  items: dataTindakan2,
                                  mode: Mode.MENU,
                                  isFilteredOnline: true,
                                  //showClearButton: true,
                                  showSearchBox: true,
                                  dropdownSearchDecoration:
                                      const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 14.0),
                                          labelText: "Aturan Pemakaian",
                                          floatingLabelStyle: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'nunito',
                                          ),
                                          filled: true,
                                          fillColor: white),
                                  dropdownSearchBaseStyle:
                                      const TextStyle(fontSize: 16.0),
                                  dropdownBuilder: (context, selectedItem) =>
                                      ListTile(
                                    title: Text(
                                      selectedItem!["nama_dosis"] ??
                                          'Belum Pilih Dosis Obat',
                                      style: GoogleFonts.roboto(fontSize: 16),
                                    ),
                                  ),
                                  popupItemBuilder:
                                      (context, item, isSelected) => ListTile(
                                    title: Text(
                                      item!["nama_dosis"],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),

                                  onChanged: (value) async {
                                    _selectedItemUser = value!;
                                    _getfillICD10();
                                  },
                                ),
                              ),
                              // Container(
                              //   padding: const EdgeInsets.only(top: 5),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.all(20.0),
                              //         child: const Text('/',
                              //             style: TextStyle(
                              //               fontSize: 13,
                              //               fontWeight: FontWeight.bold,
                              //               color: Colors.black,
                              //               fontFamily: 'RobotoMono',
                              //             )),
                              //       ),
                              //       MyTextFormFieldEntry(
                              //         // mController: jumlahTindakan, //mEmailController,
                              //         mObscureText: false,
                              //         mMaxLine: 1,
                              //         mHintTextColor: textHintColor,
                              //         mTextColor: otherColor,
                              //         mkeyboardType: TextInputType.number,
                              //         mTextInputAction: TextInputAction.next,
                              //         mWidth: 75,
                              //         mHeight: 25,
                              //         //mInputBorder: InputBorder.,
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.all(20.0),
                              //         child: const Text('X',
                              //             style: TextStyle(
                              //               fontSize: 13,
                              //               fontWeight: FontWeight.bold,
                              //               color: Colors.black,
                              //               fontFamily: 'RobotoMono',
                              //             )),
                              //       ),
                              //       MyTextFormFieldEntry(
                              //         // mController: jumlahTindakan, //mEmailController,
                              //         mObscureText: false,
                              //         mMaxLine: 1,
                              //         mHintTextColor: textHintColor,
                              //         mTextColor: otherColor,
                              //         mkeyboardType: TextInputType.number,
                              //         mTextInputAction: TextInputAction.next,
                              //         mWidth: 75,
                              //         mHeight: 25,
                              //         //mInputBorder: InputBorder.,
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.all(20.0),
                              //         child: const Text('P',
                              //             style: TextStyle(
                              //               fontSize: 13,
                              //               fontWeight: FontWeight.bold,
                              //               color: Colors.black,
                              //               fontFamily: 'RobotoMono',
                              //             )),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ))),
                );
              }),
            )
        //)
        );
  }

  @override
  Widget ListComboItemCatatan() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        //future: _getFirtsInfo,
        builder: (context, _) => SizedBox(
              height: double.infinity,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<HISSData> items = listSearchIsi;
                //AntrianPasienList;
                return Container(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 1.0, bottom: 1, right: 1, left: 10),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          //padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 5, left: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Expanded(
                                      child: TextField(
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Catatan',
                                          floatingLabelStyle: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'nunito',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ))),
                );
              }),
            )
        //)
        );
  }

  @override
  Widget ListComboItemKelompokSimple() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        builder: (context, _) => SizedBox(
              height: double.infinity,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<HISSData> items = listSearchIsi;
                //AntrianPasienList;
                return Container(
                  child: const Padding(
                      padding: EdgeInsets.only(top: 1.0, bottom: 1, right: 1),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        //padding: const EdgeInsets.only(top: 5, bottom: 5),
                      )),
                );
              }),
            )
        //)
        );
  }

  @override
  Widget ListComboItemICDAsterik() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        //future: _getFirtsInfo,
        builder: (context, _) =>
            // Padding(
            //     padding: EdgeInsets.only(
            //       top: 5, //ScreenUtil().setHeight(ScreenUtil().setHeight(10)),
            //       left: 5,
            //     ), //ScreenUtil().setHeight(ScreenUtil().setWidth(10.0))),
            //child:
            SizedBox(
              height: double.infinity,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<HISSData> items = listSearchIsiICD10Astr;
                //AntrianPasienList;
                return Container(
                  child: const Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 0, right: 5),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        //padding: const EdgeInsets.only(top: 5, bottom: 5),
                      )
                      //],
                      //),
                      ),
                );
              }),
              //)
            ));
  }

  Future<void> _getfillICD10() async {
    try {
      await EasyLoading.show(status: 'ISI data');

      setState(() {
        listSearchIsiICD10 = [];
        datalistIcd = [];
        _selectedICD10 = _selectedItemUser;
        _selectedICD10['jumlah_stok'] = _selectedItemUser['jumlah_stok'] +
            ',' +
            _selectedItemUser['jumlah_stok'];
        print(_selectedICD10);
        print(_selectedItemUser);
        _selectedICD10 = _selectedItemUser;
        DataICD10 isi = DataICD10(
            idCD10: _selectedItemUser['jumlah_stok'],
            idCD10Ket: _selectedItemUser['jumlah_stok'] +
                ' ,' +
                _selectedItemUser['jumlah_stok']);
        print(_selectedItemUser);
        listSearchIsiICD10.add(isi);
        datalistIcd =
            List<Map<dynamic, dynamic>>.from(listSearchIsiICD10).toList();
      });

      print('icd10 ${datalistIcd.length}');
    } catch (error) {
      await EasyLoading.dismiss();

      return;
      //throw error;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _getSearchInfo() async {
    Uri url = Uri.parse('${URLS.BASE_URL}/_api_soap/get_resep_px.php');

    try {
      await EasyLoading.show(status: 'search data');

      var response = await Dio().get(url.toString(), queryParameters: {
        "act": "get_nama_obat",
        "$kode_bagian_far": "",
        "src_obat": _hasBeenPressed
      });

      _selectedItemUser = {"jumlah_stok": "--", "nama_obat": "-"};

      final data = response.data;
      //datalist = [];
      setState(() {
        datalist = [];
        dataSoap = [];
      });

      if (data != null) {
        Map<dynamic, dynamic> map = json.decode(response.data);
        var result = map["list_obat"];

        setState(() {
          datalist = List<Map<dynamic, dynamic>>.from(result).toList();
        });
      }

      if (datalist.isEmpty) {
        _selectedItemUser = {"jumlah_stok": "0", "nama_obat": "tidak ada data"};
      } else {
        _selectedItemUser = {
          "jumlah_stok": "1",
          "nama_obat": "Belum pilih Obat"
        };
      }
    } catch (error) {
      await EasyLoading.dismiss();

      return;
      //throw error;
    } finally {
      await EasyLoading.dismiss();
    }

    print('Jumlah nya ${datalist.length}');
  }

  Widget profile() {
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    AntrianPasienProfile modelprofile = tablesProvider.DataPeriksaProfile;

    return FutureBuilder(
        // future: ProfileDetail(),
        builder: (context, _) => Padding(
            // padding: EdgeInsets.symmetric(horizontal: 0),
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              width: displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                return SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(children: [
                      Stack(children: [
                        SizedBox(
                          height: displayHeight(context) * .55, // 125,
                          width: displayWidth(context),
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 35, 163, 223),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Design1.png'),
                                      fit: BoxFit.cover),
                                ),
                                width: displayWidth(context),
                                height: 230,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      _textWidgetRow(
                                          title:
                                              "Pasien yang Sedang di periksa"),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      _textWidgetRow(
                                          title: "Nama Pasien:",
                                          value: modelprofile.nama_px),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      _textWidgetRow(
                                          title: "No MR:",
                                          value: modelprofile.no_mr),
                                    ],
                                  ),
                                ),
                                //color: Colors.deepPurpleAccent,
                              ),
                            ],
                          ),
                        )
                      ])
                    ]));
              }),
            )));
  }

  Widget _textWidgetRow({String? title, String? value}) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 252, 248, 248),
                fontFamily: 'RobotoMono',
              )),
          const SizedBox(width: 10),
          Flexible(
            child: Text(value ?? '',
                textAlign: TextAlign.start,
                //overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 252, 248, 248),
                  fontFamily: 'RobotoMono',
                )),
          )
        ],
      ),
    );
  }

  @override
  Widget ButtonPasien() {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    GetVitalSignPx vitalsignDataDef;
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    vitalsignDataDef = tablesProvider.DataPeriksa;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.10, // 125,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            //decoration for the outer wrapper
            color: const Color.fromARGB(255, 250, 249, 248),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  child: Stack(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 82,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 3,
                        color: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                  //height: double.infinity,
                                  child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ElevatedButtonTheme(
                                      data: ElevatedButtonThemeData(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize:
                                                  const Size(160, 60))),
                                      child: ButtonBar(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                pilTindakan = 1;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor:
                                                    pilTindakan == 1
                                                        ? white
                                                        : black,
                                                backgroundColor:
                                                    pilTindakan == 1
                                                        ? const Color.fromRGBO(
                                                            38, 153, 249, 1)
                                                        : white,
                                                textStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                    color: black)),
                                            child: const Text('Tindakan'),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  pilTindakan = 2;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor:
                                                    pilTindakan == 2
                                                        ? white
                                                        : black,
                                                backgroundColor:
                                                    pilTindakan == 2
                                                        ? const Color.fromRGBO(
                                                            38, 153, 249, 1)
                                                        : white,
                                                textStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                    color: black
                                                    //  pilTindakan == 2
                                                    //   ? white
                                                    //   : black
                                                    ),
                                              ),
                                              child:
                                                  const Text('Pemberian Obat')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                        ),
                      ),
                    ),
                  ),
                ],
              )))),
    );
  }

  @override
  Widget IsiTindakan(BuildContext context, List<Map<dynamic, dynamic>> item) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.22, // 125,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: blue, //                   <--- border color
                      width: 3.0,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 82,
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                //height: double.infinity,
                                child: ListComboItemTindakan(),
                              )),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 115),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('Jumlah',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'RobotoMono',
                                  )),
                            ),
                            MyTextFormFieldEntry(
                              mController: jumlahTindakan, //mEmailController,
                              mObscureText: false,
                              mMaxLine: 1,
                              mHintTextColor: textHintColor,
                              mTextColor: otherColor,
                              mkeyboardType: TextInputType.number,
                              mTextInputAction: TextInputAction.next,
                              mWidth: 75,
                              mHeight: 25,
                              //mInputBorder: InputBorder.,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )))),
    );
  }

  @override
  Widget IsiObat(BuildContext context, List<Map<dynamic, dynamic>> item) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.22, // 125,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: blue, //                   <--- border color
                      width: 3.0,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 82,
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                child: ListComboItemObat(),
                              )),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 115),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.all(20.0),
                            //   child: const Text('Jumlah',
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.black,
                            //         fontFamily: 'RobotoMono',
                            //       )),
                            // ),
                            MyTextFormFieldEntry(
                              mController: jumlahObat, //mEmailController,
                              mObscureText: false,
                              mMaxLine: 1,
                              mHintTextColor: textHintColor,
                              mTextColor: otherColor,
                              mkeyboardType: TextInputType.number,
                              mTextInputAction: TextInputAction.next,
                              mWidth: 75,
                              mHeight: 25,
                              //mInputBorder: InputBorder.,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )))),
    );
  }

  @override
  Widget ListComboItemTindakan() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        //future: _getFirtsInfo,
        builder: (context, _) => Padding(
            padding: const EdgeInsets.only(
              top: 10, //ScreenUtil().setHeight(ScreenUtil().setHeight(10)),
              left: 10,
            ), //ScreenUtil().setHeight(ScreenUtil().setWidth(10.0))),
            child: SizedBox(
              height: double.infinity * 0.55,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<HISSData> items = listSearchTindakan;
                //AntrianPasienList;
                return Container(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                        //padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: SizedBox(
                          height: 35,
                          child: DropdownSearch<Map<dynamic, dynamic>?>(
                            selectedItem: _selectedItemUserTindakan,
                            items: dataTindakan,
                            mode: Mode.DIALOG,
                            isFilteredOnline: true,
                            //showClearButton: true,
                            showSearchBox: true,
                            dropdownSearchDecoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor),
                            dropdownBuilder: (context, selectedItem) =>
                                ListTile(
                              title: Text(selectedItem!["nama_obat"] ??
                                  'Belum Pilih ICD-10'),
                            ),
                            popupItemBuilder: (context, item, isSelected) =>
                                ListTile(
                              title: Text(item!["nama_obat"]),
                            ),
                            onChanged: (value) async {
                              _selectedItemUserTindakan = value!;
                            },
                          ),
                        ),
                      )
                      //],
                      //),
                      ),
                );
              }),
            )));
  }

  @override
  Widget ListComboItemObat() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        //future: _getFirtsInfo,
        builder: (context, _) => Padding(
            padding: const EdgeInsets.only(
              top: 10, //ScreenUtil().setHeight(ScreenUtil().setHeight(10)),
              left: 10,
            ), //ScreenUtil().setHeight(ScreenUtil().setWidth(10.0))),
            child: SizedBox(
              height: double.infinity * 0.55,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<HISSData> items = listSearchObat;
                //AntrianPasienList;
                return Container(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                        //padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: SizedBox(
                          height: 35,
                          child: DropdownSearch<Map<dynamic, dynamic>?>(
                            selectedItem: _selectedItemUserObat,
                            items: dataObat,
                            mode: Mode.DIALOG,
                            isFilteredOnline: true,
                            //showClearButton: true,
                            showSearchBox: true,
                            dropdownSearchDecoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor),
                            dropdownBuilder: (context, selectedItem) =>
                                ListTile(
                              title: Text(selectedItem!["nama_obat"] ??
                                  'Belum Pilih Obat'),
                            ),
                            popupItemBuilder: (context, item, isSelected) =>
                                ListTile(
                              title: Text(item!["nama_obat"]),
                            ),
                            onChanged: (value) async {
                              _selectedItemUserObat = value!;
                            },
                          ),
                        ),
                      )
                      //],
                      //),
                      ),
                );
              }),
            )));
  }
}

class ListItemAdd extends StatelessWidget {
  const ListItemAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TindakanList tablesProvider =
        Provider.of<TindakanList>(context, listen: false);

    List<DataTindakan> itemTindakanObat = tablesProvider.DataTindakanPasien;
    var scrollControllertrans = ScrollController();

    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.22, // 125,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text('Tindakan dan Obat'),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Hasil Resep'),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: TindakanListEntry(
                      scrollControllertrans, itemTindakanObat),
                )
              ],
            )
            //TindakanListEntry(_scrollControllertrans, itemTindakanObat),
            ));

    // return Container(
    //     child: FutureBuilder<List<DataTindakan>>(
    //         //future: getData(),
    //         builder: (context, _) => Padding(
    //             padding: EdgeInsets.only(),
    //             child: Container(
    //               height: displayHeight(context),
    //               width: double.infinity, //  displayWidth(context),
    //               child: LayoutBuilder(builder: (context, constraints) {
    //                 var parentHeight = constraints.maxHeight;
    //                 var parentWidth = constraints.maxWidth;
    //                 final List<DataTindakan>? items = itemTindakanObat;
    //                 return Padding(
    //                   padding: const EdgeInsets.all(3.0),
    //                   child: Scrollbar(
    //                     child: ListView.builder(
    //                       physics:
    //                           const AlwaysScrollableScrollPhysics(), //Even if zero elements to update scroll
    //                       itemCount: items!.length,
    //                       scrollDirection: Axis.vertical,
    //                       controller: _scrollControllertrans,
    //                       itemBuilder: (context, index) {
    //                         return items[index] == null
    //                             ? CircularProgressIndicator()
    //                             : Padding(
    //                                 padding: const EdgeInsets.all(5.0),
    //                                 child: Text(items[index].keterangan));

    //                         //: Text(items![index].Subtitle);
    //                       },
    //                     ),
    //                   ),
    //                 );
    //               }),
    //             )))
    //     // body: Container(
    //     //     child: SingleChildScrollView(
    //     //         scrollDirection: Axis.vertical,
    //     //         child: Container(
    //     //           child: Column(
    //     //               mainAxisAlignment: MainAxisAlignment.start,
    //     //               children: [
    //     //                 ...Iterable<int>.generate(itemTindakanObat.length)
    //     //                     .map((int pageIndex) =>
    //     //                     Container(
    //     //                       child: LayoutBuilder(builder: (context, constraints) {},
    //     //                     )
    //     //               ]),
    //     //         ))),
    //     );
  }

  Widget TindakanListEntry(
      ScrollController controltrans, List<DataTindakan> itemTindakanObat) {
    return Container(
        child: FutureBuilder<List<DataTindakan>>(
            //future: getData(),
            builder: (context, _) => Padding(
                padding: const EdgeInsets.only(),
                child: SizedBox(
                  height: displayHeight(context),
                  width: double.infinity, //  displayWidth(context),
                  child: LayoutBuilder(builder: (context, constraints) {
                    var parentHeight = constraints.maxHeight;
                    var parentWidth = constraints.maxWidth;
                    final List<DataTindakan> items = itemTindakanObat;
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Scrollbar(
                        child: ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(), //Even if zero elements to update scroll
                          itemCount: items.length,
                          scrollDirection: Axis.vertical,
                          controller: controltrans,
                          itemBuilder: (context, index) {
                            return items[index] == null
                                ? const CircularProgressIndicator()
                                : Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child:
                                        //Text(items[index].keterangan)
                                        Column(
                                      children: [
                                        IsiTindakanListEntry(items[index]),
                                      ],
                                    ));

                            //: Text(items![index].Subtitle);
                          },
                        ),
                      ),
                    );
                  }),
                ))));
  }

  Widget IsiTindakanListEntry(DataTindakan data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.start, //change here don't //worked
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  left: 8.0, top: 0.0, bottom: 8.0, right: 12.0),
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.0)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.keterangan,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'NAMA OBAT:${data.tanggal}',
                  style: const TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                Text(
                  'SATUAN:${data.keterangan}',
                  style: const TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                Text(
                  'JUMLAH:${data.keterangan}',
                  style: const TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                Text(
                  'ATURAN PEMAKAIAN:${data.keterangan}',
                  style: const TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                Text(
                  'NOTE:${data.keterangan}',
                  style: const TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                Text(
                  'KET:${data.keterangan}',
                  style: const TextStyle(color: Colors.black, fontSize: 14.0),
                ),
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Divider(color: Colors.black),
        ),
      ]),
    );
  }
}
