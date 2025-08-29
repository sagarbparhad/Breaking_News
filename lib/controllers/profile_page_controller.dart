import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import '../models/state_city_model.dart';

class ProfilePageController extends GetxController {
  var csvDataList = <CsvData>[].obs;
  var isLoading = false.obs;
  var states = <String>[].obs;
  var cities = <String>[].obs;
  var pincodes = <int>[].obs;
  var selectedState = ''.obs;
  var selectedCity = ''.obs;
  var selectedPincode = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadCsvData();
  }

  Future<void> loadCsvData() async {
    isLoading(true);
    try {
      print("Reading file...");

      final csvString = await rootBundle.loadString('assets/CityMaster.csv');

      final cleanCsvString = removeBom(csvString);

      print("CSV content: ${cleanCsvString.substring(0, 100)}");

      final csvList = CsvToListConverter().convert(cleanCsvString, eol: "\n");
      print("File read successfully!");

      csvDataList.clear();
      for (var row in csvList) {
        print("Processing row: $row");
        if (row.length >= 3) {
          try {
            csvDataList.add(CsvData.fromCsv(row));
          } catch (e) {
            print("Error parsing row: $row, error: $e");
          }
        } else {
          print("Skipping invalid row: $row");
        }
      }
      states.value = csvDataList.map((e) => e.stateName).toSet().toList();
      states.sort();


    } catch (e) {
      print("Error reading file: $e");
    } finally {
      isLoading(false);
    }
  }

  String removeBom(String content) {
    if (content.startsWith("\uFEFF")) {
      return content.substring(1);
    }
    return content;
  }
  void updateCities(String state) {
    selectedState(state);
    print(selectedState);
    cities.value = csvDataList
        .where((e) => e.stateName == state)
        .map((e) => e.city)
        .toSet()
        .toList();
    cities.sort();
    selectedCity('');
    pincodes.clear();
    selectedPincode(0);
  }

  void updatePincodes(String city) {
    print(selectedState);
    print(city);
    selectedCity(city);
    pincodes.value = csvDataList
        .where((e) => e.stateName == selectedState.value && e.city == city)
        .map((e) => e.pincode).toSet()
        .toList();
    pincodes.sort();
    selectedPincode(0);
  }
}
