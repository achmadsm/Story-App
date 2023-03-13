import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:submission/data/db/auth_repository.dart';
import 'package:submission/data/model/login_response.dart';

import '../model/register_response.dart';
import '../model/stories_response.dart';
import '../model/story_response.dart';
import '../model/upload_response.dart';

class ApiService {
  final String url = 'https://story-api.dicoding.dev/v1/';
  late AuthRepository authRepository;

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${url}register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      debugPrint(response.body);
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Email is already taken');
    }
  }

  Future<LoginResponse> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${url}login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      debugPrint(response.body);
      throw Exception('Invalid Email or Password');
    }
  }

  Future<StoriesResponse> listStory(String token) async {
    final response = await http.get(
      Uri.parse('${url}stories'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return StoriesResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<StoryResponse> detailStory(String token, String id) async {
    final response = await http.get(
      Uri.parse('${url}stories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return StoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<UploadResponse> uploadImage(
    List<int> bytes,
    String fileName,
    String description,
    String token,
  ) async {
    final uri = Uri.parse('${url}stories');
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      'photo',
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      'description': description,
    };
    final Map<String, String> headers = {
      'Content-type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final UploadResponse uploadResponse = UploadResponse.fromJson(
        responseData,
      );
      return uploadResponse;
    } else {
      throw Exception('Upload file error');
    }
  }
}
