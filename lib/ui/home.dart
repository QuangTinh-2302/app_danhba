import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_qly_danhba/model/contacts.dart';
import 'package:app_qly_danhba/ui/themscreen.dart';
import 'package:app_qly_danhba/model/url.dart';
import 'package:app_qly_danhba/ui/contact_detail.dart';
import 'package:app_qly_danhba/main.dart';
import 'package:app_qly_danhba/model_view/contactservice.dart';
class MyApp extends StatefulWidget{
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() {
    return DanhBaState();
  }
}
class DanhBaState extends State<MyApp>{
  List<Contacts> _listdanhba = [];
  final TextEditingController _searchcontroller = TextEditingController();
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
            title: const Text('Danh Bạ',style: TextStyle(fontSize: 30),),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed:(){
                  Navigator.pushReplacement(
                    context,MaterialPageRoute(
                      builder: (context) => Login()
                    )
                  );
                },
                icon: Icon(Icons.exit_to_app)
              )
            ],
          ),
          body: _listdanhba.isEmpty ?
          const Center(
              child: CircularProgressIndicator()
          ) :
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchcontroller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child:_filteredContacts.isEmpty ? const Center(child: Text('Không tìm thấy liên hệ'),) :
                ListView.builder(
                    padding: const EdgeInsets.only(bottom: 60),
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context,index){
                      final contact = _filteredContacts[index];
                      return ListTile(
                        title:Text(contact.name),
                        onTap:() {Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ContactDetail(
                                    ct: contact
                                )
                            )
                        );
                        },
                        subtitle: Text(contact.phone),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
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
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Xử lý sự kiện xóa
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Xóa liên hệ'),
                                    content: const Text('Bạn có chắc muốn xóa liên hệ này không?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Hủy'),
                                      ),
                                      TextButton(
                                        onPressed: () async{
                                          await Contactservice(context).Delete(
                                              _filteredContacts[index].id as int,
                                              _filteredContacts[index].name,
                                              _filteredContacts[index].phone);
                                          setState(() {
                                            _GetData();
                                            _filterContacts();
                                            _filteredContacts.removeAt(index);
                                          });
                                          Navigator.pop(context);// Gọi API để xóa contact từ server nếu cần
                                        },
                                        child: const Text('Xóa', style: TextStyle(color: Colors.red)),
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
            onPressed:  (){Navigator.push(context, MaterialPageRoute(builder: (context) => Themscreen()));
              setState(() {
                _GetData();
              });
            },
            elevation: 10,
            child: const Icon(Icons.add,size: 30,),
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
}
