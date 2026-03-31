// import 'dart:convert';

// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
// import 'package:massaclinic/core/class/statusrequest.dart';
// import 'package:transport_project/core/class/statusrequest.dart';

// class Crud {
//   Future<Either<StatusRequest, Map>> postData(String linkUrl, Map data) async {
//     try {
    
//         var response = await http.post(Uri.parse(linkUrl), body: data);
//         if (response.statusCode == 200 || response.statusCode == 201) {
//           Map responsebody = jsonDecode(response.body);
//           return Right(responsebody);
//         } else {
//           return Left(StatusRequest.serverfailure);
//         }
      
//     } catch (_) {
//       return Left(StatusRequest.exceptionfailure);
//     }
//   }
// }
