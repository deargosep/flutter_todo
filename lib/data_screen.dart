import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

// in case if you have only an object
class Data {
  String id = '';
  String name = '';
  String description = '';
  String author = '';
  int status = 0;
}

class DataList {
  List list = [];
}

class _DataScreenState extends State<DataScreen> {
  List<dynamic> dataList = [];
  // var dataClass = Data();
  var dataListClass = DataList();
  Future workData() async {
    setState((){
      dataList = [];
    });
    dynamic gotData = await getData();
    dataListClass.list = gotData;
    //
    // in case if you have one object, not an array:
    //
    // dataClass.id = gotData[0]['_id'];
    // dataClass.name = gotData[0]['name'];
    // dataClass.description = gotData[0]['description'];
    // dataClass.author = gotData[0]['author'];
    // dataClass.status = gotData[0]['status'];
    //
    setState(() {
      dataList = gotData;
    });
    return dataList;
  }

  @override
  void initState() {
    workData();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Data'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: RefreshIndicator(
            onRefresh: workData,
            child: dataList.isEmpty ? Center(child: CircularProgressIndicator()) : ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return Item(item:dataList[index]);
                }
                ),
          ),
        ));
  }
}

class Item extends StatefulWidget {
  var item;

  Item({Key, key, required this.item}) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        height: 200,
        width: 200,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(widget.item['name'], style: TextStyle(fontSize: 20)),
            Text(widget.item['description']),
            // or, if you dont have an object for every item
            // Text(dataList[index]['description'])
          ],
        ),
      ),
    );;
  }
}


// void main() {
//   var b = Being();
Future<List<dynamic>> getData() async {
  var url = Uri.parse('https://taskboard-node.herokuapp.com/tasks');
  var response = await http.get(url);
  var body = response.body;
  var bodyDecoded = jsonDecode(response.body);
  return bodyDecoded;
}
// getData();
// }
