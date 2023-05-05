import 'dart:developer';
import 'package:doctorapp/utils/commongrid.dart';
//import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:doctorapp/apiservice/serviceapi.dart';
import 'package:doctorapp/pages/pasien/component/medrecord_pasien.dart';
import 'package:doctorapp/pages/pasien/icd10_dokter.dart';
import 'package:doctorapp/pages/pasien/list_ICD10.dart';
import 'package:doctorapp/pages/pasien/list_hiss.dart';

import 'package:doctorapp/pages/pasien/list_tindakan_obat.dart';
import 'package:doctorapp/pages/pasien/tindakan_dokter.dart';
import 'package:doctorapp/pages/pemeriksaan.dart';
import 'package:doctorapp/utils/colors.dart';
import 'package:doctorapp/utils/constant.dart';
import 'package:doctorapp/utils/strings.dart';
import 'package:doctorapp/utils/utility.dart';
import 'package:doctorapp/widgets/custom_card.dart';
import 'package:doctorapp/widgets/my_colors.dart';
import 'package:doctorapp/widgets/my_font_size.dart';
import 'package:doctorapp/widgets/mynetworkimg.dart';
import 'package:doctorapp/widgets/mysvgassetsimg.dart';
import 'package:doctorapp/widgets/mytext.dart';
import 'package:doctorapp/widgets/mytextformfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:doctorapp/model/periksamodel.dart';
import 'package:doctorapp/model/pasienmodel.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doctorapp/pages/pasien/component/vitalsign_entry.dart';
import 'package:doctorapp/pages/pasien/component/soap_entry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:doctorapp/provider/pasien_prov.dart';
import 'package:doctorapp/pages/pasien/component/diagnosis_entry.dart';

import '../resep_dokter.dart';

class DetailAntrianPasien extends StatefulWidget {
  final AntrianPasienProfile detailpasienProfile;
  const DetailAntrianPasien({Key? key, required this.detailpasienProfile})
      : super(key: key);

  @override
  State<DetailAntrianPasien> createState() => _DetailAntrianPasienState();
}

class _DetailAntrianPasienState extends State<DetailAntrianPasien> {
  GetVitalSignPx vitalSignPasien = GetVitalSignPx();
  //late CircularBottomNavigationController _navigationController;
  int selectedPos = 0;
  double bottomNavBarHeight = 70;
  final controller = ScrollController();
  //late GetVitalSignPx vitalSignUpdate;

  @override
  void initState() {
    _getFirtsInfo();
    super.initState();
    //_navigationController = CircularBottomNavigationController(selectedPos);
  }

  Widget bottomNav() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                CustomCard(
                  onTap: () {
                    Navigator.push(
                        context, ZoomAnimasi(page: const WritePrescription()));
                  },
                  shadow: false,
                  width: double.infinity,
                  bgColor: MyColors.white,
                  borderRadius: BorderRadius.circular(15),
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCard(
                          shadow: false,
                          height: 50,
                          width: 50,
                          borderRadius: BorderRadius.circular(100),
                          child: Center(
                            child: IconButton(
                              icon: Image.asset('assets/images/Penunjang1.png'),
                              tooltip: 'Closes application',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    ZoomAnimasi(
                                        page: const WritePrescription()));
                              },
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Penunjang",
                        style: TextStyle(
                            color: MyColors.blackText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                CustomCard(
                  onTap: () {
                    Navigator.push(
                        context, ZoomAnimasi(page: const TindakanDokter()));
                  },
                  shadow: false,
                  width: double.infinity,
                  bgColor: MyColors.white,
                  borderRadius: BorderRadius.circular(15),
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCard(
                          shadow: false,
                          height: 50,
                          width: 50,
                          borderRadius: BorderRadius.circular(100),
                          child: Center(
                            child: IconButton(
                              icon: Image.asset('assets/images/tindakan1.png'),
                              tooltip: 'Closes application',
                              onPressed: () {
                                Navigator.push(context,
                                    ZoomAnimasi(page: const TindakanDokter()));
                              },
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Tindakan",
                        style: TextStyle(
                            color: MyColors.blackText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                CustomCard(
                  onTap: () {
                    Navigator.push(
                        context, ZoomAnimasi(page: const TindakanDokterObat()));
                  },
                  shadow: false,
                  width: double.infinity,
                  bgColor: MyColors.white,
                  borderRadius: BorderRadius.circular(15),
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCard(
                          shadow: false,
                          height: 50,
                          width: 50,
                          borderRadius: BorderRadius.circular(100),
                          child: Center(
                            child: IconButton(
                              icon: Image.asset('assets/images/resep1.png'),
                              tooltip: 'Closes application',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    ZoomAnimasi(
                                        page: const TindakanDokterObat()));
                              },
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Isi Resep",
                        style: TextStyle(
                            color: MyColors.blackText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                CustomCard(
                  onTap: () {
                    Navigator.push(
                        context, ZoomAnimasi(page: const ICD10Dokter()));
                  },
                  shadow: false,
                  width: double.infinity,
                  bgColor: MyColors.white,
                  borderRadius: BorderRadius.circular(15),
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCard(
                          shadow: false,
                          height: 50,
                          width: 50,
                          borderRadius: BorderRadius.circular(100),
                          child: Center(
                            child: IconButton(
                              icon: Image.asset('assets/images/icdx1.png'),
                              tooltip: 'Closes application',
                              onPressed: () {
                                Navigator.push(context,
                                    ZoomAnimasi(page: const ICD10Dokter()));
                              },
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Isi ICD-10",
                        style: TextStyle(
                            color: MyColors.blackText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget bottomPlanning() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppScaffold(
        title: 'Staggered',
        child: SingleChildScrollView(
            child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: const [
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 1,
              child: TileGrid(index: 4),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: TileGrid(index: 1),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: TileGrid(index: 2),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: TileGrid(index: 3),
            ),
          ],
        )),
      ),
    );
  }

  Future<void> _getFirtsInfo() async {
    print(
        '${widget.detailpasienProfile.no_mr} ,${widget.detailpasienProfile.no_registrasi} ,${widget.detailpasienProfile.no_kunjungan}');

    GetVitalSignPx? usr = await UserApiService.getVitalSignPasienPost(
            widget.detailpasienProfile.no_mr,
            widget.detailpasienProfile.no_registrasi,
            widget.detailpasienProfile.no_kunjungan)
        .then((Vitaldata) {
      setState(() {
        vitalSignPasien = Vitaldata;
      });

      Provider.of<AuthPasienData>(context, listen: false)
          .setDataPeriksa(vitalSignPasien);
      Provider.of<AuthPasienData>(context, listen: false)
          .setDataPeriksaProfile(widget.detailpasienProfile);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // blue,
        appBar: myAppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 90.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                      children: <Widget>[
                CardProfile(vitalSignPasien),
                ButtonPasien(),
                VitalSign(context, vitalSignPasien),
                SOAPSubyektif(vitalSignPasien),
                SOAPObjektif(vitalSignPasien),
                SOAPAssestment(vitalSignPasien),
                Container(
                    child: SizedBox(
                        width: 200,
                        height: 40,
                        child: FittedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              await showModalBottomSheet<void>(
                                  isDismissible: false,
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      topLeft: Radius.circular(25),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                        heightFactor: 0.8,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.8,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: const SOAPDokterUpdate()),
                                        ));
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.redAccent,
                                textStyle: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700)),
                            child: MyText(
                              mTitle: 'Update SOAP Dokter',
                              mFontSize: 16,
                              mOverflow: TextOverflow.ellipsis,
                              mMaxLine: 1,
                              mFontWeight: FontWeight.bold,
                              mTextAlign: TextAlign.start,
                              mTextColor: white,
                            ),
                          ),
                        ))),
                ButtonTindakan(),
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          //height: double.infinity,
                          child: Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ElevatedButtonTheme(
                              data: ElevatedButtonThemeData(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(100, 40))),
                              child: ButtonBar(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: blue,
                                        shape: const ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                          ),
                                        ),
                                        textStyle: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700)),
                                    child: Text('Submit'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))),
                ),
              ]))),
        ));
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
        mTitle: 'isi SOAP',
        mFontSize: 18,
        mFontStyle: FontStyle.normal,
        mFontWeight: FontWeight.normal,
        mTextAlign: TextAlign.center,
        mTextColor: white,
      ),
    );
  }

  @override
  Widget CardProfile(GetVitalSignPx item) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    String urlfoto = widget.detailpasienProfile.url_foto_px;
    urlfoto = urlfoto.replaceAll('..', '');

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          decoration: BoxDecoration(
            //decoration for the outer wrapper
            color: const Color.fromARGB(255, 253, 251, 251),
            borderRadius: BorderRadius.circular(22),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                  child: Stack(children: <Widget>[
                Positioned(
                  child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [IsiCardProfileL(item)])),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              // borderRadius:
                                              //     BorderRadius.circular(6),
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              clipBehavior: Clip.antiAlias,
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/images/avatar.png',
                                                image:
                                                    urlfoto, //infoIsi.url_foto_px,
                                                fit: BoxFit.fill,
                                                width: 80,
                                                height: 80,
                                                imageErrorBuilder:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            //dropdownMenu(),
                                            //Container(child: dropdownMenu())
                                          ])),
                                ],
                              )
                            ]),
                      )),
                )
              ])))),
    );
  }

  Widget IsiCardProfileL(GetVitalSignPx item) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.detailpasienProfile.nama_px,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w800)),
            SizedBox(
              height: 4,
              child: Center(
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 2.0,
                  color: const Color.fromARGB(255, 217, 217, 217),
                ),
              ),
            ),
            const SizedBox(height: 5),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //signSatu(context)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textWidgeColumn(
                            title: "No MR .",
                            value: widget.detailpasienProfile.no_mr),
                        const SizedBox(height: 10),
                        _textWidgeColumn(
                            title: "Umur .",
                            value: widget.detailpasienProfile.umur_px),
                        const SizedBox(height: 10),
                        _textWidgeColumn(
                            title: "Golongan Darah .",
                            value: widget.detailpasienProfile.gol_darah_px),
                        const SizedBox(height: 10),
                        _textWidgeColumn(
                            title: "Jenis Kelamin .",
                            value: widget.detailpasienProfile.gender_px),
                        const SizedBox(height: 10),
                        _textWidgeColumn(
                            title: "Alergi .",
                            value: widget.detailpasienProfile.alergi_px),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  @override
  Widget VitalSign(BuildContext context, GetVitalSignPx item) {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    GetVitalSignPx vitalsignDataDef;
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    vitalsignDataDef = tablesProvider.DataPeriksa;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
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
                          padding: const EdgeInsets.only(top: 40),
                          child: Padding(
                              padding: const EdgeInsets.all(15),
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
                                                _textWidgeColumnRow(
                                                    title: "Keadaan Umum :",
                                                    value: item.dataVitalSign!
                                                        .keadaanUmum),
                                                const SizedBox(height: 10),
                                                _textWidgeColumnRow(
                                                    title: "Tekanan Darah :",
                                                    value: item.dataVitalSign!
                                                        .tekananDarah),
                                                const SizedBox(height: 10),
                                                _textWidgeColumnRow(
                                                    title: "Suhu :",
                                                    value: item
                                                        .dataVitalSign!.suhu),
                                                const SizedBox(height: 10),
                                                _textWidgeColumnRow(
                                                    title: "Tinggi  Badan :",
                                                    value: item.dataVitalSign!
                                                        .tinggiBadan),
                                                const SizedBox(height: 10),
                                                _textWidgeColumnRow(
                                                    title: "Heart Rate :",
                                                    value: item.dataVitalSign!
                                                        .heartRate),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _textWidgeColumnRow(
                                                    title: "Kesadaran .",
                                                    value: item.dataVitalSign!
                                                        .kesadaranPasien),
                                                const SizedBox(height: 10),
                                                _textWidgeColumnRow(
                                                    title: "Nadi .",
                                                    value: vitalsignDataDef
                                                        .dataVitalSign!.nadi),
                                                const SizedBox(height: 10),
                                                _textWidgeColumnRow(
                                                    title: "Pernafasan .",
                                                    value: item.dataVitalSign!
                                                        .pernafasan),
                                                const SizedBox(height: 10),
                                                _textWidgeColumnRow(
                                                    title: "Berat Badan .",
                                                    value: item.dataVitalSign!
                                                        .beratBadan),
                                                const SizedBox(height: 10),
                                                _textWidgeColumnRow(
                                                    title: "Lingkar Perut .",
                                                    value: item.dataVitalSign!
                                                        .lingkarPerut),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
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
                        mTitle: 'VItal Sign',
                        mFontSize: 18,
                        mOverflow: TextOverflow.ellipsis,
                        mMaxLine: 1,
                        mFontWeight: FontWeight.bold,
                        mTextAlign: TextAlign.start,
                        mTextColor: textTitleColor,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              child: SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: FittedBox(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await showModalBottomSheet<void>(
                                            isDismissible: false,
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(25),
                                                topLeft: Radius.circular(25),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return FractionallySizedBox(
                                                  heightFactor: 0.8,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child:
                                                            const VitalSignUpdate()),
                                                  ));
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          backgroundColor:
                                              Color.fromRGBO(38, 153, 249, 1),
                                          textStyle: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700)),
                                      child: MyText(
                                        mTitle: 'Edit Vital Sign',
                                        mFontSize: 16,
                                        mOverflow: TextOverflow.ellipsis,
                                        mMaxLine: 1,
                                        mFontWeight: FontWeight.bold,
                                        mTextAlign: TextAlign.start,
                                        mTextColor: white,
                                      ),
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                  )
                ],
              )))),
    );
  }

  @override
  Widget ButtonTindakan() {
    final String NoKontrak;
    final GestureTapCallback? onTap;

    GetVitalSignPx vitalsignDataDef;
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    vitalsignDataDef = tablesProvider.DataPeriksa;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  child: Stack(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 62,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            //height: double.infinity,
                            child: bottomNav())),
                  ),
                  Container(
                    transform: Matrix4.translationValues(20, 10, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      clipBehavior: Clip.antiAlias,
                      child: MyText(
                        mTitle: 'Planning',
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
          decoration: BoxDecoration(
            //decoration for the outer wrapper
            // color: Color.fromARGB(255, 250, 249, 248),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [],
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Padding(
                              padding: const EdgeInsets.all(0),
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
                                                  const Size(150, 40))),
                                      child: ButtonBar(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MedicalRecPasienList(
                                                            detailpasienProfile:
                                                                widget
                                                                    .detailpasienProfile,
                                                          )));
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                backgroundColor:
                                                    Color(0xFF0EBE7F),
                                                textStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            child: MyText(
                                              mTitle: 'Lihat MR',
                                              mFontSize: 16,
                                              mOverflow: TextOverflow.ellipsis,
                                              mMaxLine: 1,
                                              mFontWeight: FontWeight.bold,
                                              mTextAlign: TextAlign.start,
                                              mTextColor: white,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  ZoomAnimasi(
                                                      page:
                                                          const ListingHISSDoc())); //ListingHISSDoc
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                backgroundColor: Color.fromRGBO(
                                                    38, 153, 249, 1),
                                                textStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            child: MyText(
                                              mTitle: 'Dictionary HISS',
                                              mFontSize: 16,
                                              mOverflow: TextOverflow.ellipsis,
                                              mMaxLine: 1,
                                              mFontWeight: FontWeight.bold,
                                              mTextAlign: TextAlign.start,
                                              mTextColor: white,
                                            ),
                                          ),
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

  Widget SOAPSubyektif(GetVitalSignPx item) {
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
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                  //height: double.infinity,
                                  child: IsiSUbyektif(
                                newsPost: item,
                              ))),
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

  Widget _textWidgeT({String? title, String? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Expanded(
          child: Text(
            value ?? '-',
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'RobotoMono',
            ),
          ),
        )
      ],
    );
  }

  Widget _textWidgeColumn({String? title, String? value}) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(title ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: blue,
                  fontFamily: 'RobotoMono',
                )),
          ),
          Flexible(
            child: Text(value ?? '-',
                textAlign: TextAlign.start,
                //overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'RobotoMono',
                )),
          )
        ],
      ),
    );
  }

  Widget _textWidgeColumnRow({String? title, String? value}) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: blue,
                    fontFamily: 'RobotoMono',
                  )),
              Text(value ?? '-',
                  textAlign: TextAlign.start,
                  //overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'RobotoMono',
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget SOAPObjektif(GetVitalSignPx item) {
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
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                  //height: double.infinity,
                                  child: IsiObjective(
                                newsPost: item,
                              ))),
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
                        mTitle: 'Objective',
                        mFontSize: 15,
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
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                  //height: double.infinity,
                                  child: IsiAnemnese(
                                newsPost: item,
                              ))),
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
                        mTitle: 'Assestment',
                        mFontSize: 15,
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
}

class IsiSUbyektif extends StatelessWidget {
  final GetVitalSignPx newsPost;
  const IsiSUbyektif({Key? key, required this.newsPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.1,
                  maxScale: 1.5,
                  child: Container(
                    //margin: EdgeInsets.only(top: 10, right: 10),
                    height: 330,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: IsiSubyektif(newsPost),
                  ),
                ),
              ],
            )));
  }

  @override
  Widget IsiSubyektif(GetVitalSignPx item) {
    return Scrollbar(
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 1,
            scrollDirection: Axis.vertical,
            //controller: _scrollControllertransIsi,
            itemBuilder: (context, index) {
              return (Html(
                data: item.dataSoap!.subjektif,
                //shrinkWrap: true,
              ));
            }));
  }
}

class IsiObjective extends StatelessWidget {
  final GetVitalSignPx newsPost;
  const IsiObjective({Key? key, required this.newsPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.1,
                  maxScale: 1.5,
                  child: Container(
                    //margin: EdgeInsets.only(top: 10, right: 10),
                    height: 330,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Isiobjective(newsPost),
                  ),
                ),
              ],
            )));
  }

  @override
  Widget Isiobjective(GetVitalSignPx item) {
    return Scrollbar(
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 1,
            scrollDirection: Axis.vertical,
            //controller: _scrollControllertransIsi,
            itemBuilder: (context, index) {
              return (Html(
                data: item.dataSoap!.objektif,
                //shrinkWrap: true,
              ));
            }));
  }
}

class IsiAnemnese extends StatelessWidget {
  final GetVitalSignPx newsPost;
  const IsiAnemnese({Key? key, required this.newsPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.1,
                  maxScale: 1.5,
                  child: Container(
                    //margin: EdgeInsets.only(top: 10, right: 10),
                    height: 330,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Isianemnese(newsPost),
                  ),
                ),
              ],
            )));
  }

  @override
  Widget Isianemnese(GetVitalSignPx item) {
    return Scrollbar(
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 1,
            scrollDirection: Axis.vertical,
            //controller: _scrollControllertransIsi,
            itemBuilder: (context, index) {
              return (Html(
                data: item.dataSoap!.assesment,
                //shrinkWrap: true,
              ));
            }));
  }
}

class ZoomAnimasi extends PageRouteBuilder {
  final Widget page;
  ZoomAnimasi({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(
                  0.3,
                  1,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: child,
          ),
        );
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}
