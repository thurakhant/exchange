import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

class TableCsv extends StatefulWidget {
  const TableCsv({Key? key}) : super(key: key);

  @override
  State<TableCsv> createState() => _TableCsvState();
}

class _TableCsvState extends State<TableCsv> {
  List<List<dynamic>> data = [];
  PlatformFile? select;
  String? filePath;

  Future selectCSV() async {
    final pickData = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (pickData == null) return;
    filePath = pickData.files.first.path;
    final input = File(filePath!).openRead();
    final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
    setState(() {
       data = fields;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV DATA'),
      ),
      body: Table(
        columnWidths: const {
          0: FixedColumnWidth(50),
          1: FixedColumnWidth(100),
          2: FixedColumnWidth(50),
          3: FixedColumnWidth(100),
        },
        border: TableBorder.all(),
        children: data.map((item) {
          return TableRow(
              children: item.map((row) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(row.toString()),
            );
          }).toList());
        }).toList(),
      ),
      floatingActionButton: IconButton(
          onPressed: ()=> selectCSV(),
          icon: const Icon(Icons.add)),
    );
  }


}
