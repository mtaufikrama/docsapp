import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:doctorapp/apiservice/serviceapi.dart';
import 'package:doctorapp/model/hissmodel.dart';
import 'package:doctorapp/model/periksamodel.dart';
import 'package:doctorapp/model/usermodel.dart';
import 'package:doctorapp/pages/itemantrian.dart';
//import 'package:doctorapp/pages/pasien/component/list_antrian_pasiendetail.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:doctorapp/pages/pasien/component/itemantrian_pasien.dart';
import 'package:dropdown_search/dropdown_search.dart';

class PenunjangMedis extends StatefulWidget {
  const PenunjangMedis({Key? key}) : super(key: key);

  @override
  State<PenunjangMedis> createState() => _PenunjangMedisState();
}

class _PenunjangMedisState extends State<PenunjangMedis> {
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
    "kode_obat": "-",
    "nama_obat": "-"
  };

  DataTindakan isiItem = DataTindakan();

  TextEditingController jumlahTindakan = TextEditingController();
  TextEditingController jumlahObat = TextEditingController();
  TextEditingController BiayaTindakan = TextEditingController();
  TextEditingController BiayaObat = TextEditingController();
  bool progress = false;

  @override
  void initState() {
    _getFirtsInfoTindakan();
    _getFirtsInfoObat();
    super.initState();
    Provider.of<TindakanList>(context, listen: false).resetItem();
  }

  Future<void> _getFirtsInfoTindakan() async {
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    AntrianPasienProfile pasien = tablesProvider.DataPeriksaProfile;

    Uri urlTindakan = Uri.parse('${URLS.BASE_URL}/_api_soap/get_tindakan.php');
    Uri urlObat = Uri.parse('${URLS.BASE_URL}/_api_soap/get_obat_tindakan.php');

    var response = await Dio().get(
      urlTindakan.toString(),
      queryParameters: {"kode_bagian_tujuan": pasien.kode_bagian_tujuan},
    );

    try {
      final data = response.data;

      if (data != null) {
        Map<dynamic, dynamic> map = json.decode(response.data);
        var result = map["arr_tindakan"];

        setState(() {
          dataTindakan = List<Map<dynamic, dynamic>>.from(result).toList();
        });
      } else {}
    } catch (error) {
      // showAlertDialog(
      //     context: context, title: "Error ", content: error.toString());
      print(error.toString());
      return;
      //throw error;
    }
  }

  Future<void> _getFirtsInfoObat() async {
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    AntrianPasienProfile pasien = tablesProvider.DataPeriksaProfile;

    Uri urlObat = Uri.parse('${URLS.BASE_URL}/_api_soap/get_obat_tindakan.php');

    var response = await Dio().get(
      urlObat.toString(),
      queryParameters: {"kode_bagian_tujuan": pasien.kode_bagian_tujuan},
    );

    try {
      final data = response.data;

      if (data != null) {
        Map<dynamic, dynamic> map = json.decode(response.data);
        var result = map["arr_obat"];

        setState(() {
          dataObat = List<Map<dynamic, dynamic>>.from(result).toList();
        });

        print(dataObat);
      } else {
        print('no ');
      }
    } catch (error) {
      print(error.toString());
      return;
      //throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: white, // blue,
        body: SizedBox(
            width: size.width,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                profile(),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 110),
                    child: Container(
                      child: Padding(
                        //padding: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ButtonPasien(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ), //groupCategory
                Container(
                    child: Padding(
                        padding: const EdgeInsets.only(
                          top: 200,
                        ),
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 20),
                          child: Form(
                              key: _formKey,
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(children: [
                                    Expanded(
                                        child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors
                                              .white24, //                   <--- border color
                                          width: 3.0,
                                        ),
                                        color: const Color.fromARGB(
                                            255, 248, 246, 246),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(25.0),
                                        ), // BorderRadius
                                      ), // BoxDe
                                      child: ListView(
                                        children: [
                                          pilTindakan == 1
                                              ? IsiTindakan(
                                                  context, dataTindakan)
                                              : IsiObat(context, dataObat),
                                          //progress
                                          // ? Container(
                                          //     height: 50,
                                          //     width: 50,
                                          //     child:
                                          //         CircularProgressIndicator(),
                                          //   )
                                          // :

                                          ElevatedButton(
                                              onPressed: () async {
                                                // await new Future.delayed(
                                                //     const Duration(seconds: 3));
                                                setState(() {
                                                  //   //pilTindakan = 2;
                                                  isiItem
                                                      .keterangan = pilTindakan ==
                                                          1
                                                      ? _selectedItemUserTindakan[
                                                          'nama_tindakan']
                                                      : _selectedItemUserObat[
                                                          'nama_obat'];
                                                  isiItem.type = pilTindakan ==
                                                          1
                                                      ? _selectedItemUserTindakan[
                                                          'kode_tindakan']
                                                      : _selectedItemUserObat[
                                                          'kode_obat'];
                                                  progress = true;
                                                });

                                                postData();

                                                bool valid =
                                                    await _AddTindakanObat();

                                                if (valid) {
                                                  Provider.of<TindakanList>(
                                                          context,
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
                                                  desc:
                                                      mess, // 'Cek ID dan Password Anda',
                                                  autoHide: const Duration(
                                                      seconds: 5),
                                                ).show();
                                                return;
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: white,
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        38, 153, 249, 1),
                                                textStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                    color: black),
                                              ),
                                              child: const Text('Submit')),
                                          const ListItemAdd()
                                        ],
                                      ),
                                    )),
                                  ]))),
                        )))),
              ],
            )),
      ),
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
        mTitle: 'Medical Record Pasien',
        mFontSize: 18,
        mFontStyle: FontStyle.normal,
        mFontWeight: FontWeight.normal,
        mTextAlign: TextAlign.center,
        mTextColor: white,
      ),
    );
  }

  Future<bool> _AddTindakanObat() async {
    AntrianPasienProfile pasien =
        Provider.of<AuthPasienData>(context, listen: false).DataPeriksaProfile;

    bool okeh = false;
    Map dataentry = {
      "no_registrasi": pasien.no_registrasi,
      "no_kunjungan": pasien.no_kunjungan,
      "kode_bagian_tujuan": pasien.kode_bagian_tujuan,
      "kode_dokter": pasien.dokterid,
      "no_mr": pasien.no_mr,
      "nama_pasien": pasien.nama_px,
      "kode_tarif": "20290",
      "jumlah_tindakan": jumlahTindakan.text,
      "kode_brg": _selectedItemUserTindakan['kode_tindakan'],
      "jumlah_obat": jumlahTindakan.text,
      "id_user": "1",
    };

    print(dataentry);
    Uri? url = Uri.parse('${URLS.BASE_URL}/_api_soap/add_tindakan.php');

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

  Future<void> ProfileDetail() async {}
  Widget profile() {
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    AntrianPasienProfile modelprofile = tablesProvider.DataPeriksaProfile;

    return FutureBuilder(
        future: ProfileDetail(),
        builder: (context, _) => Padding(
            // padding: EdgeInsets.symmetric(horizontal: 0),
            padding: const EdgeInsets.only(top: 0),
            // child: Positioned(
            //     top: 10,
            //     left: 30,
            child: Container(
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
                    child: Column(children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: displayHeight(context) * .15, // 125,
                        width: displayWidth(context),
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: 150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 38,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: Color.fromARGB(255, 250, 247, 247),
                                size: 25,
                              ),
                            ),
                            label: const Text(""),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(blue),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(2)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: MyText(
                            mTitle: 'Tindakan Dokter',
                            mFontSize: 20,
                            mFontStyle: FontStyle.normal,
                            mFontWeight: FontWeight.normal,
                            mTextAlign: TextAlign.center,
                            mTextColor: white,
                          ),
                        ),
                      ),
                      Positioned(
                        //<-- SEE HERE
                        left: 0,
                        top: 55,
                        child: SizedBox(
                          width: displayWidth(context),
                          height: 230,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                _textWidgetRow(
                                    title: "Nama Pasien :",
                                    value: modelprofile.nama_px),
                                const SizedBox(
                                  height: 10,
                                ),
                                _textWidgetRow(
                                    title: "No MR:", value: modelprofile.no_mr),
                              ],
                            ),
                          ),
                          //color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  ),
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
          Text(title ?? '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 252, 248, 248),
                fontFamily: 'RobotoMono',
              )),
          const SizedBox(width: 10),
          Flexible(
            child: Text(value ?? '-',
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
            color: white,
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

  Future postData() async {
    //Change values on setState
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      progress = false;
      isiItem.keterangan = pilTindakan == 1
          ? _selectedItemUserTindakan['nama_tindakan']
          : _selectedItemUserObat['nama_obat'];
      isiItem.type = pilTindakan == 1
          ? _selectedItemUserTindakan['kode_tindakan']
          : _selectedItemUserObat['kode_obat'];
    });

    //print(isiItem);
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
                            dropdownSearchDecoration: const InputDecoration(
                                filled: true, fillColor: white),
                            dropdownBuilder: (context, selectedItem) =>
                                ListTile(
                              title: Text(selectedItem!["nama_tindakan"] ??
                                  'Belum Pilih Tindakan'),
                            ),
                            popupItemBuilder: (context, item, isSelected) =>
                                ListTile(
                              title: Text(item!["nama_tindakan"]),
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
                            dropdownSearchDecoration: const InputDecoration(
                                filled: true, fillColor: white),
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
          height: MediaQuery.of(context).size.height * 0.38, // 125,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(
              color: blue, //                   <--- border color
              width: 3.0,
            ),
          ),
          child: TindakanListEntry(scrollControllertrans, itemTindakanObat),
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
                                    padding: const EdgeInsets.all(5.0),
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
      padding: const EdgeInsets.all(5.0),
      child: Column(children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.start, //change here don't //worked
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  left: 8.0, top: 8.0, bottom: 8.0, right: 12.0),
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(40.0)),
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
                  'Jumlah: ${data.qty}',
                  style: const TextStyle(color: Colors.black, fontSize: 14.0),
                )
              ],
            ),
            const Spacer(), // I just added one line
            InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {},
                child: const Icon(Icons.delete_forever, color: Colors.black)),

            // This Icon
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
