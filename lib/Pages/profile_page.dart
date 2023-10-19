import 'dart:io';
import 'package:contact/UI_Helper/UIHelper.dart';
import 'package:contact/Pages/frm_page.dart';
import 'package:contact/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  List<dynamic> dataLst;
  int idx;

  ProfilePage(this.dataLst, this.idx);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // For Back press
  Future<bool> goBack() async {
    return await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ),
    );
  }

  Future<void> _callNumber(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  List<dynamic>? dataLst;
  int? idx;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dataLst = widget.dataLst;
    idx = widget.idx;
  }

  Future<void> _textMe() async {
    Uri uri = Uri.parse(
        "sms:${dataLst![idx!]["countryCode"]} ${dataLst![idx!]["phone"]}?body=hello%20there");

    if (await launchUrl(uri)) {
    } else {
      throw "Could not launch";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: goBack,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () async {
                await Navigator.pushReplacementNamed(context, "home_page");
              },
              icon: const Icon(Icons.arrow_back_outlined)),
          title: const Text("Profile page"),
          actions: [
            IconButton(
                onPressed: () async {
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const FormPage();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 20.0),
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundColor: MyColors.greenAccent,
                  child: dataLst![idx!]["image"] == null
                      ? Text("${dataLst![idx!]["fname"][0].toUpperCase()}",
                          style:
                              TextStyle(color: MyColors.green, fontSize: 30.0))
                      : Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors.green,
                              image: DecorationImage(
                                  image:
                                      FileImage(File(dataLst![idx!]["image"])),
                                  fit: BoxFit.fill)),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  "${dataLst![idx!]["fname"]} ${dataLst![idx!]["lname"]}",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        _callNumber(dataLst![idx!]["phone"]);
                      },
                      icon: const Icon(Icons.phone_outlined)),
                  IconButton(
                      onPressed: () {
                        _textMe();
                      },
                      icon: const Icon(Icons.textsms_outlined)),
                  IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Future work"),
                            backgroundColor: MyColors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.video_call_outlined)),
                  IconButton(
                      onPressed: () async {
                        String email =
                            Uri.encodeComponent(dataLst![idx!]["email"]);
                        String subject = Uri.encodeComponent("Test Email");
                        String body =
                            Uri.encodeComponent("This is a test email.");
                        Uri mail = Uri.parse(
                            "mailto:$email?subject=$subject&body=$body");

                        if (await launchUrl(mail)) {
                          //email app opened
                        } else {
                          //email app is not opened
                          throw "Could not launch";
                        }
                      },
                      icon: const Icon(Icons.email_outlined)),
                ],
              ),
              const Divider(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: MyColors.greenAccent,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Contact Info",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "${dataLst![idx!]["email"]}",
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Text(
                      "${dataLst![idx!]["countryCode"]} ${dataLst![idx!]["phone"]}",
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              dataLst![idx!]["address"] == "" &&
                      dataLst![idx!]["company"] == "" &&
                      dataLst![idx!]["sip"] == "" &&
                      dataLst![idx!]["notes"] == "" &&
                      dataLst![idx!]["lbl1"] == "No label"
                  ? Container()
                  : Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      decoration: BoxDecoration(
                        color: MyColors.greenAccent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Other Info",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                            ),
                          ),
                          dataLst![idx!]["address"] == ""
                              ? Container()
                              : Text(
                                  "${dataLst![idx!]["address"]}",
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                          dataLst![idx!]["company"] == ""
                              ? Container()
                              : Text(
                                  "${dataLst![idx!]["company"]}",
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                          dataLst![idx!]["sip"] == ""
                              ? Container()
                              : Text(
                                  "${dataLst![idx!]["sip"]}",
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                          dataLst![idx!]["notes"] == ""
                              ? Container()
                              : Text(
                                  "${dataLst![idx!]["notes"]}",
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                          dataLst![idx!]["lbl1"] == "No label"
                              ? Container()
                              : Text(
                                  "${dataLst![idx!]["lbl1"]}",
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
