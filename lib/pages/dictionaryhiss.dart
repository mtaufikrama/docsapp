import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:doctorapp/apiservice/serviceapi.dart';
import 'package:doctorapp/model/hissmodel.dart';
import 'package:doctorapp/model/periksamodel.dart';
import 'package:doctorapp/model/usermodel.dart';
import 'package:doctorapp/pages/pasien/component/list_antrian_pasiendetail.dart';
//import 'package:doctorapp/pages/pasien/component/list_antrian_pasiendetail.dart';
import 'package:doctorapp/provider/auth_user.dart';
import 'package:doctorapp/utils/colors.dart';
import 'package:doctorapp/utils/constant.dart';
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
import 'package:dropdown_search/dropdown_search.dart';

//mport 'package:pluto_grid/pluto_grid.dart';

class HISS extends StatefulWidget {
  const HISS({Key? key}) : super(key: key);

  @override
  State<HISS> createState() => _HISSState();
}

class _HISSState extends State<HISS> {
  final _scrollControllertrans = ScrollController();
  String _hasBeenPressed = '';
  String _hasButtonPressed = '';
  List<HISSData> KelompokPenyakitList = [];
  List<AntrianPasienProfile> AntrianPasienList = [];
  late List<HISSData> listSearchIsi = [];
  late List<AntrianPasienProfile> listSearchKelompok = [];
  bool searchSts = false;
  late int pilihgroup = 1;
  Map<dynamic, dynamic> _selectedItemUser = {"ID1": "-", "nama_penyakit": "-"};
  List<Map<dynamic, dynamic>> datalist = [];
  GetVitalSignPx vitalSignPasien = GetVitalSignPx();
  List<Map<dynamic, dynamic>> dataSoap = [];
  final _formKey = GlobalKey<FormState>();
  late List<String>? groupCategoryIsi = [];
  late List<String>? groupCategorybutton = [];
  List<String>? groupisiCategorybutton = [];

  TextEditingController HISSPenyakit = TextEditingController();
  TextEditingController HISSSubyektif = TextEditingController();
  TextEditingController HISSObyektif = TextEditingController();
  TextEditingController HISSAnalis = TextEditingController();

  late FocusNode myFocusNode;
  bool typesearch = false;

  @override
  void initState() {
    _hasBeenPressed = "";
    _hasButtonPressed = "";
    super.initState();
    _selectedItemUser = {"ID1": "--", "nama_penyakit": "-"};
    HISSPenyakit.text = "";
    getData();
    groupisiCategorybutton!.add('isi 1');
    EasyLoading.addStatusCallback(statusCallback);
    myFocusNode = FocusNode();
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

  Future<void> _getSearchInfo() async {
    Uri url =
        Uri.parse('${URLS.BASE_URL}/_api_soap/get_nama_penyakit_hiss.php');

    try {
      await EasyLoading.show(status: 'search data');

      var response = await Dio().get(
        url.toString(),
        queryParameters: {"src_penyakit": _hasBeenPressed},
      );

      _selectedItemUser = {"ID1": "--", "nama_penyakit": "-"};

      final data = response.data;
      //datalist = [];
      setState(() {
        datalist = [];
        pilihgroup = 1;
        HISSPenyakit.text = "";
        HISSSubyektif.text = "";
        HISSObyektif.text = "";
        HISSAnalis.text = "";
        dataSoap = [];
      });

      if (data != null) {
        Map<dynamic, dynamic> map = json.decode(response.data);
        var result = map["list"];

        setState(() {
          datalist = List<Map<dynamic, dynamic>>.from(result).toList();
          searchSts = true;
        });
      }

      if (datalist.isEmpty) {
        _selectedItemUser = {"ID1": "0", "nama_penyakit": "tidak ada data"};
      } else {
        _selectedItemUser = {
          "ID1": "1",
          "nama_penyakit": "pilih kelompok penyakit"
        };
      }
    } catch (error) {
      await EasyLoading.dismiss();
      // showAlertDialog(
      //     context: context, title: "Error ", content: error.toString());
      return;
      //throw error;
    } finally {
      await EasyLoading.dismiss();
    }

    //print('Jumlah nya ' + datalist.length.toString());
  }

  Future<void> _getSearchSOAPInfo(String IDSoap) async {
    Uri url = Uri.parse('${URLS.BASE_URL}/_api_soap/get_soap_hiss.php');

    var response = await Dio().get(
      url.toString(),
      queryParameters: {"ID": '36'}, // IDSoap},
    );

    final data = response.data;
    List<HISSData> myModels = [];

    if (data != null) {
      Map<String, dynamic> map = json.decode(response.data);
      groupisiCategorybutton!.clear();
      var result = map["list"];
      setState(() {
        dataSoap = List<Map<dynamic, dynamic>>.from(result).toList();
        HISSPenyakit.text = dataSoap[0]['Nama_Penyakit'];
        HISSSubyektif.text = dataSoap[0]['subyektif/gejala'];
        HISSObyektif.text = dataSoap[0]['objektif/penyebab'];
        HISSAnalis.text = dataSoap[0]['analisis/pengobatan'];
        //pilihgroup += 1;
        pilihgroup = 0;
        _hasButtonPressed = groupCategorybutton![0].toString();

        groupisiCategorybutton!.add(dataSoap[0]['subyektif/gejala']);
        groupisiCategorybutton!.add(dataSoap[0]['objektif/penyebab']);
        groupisiCategorybutton!.add(dataSoap[0]['penunjang']);
        groupisiCategorybutton!.add(dataSoap[0]['analisis/pengobatan']);
        groupisiCategorybutton!.add(dataSoap[0]['komplikasi']);
        groupisiCategorybutton!.add(dataSoap[0]['Differential']);
        groupisiCategorybutton!.add(dataSoap[0]['catatan']);
        groupisiCategorybutton!.add('-');

        print('isi ${groupisiCategorybutton!.length}');
        print({groupisiCategorybutton![0], dataSoap[0]['subyektif/gejala']});
      });

      print(pilihgroup);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        appBar: myAppBar(),
        body: Container(
            child: Stack(alignment: Alignment.topLeft, children: [
          SingleChildScrollView(
              child: Column(children: [
            profile(),
            isikonten(),
          ]))
        ])));
  }

  Widget isikonten() {
    return Container(
        child: Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text('Category HISS',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              child: Padding(
                //padding: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                ),
              ),
            ),
          ),
        ),
        Container(
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: ItemCategory(),
                )))),
        Container(
            child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 2.1,
                        child: Column(
                          children: [
                            Expanded(
                                child: Padding(
                                    //padding: const EdgeInsets.all(8.0),
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 0, right: 0, bottom: 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors
                                              .white24, //                   <--- border color
                                          width: 3.0,
                                        ),
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(25.0),
                                        ), // BorderRadius
                                      ), // BoxDe
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ClipPath(
                                          clipper: const ShapeBorderClipper(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              25)))),
                                          child: Padding(
                                            //padding: const EdgeInsets.all(15.0),
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Column(children: <Widget>[
                                              HISSKelompok(),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('Subyektif',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'RobotoMono',
                                                      )),
                                                ),
                                              ),
                                              MyTextFormFieldEntry(
                                                mController:
                                                    HISSSubyektif, //mEmailController,
                                                mObscureText: false,
                                                mMaxLine: 10,
                                                mHintTextColor: textHintColor,
                                                mTextColor: otherColor,
                                                mkeyboardType:
                                                    TextInputType.text,
                                                mTextInputAction:
                                                    TextInputAction.next,
                                                mWidth: 500,
                                                mHeight: 100,
                                                //mInputBorder: InputBorder.,
                                              ),
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('Objektif',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'RobotoMono',
                                                      )),
                                                ),
                                              ),
                                              MyTextFormFieldEntry(
                                                mController:
                                                    HISSObyektif, //mEmailController,
                                                mObscureText: false,
                                                mMaxLine: 10,
                                                mHintTextColor: textHintColor,
                                                mTextColor: otherColor,
                                                mkeyboardType:
                                                    TextInputType.text,
                                                mTextInputAction:
                                                    TextInputAction.next,
                                                mWidth: 500,
                                                mHeight: 100,
                                                //mInputBorder: InputBorder.,
                                              ),
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('Analisys',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'RobotoMono',
                                                      )),
                                                ),
                                              ),
                                              MyTextFormFieldEntry(
                                                mController:
                                                    HISSAnalis, //mEmailController,
                                                mObscureText: false,
                                                mMaxLine: 10,
                                                mHintTextColor: textHintColor,
                                                mTextColor: otherColor,
                                                mkeyboardType:
                                                    TextInputType.text,
                                                mTextInputAction:
                                                    TextInputAction.next,
                                                mWidth: 500,
                                                mHeight: 100,
                                                //mInputBorder: InputBorder.,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Container(
                                                        //height: double.infinity,
                                                        child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                    ))),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    )))
                          ],
                        ),
                      ),
                    ),
                  ),
                )))),
      ],
    ));
  }

  Future<void> ProfileDetail() async {}

  Widget profile() {
    return FutureBuilder(
        future: ProfileDetail(),
        builder: (context, _) => Padding(
            // padding: EdgeInsets.symmetric(horizontal: 0),
            padding: const EdgeInsets.only(top: 0),
            //     left: 30,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: blue,
                image: DecorationImage(
                    image: AssetImage('assets/images/Design1.png'),
                    fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 0), // Shadow position
                  ),
                ],
              ),
              width: displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                return SingleChildScrollView(
                    child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: SizedBox(
                      width: displayWidth(context),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Column(children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                ItemSearch(),
                                ListComboItemSearch(),
                              ]))
                        ],
                      ),
                    ),
                  ),
                ]));
              }),
            )));
  }

  @override
  Widget ItemSearch() {
    final debouncer = WaitingType(milliseconds: 1000);
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: TextFormField(
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.next,
          style: const TextStyle(
              color: Color.fromARGB(255, 19, 1, 1),
              fontSize: 16,
              fontWeight: FontWeight.bold),
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 12, 11, 11),
            ),
            border: InputBorder.none,
            hintText: "Nama Penyakit",
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

  AppBar myAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 35, 163, 223),
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
        mTitle: 'Dictionory HISS',
        mFontSize: 18,
        mFontStyle: FontStyle.normal,
        mFontWeight: FontWeight.normal,
        mTextAlign: TextAlign.center,
        mTextColor: white,
      ),
    );
  }

  @override
  Widget ListComboItemSearch() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        //future: _getFirtsInfo,
        builder: (context, _) => Padding(
              padding: const EdgeInsets.only(
                  left: 0,
                  top: 10,
                  bottom: 0,
                  right: 0), //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                final List<HISSData> items = listSearchIsi;
                //AntrianPasienList;
                return Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0, top: 0, bottom: 1, right: 1),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        //padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: DropdownSearch<Map<dynamic, dynamic>?>(
                          selectedItem: _selectedItemUser,
                          items: datalist,
                          mode: Mode.BOTTOM_SHEET,
                          isFilteredOnline: true,
                          //showClearButton: true,
                          showSearchBox: true,
                          dropdownSearchDecoration: const InputDecoration(
                            filled: true,
                            border: InputBorder.none,
                            fillColor: white,
                            labelText: "Kelompok Penyakit",
                          ),
                          dropdownBuilder: (context, selectedItem) => ListTile(
                            title: Text(selectedItem!["nama_penyakit"] ??
                                'Belum Pilih ID Kelompok'),
                          ),
                          popupItemBuilder: (context, item, isSelected) =>
                              ListTile(
                            title: Text(item!["nama_penyakit"]),
                          ),

                          onChanged: (value) async {
                            _selectedItemUser = value!;
                            //print(value['ID1']);
                            await _getSearchSOAPInfo(_selectedItemUser["ID1"]);
                          },
                        ),
                      ),
                    )
                    //],
                    //),

                    );
              }),
            )
        //)
        );
  }

  @override
  Widget ListComboItemSearchOld() {
    return FutureBuilder<List<AntrianPasienProfile>>(
        //future: _getFirtsInfo,
        builder: (context, _) =>
            //Padding(
            // padding: EdgeInsets.only(
            //   top: 10, //ScreenUtil().setHeight(ScreenUtil().setHeight(10)),
            //   left: 10,
            // ), //ScreenUtil().setHeight(ScreenUtil().setWidth(10.0))),
            SizedBox(
              height: double.infinity,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                // var parentHeight = height; //constraints.maxHeight;
                // var parentWidth = constraints.maxWidth;
                final List<HISSData> items = listSearchIsi;
                //AntrianPasienList;
                return Container(
                  // decoration: BoxDecoration(
                  //   color: white,
                  //   borderRadius: BorderRadius.circular(15),
                  //   border: Border.all(color: gray),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: gray.withOpacity(0.5), //color of shadow
                  //       spreadRadius: 2, //spread radius
                  //       blurRadius: 10, // blur radius
                  //       offset: Offset(0, 1), // changes position of shadow
                  //     ),
                  //   ],
                  // ),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                        //padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: SizedBox(
                          // decoration: BoxDecoration(
                          //   color: white,
                          //   borderRadius: BorderRadius.circular(15),
                          //   border: Border.all(color: gray),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: gray.withOpacity(0.5), //color of shadow
                          //       spreadRadius: 2, //spread radius
                          //       blurRadius: 10, // blur radius
                          //       offset:
                          //           Offset(0, 1), // changes position of shadow
                          //     ),
                          //   ],
                          // ),
                          height: 35,
                          child: DropdownSearch<Map<dynamic, dynamic>?>(
                            selectedItem: _selectedItemUser,
                            items: datalist,
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
                              title: Text(selectedItem!["nama_penyakit"] ??
                                  'Belum Pilih ID Kelompok'),
                            ),
                            popupItemBuilder: (context, item, isSelected) =>
                                ListTile(
                              title: Text(item!["nama_penyakit"]),
                            ),

                            onChanged: (value) async {
                              _selectedItemUser = value!;
                              //print(value['ID1']);
                              await _getSearchSOAPInfo(
                                  _selectedItemUser["ID1"]);
                            },
                          ),
                        ),
                      )
                      //],
                      //),
                      ),
                );
              }),
            ));
  }

  Widget tabBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 40,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(0, 88, 64, 64),
            Color.fromARGB(0, 247, 243, 243),
            Color.fromARGB(204, 36, 101, 241),
          ],
        ),
      ),
      // color:,
      // borderRadius: BorderRadius.circular(100)),
      child: Row(
        children: const [
          // tabBarItem(0),
          // tabBarItem(1),
          // tabBarItem(2),
          // tabBarItem(3),
        ],
      ),
    );
  }

  @override
  Widget IsiKelompokICD10(
      BuildContext context, List<Map<dynamic, dynamic>> item) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Container(
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
                            child: Column(
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      //signSatu(context)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _textWidgeColumn(
                                                title: "Kode ICD-10 .",
                                                value: item.isEmpty
                                                    ? ''
                                                    : item[0]['IcdX']),
                                            const SizedBox(height: 10),
                                            _textWidgeColumn(
                                                title: "Diagnosa .",
                                                value: item.isEmpty
                                                    ? ''
                                                    : item[0]['Diagnosa_Icdx']),
                                            const SizedBox(height: 10),
                                            _textWidgeColumn(
                                                title: "Kelompok .",
                                                value: item.isEmpty
                                                    ? ''
                                                    : item[0]['kelompok']),
                                            const SizedBox(height: 10),
                                            _textWidgeColumn(
                                                title: "Rawa Inap .",
                                                value: item.isEmpty
                                                    ? ''
                                                    : item[0]['Lama_Rawat']),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),

                  // Container(
                  //   transform: Matrix4.translationValues(20, -4, 0),
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(4.0),
                  //     clipBehavior: Clip.antiAlias,
                  //     child: MyText(
                  //       mTitle: 'Data ICD-10',
                  //       mFontSize: 18,
                  //       mOverflow: TextOverflow.ellipsis,
                  //       mMaxLine: 1,
                  //       mFontWeight: FontWeight.normal,
                  //       mTextAlign: TextAlign.start,
                  //       mTextColor: textTitleColor,
                  //     ),
                  //   ),
                  // ),
                ],
              )))),
    );
  }

  @override
  Widget IsiItemComboGroup(BuildContext context) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    GetVitalSignPx vitalsignDataDef;
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    vitalsignDataDef = tablesProvider.DataPeriksa;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.07, // 125,
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
                        elevation: 0,
                        color: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                //height: double.infinity,
                                child: Column(
                                  children: [
                                    IntrinsicHeight(
                                      child: ListComboItemSearch(),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              )))),
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

  Widget SOAPSubyektif(GetVitalSignPx item) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          decoration: BoxDecoration(
            //decoration for the outer wrapper
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
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
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                  //height: double.infinity,
                                  //     child: IsiSUbyektif(
                                  //   newsPost: item,
                                  // )

                                  )),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(20, -4, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      clipBehavior: Clip.antiAlias,
                      child: MyText(
                        mTitle: 'Subyektif',
                        mFontSize: 18,
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

  Widget SOAPObjektif(GetVitalSignPx item) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.15, // 125,
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
                        elevation: 0,
                        color: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                  //height: double.infinity,
                                  //child: Text('2')
                                  //     IsiObjective(
                                  //   newsPost: item,
                                  // )
                                  )),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(20, -4, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      clipBehavior: Clip.antiAlias,
                      child: MyText(
                        mTitle: 'Objective',
                        mFontSize: 18,
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

  Widget SOAPAssestment(GetVitalSignPx item) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.15, // 125,
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
                        elevation: 0,
                        color: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                  //height: double.infinity,
                                  //child: Text('3')
                                  )),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(20, -4, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      clipBehavior: Clip.antiAlias,
                      child: MyText(
                        mTitle: 'Analisys',
                        mFontSize: 18,
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

  Widget HISSKelompok() {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Container(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
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
                        elevation: 2,
                        color: white,
                        child: Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                //height: double.infinity,
                                child: Column(
                                  children: [
                                    if (pilihgroup == 0) ...[
                                      IsiKelompokICD10(context, dataSoap),
                                    ] //icdx
                                    else if (pilihgroup != 0) ...[
                                      TextIsi()
                                    ]

                                    //gejala
                                    // else if (pilihgroup == 3) ...[
                                    //   TextIsi()
                                    // ] //penyebab
                                    // else if (pilihgroup == 4) ...[
                                    //   TextIsi()
                                    // ] //penunjang
                                    // else if (pilihgroup == 5) ...[
                                    //   TextIsi()
                                    // ] //pengobatan
                                    // else if (pilihgroup == 6) ...[
                                    //   TextIsi()
                                    // ] //Komplikasi
                                    // else if (pilihgroup == 7) ...[
                                    //   TextIsi()
                                    // ] //Diferensial
                                    // else if (pilihgroup == 8) ...[
                                    //   TextIsi()
                                    // ] //Catatan
                                    // else if (pilihgroup == 9) ...[
                                    //   TextIsi()
                                    // ] //PreExisting
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              )))),
    );
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
                color: Colors.white,
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
                  color: Colors.white,
                  fontFamily: 'RobotoMono',
                )),
          ),
        ],
      ),
    );
  }

  Widget TextIsi() {
    // ));
    TextEditingController isiKelompok = TextEditingController();
    isiKelompok.text = groupisiCategorybutton!.length > 1
        ? groupisiCategorybutton![pilihgroup - 1].toString()
        : ''; //mEmail
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(HISSModul[pilihgroup].toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'RobotoMono',
                )),
          ),
        ),
        MyTextFormFieldEntry(
          mController: isiKelompok,
          mObscureText: false,
          mMaxLine: 10,
          mHintTextColor: textHintColor,
          mTextColor: otherColor,
          mkeyboardType: TextInputType.text,
          mTextInputAction: TextInputAction.next,
          mReadOnly: true,
          mWidth: 500,
          mHeight: 130,
          //mInputBorder: InputBorder.,
        ),
      ],
    );
  }

  getData() async {
    await Future.delayed(const Duration(seconds: 0));

    setState(() {
      groupCategoryIsi = [
        'ICD X & Diagnosa',
        'Simtom & Gejala Klinik',
        'Penyebab',
        'Pemeriksaan Lab/Penunjang Diagnostic',
        'Pengobatan',
        'Komplikasi & Prognosis',
        'Differensial',
        'Catatan',
        'Pre Existing',
      ];

      groupCategorybutton = [
        'ICD X ',
        'Gejala',
        'Penyebab',
        'Penunjang',
        'Pengobatan',
        'Komplikasi',
        'Differensial',
        'Catatan',
        'Pre Existing',
      ];
    });

    return groupCategoryIsi;
  }

  @override
  Widget ItemCategory() {
    return FutureBuilder<List<String>>(
        //future: getData(),
        builder: (context, _) => Padding(
            padding: const EdgeInsets.only(top: 0
                //     top: ScreenUtil().setHeight(ScreenUtil().setHeight(10)),
                //     left: ScreenUtil().setHeight(ScreenUtil().setWidth(10.0))
                ),
            child: SizedBox(
              height: 60,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<String>? items = groupCategorybutton;
                return Padding(
                  padding:
                      const EdgeInsets.only(right: 4.0, top: 5.0, left: 10),
                  child: Scrollbar(
                    child: ListView.builder(
                      physics:
                          const AlwaysScrollableScrollPhysics(), //Even if zero elements to update scroll
                      itemCount: items!.length,
                      scrollDirection: Axis.horizontal,
                      controller: _scrollControllertrans,
                      itemBuilder: (context, index) {
                        return items[index] == null
                            ? const CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CategoryButton(
                                    action: (() async {
                                      setState(() {
                                        pilihgroup = index;
                                        _hasButtonPressed = items[index];
                                      });
                                    }),
                                    remarkButton: items[index],
                                    pressButton: _hasButtonPressed),
                              );
                        //: Text(items![index].Subtitle);
                      },
                    ),
                  ),
                );
              }),
            )));
  }

  @override
  Widget LogoSearch() {
    return FutureBuilder<List<String>>(
        //future: getData(),
        builder: (context, _) => Padding(
            padding: const EdgeInsets.only(
                //     top: ScreenUtil().setHeight(ScreenUtil().setHeight(10)),
                //     left: ScreenUtil().setHeight(ScreenUtil().setWidth(10.0))
                ),
            child: SizedBox(
              height: 55,
              width: double.infinity, //  displayWidth(context),
              child: LayoutBuilder(builder: (context, constraints) {
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                final List<String>? items = groupCategorybutton;
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Scrollbar(
                    child: ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), //Even if zero elements to update scroll
                      itemCount: items!.length,
                      scrollDirection: Axis.horizontal,
                      controller: _scrollControllertrans,
                      itemBuilder: (context, index) {
                        return items[index] == null
                            ? const CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CategoryButton(
                                    action: (() async {
                                      setState(() {
                                        pilihgroup = index;
                                        _hasButtonPressed = items[index];
                                      });
                                    }),
                                    remarkButton: items[index],
                                    pressButton: _hasButtonPressed),
                              );
                        //: Text(items![index].Subtitle);
                      },
                    ),
                  ),
                );
              }),
            )));
  }

  Future updateData() async {
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    vitalSignPasien = tablesProvider.DataPeriksa;

    final AuthUserData dokterProvider =
        Provider.of<AuthUserData>(context, listen: false);
    UserProfile dokter = dokterProvider.DataUser;
    AntrianPasienProfile vitalsignDataProfile =
        tablesProvider.DataPeriksaProfile;

    vitalsignDataProfile.dokterid = dokter.dtDokter![0].idDdUser!;
    vitalSignPasien.dataSoap!.subjektif = HISSSubyektif.text;
    vitalSignPasien.dataSoap!.objektif = HISSObyektif.text;
    vitalSignPasien.dataSoap!.assesment = HISSAnalis.text;

    //update to APi
    //if success set to provider

    bool ok = await UserApiService.postvitalSOAPPasienAntri(
        vitalSignPasien, vitalsignDataProfile, true);

    tablesProvider.setDataPeriksa(vitalSignPasien);

    if (ok) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailAntrianPasien(
                detailpasienProfile: vitalsignDataProfile,
              )));
    } else {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.SCALE,
        title: 'Data Tidak Valid',
        desc: 'cek data entry kembali',
        autoHide: const Duration(seconds: 5),
      ).show();
      return;
    }
  }
}

class IsiInfoSearchandFilter extends StatelessWidget {
  final AntrianPasienProfile infoIsi;
  final Widget? prefWidget;
  final VoidCallback action;
  const IsiInfoSearchandFilter(
      {Key? key, required this.infoIsi, required this.action, this.prefWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String urlfoto = infoIsi.url_foto_px;
    urlfoto = urlfoto.replaceAll('..', '');

    return InkWell(
        onTap: () => action(),
        child: SizedBox(
            height: 100,
            width: 390,
            child: IntrinsicHeight(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/avatar.png',
                                            image:
                                                urlfoto, //infoIsi.url_foto_px,
                                            fit: BoxFit.cover,
                                            width: 120,
                                            height: 60,
                                            imageErrorBuilder:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ])),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  flex: 8,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(infoIsi.nama_px,
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800)),
                                        SizedBox(
                                          height: 4,
                                          child: Center(
                                            child: Container(
                                              margin:
                                                  const EdgeInsetsDirectional
                                                          .only(
                                                      start: 1.0, end: 1.0),
                                              height: 2.0,
                                              color: const Color.fromARGB(
                                                  255, 241, 187, 183),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                            ' No Antrian ${infoIsi.no_antrian}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 2),
                                        Text(
                                            ' Pendafatran ${infoIsi.jam_daftar}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)),
                                      ]))
                            ])
                      ]),
                    )))));
  }
}

class CategoryButton extends StatelessWidget {
  final String remarkButton;
  final String pressButton;
  final VoidCallback action;

  const CategoryButton({
    Key? key,
    required this.remarkButton,
    required this.action,
    required this.pressButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => action(),
        child: Container(
          height: 40,
          width: 145,
          decoration: BoxDecoration(
              color: pressButton == remarkButton
                  ? blue
                  : const Color.fromARGB(255, 233, 235, 238),
              //color: Color.fromARGB(255, 3, 29, 63)

              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 5,
          ),
          child: Center(
            child: Text(
              remarkButton,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: pressButton == remarkButton
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: pressButton == remarkButton
                      ? Colors.white
                      : const Color.fromARGB(255, 15, 15, 15)),
            ),
          ),
        ));
  }
}
