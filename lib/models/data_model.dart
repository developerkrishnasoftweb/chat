import 'dart:io';

import 'package:http/http.dart';

/// Global class to store data
/// and paginated products fetched from RestApi
/// and the type of data will be the parameter type of class
///

class Data<T> {
  final int statusCode;
  final String message;
  final T? data;
  final PaginationModel? pagination;

  const Data({
    required this.message,
    this.data,
    required this.statusCode,
    this.pagination,
  });

  /// Data model from Response
  factory Data.fromResponse(Response response) {
    return Data(
      statusCode: response.statusCode,
      message: response.reasonPhrase ?? 'Data retrieved',
    );
  }

  /// Data model handles the exceptions
  factory Data.fromException(Object exception) {
    if (exception is SocketException) {
      return Data(
        statusCode: exception.osError!.errorCode,
        message: exception.osError!.message,
      );
    }
    return Data(
      statusCode: 500,
      message: exception.toString(),
    );
  }

  factory Data.error({String message = ''}) {
    return Data(message: message, statusCode: 500);
  }

  Map<String, dynamic> toJson() {
    return {
      'status': statusCode,
      'message': message,
      'data': data,
    };
  }

  // Copy with existing data
  Data<T> copyWith<T>({
    int? statusCode,
    String? message,
    T? data,
    PaginationModel? pagination,
  }) =>
      Data<T>(
        data: data ?? (this.data as T),
        message: message ?? this.message,
        pagination: pagination ?? this.pagination,
        statusCode: statusCode ?? this.statusCode,
      );
}

class PaginationModel {
  const PaginationModel();

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      const PaginationModel();
}
