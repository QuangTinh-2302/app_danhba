import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_qly_danhba/model/contacts.dart';
import 'package:flutter/services.dart';
import 'package:app_qly_danhba/model_view/contactservice.dart';

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
        title: const Text('Danh Bạ'),
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
            const SizedBox(height: 25.0),
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
            const SizedBox(height: 40.0),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(widget.contact != null){
                    Contactservice(context).updateContact(widget.contact?.id as int,_nameController.text, _phoneController.text);
                  }else{
                    Contactservice(context).addContact(_nameController.text, _phoneController.text);
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
                child: Text(widget.contact == null ? 'Thêm' : 'Cập nhập',style: const TextStyle(fontSize: 20,color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
