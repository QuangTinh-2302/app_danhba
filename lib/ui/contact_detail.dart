import 'package:flutter/material.dart';
import 'package:app_qly_danhba/model/contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_qly_danhba/ui/themscreen.dart';
class ContactDetail extends StatefulWidget {
  final Contacts? ct;
  ContactDetail({super.key,this.ct});
  @override
  State<ContactDetail> createState() => _ContactDetailState();
}
class _ContactDetailState extends State<ContactDetail> {
  @override
  Widget build(BuildContext context) {
    final String phone = widget.ct!.phone;
    final String name = widget.ct!.name;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar:
            AppBar(
              title: Text('Chi tiết liên hệ',style: TextStyle(fontSize: 30),),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // Quay lại màn hình trước đó
                },
              ),
            ),
          body:
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child:
                  CircleAvatar(
                    radius: 90,
                    child: Text(name[0],style: TextStyle(fontSize: 60),),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 13),
                // Số điện thoại
                Center(
                  child: Text(
                    phone,
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                ),
                SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone,size: 35,),
                      onPressed: () => _launchPhone(phone),
                    ),
                    IconButton(
                      icon: const Icon(Icons.message,size: 35),
                      onPressed: () => _launchSMS(phone),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit,size: 35),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Themscreen(contact: widget.ct!),
                          ),
                        );
                      },
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.delete),
                    //   onPressed: () {
                    //     // Xóa liên hệ
                    //     // Cần thêm logic để xóa liên hệ
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
          )
        ),
      ),
          debugShowCheckedModeBanner: false,
    );
  }
  Future<void> _launchSMS(String phoneNumber) async {
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
  Future<void> _launchPhone(String phoneNumber) async {
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
}

