import 'dart:io';
import 'package:contact/DB_Helper/DBHelper.dart';
import 'package:contact/UI_Helper/UIHelper.dart';
import 'package:contact/Pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  bool isLoading = false;

  // This is List.
  List dataLst = [];

  loadData() async {
    // This is Array.
    List l = [];

    l = await DBHelper.database!.rawQuery("select*from tblRecord order by id desc");
    dataLst.addAll(l);

    if (dataLst.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
    }
  }

  final TextEditingController _search = TextEditingController();

  // For Drawer
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // For Popupmenu
  List<String> itemsLst = ["Select", "Select All", "Customise view"];

  List<PopupMenuItem> _items() {
    List<PopupMenuItem> itemsLst = [];
    for (int i = 0; i < this.itemsLst.length; i++) {
      itemsLst.add(PopupMenuItem(child: Text(this.itemsLst[i])));
    }
    return itemsLst;
  }

  List<String> name = [
    "First Name",
    "Middle Name",
    "Last Name",
    "Email",
    "Country code",
    "Phone",
    "Phone Label",
    "Relation",
    "Address",
    "Company",
    "SIP",
    "Notes",
    "Gender",
    "Hobby",
    "Password"
  ];

  List<String> keyName = [
    "fname",
    "mname",
    "lname",
    "email",
    "countryCode",
    "phone",
    "lbl1",
    "lbl2",
    "address",
    "company",
    "sip",
    "notes",
    "gender",
    "hobby",
    "password"
  ];

  Future deleteDialoge(int index) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MyColors.greenAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          title: const Text("Delete contact?",
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: "Manrope",
              )),
          content: const Text(
              "This contact will be permanently deleted from your device",
              style: TextStyle(
                fontSize: 14.5,
                color: Colors.black54,
                fontFamily: "Manrope",
                fontWeight: FontWeight.w700,
              )),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: MyColors.green))),
            TextButton(
                onPressed: () async {
                  int id = dataLst[index]["id"];
                  await DBHelper.database!
                      .rawDelete("delete from tblRecord where id = $id");
                  Navigator.pop(context);
                  setState(() {
                    dataLst.removeAt(index);
                  });
                },
                child: Text("Delete", style: TextStyle(color: MyColors.green))),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dataLst.isEmpty) {
      isLoading = false;
    } else {
      isLoading = true;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Set status bar without any AppBar.
      value: SystemUiOverlayStyle(
          statusBarColor: MyColors.green,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light),
      child: SafeArea(
        child: Scaffold(
          body: isLoading
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                      child: Container(
                        height: 55.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: MyColors.greenAccent,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: ListTile(
                          horizontalTitleGap: 00.0,
                          minVerticalPadding: 0.0,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                          visualDensity:
                              const VisualDensity(horizontal: 0.0, vertical: 0),
                          leading: IconButton(
                            onPressed: () {
                              _key.currentState!.openDrawer();
                            },
                            icon: const Icon(
                              Icons.menu_outlined,
                            ),
                            color: Colors.black,
                          ),
                          title: TextField(
                            controller: _search,
                            autofocus: false,
                            autocorrect: true,
                            enableSuggestions: true,
                            decoration: const InputDecoration(
                              hintText: "Search contacts",
                              border: InputBorder.none,
                            ),
                            showCursor: true,
                            cursorHeight: 25.0,
                            cursorWidth: 2.0,
                            cursorColor: Colors.black,
                            cursorRadius: const Radius.circular(50.0),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Manrope",
                            ),
                            toolbarOptions: const ToolbarOptions(
                                copy: true,
                                paste: true,
                                cut: false,
                                selectAll: true),
                          ),
                          trailing: PopupMenuButton(
                            splashRadius: 20.0,
                            icon: const Icon(Icons.more_vert_outlined,
                                color: Colors.black),
                            iconSize: 30.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            position: PopupMenuPosition.over,
                            elevation: 10.0,
                            shadowColor: Colors.grey.shade800,
                            onSelected: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("$value",
                                          style: const TextStyle(
                                              color: Colors.black))));
                            },
                            itemBuilder: (context) {
                              return _items();
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dataLst.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return ProfilePage(dataLst, index);
                                },
                              ));
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: MyColors.green,
                                  child: dataLst[index]["image"] == null
                                      ? Text(
                                          "${dataLst[index]["fname"][0].toUpperCase()}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0))
                                      : Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: MyColors.green,
                                              image: DecorationImage(
                                                  image: FileImage(File(
                                                      dataLst[index]["image"])),
                                                  fit: BoxFit.fill)),
                                        ),
                                ),
                              ),
                              title: Text(
                                "${dataLst[index]["fname"] + " " + dataLst[index]["lname"]}",
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text("${dataLst[index]["phone"]}",
                                  style: const TextStyle(
                                      fontSize: 14.5, color: Colors.black54)),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: IconButton(
                                    onPressed: () {
                                      deleteDialoge(index);
                                    },
                                    icon: Icon(Icons.delete,
                                        color: MyColors.green)),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              : Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("anim/no_records.json",
                        filterQuality: FilterQuality.high, height: 200.0),
                    const Text("No Contacts Available",
                        style: TextStyle(fontSize: 13.0))
                  ],
                )),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.pushReplacementNamed(context, "form_page");
            },
            mini: false,
            backgroundColor: MyColors.green,
            tooltip: "Edit",
            elevation: 20.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            foregroundColor: Colors.white,
            splashColor: Colors.red,
            child: const Icon(
              Icons.add_outlined,
              size: 30.0,
            ),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          persistentFooterAlignment: AlignmentDirectional.bottomEnd,
          key: _key,
          drawer: Drawer(
            backgroundColor: MyColors.greenAccent,
            width: 250,
            shadowColor: MyColors.green,
            elevation: 10.0,
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.fromLTRB(
                  8.0, MediaQuery.of(context).padding.top, 8.0, 0.0),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("img/logo.jpg",
                        height: 45.0,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high),
                    const SizedBox(width: 10.0),
                    const Text(
                      "Contacts",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope",
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                    color: MyColors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child:
                                Icon(Icons.person_outline, color: Colors.white),
                          ),
                          Text(
                            "Contact    ${dataLst.length}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
