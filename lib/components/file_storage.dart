import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// To save the file in the device
class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> saveDownloadedFile(Uint8List bytes,String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension

    //check if file name already exist then make it as copy (1) file
    final fileName= await getUniqueFileName(name, path);

    // File filetest= File('$path/$name');
    File file= File('$path/$fileName');

    // Write the data in the file you have created
    return file.writeAsBytes(bytes);
  }
}


Future<String> getUniqueFileName(String fileName, String folderPath) async {
  int count = 0;
  String uniqueFileName = fileName;
  final Directory directory = Directory(folderPath);
  final List<FileSystemEntity> files = directory.listSync();

  while (files.any((file) => file is File && file.path.endsWith(uniqueFileName))) {
    count++;
    uniqueFileName = '${fileName.replaceAll('.pdf', '')} ($count).pdf';
  }
  return uniqueFileName;
}

