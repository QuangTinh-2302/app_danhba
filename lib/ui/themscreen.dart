import 'package:app_qly_danhba/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_qly_danhba/model/contacts.dart';
import 'package:app_qly_danhba/model/url.dart';
import 'package:flutter/services.dart';

class Themscreen extends StatefulWidget {
  final Contacts? contact; // Thêm thuộc tính contact, có thể null
  Themscreen({Key? key, this.contact}) : super(key: key);
  @override
  _ThemscreenState createState() => _ThemscreenState();
}

class _ThemscreenState extends State<Themscreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Danh Bạ'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                LengthLimitingTextInputFormatter(15),   // Giới hạn tối đa 15 ký tự
              ],
              decoration: InputDecoration(
                labelText: 'Số Điện Thoại',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(widget.contact != null){
                    _updateContact();
                  }else{
                    _addContact();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  elevation: 8,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Góc bo tròn của nút
                  ),
                ),
                child: Text(widget.contact == null ? 'Thêm' : 'Cập nhập',style: TextStyle(fontSize: 20,color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _addContact() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng nhập đủ thông tin',),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
      );
      return;
    }
    var data = {
      'name': name,
      'phone': phone,
    };
    var response = await http.post(Url.url_add, headers: {"Content-Type": "application/json"}, body: json.encode(data),);
    if (response.statusCode == 200) {
      final newContact = Contacts(null,name, phone);
      Navigator.pop(context, newContact);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm không thành công',),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
      );
    }
  }
  //Update lên csdl
  Future<void> _updateContact() async{
    final name = _nameController.text;
    final phone = _phoneController.text;
    Contacts newContact = Contacts(
        widget.contact?.id, // Sử dụng ID hiện tại nếu có
        _nameController.text,
        _phoneController.text);
    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng nhập đủ thông tin',),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
      );
      return;
    }
    var data = {
      'id': newContact.id,
      'name': name,
      'phone': phone,
    };
    var reponse = await http.post(Url.url_update,headers:{"Content-Type":"application/json"},body:json.encode(data));
    if (reponse.statusCode == 200) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyApp()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sửa thành công',),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sửa không thành công'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
