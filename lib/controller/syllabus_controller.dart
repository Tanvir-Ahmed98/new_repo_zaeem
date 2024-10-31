import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../component/app_platforms.dart';
import '../component/custom_snackbar.dart';
import '../services/api_service.dart';
import '../services/local_database.dart';
import '../services/storage_service.dart';

class SyllabusController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final LocalDatabase _localDatabase = LocalDatabase();
  final OverlayPortalController studentSessionListTooltipController =
          OverlayPortalController(),
      studentClassListTooltipController = OverlayPortalController(),
      studentTermListTooltipController = OverlayPortalController();
  final studentSessionListLink = LayerLink(),
      studentClassListLink = LayerLink(),
      studentTermListLink = LayerLink();
  OverlayPortalController? activeController;
  late ScrollController studentSessionListScrollController = ScrollController(),
      studentClassListScrollController = ScrollController(),
      studentTermListScrollController = ScrollController();
  final TextEditingController studentSessionListController =
          TextEditingController(),
      studentClassListController = TextEditingController(),
      searchStudentSessionListController = TextEditingController(),
      searchStudentClassListController = TextEditingController(),
      studentTermListController = TextEditingController(),
      searchSyllabusListController = TextEditingController(),
      searchStudentTermListController = TextEditingController();

  RxList<Map<String, dynamic>> studentSessionList =
          <Map<String, dynamic>>[].obs,
      studentClassList = <Map<String, dynamic>>[].obs,
      studentTermList = <Map<String, dynamic>>[].obs,
      syllabusList = <Map<String, dynamic>>[].obs;
  RxBool studentSessionHasPage = true.obs,
      studentClassHasPage = true.obs,
      studentTermHasPage = true.obs,
      syllabusHasPage = true.obs,
      studentSessionListLoading = true.obs,
      studentClassListLoading = true.obs,
      studentTermListLoading = true.obs,
      syllabusLoading = false.obs,
      pdfDownLoading = false.obs,
      enableFilter = false.obs;
  RxInt studentSessionListPageOffset = 0.obs,
      studentClassListPageOffset = 0.obs,
      studentTermListPageOffset = 0.obs,
      syllabusListPageOffset = 0.obs,
      studentId = 0.obs;

  @override
  void onInit() {
    studentId.value = Get.arguments;
    getStudentSessionList();
    getStudentClassList();
    getStudentTermList();
    studentSessionListScrollController.addListener(() {
      if (studentSessionListScrollController.position.pixels ==
          studentSessionListScrollController.position.maxScrollExtent) {
        log("-----${studentSessionHasPage.value} ${studentSessionListPageOffset.value}");
        pagination(studentSessionHasPage.value, studentSessionHasPage.value,
            getStudentSessionList);
      }
    });
    studentClassListScrollController.addListener(() {
      if (studentClassListScrollController.position.pixels ==
          studentClassListScrollController.position.maxScrollExtent) {
        pagination(studentClassHasPage.value, studentClassHasPage.value,
            getStudentClassList);
      }
    });

    studentTermListScrollController.addListener(() {
      if (studentTermListScrollController.position.pixels ==
          studentTermListScrollController.position.maxScrollExtent) {
        pagination(studentTermHasPage.value, studentTermHasPage.value,
            getStudentTermList);
      }
    });

    studentSessionListController.addListener(
      () {
        if (studentSessionListController.text.isNotEmpty) {
          checkFilterButtonEnable();
        }
      },
    );
    studentClassListController.addListener(
      () {
        if (studentClassListController.text.isNotEmpty) {
          checkFilterButtonEnable();
        }
      },
    );
    studentTermListController.addListener(
      () {
        if (studentTermListController.text.isNotEmpty) {
          checkFilterButtonEnable();
        }
      },
    );
    super.onInit();
  }

  checkFilterButtonEnable() {
    enableFilter.value = studentSessionListController.text.isNotEmpty &&
        studentClassListController.text.isNotEmpty &&
        studentTermListController.text.isNotEmpty;
  }

  void pagination(hasPage, offset, Future<void> Function() update) {
    if (hasPage && offset != 0) {
      update();
    }
  }

  void setActiveController(OverlayPortalController controller) {
    if (activeController != null && activeController != controller) {
      activeController!.hide();
    }
    activeController = controller;
  }

  Future<void> getStudentSessionList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    //var pMainCompany = _storageService.read('mainCompany');

    try {
      var response = await _apiService.get(
          "/PT_PARENT_ATTND_TIME_SESSION_LIST?P_COM_ID=$pComId&offset=${studentSessionListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = studentSessionList.any(
              (enrollment) => enrollment['ar_ref_id'] == item['ar_ref_id']);
          if (!exists) {
            studentSessionList.add(item);
          }
        }

        studentSessionHasPage.value = response['hasMore'];

        if (studentSessionHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            studentSessionListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : studentSessionListPageOffset.value;
          }
        }
      }

      studentSessionListLoading.value = false;
    } catch (error) {
      studentSessionListLoading.value = false;
    }
  }

  Future<void> getStudentClassList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();

    try {
      var response = await _apiService.get(
          "/PT_PARENT_ATTND_TIME_CLASS_LIST?P_COM_ID=$pComId&offset=${studentClassListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = studentClassList.any((enrollment) =>
              enrollment['asc_class_id'] == item['asc_class_id']);
          if (!exists) {
            studentClassList.add(item);
          }
        }

        studentClassHasPage.value = response['hasMore'];

        if (studentClassHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            studentClassListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : studentClassListPageOffset.value;
          }
        }
      }

      studentClassListLoading.value = false;
    } catch (error) {
      studentClassListLoading.value = false;
    }
  }

  Future<void> getStudentTermList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();

    try {
      var response = await _apiService.get(
          "/PT_PARENT_SYLLABUS_TERM_LIST?P_COM_ID=$pComId&offset=${studentTermListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = studentTermList.any(
              (enrollment) => enrollment['ar_ref_id'] == item['ar_ref_id']);
          if (!exists) {
            studentTermList.add(item);
          }
        }

        studentTermHasPage.value = response['hasMore'];

        if (studentTermHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            studentTermListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : studentTermListPageOffset.value;
          }
        }
      }

      studentTermListLoading.value = false;
    } catch (error) {
      log("Error $error");
      studentTermListLoading.value = false;
    }
  }

  Future<void> getSyllabusList() async {
    syllabusLoading.value = true;
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var sessionId = studentSessionList.firstWhere((element) =>
        element['ar_desc_name'] ==
        studentSessionListController.text)['ar_ref_id'];
    var classId = studentClassList.firstWhere((element) =>
        element['asc_class_name'] ==
        studentClassListController.text)['asc_class_id'];
    var termId = studentTermList.firstWhere((element) =>
        element['ar_desc_name'] == studentTermListController.text)['ar_ref_id'];
    try {
      var response = await _apiService.get(
          "/PT_PARENT_SYALBUS_REPORT?P_COM_ID=$pComId&P_SESSION=$sessionId&P_CLASS=$classId&P_TERM=$termId&offset=${syllabusListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = syllabusList.any(
              (enrollment) => enrollment['asss_sy_id'] == item['asss_sy_id']);
          if (!exists) {
            syllabusList.add(item);
          }
        }

        syllabusHasPage.value = response['hasMore'];

        if (syllabusHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            syllabusListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : syllabusListPageOffset.value;
          }
        }
      }

      syllabusLoading.value = false;
    } catch (error) {
      log("Error $error");
      syllabusLoading.value = false;
    }
  }

  RxDouble downloadProgress = 0.0.obs;
  RxString filePathLocation = "".obs;

  Future<void> downloadAndSaveImageToGallery(
      String base64String, String customId) async {
    Map<String, dynamic> searchingQuery = {
      "dataTableName": "Syllabus",
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
              await getExternalStorageDirectory().then((value) async {
                if (value != null) {
                  folderPath = '${value.path}/parent_app_by_ats/photos';
                  var hiveFolder = Directory("${value.path}$folderPath");
                  if (!await hiveFolder.exists()) {
                    await Directory(folderPath!).create(recursive: true);
                  }
                  String filePath =
                      '$folderPath/Syllabus${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId.jpg';
                  File file = File(filePath);
                  await file.writeAsBytes(imageBytes);
                  final result = await ImageGallerySaverPlus.saveImage(
                      imageBytes,
                      quality: 80,
                      name:
                          "Syllabus${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId");
                  if (result['isSuccess']) {
                    Map<String, dynamic> savingData = {
                      "dataTableName": "Syllabus",
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
              await getExternalStorageDirectory().then((value) async {
                if (value != null) {
                  folderPath = '${value.path}/parent_app_by_ats/photos';
                  var hiveFolder = Directory("${value.path}$folderPath");
                  if (!await hiveFolder.exists()) {
                    await Directory(folderPath!).create(recursive: true);
                  }
                  String filePath =
                      '$folderPath/Syllabus${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId.jpg';
                  File file = File(filePath);
                  await file.writeAsBytes(imageBytes);
                  final result = await ImageGallerySaverPlus.saveImage(
                      imageBytes,
                      quality: 80,
                      name:
                          "Syllabus${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId");
                  if (result['isSuccess']) {
                    Map<String, dynamic> savingData = {
                      "dataTableName": "Syllabus",
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
                  '$folderPath/Syllabus${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId.jpg';
              File file = File(filePath);
              await file.writeAsBytes(imageBytes);
              final result = await ImageGallerySaverPlus.saveImage(imageBytes,
                  quality: 80,
                  name:
                      "OnlineDairyReport${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}$customId");
              if (result['isSuccess']) {
                Map<String, dynamic> savingData = {
                  "dataTableName": "Syllabus",
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
          } else if (await Permission.storage.isPermanentlyDenied) {
            await openAppSettings();
          } else if (await Permission.storage.isDenied) {
            await openAppSettings();
          }
        });
      }
    }
  }
}
