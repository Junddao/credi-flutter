import 'dart:io';

import 'package:crediApp/global/models/file/file_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/service/api_service.dart';
import 'package:crediApp/global/enums/file_type.dart';

class FileControllerChangeNotifier extends ParentProvider {
  FileResponse? productImageResponse = FileResponse();
  Future<FileModel?> uploadImages(List<File> _images) async {
    try {
      setStateBusy();
      var api = ApiService();
      var response =
          await api.postMultiPart('/file/upload', _images, FileType.image);
      productImageResponse = FileResponse.fromMap(response);
      setStateIdle();
    } catch (error) {
      setStateError();
    }

    return productImageResponse!.data;
  }

  Future<FileModel?> uploadFiles(List<File> _files) async {
    try {
      setStateBusy();
      var api = ApiService();
      var response =
          await api.postMultiPart('/file/upload', _files, FileType.file);
      productImageResponse = FileResponse.fromMap(response);
      setStateIdle();
    } catch (error) {
      setStateError();
    }
    return productImageResponse!.data;
  }
}
