// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, slash_for_doc_comments, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'register_edit_asset.dart';
import 'dart:convert';

/**
 * 查看资产
 */

class ViewAsset extends StatefulWidget {
  const ViewAsset({Key? key}) : super(key: key);

  @override
  _ViewAssetState createState() => _ViewAssetState();
}

class _ViewAssetState extends State<ViewAsset> {

  Map assetMap = {};
  Map specificationMap = {};
  List specKey =[];
  List specValue =[];
  List photosList = [];

  void initScreenUtil() {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, //屏幕宽度
          maxHeight: MediaQuery.of(context).size.height //屏幕高度
      ),
      designSize: Size(360, 690), //基于360*690dp的屏幕适配
    );
  }

  void getAsset() async{
    Object? object = ModalRoute.of(context)!.settings.arguments;
    assetMap = json.decode(json.encode(object));
    print('assetMap: $assetMap');
    // print('specification: ${assetMap["specification"]}');

    if(assetMap["assetPhotos"].length>0){
      specificationMap= json.decode(assetMap["specification"]);
    }

    specificationMap.forEach((key, value) {
      specKey.add("$key");
      specValue.add(value);
    });
    photosList = assetMap["assetPhotos"];
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil();
    getAsset();//获取资产信息

    return Scaffold(

      appBar: AppBar(
        toolbarHeight: 45,
        elevation: 0,
        backgroundColor: Color(0xffD7D7D7),
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xff848484),
              size: ScreenUtil().setSp(20),
            )
        ),
        titleSpacing: ScreenUtil().setSp(-10),
        title: Text("View Asset",
          style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(15)
          ),
        ),
        actions: <Widget>[
          //编辑按钮
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => RegisterEditAsset(),
                  settings: RouteSettings(
                    arguments: assetMap
                  )
                )
                );
              },
              icon: Container(
                width: ScreenUtil().setWidth(27),
                height: ScreenUtil().setHeight(27),
                child: Image.asset("images/icon-edit.png",fit: BoxFit.fill),
              )
          )
        ],
      ),

      body: Container(
        color: Color(0xffD7D7D7),
        child: Column(
          children: [

            //信息
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xffF2F2F2),
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                        child: Text("Name：${assetMap["name"]}(${assetMap["assetNumber"]})",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(11),
                              fontWeight: FontWeight.w500
                            )
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: ScreenUtil().setHeight(20),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(10),
                            right: ScreenUtil().setWidth(40)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Asset Category：${assetMap["category"]}",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(11),
                                    fontWeight: FontWeight.w500
                                )
                            ),

                            Text("Price：¥${assetMap["price"]}",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(10),
                                    fontWeight: FontWeight.w500
                                )
                            )
                          ],
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: ScreenUtil().setHeight(30),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(10),
                            right: ScreenUtil().setWidth(28)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Manufacture Date：${assetMap["manufactureDate"] ?? "No record" }",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(11),
                                    fontWeight: FontWeight.w500
                                )
                            ),

                            Text("Service Date：\n${assetMap["serviceDate"] ?? "No record"}",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(10),
                                    fontWeight: FontWeight.w500
                                )
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                        child: Text("Department：${assetMap["department"]}",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(11),
                                fontWeight: FontWeight.w500
                            )
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(5)),

                      Spacer(),
                      Container(
                        height: ScreenUtil().setHeight(5),
                        color: Color(0xffD7D7D7),
                      )

                    ],
                  ),
                )
            ),

            //属性
            Expanded(
                flex: 5,
                child: Container(
                  color: Color(0xffF2F2F2),
                  child: Stack(
                    children: [

                      Align(
                        alignment: Alignment(0, -0.7),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: specificationMap.isNotEmpty ? specificationMap.length:1,
                            itemBuilder: (context,index){
                              return Row(
                                children: [
                                  //左
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        height: ScreenUtil().setHeight(45),
                                        decoration: BoxDecoration(
                                            color: Color(0xffFDFDFD),
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xffE9EBF0)
                                              ),
                                              bottom: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xffE9EBF0)
                                              ),
                                            )
                                        ),
                                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(2.5)),
                                        padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                                        child: Text(specKey.isNotEmpty ?specKey[index]:"暂无资产信息",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(10),
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff565656)
                                          ),
                                        )
                                      ),
                                  ),

                                  //右
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: ScreenUtil().setHeight(45),
                                        decoration: BoxDecoration(
                                            color: Color(0xffFDFDFD),
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xffE9EBF0)
                                              ),
                                              bottom: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xffE9EBF0)
                                              ),
                                            )
                                        ),
                                        padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                                        child: Text(specValue.isNotEmpty ?specValue[index]:"",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(11),
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff565656)
                                          ),
                                        )
                                    ),
                                  )

                                ],
                              );
                              },
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment(0,1),
                        child: Container(
                          height: ScreenUtil().setHeight(5),
                          color: Color(0xffD7D7D7),
                        ),
                      )
                    ],
                  ),
                )
            ),

            //图片
            Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.center,
                  color: Color(0xffF2F2F2),
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(30),
                    horizontal: ScreenUtil().setWidth(20)
                  ),
                  child: GridView.builder(
                    itemCount: photosList.isNotEmpty? photosList.length:0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Color(0xffCCCCCC),
                        padding: EdgeInsets.all(ScreenUtil().setSp(5)),
                        child: Container(
                          child: Image.asset("images/${photosList[index]["photo"]}",fit: BoxFit.fill),
                        ),
                      );
                    },
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //单个子Widget的水平最大宽度
                      //   maxCrossAxisExtent: 100,
                        //水平单个子Widget之间间距
                        mainAxisSpacing: 20.0,
                        //垂直单个子Widget之间间距
                        crossAxisSpacing: 30.0,
                        childAspectRatio: 1.6,
                        crossAxisCount: 2
                    ),
                  )
                )
            ),

          ],
        ),
      ),
    );
  }
}
