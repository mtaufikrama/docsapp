import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doctorapp/apiservice/serviceapi.dart';
import 'package:doctorapp/pages/pasien/component/list_antrian_pasiendetail.dart';
import 'package:doctorapp/pages/pemeriksaan.dart';
import 'package:doctorapp/utils/colors.dart';
import 'package:doctorapp/utils/constant.dart';
import 'package:doctorapp/utils/strings.dart';
import 'package:doctorapp/utils/utility.dart';
import 'package:doctorapp/widgets/mynetworkimg.dart';
import 'package:doctorapp/widgets/mysvgassetsimg.dart';
import 'package:doctorapp/widgets/mytext.dart';
import 'package:doctorapp/widgets/mytextformfield.dart';
import 'package:flutter/material.dart';
import 'package:doctorapp/model/periksamodel.dart';
import 'package:doctorapp/model/pasienmodel.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doctorapp/provider/pasien_prov.dart';
import 'package:provider/provider.dart';

class VitalSignUpdate extends StatefulWidget {
  const VitalSignUpdate({Key? key}) : super(key: key);

  @override
  State<VitalSignUpdate> createState() => _VitalSignUpdateState();
}

class _VitalSignUpdateState extends State<VitalSignUpdate> {
  GetVitalSignPx vitalsignData = GetVitalSignPx();
  final _scrollControllerdet = ScrollController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController signNadi = TextEditingController();
  TextEditingController signKesadaranUmum = TextEditingController();
  TextEditingController signTekananDarah = TextEditingController();
  TextEditingController signSuhu = TextEditingController();
  TextEditingController signTinggiBadan = TextEditingController();
  TextEditingController signKesadaran = TextEditingController();
  TextEditingController signPernafasan = TextEditingController();
  TextEditingController signBeratBadan = TextEditingController();

  @override
  void initState() {
    _getUserProvider();
    super.initState();
  }

  _getUserProvider() async {
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    vitalsignData = tablesProvider.DataPeriksa;

    signNadi.text = vitalsignData.dataVitalSign!.nadi!;
    signKesadaranUmum.text = vitalsignData.dataVitalSign!.keadaanUmum!;
    signTekananDarah.text = vitalsignData.dataVitalSign!.tekananDarah!;
    signSuhu.text = vitalsignData.dataVitalSign!.suhu!;
    signTinggiBadan.text = vitalsignData.dataVitalSign!.tinggiBadan!;
    signKesadaran.text = vitalsignData.dataVitalSign!.kesadaranPasien!;
    signPernafasan.text = vitalsignData.dataVitalSign!.pernafasan!;
    signBeratBadan.text = vitalsignData.dataVitalSign!.beratBadan!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: [
      Positioned(
        top: 5,
        right: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 150.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 238, 236, 236),
              borderRadius: BorderRadius.circular(200),
            ),
            height: 8.0,
            width: 60.0,
            //color: Colors.grey,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 17),
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ListView(children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: RichText(
                          text: const TextSpan(
                              text: 'Update ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 39, 28, 1),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Vital Sign',
                                  style: TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 2,
                                    color: Colors.blue,
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                        child: Text('Keadaan Umum',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'RobotoMono',
                            ))),
                    Flexible(
                      child: MyTextFormFieldEntry(
                        mController: signKesadaranUmum, //mEmailController,
                        mObscureText: false,
                        mMaxLine: 1,
                        mHintTextColor: textHintColor,
                        mTextColor: otherColor,
                        mkeyboardType: TextInputType.text,
                        mTextInputAction: TextInputAction.next,
                        mWidth: 300,
                        mHeight: 35,
                        //mInputBorder: InputBorder.,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                          child: Text('Tekanan Darah',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'RobotoMono',
                              ))),
                      Flexible(
                        child: MyTextFormFieldEntry(
                          mController: signTekananDarah, //mEmailController,
                          mObscureText: false,
                          mMaxLine: 1,
                          mHintTextColor: textHintColor,
                          mTextColor: otherColor,
                          mkeyboardType: TextInputType.text,
                          mTextInputAction: TextInputAction.next,
                          mWidth: 300,
                          mHeight: 35,
                          //mInputBorder: InputBorder.,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                        child: Text('Suhu',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'RobotoMono',
                            ))),
                    Flexible(
                      child: MyTextFormFieldEntry(
                        mController: signSuhu, //mEmailController,
                        mObscureText: false,
                        mMaxLine: 1,
                        mHintTextColor: textHintColor,
                        mTextColor: otherColor,
                        mkeyboardType: TextInputType.text,
                        mTextInputAction: TextInputAction.next,
                        mWidth: 300,
                        mHeight: 35,
                        //mInputBorder: InputBorder.,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                        child: Text('Tinggi Badan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'RobotoMono',
                            ))),
                    Flexible(
                      child: MyTextFormFieldEntry(
                        mController: signTinggiBadan, //mEmailController,
                        mObscureText: false,
                        mMaxLine: 1,
                        mHintTextColor: textHintColor,
                        mTextColor: otherColor,
                        mkeyboardType: TextInputType.text,
                        mTextInputAction: TextInputAction.next,
                        mWidth: 300,
                        mHeight: 35,
                        //mInputBorder: InputBorder.,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                        child: Text('Kesadaran',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'RobotoMono',
                            ))),
                    Flexible(
                      child: MyTextFormFieldEntry(
                        mController: signKesadaran, //mEmailController,
                        mObscureText: false,
                        mMaxLine: 1,
                        mHintTextColor: textHintColor,
                        mTextColor: otherColor,
                        mkeyboardType: TextInputType.text,
                        mTextInputAction: TextInputAction.next,
                        mWidth: 300,
                        mHeight: 35,
                        //mInputBorder: InputBorder.,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                        child: Text('Nadi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'RobotoMono',
                            ))),
                    Flexible(
                      child: MyTextFormFieldEntry(
                        mController: signNadi, //mEmailController,
                        mObscureText: false,
                        mMaxLine: 1,
                        mHintTextColor: textHintColor,
                        mTextColor: otherColor,
                        mkeyboardType: TextInputType.text,
                        mTextInputAction: TextInputAction.next,
                        mWidth: 300,
                        mHeight: 35,
                        //mInputBorder: InputBorder.,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                        child: Text('Pernafasan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'RobotoMono',
                            ))),
                    Flexible(
                      child: MyTextFormFieldEntry(
                        mController: signPernafasan, //mEmailController,
                        mObscureText: false,
                        mMaxLine: 1,
                        mHintTextColor: textHintColor,
                        mTextColor: otherColor,
                        mkeyboardType: TextInputType.text,
                        mTextInputAction: TextInputAction.next,
                        mWidth: 300,
                        mHeight: 35,
                        //mInputBorder: InputBorder.,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                        child: Text('Berat Badan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'RobotoMono',
                            ))),
                    Flexible(
                      child: MyTextFormFieldEntry(
                        mController: signBeratBadan, //mEmailController,
                        mObscureText: false,
                        mMaxLine: 1,
                        mHintTextColor: textHintColor,
                        mTextColor: otherColor,
                        mkeyboardType: TextInputType.text,
                        mTextInputAction: TextInputAction.next,
                        mWidth: 300,
                        mHeight: 35,
                        //mInputBorder: InputBorder.,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: ElevatedButton(
                          onPressed: () async {
                            await updateData();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor:
                                  const Color.fromRGBO(38, 153, 249, 1),
                              textStyle: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700)),
                          child: MyText(
                            mTitle: 'Submit',
                            mFontSize: 16,
                            mOverflow: TextOverflow.ellipsis,
                            mMaxLine: 1,
                            mFontWeight: FontWeight.bold,
                            mTextAlign: TextAlign.start,
                            mTextColor: white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            )),
      )
    ]));
  }

  Future updateData() async {
    final AuthPasienData tablesProvider =
        Provider.of<AuthPasienData>(context, listen: false);
    vitalsignData = tablesProvider.DataPeriksa;

    AntrianPasienProfile vitalsignDataProfile =
        tablesProvider.DataPeriksaProfile;

    vitalsignData.dataVitalSign!.nadi = signNadi.text;
    vitalsignData.dataVitalSign!.keadaanUmum = signKesadaranUmum.text;
    vitalsignData.dataVitalSign!.tekananDarah = signTekananDarah.text;
    vitalsignData.dataVitalSign!.suhu = signSuhu.text;
    vitalsignData.dataVitalSign!.tinggiBadan = signTinggiBadan.text;
    vitalsignData.dataVitalSign!.kesadaranPasien = signKesadaran.text;
    vitalsignData.dataVitalSign!.pernafasan = signPernafasan.text;
    vitalsignData.dataVitalSign!.beratBadan = signBeratBadan.text;

    //update to APi
    //if success set to provider

    bool ok = await UserApiService.postvitalSignPasienAntri(
        vitalsignData, vitalsignDataProfile);
    tablesProvider.setDataPeriksa(vitalsignData);

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
        desc: 'cek data entry kembali', //
        autoHide: const Duration(seconds: 5),
      ).show();
      return;
    }
  }
}
