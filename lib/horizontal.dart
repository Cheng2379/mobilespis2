// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, slash_for_doc_comments, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_null_comparison, prefer_final_fields

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'asset_management.dart';
import 'register_edit_asset.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class HorizontalScreen extends StatefulWidget {
  const HorizontalScreen({Key? key}) : super(key: key);
  @override
  _HorizontalScreenState createState() => _HorizontalScreenState();
}

class _HorizontalScreenState extends State<HorizontalScreen> {
  final FocusNode _assetNameNode = FocusNode(); //焦点
  final FocusNode _priceNode = FocusNode(); //焦点
  var _assetNameText = TextEditingController(); //资产名称
  var _priceText = TextEditingController(); //资产名称

  XFile? file;
  XFile? image;

  bool first = true;
  bool repeat = true;//资产属性是否重复
  bool update = true;//true: 更新资产；false：注册资产

  Map assetMap = {};
  Map portraitMap = {};
  Map specificationMap = {};
  Map numberMap = {};

  List categoryAllList = [];
  List departmentList = [];
  List attributeNameHttpList = [];
  List attributeValueHttpList = [];
  List attributeNameList = []; //接收的属性名
  List attributeValueList = []; //接收的属性值
  List items = [];
  List photosList = [];

  String category = "Select Asset Category";
  String name = "Asset Name";
  String department = "Department";
  String price = "Price";
  String manufactureDate = "Manufacture Date";
  String serviceDate = "Service Date";
  String number = "Asset Number";
  String attributeName = "Attribute Name";
  String attributeValue = "Attribute Value";

  int? assetId;
  int? categoryId;
  int? departmentId;
  int? photoId;
  int? attributeNameId;


  initScreenUtil() {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, //屏幕宽度
          maxHeight: MediaQuery.of(context).size.height //屏幕高度
          ),
      designSize: Size(360, 690), //基于360*690dp的屏幕适配
    );
  }

  @override
  void initState() {
    super.initState();
    getCategory();
    getDepartment();
    WidgetsFlutterBinding.ensureInitialized();
  }

  getRouteAsset(){
    //所有资产页面传入值
    Object? object = ModalRoute.of(context)!.settings.name;
    //竖屏传入值 => portrait
    Object? portrait = ModalRoute.of(context)!.settings.arguments;

    //传入值
    if(object!=null){
      var asset = json.decode(json.encode(object));
      assetMap = json.decode(asset);
      update = true;
      print("接收数据: $assetMap");
      print("更新资产");
      setState(() {
        assetId = assetMap['id'];//AssetId
        category = assetMap['category']; //类别
        name = assetMap['name']; //名字
        department = assetMap['department']; //部门
        price = (assetMap['price']).toString();
        categoryId = assetMap['categoryId']; //类别Id
        photosList = assetMap['assetPhotos']; //照片

        if (assetMap['specification'] != "") {
          print('specification: ${assetMap['specification']}');
          specificationMap = json.decode(assetMap['specification']);
          items = List.generate(specificationMap.length, (index) => '$index');
          specificationMap.forEach((key, value) {
            attributeNameList.add(key);
            attributeValueList.add(value);
          });
        }
        if (assetMap["manufactureDate"] != null) {
          manufactureDate = (assetMap["manufactureDate"]).split(" ")[0];
        } else if (assetMap["serviceDate"] != null) {
          serviceDate = (assetMap["serviceDate"]).split(" ")[0];
        }
      });
    }else{
      update = false;
      print("注册资产");
    }

    //竖屏
    if(portrait!=null){
      portraitMap = json.decode(json.encode(portrait));
      update = portraitMap['update'];
      print("竖屏数据: $portraitMap");
      setState(() {
        assetId = portraitMap['id'];//AssetId
        category = portraitMap['category']; //类别
        categoryId = portraitMap['categoryId']; //类别Id
        name = portraitMap['name']; //名字
        department = portraitMap['department']; //部门
        price = portraitMap['price'];//金额
        photosList = portraitMap['assetPhotos']; //照片
        number = portraitMap['number'];//编号
        attributeName = portraitMap['attributeName'];
        attributeValue = portraitMap['attributeValue'];
        image = portraitMap['photo'];
        manufactureDate = portraitMap["manufactureDate"];
        serviceDate = portraitMap["serviceDate"];

        if (portraitMap['specification'] != null) {
          print('specification: ${portraitMap['specification']}');
          specificationMap = json.decode(portraitMap['specification']);
          items = List.generate(portraitMap.length, (index) => '$index');
          portraitMap.forEach((key, value) {
            attributeNameList.add(key);
            attributeValueList.add(value);
          });
        }
      });
    }
  }

  getCategory() async {
    var response = await http.get(Uri.parse("http://10.0.2.2:5000/api/AssetCategory"));
    if (response.statusCode == 200) {
      setState(() {
        categoryAllList = json.decode(response.body);
        // print('类别：$categoryAllList');
      });
    }
  }

  getDepartment() async {
    var response =
    await http.get(Uri.parse("http://10.0.2.2:5000/api/Department"));
    if (response.statusCode == 200) {
      setState(() {
        departmentList = json.decode(response.body);
        // print('部门；$departmentList');
      });
    }
  }

  getAttributeName() async {
    var response = await http.get(
        Uri.parse("http://10.0.2.2:5000/api/AssetattributeKey/$categoryId"));
    if (response.statusCode == 200) {
      setState(() {
        attributeNameHttpList = json.decode(response.body);
        // print('AttributeNameList =>  $attributeNameHttpList');
      });
    } else {
      setState(() {
        attributeName = "Attribute Name";
        attributeValue = "Attribute Value";
        attributeNameHttpList = [];
        attributeValueHttpList = [];
      });
    }
  }

  getAttributeValue() async {
    var response = await http.get(Uri.parse(
        "http://10.0.2.2:5000/api/AssetAttributeValue/$attributeNameId"));
    if (response.statusCode == 200) {
      setState(() {
        attributeValueHttpList = json.decode(response.body);
        // print('AttributeValueList => $attributeValueHttpList');
      });
    } else {
      setState(() {
        attributeValue = "Attribute Value";
        attributeValueHttpList = [];
      });
    }
  }

  getNumber() async {
    var response =
    await http.get(Uri.parse("http://10.0.2.2:5000/api/Asset/$categoryId"));
    if (response.statusCode == 200) {
      numberMap = json.decode(response.body);
      number = numberMap['proposal'];
    } else {
      number = "Asset Number";
    }
  }

  portrait(){
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if(MediaQuery.of(context).orientation ==  Orientation.portrait){
        print('已竖屏');
        Future.delayed(Duration(milliseconds: 500),(){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => RegisterEditAsset()
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil();

    if (first) {
      getRouteAsset();//获取传入值
      getNumber();
      getAttributeName();
      getAttributeValue();
      first = false;
    }
    // portrait();//竖屏

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffD7D7D7),
          toolbarHeight: ScreenUtil().setHeight(35),
          //返回
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>AssetManagement(),
                ));
              },
              icon: Container(
                width: ScreenUtil().setWidth(10),
                height: ScreenUtil().setHeight(20),
                child: Image.asset("images/icon-left.png", fit: BoxFit.fill),
              ),
          ),
          titleSpacing: ScreenUtil().setWidth(-5),
          title: Text("Register / Edit Asset",
            style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(15)
            ),
          ),
          //提交
          actions: [
            IconButton(
                onPressed: () {
                  if(update){
                    //编辑
                    _submit();
                  }else{
                    //注册
                    _register();
                  }
                },
                icon: Container(
                  width: ScreenUtil().setWidth(50),
                  height: ScreenUtil().setHeight(50),
                  child: Image.asset("images/icon-submit.png", fit: BoxFit.fill),
                )
            )
          ],
        ),

        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            color: Color(0xffD7D7D7),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Row(
              children: [
                //Basic Information
                Expanded(
                    flex: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xff222222),
                      child: Stack(
                        children: [

                          Align(
                            alignment: Alignment(-1,0),
                            child: Container(
                              color: Color(0xffF2F2F2),
                              child: Column(
                                children: [
                                  //Basic Information
                                  Container(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: ScreenUtil().setWidth(3),
                                            height: ScreenUtil().setHeight(25),
                                            color: Color(0xffD7D7D7),
                                            margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(8),
                                              top: ScreenUtil().setHeight(5)
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(2),
                                              top: ScreenUtil().setHeight(5)
                                            ),
                                            child: Text("Basic Information",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: ScreenUtil().setSp(13),
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                  //Select Asset Category
                                  Container(
                                    height: ScreenUtil().setHeight(28),
                                    padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(7),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(category,
                                            style: TextStyle(
                                                fontSize: ScreenUtil().setSp(12),
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff000000)),
                                          ),
                                        ),

                                        PopupMenuButton(
                                          icon: Icon(Icons.arrow_drop_down,
                                              size: ScreenUtil().setSp(25),
                                              color: Color(0xff7F7F7F)),
                                          itemBuilder: (BuildContext context) {
                                            return List.generate(categoryAllList.length, (index) => PopupMenuItem(
                                                child: Text(categoryAllList[index]["name"],
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil().setSp(12)),
                                                ),
                                                value: categoryAllList[index],
                                              ),
                                            );
                                          },
                                          onSelected: (value) {
                                            setState(() {
                                              Map categoryMap = value as Map;
                                              category = categoryMap['name'];
                                              categoryId = categoryMap['id'];
                                              print('Category：$category');
                                              // print('CategoryId：$categoryId');
                                              getNumber();
                                              getAttributeName();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  //分割线
                                  Container(
                                      height: 1,
                                      margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        right: ScreenUtil().setWidth(7),
                                      ),
                                      color: Color(0xffD0D0D0),
                                  ),

                                  //Asset Name
                                  Container(
                                      height: ScreenUtil().setHeight(33),
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        right: ScreenUtil().setWidth(10),
                                      ),
                                      child: TextField(
                                        autofocus: false,
                                        focusNode: _assetNameNode,
                                        controller: _assetNameText,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(11),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: assetMap["name"] ?? "Asset Name",
                                          hintStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(11),
                                              color: Color(0xff000000)),
                                        ),
                                      )
                                  ),

                                  //分割线
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(7),
                                      right: ScreenUtil().setWidth(7),
                                    ),
                                    color: Color(0xffD0D0D0),
                                  ),

                                  //Department
                                  Container(
                                    height: ScreenUtil().setHeight(28),
                                    padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(7),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(department,
                                            style: TextStyle(
                                                fontSize: ScreenUtil().setSp(12),
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff000000)),
                                          ),
                                        ),

                                        PopupMenuButton(
                                          icon: Icon(Icons.arrow_drop_down,
                                              size: ScreenUtil().setSp(25),
                                              color: Color(0xff7F7F7F)),
                                          itemBuilder: (BuildContext context) {
                                            return List.generate(departmentList.length, (index) => PopupMenuItem(
                                              child: Text(departmentList[index]["name"],
                                                style: TextStyle(
                                                    fontSize: ScreenUtil().setSp(12)),
                                              ),
                                              value: departmentList[index],
                                            ),
                                            );
                                          },
                                          onSelected: (value) {
                                            setState(() {
                                              Map departmentMap = value as Map;
                                              department = departmentMap['name'];
                                              departmentId = departmentMap['id'];
                                              print('Department：$department');
                                              // print('CategoryId：$categoryId');
                                              // getNumber();
                                              // getAttributeName();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  //分割线
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(7),
                                      right: ScreenUtil().setWidth(7),
                                    ),
                                    color: Color(0xffD0D0D0),
                                  ),

                                  //Price
                                  Container(
                                      height: ScreenUtil().setHeight(33),
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        right: ScreenUtil().setWidth(10),
                                      ),
                                      child: TextField(
                                        autofocus: false,
                                        focusNode: _priceNode,
                                        controller: _priceText,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(11),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: price,
                                          hintStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(11),
                                              color: Color(0xff000000)),
                                        ),
                                      )
                                  ),

                                  //分割线
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(7),
                                      right: ScreenUtil().setWidth(7),
                                    ),
                                    color: Color(0xffD0D0D0),
                                  ),

                                  //Manufacture Date
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        top: ScreenUtil().setHeight(5)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(manufactureDate,
                                          style: TextStyle(
                                              fontSize:
                                              ScreenUtil().setSp(12),
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff000000)
                                          ),
                                        ),

                                        Container(
                                            width: ScreenUtil().setWidth(10),
                                            height: ScreenUtil().setHeight(20),
                                            margin: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
                                            child: InkWell(
                                              onTap: () async {
                                                var result = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2050),
                                                ) as DateTime;
                                                setState(() {
                                                  manufactureDate = formatDate(result, [yyyy, '-', m, '-', d]);
                                                  print('Manufacture Date: $manufactureDate');
                                                });
                                              },
                                              child: Image.asset("images/icon-calendar.png", fit: BoxFit.fill),
                                            )
                                        )
                                      ],
                                    ),
                                  ),

                                  //分割线
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(7),
                                      right: ScreenUtil().setWidth(7),
                                      top: ScreenUtil().setHeight(5)
                                    ),
                                    color: Color(0xffD0D0D0),
                                  ),

                                  //Service Date
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        top: ScreenUtil().setHeight(5)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(serviceDate,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(12),
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff000000)
                                          ),
                                        ),

                                        Container(
                                            width: ScreenUtil().setWidth(10),
                                            height: ScreenUtil().setHeight(20),
                                            margin: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
                                            child: InkWell(
                                              onTap: () async {
                                                var result = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2050),
                                                ) as DateTime;
                                                setState(() {
                                                  serviceDate = formatDate(result, [yyyy, '-', m, '-', d]);
                                                  print('Service Date: $serviceDate');
                                                });
                                              },
                                              child: Image.asset("images/icon-calendar.png", fit: BoxFit.fill),
                                            )
                                        )
                                      ],
                                    ),
                                  ),

                                  //分割线
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        right: ScreenUtil().setWidth(7),
                                        top: ScreenUtil().setHeight(5)
                                    ),
                                    color: Color(0xffD0D0D0),
                                  ),

                                  //Asset Number
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: ScreenUtil().setHeight(15),
                                    margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(5),
                                      left: ScreenUtil().setWidth(7),
                                      right: ScreenUtil().setWidth(10),
                                    ),
                                    child: Text(number,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff000000)),
                                    ),
                                  ),

                                  //分割线
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        right: ScreenUtil().setWidth(7),
                                        top: ScreenUtil().setHeight(5)
                                    ),
                                    color: Color(0xffD0D0D0),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //右侧分割线
                          Align(
                            alignment: Alignment(1,0),
                            child: Container(
                              width: ScreenUtil().setWidth(3),
                              height: MediaQuery.of(context).size.height,
                              color: Color(0xffD0D0D0),
                            ),
                          ),
                        ],
                      ),
                    )
                ),

                //Specification
                Expanded(
                    flex: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xffF2F2F2),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment(-1,0),
                            child: Container(
                              color: Color(0xffF2F2F2),
                              child: Column(
                                children: [

                                  //Specification
                                  Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: ScreenUtil().setWidth(3),
                                          height: ScreenUtil().setHeight(25),
                                          color: Color(0xffD7D7D7),
                                          margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(8),
                                              top: ScreenUtil().setHeight(5)
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(2),
                                              top: ScreenUtil().setHeight(5)
                                          ),
                                          child: Text("Specification",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: ScreenUtil().setSp(13),
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),


                                  //Attribute Name
                                  Container(
                                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(7)),
                                    height: ScreenUtil().setHeight(28),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                                          child: Text(attributeName, style: TextStyle(
                                                fontSize: ScreenUtil().setSp(12),
                                                color: Color(0xff000000)),
                                          ),
                                        ),
                                        PopupMenuButton(
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            size: ScreenUtil().setSp(25),
                                            color: Color(0xff7F7F7F),
                                          ),
                                          itemBuilder: (BuildContext context) {
                                            return List.generate(attributeNameHttpList.length, (index) => PopupMenuItem(
                                                child: Text(attributeNameHttpList[index]['name'],
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil().setSp(12),
                                                      color: Colors.black
                                                  ),
                                                ),
                                                value: attributeNameHttpList[index],
                                              ),
                                            );
                                          },
                                          onSelected: (value) {
                                            setState(() {
                                              Map map = value as Map;
                                              attributeName = map['name'];
                                              attributeNameId = map['id'];
                                              print(
                                                  'Attribute Name: $attributeName');
                                              getAttributeValue();
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),

                                  //分割线
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        right: ScreenUtil().setWidth(7),
                                        top: ScreenUtil().setHeight(5)
                                    ),
                                    color: Color(0xffD0D0D0),
                                  ),

                                  //Attribute Value
                                  Container(
                                    height: ScreenUtil().setHeight(28),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //Attribute Value
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(7),
                                              top: ScreenUtil().setHeight(5)
                                          ),
                                          child: Text(attributeValue,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                ScreenUtil().setSp(12)
                                            ),
                                          ),
                                        ),

                                        PopupMenuButton(
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xff7F7F7F),
                                            size: ScreenUtil().setSp(25),
                                          ),
                                          itemBuilder:
                                              (BuildContext context) {
                                            return List.generate(attributeValueHttpList.length, (index) => PopupMenuItem(
                                                child: Text(
                                                  attributeValueHttpList[index]["value"],
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil().setSp(12),
                                                      color: Colors.black),
                                                ),
                                                value: attributeValueHttpList[index],
                                              ),
                                            );
                                          },
                                          onSelected: (value) {
                                            setState(() {
                                              Map map = value as Map;
                                              attributeValue = map['value'];
                                              print('attributeValue: $attributeValue');
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),

                                  //分割线
                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        right: ScreenUtil().setWidth(7),
                                        top: ScreenUtil().setHeight(5)
                                    ),
                                    color: Color(0xffD0D0D0),
                                  ),

                                  //Button => Add to List
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10),
                                        right: ScreenUtil().setWidth(7)),
                                    child: Container(
                                      width: ScreenUtil().setWidth(37),
                                      height: ScreenUtil().setHeight(25),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: Color(0xff868686)),
                                          borderRadius: BorderRadius.circular(ScreenUtil().setSp(3))),
                                      child: MaterialButton(
                                        //点击事件
                                        onPressed: () {
                                          repeat = true;
                                          if (attributeName != "Attribute Name" &&
                                              attributeValue != "Attribute Value") {
                                            //true: 不重复，false: 重复
                                            attributeNameList.forEach((element) {
                                              if (attributeName == element) {
                                                Fluttertoast.showToast(
                                                    msg: "Duplicate attribute name!\nPlease reselect！");
                                                repeat = false;
                                              }
                                            });
                                            if (repeat) {
                                              setState(() {
                                                specificationMap[attributeName] = attributeValue;
                                                attributeNameList.add(attributeName);
                                                attributeValueList.add(attributeValue);
                                                items.add(items.length);
                                                repeat = false;
                                              });
                                            }
                                          }
                                        },
                                        child: Text("Add to List",
                                            style: TextStyle(fontSize: ScreenUtil().setSp(10))),
                                      ),
                                    ),
                                  ),

                                  //ListView => Attribute Name / Attribute Value
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: ScreenUtil().setHeight(135),
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7),
                                        right: ScreenUtil().setWidth(7),
                                        top: ScreenUtil().setHeight(5)),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: items.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            height: ScreenUtil().setHeight(30),
                                            margin: EdgeInsets.only(bottom: 3),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    width: 1, color: Color(0xffD7D7D7)),
                                                borderRadius: BorderRadius.circular(3)),
                                            child: Row(
                                              children: [
                                                //Attribute Name
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: ScreenUtil().setWidth(5)
                                                  ),
                                                  child: Text(attributeNameList[index],
                                                    style: TextStyle(
                                                        fontSize:
                                                        ScreenUtil().setSp(12)),
                                                  ),
                                                ),

                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: ScreenUtil().setWidth(5),
                                                    right: ScreenUtil().setWidth(10),
                                                  ),
                                                  child: Text("/",
                                                    style: TextStyle(
                                                        fontSize:
                                                        ScreenUtil().setSp(12)),
                                                  ),
                                                ),

                                                //Attribute Value
                                                Container(
                                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                                  child: Text(attributeValueList[index],
                                                    style: TextStyle(
                                                        fontSize:
                                                        ScreenUtil().setSp(12)),
                                                  ),
                                                ),

                                                Expanded(child: SizedBox()),

                                                //DeleteButton
                                                Container(
                                                  width: ScreenUtil().setWidth(10),
                                                  height: ScreenUtil().setHeight(20),
                                                  margin: EdgeInsets.only(
                                                      right: ScreenUtil().setWidth(5)),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        items.removeAt(index);
                                                        attributeNameList.removeAt(index);
                                                        attributeValueList.removeAt(index);
                                                      });
                                                    },
                                                    child: Image.asset("images/icon-delete.png", fit: BoxFit.fill),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),

                                ],
                              ),
                            ),
                          ),

                          //右侧分割线
                          Align(
                            alignment: Alignment(1,0),
                            child: Container(
                              width: ScreenUtil().setWidth(3),
                              height: MediaQuery.of(context).size.height,
                              color: Color(0xffD0D0D0),
                            ),
                          ),
                        ],
                      ),
                    )
                ),

                //Photo
                Expanded(
                    flex: 3,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xffF2F2F2),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(0,0),
                              child: Container(
                                color: Color(0xffF2F2F2),
                                child: Column(
                                  children: [
                                    //Photo
                                    Container(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: ScreenUtil().setWidth(3),
                                            height: ScreenUtil().setHeight(25),
                                            color: Color(0xffD7D7D7),
                                            margin: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(8),
                                                top: ScreenUtil().setHeight(5)
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(2),
                                                top: ScreenUtil().setHeight(5)
                                            ),
                                            child: Text("Photo",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil().setSp(13),
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    Container(
                                      width: ScreenUtil().setWidth(95),
                                      height: ScreenUtil().setHeight(90),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(10),
                                        vertical: ScreenUtil().setHeight(7)
                                      ),
                                      padding: EdgeInsets.all(ScreenUtil().setSp(5)),
                                      color: Color(0xffCCCCCC),
                                      child: photosList.isNotEmpty?
                                      Image.asset("images/${photosList[0]['photo']}",fit: BoxFit.fill)
                                          :
                                      Image.asset("images/image_null.png",fit: BoxFit.fill),
                                    ),

                                    Container(
                                      width: ScreenUtil().setWidth(95),
                                      height: ScreenUtil().setHeight(90),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setWidth(10),
                                          vertical: ScreenUtil().setHeight(7)
                                      ),
                                      padding: EdgeInsets.all(ScreenUtil().setSp(5)),
                                      color: Color(0xffCCCCCC),
                                      child: image!=null? Image.file(File(image!.path),fit: BoxFit.fill):Image.asset("images/image_null.png",fit: BoxFit.fill),
                                    ),

                                    //add
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      height: ScreenUtil().setHeight(50),
                                      margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(7)
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          addPhoto();
                                        },
                                        child: Container(
                                          width: ScreenUtil().setWidth(25),
                                          height: ScreenUtil().setHeight(60),
                                          child: Image.asset("images/icon-add.png", fit: BoxFit.fill),
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                ),
              ],
            ),
          ),
        )
    );
  }

  //添加照片
  addPhoto() async {
    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setSp(10)),
              topRight: Radius.circular(ScreenUtil().setSp(10)),
            )
        ),
        context: context,
        backgroundColor: Colors.white,
        builder: (context) =>StatefulBuilder(
            builder: (builder,State) {
              return Container(
                height: photosList.isNotEmpty? ScreenUtil().setHeight(400):ScreenUtil().setHeight(180),
                child: Column(
                  children: [

                    Visibility(
                      child: Container(
                        height: ScreenUtil().setHeight(150),
                        padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0
                            ),
                            itemCount: photosList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(10),
                                    right: ScreenUtil().setWidth(10)
                                ),
                                child: Stack(
                                  children: [

                                    Align(
                                      alignment: Alignment(0,0),
                                      child: Container(
                                        width: ScreenUtil().setHeight(95),
                                        height: ScreenUtil().setHeight(90),
                                        color: Color(0xffCCCCCC),
                                        padding: EdgeInsets.all(
                                            ScreenUtil().setSp(5)
                                        ),
                                        child: Image.asset("images/${photosList[index]['photo']}", fit: BoxFit.fill),
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment(1.2,-1.4),
                                      child: InkWell(
                                        onTap: (){
                                          photoId = photosList[index]['id'];
                                          State(() {
                                            photosList.removeAt(index);
                                            // print('photoList: $photosList');
                                          });
                                          setState(() {
                                          });
                                          postDelete();//删除
                                        },
                                        child: Container(
                                          width: ScreenUtil().setWidth(25),
                                          height: ScreenUtil().setHeight(25),
                                          child: Image.asset("images/icon-delete.png",fit: BoxFit.fill),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      visible: photosList.isNotEmpty? true:false,
                    ),

                    //居于底部
                    Visibility(
                      child: Spacer(),
                    ),
                    Visibility(
                      child: Container(
                        height: 1,
                        color: Color(0xffD7D7D7),
                      ),
                      visible: photosList.isNotEmpty? true:false,
                    ),
                    //拍照
                    ListTile(
                      title: Text("拍照", textAlign: TextAlign.center),
                      onTap: () async {
                        Navigator.pop(context);
                        ImagePicker _picker = ImagePicker();
                        file = await _picker.pickImage(source: ImageSource.camera);

                        setState(() {
                          image = file;
                          print('image:${image!.path}');
                        });

                      },
                    ),
                    Container(
                      height: 1,
                      color: Color(0xffD7D7D7),
                    ),
                    //选择相册
                    ListTile(
                      title: Text("选择照片", textAlign: TextAlign.center),
                      onTap: () async{
                        Navigator.pop(context);
                        ImagePicker _picker = ImagePicker();
                        file = await _picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          image = file;
                          print('image:${image!.path}');
                        });
                      },
                    ),
                    Container(
                      height: 1,
                      color: Color(0xffD7D7D7),
                    ),
                    //取消
                    ListTile(
                      title: Text("取消", textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            }
        )
    );
  }

  //删除照片
  postDelete() async{

    Map map = {
      'Id':photoId,
      'AssetId':assetId,
    };

    http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:5000/api/AssetPhoto/DeleteAssetPhoto"),
        headers: {"content-type":"application/json"},
        body: json.encode(map)
    );
    if(response.statusCode == 200){
      var responseBody = json.decode(response.body);
      print("删除成功，返回值： $responseBody");
    }
  }

  //更新
  _submit() async {
    String assetNameText = _assetNameText.text;
    String priceText = _priceText.text;

    Map specMap = {};
    attributeNameList.forEach((element) {
      attributeValueList.forEach((element1) {
        specMap.putIfAbsent(element, () => element1);
      });
    });
    Map updateMap ={};

    if(name=="Asset Name"){
      if(assetNameText!=""){
        name = assetNameText;
      }else{
        Fluttertoast.showToast(
            msg: "请输入用户名"
        );
      }
    }else{
      if(assetNameText!=""){
        name = assetNameText;
      }
      if(price == "Price"){
        if(priceText != ""){
          price = priceText;
        }else{
          Fluttertoast.showToast(msg: "资产金额不能为空！");
        }
      }else{
        if(priceText != ""){
          price = priceText;
        } else if(specMap.isEmpty){
          updateMap = {
            "id": assetId,
            "name": name,
            "assetNumber": number,
            "categoryId": categoryId,
            "departmentId": departmentId,
            "price": price,
            "serviceDate": serviceDate,
          };
        }else{
          updateMap = {
            "id": assetId,
            "name": name,
            "assetNumber": number,
            "categoryId": categoryId,
            "departmentId": departmentId,
            "price": price,
            "specification": json.encode(specMap)
          };
          print('提交数据: $updateMap');

          var response = await http.post(
              Uri.parse("http://10.0.2.2:5000/api/Asset/UpdateAsset"),
              headers: {"content-type": "application/json"},
              body: json.encode(updateMap)
          );
          print("响应码：${response.statusCode}");
          if(response.statusCode == 200){
            Fluttertoast.showToast(msg: "更新成功！");
            //返回
            Navigator.pop(context);
            print('返回值：${response.body}');
          }else if(response.statusCode == 400){
            Fluttertoast.showToast(msg: response.body);
            print('返回值：${response.body}');
          }

        }
      }
    }
  }

  //注册
  _register() async{

    String assetNameText = _assetNameText.text;
    String priceText = _priceText.text;
    DateTime now = DateTime.now();
    String nowTime = formatDate(now, [yyyy, '-',mm, '-', dd,' ',HH,':',nn,':',ss]);
    // print("当前时间：$nowTime");

    Map specMap = {};
    attributeNameList.forEach((element) {
      attributeValueList.forEach((element1) {
        specMap.putIfAbsent(element, () => element1);
      });
    });

    if(name=="Asset Name"){
      if(assetNameText!=""){
        name = assetNameText;
      }else{
        Fluttertoast.showToast(
            msg: "请输入用户名"
        );
      }
    }else{
      if(assetNameText!=""){
        name = assetNameText;
      }

      if(price=="Price"){
        if(priceText!=""){
          price = priceText;
        }else{
          Fluttertoast.showToast(
              msg: "请输入资产金额"
          );
        }
      }else{
        if(priceText!=""){
          price = priceText;
        }
        if(categoryId==null){
          Fluttertoast.showToast(
              msg: "请选择资产类别"
          );
        }else if(departmentId==null){
          Fluttertoast.showToast(
              msg: "请选择部门"
          );
        }else if(manufactureDate == "Manufacture Date"){
          Fluttertoast.showToast(
              msg: "请选择生产日期"
          );
        }else if(serviceDate == "Service Date"){
          Fluttertoast.showToast(
              msg: "请选择结束日期"
          );
        }else if(specMap.isEmpty){
          Fluttertoast.showToast(
              msg: "请至少添加一个属性与属性值"
          );
        }else{
          Map updateMap = {
            "name": name,
            "assetNumber": number,
            "categoryId": categoryId,
            "departmentId": departmentId,
            "price": price,
            "manufactureDate": manufactureDate,
            "serviceDate": serviceDate,
            "registrationTime": nowTime,
            "specification": json.encode(specMap)
          };
          print('提交数据: $updateMap');
          var response = await http.post(
              Uri.parse("http://10.0.2.2:5000/api/Asset/AddAsset") ,
              headers: {"content-type": "application/json"},
              body: json.encode(updateMap)
          );
          if(response.statusCode == 200){
            Fluttertoast.showToast(
                msg: "注册成功！"
            );
            //返回
            Navigator.pop(context);
            print('注册成功，返回值：${response.body}');
          }
          if(response.statusCode == 400){
            print('response.body: ${response.body}');
            if(response.body=="Assetnumber already exists"){
              Fluttertoast.showToast(msg: "资产名字已存在！");
            }else if(response.body == "DepartmentId does not conform to FK constraint"){
              Fluttertoast.showToast(msg: "部门Id不符合FK约束！");
            }else if(response.body == "Assetnumber already exists"){
              Fluttertoast.showToast(msg: "资产编号已存在！");
            }
          }
        }
      }
    }
  }
}
