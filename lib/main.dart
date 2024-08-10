import 'package:flutter/material.dart';
import 'dart:convert';
//import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:app_qly_danhba/model/contacts.dart';
import 'package:app_qly_danhba/ui/themscreen.dart';
import 'package:app_qly_danhba/model/url.dart';
void main() {
  runApp(MaterialApp(home: MyApp(),debugShowCheckedModeBanner: false,));
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DanhBaState();
  }
}

class DanhBaState extends State<MyApp>{
  static const String localhost = '192.168.1.3';
  List<Contacts> listdanhba = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Danh Bạ'),
          backgroundColor: Colors.blue,
        ),
        body: listdanhba.isEmpty ? Center(
          child: CircularProgressIndicator()) : ListView.builder(
            padding: EdgeInsets.only(bottom: 60),
            itemCount: listdanhba.length,
            itemBuilder: (Context,index){
              final contact = listdanhba[index];
              return ListTile(
                title:Text(contact.name),
                subtitle: Text(contact.phone),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {// Xử lý sự kiện sửa
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Themscreen(
                              contact: contact, // truyền contact để sửa
                            ),
                          ),
                        ).then((value) {
                          if (value == true) {
                            setState(() {
                              GetData();
                            });
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Xử lý sự kiện xóa
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Xóa liên hệ'),
                            content: Text('Bạn có chắc muốn xóa liên hệ này không?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _Delete(index);
                                    listdanhba.removeAt(index);
                                  });
                                  Navigator.pop(context);// Gọi API để xóa contact từ server nếu cần
                                },
                                child: Text('Xóa', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:  ()async{
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Themscreen()));
            if(result != null){
              setState(() {
                listdanhba.add(result);
              });
            }
          },
          child: Icon(Icons.add,size: 30,),
          elevation: 10,
        ),
      )
    );
  }
  Future<void> GetData() async{
    var reponse = await http.get(Url.Url_getdata);
    if(reponse.statusCode == 200){
      var jsonReponse = jsonDecode(reponse.body);
      setState(() {
        listdanhba = (jsonReponse as List)
            .map((jsonOb) => Contacts.fromJson(jsonOb))
            .toList();
      });
    }else{
      print('Request failed');
    }
  }
  Future<void> _Delete(int index) async{
    final id = listdanhba[index].id;
    final name = listdanhba[index].name;
    final phone = listdanhba[index].phone;
    var data = {
      'id': id,
      'name': name,
      'phone': phone,
    };
    var deleterepose = await http.post(Url.url_delete,headers:{"Content-Type":"application/json"},body:json.encode(data));
    if (deleterepose.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa thành công $name',)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa không thành công')),
      );
    }
  }
}
