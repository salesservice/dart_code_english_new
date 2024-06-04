import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../functions/check_internet.dart';
import 'statusrequest.dart';

String _basicAuth = 'Basic ${base64Encode(utf8.encode('dddd:sdfsdfsdfdsf'))}';

Map<String, String> _myheaders = {
  // 'content-type': 'application/json',
  // 'accept': 'application/json',
  "authorization": _basicAuth
};

class Crud {
  Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
    // try {
    if (await sjekkInternett()) {
      var response = await http.post(Uri.parse(linkurl), body: data);
      //print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);
        //print(responsebody);
        return Right(responsebody);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, Map>> addRequestWithImageOne(
      url, data, File? image,
      [String? namerequest]) async {
    if (namerequest == null) {
      namerequest = "files";
    }

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(_myheaders);

    if (image != null) {
      var length = await image.length();
      var stream = http.ByteStream(image.openRead());
      stream.cast();
      var multipartFile = http.MultipartFile(namerequest, stream, length,
          filename: basename(image.path));
      request.files.add(multipartFile);
    }

    // add Data to request
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    // add Data to request
    // Send Request
    var myrequest = await request.send();
    // For get Response Body
    var response = await http.Response.fromStream(myrequest);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      Map responsebody = jsonDecode(response.body);
      return Right(responsebody);
    } else {
      return const Left(StatusRequest.serverfailure);
    }
  }

////////////////////////////////////////////////////////////////////////////////////
  ///
  Future<Either<StatusRequest, Map>> addRequestWithMultipleImages(
      String url, Map<String, String> data, List<File>? images,
      [String namerequest = "files"]) async {
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(_myheaders);

    for (int i = 0; i < images!.length; i++) {
      var image = images[i];
      var length = await image.length();
      var stream = http.ByteStream(image.openRead());
      stream.cast();
      var multipartFile = http.MultipartFile(
        '$namerequest[$i]',
        stream,
        length,
        filename: basename(image.path),
      );
      request.files.add(multipartFile);
    }

    // add Data to request
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    // Send Request
    var myrequest = await request.send();

    // For get Response Body
    var response = await http.Response.fromStream(myrequest);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      Map responsebody = jsonDecode(response.body);
      return Right(responsebody);
    } else {
      return const Left(StatusRequest.serverfailure);
    }
  }
}
