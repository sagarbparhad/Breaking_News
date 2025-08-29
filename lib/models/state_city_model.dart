class CsvData {
  final String city;
  final int pincode;
  final String stateName;

  CsvData({required this.city, required this.pincode, required this.stateName});

  factory CsvData.fromCsv(List<dynamic> row) {
    int parsePincode(String? input) {
      if (input == null || input.isEmpty) {
        return 0;
      }
      return int.tryParse(input) ?? 0;
    }

    return CsvData(
      city: row[0].toString(),
      pincode: parsePincode(row[1].toString()),
      stateName: row[2].toString(),
    );
  }
}
