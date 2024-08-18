import 'package:app_qly_danhba/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:app_qly_danhba/model/contacts.dart';
import 'package:app_qly_danhba/ui/themscreen.dart';
import 'package:app_qly_danhba/model_view/contactservice.dart';
class ContactDetail extends StatefulWidget {
  final Contacts? ct;
  ContactDetail({super.key,this.ct});
  @override
  State<ContactDetail> createState() => _ContactDetailState();
}
class _ContactDetailState extends State<ContactDetail> {
  @override
  Widget build(BuildContext context) {
    final int id = widget.ct!.id as int;
    final String phone = widget.ct!.phone;
    final String name = widget.ct!.name;
    final bool status = widget.ct!.status;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar:
            AppBar(
              title: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Quay lại màn hình trước đó
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.arrow_back,),
                    SizedBox(width: 4,),
                    Flexible(
                      child: Text('Back',
                        style: TextStyle(fontSize: 20,decoration: TextDecoration.underline),
                        overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
              ),
            ),
          body: Padding(
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
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    phone,
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone,size: 35,),
                      onPressed: () => Contactservice(context).launchPhone(phone),
                    ),
                    IconButton(
                      icon: const Icon(Icons.message,size: 35),
                      onPressed: () => Contactservice(context).launchPhone(phone),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,size: 35),
                      onPressed: () {
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
                                onPressed: () {
                                 Contactservice(context).Delete(widget.ct!.id as int, widget.ct!.name, widget.ct!.phone);
                                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>MyApp()));// Gọi API để xóa contact từ server nếu cần
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
                const SizedBox(height: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Themscreen()));
                        },
                        child: Text('Thêm liên hệ mới',style: TextStyle(fontSize: 20),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Themscreen(contact: widget.ct)));
                        },
                        child: Text('Sửa liên hệ',style: TextStyle(fontSize: 20),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: (){
                          if(status == true){
                            showDialog(
                                context: context,
                                builder:(BuildContext) => AlertDialog(
                                  title: const Text('Chặn liên hệ'),
                                  content: const Text('Bạn có chắc muốn chặn liên hệ này không?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        Contactservice(context).BlockContact(widget.ct!.id as int,false);
                                        Navigator.pushReplacement(
                                            context, MaterialPageRoute(builder: (context)=> MyApp())
                                        );
                                      },
                                      child: const Text('Chặn', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                )
                            );
                          }else{
                            Contactservice(context).BlockContact(id, true);
                          }
                        },
                        child: Text(status == true? 'Chặn' : 'Bỏ Chặn',style: TextStyle(fontSize: 20,color: Colors.red),),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ),
      ),
          debugShowCheckedModeBanner: false,
    );
  }
}