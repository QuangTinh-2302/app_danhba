import 'package:flutter/material.dart';
import 'package:app_qly_danhba/model/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_qly_danhba/ui/home.dart';
import 'package:url_launcher/url_launcher.dart';
class Contactservice with ChangeNotifier {
  final BuildContext context;
  Contactservice(this.context);
  Future<void> Delete(int id, String name, String phone) async{
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
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
      );
    }
  }
  Future<void> addContact(String name,String phone) async {
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
    var response = await http.post(Url.url_add, headers: {"Content-Type": "application/json",}, body: json.encode(data),);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => MyApp()));
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
  Future<void> updateContact(int id, String name, String phone) async{
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
      'id': id,
      'name': name,
      'phone': phone,
    };
    var reponse = await http.post(Url.url_update,headers:{"Content-Type":"application/json"},body:json.encode(data));
    if (reponse.statusCode == 200) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const MyApp()));
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
  Future<void> launchSMS(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Hiển thị thông báo lỗi nếu không thể mở ứng dụng nhắn tin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể gửi tin nhắn đến $phoneNumber'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  Future<void> launchPhone(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Hiển thị thông báo lỗi nếu không thể mở ứng dụng gọi điện thoại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể gửi tin nhắn đến $phoneNumber'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  Future<void> BlockContact(int id, bool status) async{
    var data = {
      'id' : id,
      'status' : status
    };
    var reponse = await http.post(Url.url_block,headers: {"Content-Type":"application/json"},body: json.encode(data));
    if (reponse.statusCode == 200) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const MyApp()));
      ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(status ? 'Đã bỏ chặn thành công' : 'Đã chặn thành công',),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chặn không thành công'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}