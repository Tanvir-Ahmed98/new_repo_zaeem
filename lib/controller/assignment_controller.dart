import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:parent_app_by_ats/component/app_platforms.dart';
import 'package:parent_app_by_ats/component/custom_snackbar.dart';
import 'package:parent_app_by_ats/services/local_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AssignmentController extends GetxController {
  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();
  final LocalDatabase _localDatabase = LocalDatabase();
  String? pComId, pUsername, pStudentId;
  RxList assignmentList = [].obs;
  RxBool assignmentLoading = true.obs;
  @override
  void onInit() {
    pStudentId = Get.arguments;

    getAssignmentList();
    super.onInit();
  }

  Future<void> getAssignmentList() async {
    await _storageService.init();
    pComId = _storageService.read('comId').toString();

    try {
      var response = await _apiService.get(
          "/PT_CHILD_DIARY_ASSIGNMENT_REPORT?P_COM_ID=$pComId&P_STD_ID=$pStudentId");
      assignmentList.value = response['items'];
      assignmentLoading.value = false;
    } catch (error) {
      assignmentLoading.value = false;
      log("Error: $error");
    }
  }

  // Download and save image to gallery with a custom ID

  Future<void> downloadAndSaveImageToGallery(
      String base64String, String customId) async {
    Map<String, dynamic> searchingQuery = {
      "dataTableName": "AssignmentReport",
      'id': customId
    };
    // Check if the image is already saved locally in Hive using the custom ID
    dynamic savedImageData = await _localDatabase.getImage(searchingQuery);

    if (savedImageData != null) {
      CustomeSnackbar.showSnackbar(
          title: "Image Already Saved",
          message: "This image has already been saved to your gallery.",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          duration: const Duration(seconds: 2),
          position: SnackPosition.BOTTOM);
      return; // Exit if already saved
    } else {
      if (getPlatform() == AppPlatform.android) {
        DeviceInfoPlugin plugin = DeviceInfoPlugin();

        AndroidDeviceInfo android = await plugin.androidInfo;

        if (android.version.sdkInt < 33) {
          await Permission.storage.request().then((value) async {
            if (value.isGranted) {
              Uint8List imageBytes = base64Decode(base64String.split(',').last);

              String? folderPath;
              //save image to parent_app_by_ats folder
              await getExternalStorageDirectory().then((value) async {
                if (value != null) {
                  folderPath = '${value.path}/parent_app_by_ats/photos';
                  var hiveFolder = Directory("${value.path}$folderPath");
                  if (!await hiveFolder.exists()) {
                    await Directory(folderPath!).create(recursive: true);
                  }
                  String filePath =
                      '$folderPath/AssignmentReport${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId.jpg';
                  File file = File(filePath);
                  await file.writeAsBytes(imageBytes);
                  final result = await ImageGallerySaverPlus.saveImage(
                      imageBytes,
                      quality: 80,
                      name:
                          "AssignmentReport${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId");
                  if (result['isSuccess']) {
                    Map<String, dynamic> savingData = {
                      "dataTableName": "AssignmentReport",
                      "id": customId,
                    };
                    await _localDatabase.saveImage(savingData).whenComplete(
                      () {
                        CustomeSnackbar.showSnackbar(
                            title: "Image Saved",
                            message: "This image is saved to your gallery.",
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            duration: const Duration(seconds: 2),
                            position: SnackPosition.BOTTOM);
                      },
                    );
                  } else {
                    CustomeSnackbar.showSnackbar(
                        title: "Image Saving Failed",
                        message:
                            "There was an issue saving the image to the gallery.",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        duration: const Duration(seconds: 2),
                        position: SnackPosition.BOTTOM);
                  }
                } else {
                  CustomeSnackbar.showSnackbar(
                      title: "Failed",
                      message: "Failed to get external storage directory",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      duration: const Duration(seconds: 2),
                      position: SnackPosition.BOTTOM);
                }
              });
            } else if (await Permission.storage.isPermanentlyDenied) {
              await openAppSettings();
            } else if (await Permission.storage.isDenied) {
              await openAppSettings();
            }
          });
        } else {
          await Permission.manageExternalStorage.request().then((value) async {
            if (value.isGranted) {
              Uint8List imageBytes = base64Decode(base64String.split(',').last);

              String? folderPath;
              //save image to parent_app_by_ats folder
              await getExternalStorageDirectory().then((value) async {
                if (value != null) {
                  folderPath = '${value.path}/parent_app_by_ats/photos';
                  var hiveFolder = Directory("${value.path}$folderPath");
                  if (!await hiveFolder.exists()) {
                    await Directory(folderPath!).create(recursive: true);
                  }
                  String filePath =
                      '$folderPath/AssignmentReport${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId.jpg';
                  File file = File(filePath);
                  await file.writeAsBytes(imageBytes);
                  final result = await ImageGallerySaverPlus.saveImage(
                      imageBytes,
                      quality: 80,
                      name:
                          "AssignmentReport${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId");
                  if (result['isSuccess']) {
                    Map<String, dynamic> savingData = {
                      "dataTableName": "AssignmentReport",
                      "id": customId,
                    };
                    await _localDatabase.saveImage(savingData).whenComplete(
                      () {
                        CustomeSnackbar.showSnackbar(
                            title: "Image Saved",
                            message: "This image is saved to your gallery.",
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            duration: const Duration(seconds: 2),
                            position: SnackPosition.BOTTOM);
                      },
                    );
                  } else {
                    CustomeSnackbar.showSnackbar(
                        title: "Image Saving Failed",
                        message:
                            "There was an issue saving the image to the gallery.",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        duration: const Duration(seconds: 2),
                        position: SnackPosition.BOTTOM);
                  }
                } else {
                  CustomeSnackbar.showSnackbar(
                      title: "Failed",
                      message: "Failed to get external storage directory",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      duration: const Duration(seconds: 2),
                      position: SnackPosition.BOTTOM);
                }
              });
            } else if (await Permission.storage.isPermanentlyDenied) {
              await openAppSettings();
            } else if (await Permission.storage.isDenied) {
              await openAppSettings();
            }
          });
        }
      } else if (getPlatform() == AppPlatform.ios) {
        await Permission.photosAddOnly.request().then((value) async {
          if (value.isGranted) {
            Uint8List imageBytes = base64Decode(base64String.split(',').last);

            String? folderPath;
            //save image to parent_app_by_ats folder
            await getApplicationDocumentsDirectory().then((value) async {
              folderPath = '${value.path}/photos';
              var hiveFolder = Directory("${value.path}$folderPath");
              if (!await hiveFolder.exists()) {
                await Directory(folderPath!).create(recursive: true);
              }
              String filePath =
                  '$folderPath/AssignmentReport${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId.jpg';
              File file = File(filePath);
              await file.writeAsBytes(imageBytes);
              final result = await ImageGallerySaverPlus.saveImage(imageBytes,
                  quality: 80,
                  name:
                      "AssignmentReport${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId");
              if (result['isSuccess']) {
                Map<String, dynamic> savingData = {
                  "dataTableName": "AssignmentReport",
                  "id": customId,
                };
                await _localDatabase.saveImage(savingData).whenComplete(
                  () {
                    CustomeSnackbar.showSnackbar(
                        title: "Image Saved",
                        message: "This image is saved to your gallery.",
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        duration: const Duration(seconds: 2),
                        position: SnackPosition.BOTTOM);
                  },
                );
              } else {
                CustomeSnackbar.showSnackbar(
                    title: "Image Saving Failed",
                    message:
                        "There was an issue saving the image to the gallery.",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    duration: const Duration(seconds: 2),
                    position: SnackPosition.BOTTOM);
              }
            });
          } else if (await Permission.photosAddOnly.isPermanentlyDenied) {
            await openAppSettings();
          } else if (await Permission.photosAddOnly.isDenied) {
            await openAppSettings();
          }
        });
      }
    }
  }
}
