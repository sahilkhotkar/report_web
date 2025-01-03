import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ExcelService {
  Future<void> jsonToCsvAndSaveAndOpen(String jsonString,
      {Function? open}) async {
    try {
      List<Map<String, dynamic>> jsonList =
          jsonDecode(jsonString).cast<Map<String, dynamic>>();

      List<String> headers = jsonList[0].keys.toList();
      String csvData = headers.join(",") + "\n";
      
      for (Map<String, dynamic> json in jsonList) {
        List<String> values = [];
        for (String header in headers) {
          var value = json[header].toString();

          if (value.contains(',')) {
            value = '"$value"';
          }

          values.add(value);
        }
        csvData += values.join(",") + "\n";
      }

      final formattedDateTime =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'custom_name_$formattedDateTime.csv';

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(Uint8List.fromList(csvData.codeUnits),
          flush: true);

      print("File saved successfully at $filePath");

      try {
        final result = await OpenFile.open(filePath);
        Fluttertoast.showToast(msg: result.message.toString());
        print("File opened with result: ${result.message}");
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
