import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'db_helper.dart';
import 'employee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Employee> employees = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initDbAndInsertDummyData();
  }

  Future<void> _initDbAndInsertDummyData() async {
    setState(() {
      isLoading = true;
    });
    final dbHelper = DatabaseHelper();
    List employeesData = [
      ['Ram', '2000-10-10', true],
      ['Raj', '2020-09-12', true],
      ['John', '2015-05-15', true],
      ['Jane', '2018-03-20', false],
      ['Alice', '2010-07-07', true],
      ['Bob', '2012-11-30', false],
      ['Charlie', '2016-04-25', true],
      ['David', '2023-01-01', true],
      ['Eve', '2011-08-08', false],
      ['Frank', '2019-12-12', true],
      ['Grace', '2017-06-06', false],
      ['Heidi', '2021-02-02', true],
      ['Ivan', '2009-09-09', true],
      ['Judy', '2013-10-10', false],
      ['Mallory', '2018-05-05', true],
      ['Niaj', '2020-12-12', false],
      ['Oscar', '2017-07-07', true],
      ['Pat', '2016-06-06', true],
      ['Quentin', '2015-05-05', false],
      ['Rupert', '2014-04-04', true],
    ];
    for (int i = 0; i < employeesData.length; i++) {
      final employee = Employee(
        id: i,
        name: employeesData[i][0],
        joinDate: DateTime.parse(employeesData[i][1]),
        isActive: employeesData[i][2],
      );
      await dbHelper.insertEmployee(employee);
    }
    employees = await dbHelper.employees();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employees"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                bool flag = _shouldHighlight(employees[index]);
                return ListTile(
                  title: Text(
                    employees[index].name,
                    style: TextStyle(color: flag ? Colors.white : Colors.black),
                  ),
                  subtitle: Text(
                      "Join date : ${_formatDate(employees[index].joinDate)}",
                      style:
                          TextStyle(color: flag ? Colors.white : Colors.black)),
                  tileColor: flag ? Colors.green : null,
                );
              },
            ),
    );
  }

  bool _shouldHighlight(Employee employee) {
    if (!employee.isActive) return false;
    final yearsInCompany =
        DateTime.now().difference(employee.joinDate).inDays / 365;
    return yearsInCompany > 5;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
