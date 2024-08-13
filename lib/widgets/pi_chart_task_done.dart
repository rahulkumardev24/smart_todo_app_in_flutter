import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../data/local/data_base_helper.dart';

class PiChartTaskDone extends StatefulWidget {
  const PiChartTaskDone({Key? key, this.refreshChart}) : super(key: key);

  final Function()? refreshChart;

  @override
  State<PiChartTaskDone> createState() => _PiChartTaskDoneState();
}

class _PiChartTaskDoneState extends State<PiChartTaskDone> {
  late final DataBaseHelper mainDB;
  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    mainDB = DataBaseHelper.instance;
    _fetchData();
  }

  Future<void> _fetchData() async {
    final todos = await mainDB.getAllTodos();
    int completed = todos.where((todo) => todo[DataBaseHelper.columnTodoIsDone] == 1).length;
    int uncompleted = todos.length - completed;

    setState(() {
      dataMap = {
        "Completed": completed.toDouble(),
        "Uncompleted": uncompleted.toDouble(),
      };
    });
  }

  void refreshChart() {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: dataMap.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 100,
        chartRadius: MediaQuery.of(context).size.width / 5,
        initialAngleInDegree: 30,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        centerText: "Tasks",
        centerTextStyle: const TextStyle(
          fontFamily: "myFont",
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "myFont",
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValues: true,
          showChartValuesInPercentage: true, // Show values in percentage
          showChartValuesOutside: true,
        ),
      ),
    );
  }
}
