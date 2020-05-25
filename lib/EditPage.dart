import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;

  List<User> users;
  bool flag = false;

  var duration, name;
  var _uid;
  String timeslot = "10AM - 12PM";

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return firestore
        .collection('homemakers')
        .document(_uid)
        .collection('menu')
        .snapshots();
  }

  void getUser() async {
    var temp;
    _auth.onAuthStateChanged.listen((user) async {
      temp = await firestore.collection('homemakers').document(user.uid).get();
      setState(() {
        _uid = user.uid;
      });
    });
  }

  void getData() async {
    var temp;
    _auth.onAuthStateChanged.listen((user) async {
      temp = await firestore.collection('homemakers').document(user.uid).get();
      setState(() {
        duration = temp.data['ohours'];
        flag = !flag;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            height: 54,
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.explore,
                    color: Colors.black,
                  ),
                  title: Text("Home"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search, color: Colors.black),
                  title: Text("Shop"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border, color: Colors.black),
                  title: Text("Shop"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.perm_identity, color: Colors.black),
                  title: Text("Shop"),
                )
              ],
            ),
          )),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 48),
              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/MenuPage");
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.black,
                  )),
              SizedBox(height: 40),
              Text(
                "Edit Menu",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Gilroy",
                  fontSize: 25.0,
                ),
              ),
              SizedBox(height: 31),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  // margin: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            timeslot = "10AM - 12PM";
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: Text(
                              "10AM - 12PM",
                              style: TextStyle(
                                  fontSize:
                                      timeslot == "10AM - 12PM" ? 18.0 : 15.0,
                                  color: timeslot == "10AM - 12PM"
                                      ? Color(0xffFE506D)
                                      : Colors.black26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Gilroy"),
                            )),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            timeslot = "01PM - 04PM";
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: Text(
                              "01PM - 04PM",
                              style: TextStyle(
                                  fontSize:
                                      timeslot == "01PM - 04PM" ? 18.0 : 15.0,
                                  color: timeslot == "01PM - 04PM"
                                      ? Color(0xffFE506D)
                                      : Colors.black26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Gilroy"),
                            )),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            timeslot = "06PM - 09PM";
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: Text(
                              "06PM - 09PM",
                              style: TextStyle(
                                  fontSize:
                                      timeslot == "06PM - 09PM" ? 18.0 : 15.0,
                                  color: timeslot == "06PM - 09PM"
                                      ? Color(0xffFE506D)
                                      : Colors.black26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Gilroy"),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: StreamBuilder(
                      stream: firestore
                          .collection("homemakers")
                          .document(_uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          return Container(
                            height: 250,
                            child: ListView.builder(
                                itemCount: snapshot.data.data["menu"].length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  if ((snapshot.data.data["menu"][index]
                                              ["timeslot"])
                                          .toString() ==
                                      timeslot) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 15.0, left: 5, right: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "${snapshot.data.data["menu"][index]["name"]}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Gilroy",
                                                fontSize: 21.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.8,
                                                height: 1.15,
                                              ),
                                            ),
                                          ),
                                          ButtonTheme(
                                            minWidth: 30.0,
                                            height: 30.0,
                                            child: OutlineButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)), //this right here
                                                        child: Container(
                                                          height: 200,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    15,
                                                                    15,
                                                                    15,
                                                                    15),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                        width:
                                                                            220),
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Icon(
                                                                            Icons.highlight_off))
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "Are you sure you want to delete ${snapshot.data.data["menu"][index]["name"]}?",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'SF Pro Text',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15.0,
                                                                    letterSpacing:
                                                                        -0.8,
                                                                    height:
                                                                        1.15,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 40),
                                                                SizedBox(
                                                                  width: 320.0,
                                                                  child:
                                                                      RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      List<dynamic>
                                                                          menu =
                                                                          [];
                                                                      for (int i =
                                                                              0;
                                                                          i < snapshot.data.data["menu"].length;
                                                                          i++) {
                                                                        if (i ==
                                                                            index) {
                                                                          continue;
                                                                        } else {
                                                                          menu.add(snapshot
                                                                              .data
                                                                              .data["menu"][i]);
                                                                        }
                                                                      }
                                                                      firestore
                                                                          .collection(
                                                                              "homemakers")
                                                                          .document(
                                                                              _uid)
                                                                          .updateData({
                                                                        "menu":
                                                                            menu
                                                                      }).whenComplete(
                                                                              () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                      "DELETE ITEM",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'SF Pro Text',
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        height:
                                                                            1.15,
                                                                      ),
                                                                    ),
                                                                    color: Color(
                                                                        0xffFE4E74),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xffFE4E74),
                                              ),
                                              child: Center(
                                                  child: Icon(
                                                Icons.close,
                                                color: Color(0xffFE4E74),
                                                size: 20,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ButtonTheme(
                                            minWidth: 30.0,
                                            height: 30.0,
                                            child: OutlineButton(
                                              onPressed: () {
                                                editDialog(
                                                    context, snapshot, index);
                                              },
                                              borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xffFE4E74),
                                              ),
                                              child: Center(
                                                  child: Icon(
                                                Icons.edit,
                                                color: Color(0xffFE4E74),
                                                size: 20,
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          );
                        }
                      }),
                ),
              ),
              SizedBox(height: 100),
              SizedBox(
                child: OutlineButton(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Color(0xffFE506D),
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "ADD ITEM",
                          style: TextStyle(
                              color: Color(0xffFE506D),
                              fontFamily: "Gilroy",
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    borderSide: BorderSide(color: Color(0xffFE506D), width: 2),
                    onPressed: () {
                      return showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                          context: context,
                          builder: (BuildContext bc) {
                            return Container(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 40),
                                  Text("Add Item",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        OutlineButton(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.add,
                                                  color: Color(0xffFE506D),
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                new Text(
                                                  "NEW ITEM",
                                                  style: TextStyle(
                                                      color: Color(0xffFE506D),
                                                      fontFamily: "Gilroy",
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            borderSide: BorderSide(
                                                color: Color(0xffFE506D),
                                                width: 2),
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context, "/NewItemPage");
                                            },
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0))),
                                        OutlineButton(
                                            child: new Text(
                                              "FROM INVENTORY",
                                              style: TextStyle(
                                                  color: Color(0xffFE506D),
                                                  fontFamily: "Gilroy",
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            borderSide: BorderSide(
                                                color: Color(0xffFE506D),
                                                width: 2),
                                            onPressed: () {},
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0))),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future editDialog(
      BuildContext context, AsyncSnapshot<dynamic> snap, int index) {
    TextEditingController itemname = new TextEditingController();
    TextEditingController itemPrice = new TextEditingController();
    String itemTimeslot;
    var veg=snap.data.data["menu"][index]["veg"];
    var image=snap.data.data["menu"][index]["image"];
    var rating=snap.data.data["menu"][index]["rating"];
    itemname.text = snap.data.data["menu"][index]["name"];
    itemPrice.text = snap.data.data["menu"][index]["price"].toString();
    itemTimeslot = snap.data.data["menu"][index]["timeslot"];
    return showDialog(
        context: (context),
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: EdgeInsets.all(10.0),
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.close),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Edit Current Item",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Gilroy",
                        fontSize: 25.0,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextField(
                      style: TextStyle(fontSize: 20.0, fontFamily: "Gilroy"),
                      controller: itemname,
                      decoration: InputDecoration(
                        hintText: "Enter Item Name",
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      style: TextStyle(fontSize: 20.0, fontFamily: "Gilroy"),
                      controller: itemPrice,
                      decoration: InputDecoration(
                        hintText: "Enter Item Price",
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                                          child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Center(
                          child: DropdownButton<String>(
                            value: itemTimeslot,
                            hint: Text("Choose a time slot"),
                            style: TextStyle(
                              color: Color.fromRGBO(38, 50, 56, 0.30),
                              fontSize: 15.0,
                              fontFamily: "Gilroy",
                            ),
                            underline: Container(
                              height: 2,
                              color: Colors.black45,
                            ),
                            onChanged: (value) {
                              setState(() {
                                itemTimeslot = value;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                value: "10AM - 12PM",
                                child: Text(
                                  "10AM - 12PM", style: TextStyle(fontSize: 15),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "01PM - 04PM",
                                child: Text(
                                  "01PM - 04PM", style: TextStyle(fontSize: 15),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "06PM - 09PM",
                                child: Text(
                                  "06PM - 09PM", style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        List<dynamic> menu = [];
                        for (int i = 0;
                            i < snap.data.data["menu"].length;
                            i++) {
                          if (i == index) {
                            menu.add({
                              "name": itemname.text,
                              "price": int.parse(itemPrice.text),
                              "timeslot": itemTimeslot,
                              "veg":veg,
                              "rating":rating,
                              "image":image
                            });
                          } else {
                            menu.add(snap.data.data["menu"][i]);
                          }
                        }
                        Firestore.instance
                            .collection("homemakers")
                            .document(_uid)
                            .updateData({"menu": menu}).whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        "MODIFY ITEM",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF Pro Text',
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                        ),
                      ),
                      color: Color(0xffFE4E74),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}