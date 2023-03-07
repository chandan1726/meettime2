import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meettime/getx.dart';
import 'package:http_parser/http_parser.dart';
import "package:async/async.dart";
import 'package:path/path.dart';

class HTTP {
  String apiUrl = "https://meet.coolma.in/api/";
  String imgUrl = "https://meet.coolma.in/images/";
  final DataController gf = Get.put(DataController());

  var client = http.Client();

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Headers': 'Content-Type',
    // 'token': '',
    // 'userid': '',
  };

  Future<Map> simpleGet(url) async {
    var response = await client.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map;
    } else {
      Future.error("error");
    }
  }

  Future<Map> getData(url) async {
    // headers['token'] = (gf.userDetail != null)
    //     ? gf.userDetail['token']
    //     : '12345678901234567890';
    // headers['userid'] = (gf.userDetail != null) ? gf.userDetail['u_id'] : '0';
    print(apiUrl + url);
    print(headers);
    var response = await client.get(Uri.parse(apiUrl + url), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map;
    } else {
      Future.error("error");
    }
  }

  Future<dynamic> postData(url, data) async {
    // headers['token'] = (gf.userDetail != null)
    //     ? gf.userDetail['token']
    //     : '12345678901234567890';
    // headers['userid'] =(gf.userDetail != null) ? gf.userDetail['user_id'] : '0';
    print(apiUrl + url);
    print(headers);
    print(data);
    var response = await client.post(
      Uri.parse(apiUrl + url),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map;
    } else {
      Future.error(false);
    }
  }

  Future<dynamic> uploadFile(url, data,fileByte) async {
    var uri = Uri.https('example.com', 'create');
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl + url));
      // ..fields['user'] = 'nweiz@google.com'
      // ..files.add(await http.MultipartFile.fromPath(
      //     'package', 'build/package.tar.gz',
      //     contentType: MediaType('application', 'x-tar')));
    request.files.add(http.MultipartFile.fromBytes(
        'file', fileByte,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
    return response;
  }

  uploadImage(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(apiUrl+"manage_data.php?uploadImage");
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile("image", stream, length,filename: basename(imageFile.path));
    request.files.add(multipartFile);

    request.fields['productname'] = "Chandan tiwari products";
    // request.fields['productprice'] = controllerPrice.text;
    // request.fields['producttype'] = controllerType.text;
    // request.fields['product_owner'] = globals.restaurantId;

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
  }
}
