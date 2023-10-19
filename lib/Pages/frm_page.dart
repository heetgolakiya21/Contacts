import 'dart:io';
import 'package:contact/DB_Helper/DBHelper.dart';
import 'package:contact/UI_Helper/UIHelper.dart';
import 'package:contact/Pages/home_page.dart';
import 'package:contact/Custom_Widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
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

  // TextEditingControllers
  final TextEditingController _fName = TextEditingController();
  final List<String> _name = ["Middle Name", "Last Name"];
  final List<TextEditingController> _controllers = [];
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final List<String> _name1 = ["Address", "Company", "SIP", "Notes"];
  final List<TextEditingController> _controllers1 = [];

  // For ListView Icon
  List<Icon> icn = [
    const Icon(Icons.location_on_outlined),
    const Icon(Icons.business_outlined),
    const Icon(Icons.dialer_sip_outlined),
    const Icon(Icons.note_outlined),
  ];

  // Validation
  String? _ferr;
  String? _emailerr;
  String? _phoneerr;

  // Mobile Label
  final List<String> _mobileLbl = [
    "No label",
    "Mobile",
    "Work",
    "Home",
    "Main",
    "Work fax",
    "Home fax",
    "Pager",
    "Other",
    "Custom"
  ];
  String _defMobileLbl = "No label";

  List<DropdownMenuItem> items() {
    List<DropdownMenuItem> code = [];
    for (int i = 0; i < _mobileLbl.length; i++) {
      code.add(
          DropdownMenuItem(value: _mobileLbl[i], child: Text(_mobileLbl[i])));
    }

    return code;
  }

  // Country Code Label
  final List<String> _codeLbl = ["+91", "+1", "+92"];
  String _defCodeLbl = "+91";

  List<DropdownMenuItem> items2() {
    List<DropdownMenuItem> countryCode1 = [];
    for (int i = 0; i < _codeLbl.length; i++) {
      countryCode1
          .add(DropdownMenuItem(value: _codeLbl[i], child: Text(_codeLbl[i])));
    }

    return countryCode1;
  }

  // Radio
  List<String> gender = ["Male", "Female", "Other"];
  String _none = "";

  //  Relation Label
  final List<String> _relationLbl = [
    "No label",
    "Assistant",
    "Brother",
    "Child",
    "Domestic Partner",
    "Father",
    "Friend",
    "Manager",
    "Mother",
    "Parent",
    "Partner",
    "Referred by",
    "Relative",
    "Sister",
    "Spouse",
    "Custom"
  ];
  String _defRelationLbl = "No label";

  List<DropdownMenuItem> items1() {
    List<DropdownMenuItem> code1 = [];
    for (int i = 0; i < _relationLbl.length; i++) {
      code1.add(DropdownMenuItem(
          value: _relationLbl[i], child: Text(_relationLbl[i])));
    }

    return code1;
  }

  // For Checkbox
  final List<bool> _chkStatus = List.filled(4, false);
  final List<String> _chkName = ["Reading", "Writing", "Listening", "Speaking"];

  List<String> cksAns = [];

  // File? image;
  File? image;

  Future<void> pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: goBack,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create contact"),
          leading: IconButton(
              onPressed: () async {
                await Navigator.pushReplacementNamed(context, "home_page");
              },
              splashColor: MyColors.green,
              splashRadius: 15.0,
              tooltip: "Close",
              icon: const Icon(Icons.close_outlined, size: 30.0)),
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                    onPressed: () async {
                      bool emailValid =
                          RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*$')
                              .hasMatch(_email.text);

                      setState(() {
                        _ferr = null;
                        _emailerr = null;
                        _phoneerr = null;
                      });

                      if (_fName.text.isEmpty) {
                        setState(() {
                          _ferr = "Required First Name";
                        });
                      } else if (_email.text.isEmpty) {
                        setState(() {
                          _emailerr = "Required Email";
                        });
                      } else if (_email.text.isNotEmpty &&
                          emailValid == false) {
                        setState(() {
                          _emailerr = "Enter Valid Email";
                        });
                      } else if (_phone.text.isEmpty) {
                        setState(() {
                          _phoneerr = "Required Number";
                        });
                      } else if (_phone.text.length < 10) {
                        setState(() {
                          _phoneerr = "Enter Valid Number";
                        });
                      } else {
                        // Database Related Code
                        String fname = _fName.text;
                        String mname = _controllers[0].text;
                        String lname = _controllers[1].text;
                        String email = _email.text;
                        String countryCode = _defCodeLbl;
                        String phone = _phone.text;
                        String lbl1 = _defMobileLbl;
                        String lbl2 = _defRelationLbl;
                        String address = _controllers1[0].text;
                        String company = _controllers1[1].text;
                        String sip = _controllers1[2].text;
                        String notes = _controllers1[3].text;
                        String gender = _none;
                        List<String> hobby = cksAns;
                        String imagePath = image!.path;

                        String query =
                            "INSERT INTO tblRecord (fname,mname,lname,email,countryCode,phone,lbl1,lbl2,address,company,sip,notes,gender,hobby,image) VALUES('$fname','$mname','$lname','$email','$countryCode','$phone','$lbl1','$lbl2','$address','$company','$sip','$notes','$gender','$hobby','$imagePath')";

                        int? no = await DBHelper.database!.rawInsert(query);

                        if (no > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Contact Saved",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Image.asset(
                                  "img/tick.png",
                                  height: 20.0,
                                )
                              ],
                            ),
                            duration: const Duration(milliseconds: 1000),
                            backgroundColor: MyColors.green,
                            behavior: SnackBarBehavior.floating,
                            width: 200.0,
                          ));
                          await Navigator.pushReplacementNamed(
                              context, "home_page");
                        }
                      }
                    },
                    child: const Text("Save"))),
            PopupMenuButton(
              splashRadius: 15.0,
              tooltip: "Menu",
              position: PopupMenuPosition.under,
              iconSize: 30.0,
              itemBuilder: (context) {
                return [const PopupMenuItem(child: Text("Help & feedback"))];
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(
          //     decelerationRate: ScrollDecelerationRate.fast),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: CircleAvatar(
                    radius: 90.0,
                    backgroundColor: MyColors.greenAccent,
                    child: image == null
                        ? const Icon(Icons.add_photo_alternate_outlined,
                            color: Colors.black)
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors.greenAccent,
                              image: DecorationImage(
                                image: FileImage((File(image!.path))),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            backgroundColor: MyColors.greenAccent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 30.0),
                            title: const Text("What do you prefer?"),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await pickImage(ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                    icon:
                                        const Icon(Icons.photo_camera_outlined),
                                    iconSize: 60.0,
                                    color: MyColors.green,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await pickImage(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                    icon:
                                        const Icon(Icons.photo_album_outlined),
                                    iconSize: 60.0,
                                    color: MyColors.green,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Add picture",
                      style: TextStyle(
                          color: MyColors.green, fontWeight: FontWeight.w600),
                    )),
                // NAME
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                  ),
                  child: ListTileTheme(
                    horizontalTitleGap: 0.0,
                    child: ExpansionTile(
                      collapsedIconColor: MyColors.green,
                      iconColor: MyColors.green,
                      tilePadding: EdgeInsets.zero,
                      initiallyExpanded: true,
                      leading: const Icon(Icons.person_outline,
                          size: 25.0, color: Colors.black),
                      title: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CustomTextField(
                          labelText: "First Name *",
                          controller: _fName,
                          errorText: _ferr,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-Z]+|\s")),
                          ],
                        ),
                      ),
                      children: [
                        ListView.builder(
                          itemCount: _name.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            _controllers.add(TextEditingController());
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  40.0, 13.0, 40.0, 0.0),
                              child: CustomTextField(
                                labelText: _name[index],
                                controller: _controllers[index],
                                keyboardType: TextInputType.name,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[a-zA-Z]+|\s")),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // EMAIL
                Padding(
                  padding: const EdgeInsets.only(right: 40.0, top: 18.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.email_outlined),
                      ),
                      Expanded(
                          child: CustomTextField(
                        labelText: "Email *",
                        controller: _email,
                        errorText: _emailerr,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                      )),
                    ],
                  ),
                ),
                // PHONE
                Padding(
                  padding: const EdgeInsets.only(right: 40.0, top: 18.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15.0, top: 13.5),
                        child: Icon(Icons.phone_outlined),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 90.0,
                          child: DropdownButtonFormField(
                            value: _defCodeLbl,
                            items: items2(),
                            onChanged: (value) {
                              setState(() {
                                _defCodeLbl = value;
                              });
                            },
                            menuMaxHeight: 350,
                            iconEnabledColor: MyColors.green,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 14.0),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyColors.green, width: 2.0)),
                              labelText: "Code",
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                              floatingLabelStyle: TextStyle(
                                color: MyColors.green,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: CustomTextField(
                        labelText: "Phone *",
                        controller: _phone,
                        errorText: _phoneerr,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                        ],
                      )),
                    ],
                  ),
                ),
                // LABEL
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: SizedBox(
                        width: 170,
                        child: DropdownButtonFormField(
                          value: _defMobileLbl,
                          items: items(),
                          onChanged: (value) {
                            setState(() {
                              _defMobileLbl = value;
                            });
                          },
                          menuMaxHeight: 350,
                          iconEnabledColor: const Color(0xFF006A68),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 14.0),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF006A68), width: 2.0)),
                            labelText: "Label",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Color(0xFF006A68),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // RELATION
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.refresh_rounded,
                          size: 30.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 210,
                        child: DropdownButtonFormField(
                          value: _defRelationLbl,
                          items: items1(),
                          onChanged: (value) {
                            setState(() {
                              _defRelationLbl = value;
                            });
                          },
                          menuMaxHeight: 350,
                          iconEnabledColor: const Color(0xFF006A68),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 14.0),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF006A68), width: 2.0)),
                            labelText: "Relation",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Color(0xFF006A68),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: _name1.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    _controllers1.add(TextEditingController());
                    return Padding(
                      padding: const EdgeInsets.only(right: 40.0, top: 18.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: icn[index],
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: _controllers1[index],
                              labelText: _name1[index],
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 13.0, left: 40.0, right: 40.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "Gender",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            ListView.builder(
                              itemCount: gender.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  value: gender[index],
                                  groupValue: _none,
                                  onChanged: (value) {
                                    setState(() {
                                      _none = gender[index];
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: MyColors.green,
                                  title: Text(gender[index]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "Hobby",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            ListView.builder(
                              itemCount: _chkName.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
                                  value: _chkStatus[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _chkStatus[index] = value!;
                                    });
                                  },
                                  title: Text(_chkName[index]),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
