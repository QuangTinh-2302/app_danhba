import 'package:flutter/material.dart';
import 'dart:convert';
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
  List<Contacts> _listdanhba = [];
  TextEditingController _searchcontroller = TextEditingController();
  List<Contacts> _filteredContacts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _GetData();
      _searchcontroller.addListener(_filterContacts);
  }
  void _filterContacts() {
    final query = _searchcontroller.text.toLowerCase();
    setState(() {
      _filteredContacts = _listdanhba
          .where((contact) => contact.name.toLowerCase().contains(query) ||
          contact.phone.contains(query))
          .toList();
    });
  }
  @override
  void dispose() {
    _searchcontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Danh Bạ',style: TextStyle(fontSize: 30),),
          centerTitle: true,
        ),
        body: _listdanhba.isEmpty ?
        const Center(
          child: CircularProgressIndicator()
        ) :
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchcontroller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:_filteredContacts.isEmpty ? Center(child: Text('Không tìm thấy liên hệ'),) :
              ListView.builder(
                padding: EdgeInsets.only(bottom: 60),
                itemCount: _filteredContacts.length,
                itemBuilder: (Context,index){
                  final contact = _filteredContacts[index];
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
                                  _GetData();
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
                                    onPressed: () async{
                                      await _Delete(index);
                                      setState(() {
                                        _filterContacts();
                                        _filteredContacts.removeAt(index);
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:  ()async{
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Themscreen()));
            if(result != null){
              setState(() {
                _GetData();
              });
            }
          },
          child: Icon(Icons.add,size: 30,),
          elevation: 10,
        ),
      )
    );
  }
  Future<void> _GetData() async{
    var reponse = await http.get(Url.Url_getdata);
    if(reponse.statusCode == 200){
      var jsonReponse = jsonDecode(reponse.body);
      setState(() {
        _listdanhba = (jsonReponse as List)
            .map((jsonOb) => Contacts.fromJson(jsonOb))
            .toList();
        _filterContacts();
      });
    }else{
      print('Request failed');
    }
  }
  Future<void> _Delete(int index) async{
    final id = _filteredContacts[index].id;
    final name = _filteredContacts[index].name;
    final phone = _filteredContacts[index].phone;
    var data = {
      'id': id,
      'name': name,
      'phone': phone,
    };
    var deleterepose = await http.post(Url.url_delete,headers:{"Content-Type":"application/json"},body:json.encode(data));
    if (deleterepose.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa thành công $name'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa không thành công'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        )
      );
    }
  }
}
