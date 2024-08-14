class Url{
  static String localhost = '192.168.137.145';
  static var Url_getdata = Uri.parse('http://$localhost/app_danhba/GetData.php');
  static var url_delete = Uri.parse('http://$localhost/app_danhba/Delete.php');
  static var url_add = Uri.parse('http://$localhost/app_danhba/Add.php');
  static var url_update = Uri.parse('http://$localhost/app_danhba/Update.php');
}