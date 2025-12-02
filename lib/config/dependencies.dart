import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  return [
    // Core providers - Dio com interceptor de autenticação
   Provider(create:  (_) => Dio()), 
  ];
}
