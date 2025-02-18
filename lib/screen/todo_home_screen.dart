import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
// Import DateFormat for date formatting
import 'package:smart_todo/data/local/data_base_helper.dart';
import 'package:smart_todo/utils/custom_text_style.dart';
import 'package:smart_todo/widgets/my_text_field.dart';
import 'package:smart_todo/widgets/pi_chart_task_done.dart';

// Assuming Search widget is defined in search_bar.dart
import '../widgets/search_bar.dart';

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({Key? key}) : super(key: key);

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();
  late final DataBaseHelper mainDB;
  List<Map<String, dynamic>> allTodo = [];
  @override
  void initState() {
    super.initState();
    mainDB = DataBaseHelper.instance;
    getAllTodo();
  }

  Future<void> getAllTodo() async {
    final todo = await mainDB.getAllTodos();
    setState(() {
      allTodo = todo;
    });
  }

  void refreshChart() async {
    await getAllTodo();
    setState(() {});
  }

  ///--------------------- Search ----------------------------------///
  void _searchTask(String keyword) async {
    if (keyword.isEmpty) {
      getAllTodo();
    } else {
      List<Map<String, dynamic>> results = await mainDB.searchTodos(keyword);
      setState(() {
        allTodo = results;
      });
    }
  }

  /// ----------------- update bottom sheet --------------------///
  void _showEditBottomSheet(Map<String, dynamic> todo) {
    title.text = todo[DataBaseHelper.columnTodoTitle].toString();
    message.text = todo[DataBaseHelper.columnTodoMessage].toString();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Update Todo",
                    style: myTextStyle24(fontWeight: FontWeight.bold),
                  ),
                  Divider(),

                  ///---------- Title------------///
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: myTextStyle18(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      MyTextField(
                        textEditingController: title,
                        hintText: "Enter title here",
                        hintColor: Colors.black45,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  ///---------- Message ------------///
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Message",
                        style: myTextStyle18(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      MyTextField(
                        textEditingController: message,
                        hintText: "Enter message here",
                        hintColor: Colors.black45,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(width: 1, color: Colors.red),
                        ),
                        child: Text(
                          "Cancel",
                          style: myTextStyle24(
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String todoDate =
                              todo[DataBaseHelper.columnTodoDate].toString();
                          DateTime parsedDate = DateTime.parse(todoDate);
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(parsedDate);
                          mainDB.updateTodo(
                            id: todo[DataBaseHelper.columnTodoSno],
                            title: title.text,
                            message: message.text,
                            date: formattedDate,
                          );

                          getAllTodo();
                          title.clear();
                          message.clear();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.green,
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          "Update",
                          style: myTextStyle24(
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///---------------------------APPBAR--------------------------------///
      appBar: AppBar(
        title: Text(
          "TODO",
          style: TextStyle(
              fontSize: 25, fontFamily: "myFont", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/image/notes.png"),
          )
        ],
      ),

      /// ---------------- Floating Action button --------------------------///
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.orangeAccent.shade200,
            elevation: 0,
            context: context,
            builder: (context) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Add Todo",
                          style: myTextStyle24(fontColor: Colors.white)),
                    ),
                    Divider(),

                    /// title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title",
                            style: myTextStyle18(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 11,
                          ),
                          MyTextField(
                            textEditingController: title,
                            hintText: "Enter title here",
                            hintColor: Colors.black45,
                            borderColor: Colors.white,
                          )
                        ],
                      ),
                    ),

                    /// message
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Message",
                            style: myTextStyle18(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 11,
                          ),
                          MyTextField(
                            textEditingController: message,
                            hintText: "Enter message here",
                            hintColor: Colors.black45,
                            borderColor: Colors.white,
                            maxLine: 3,
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// cancel button
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                              width: 1,
                              color: Colors.red,
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: myTextStyle24(fontColor: Colors.red),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            mainDB.addTodo(
                              title: title.text.toString(),
                              message: message.text.toString(),
                            );
                            getAllTodo();
                            title.clear();
                            message.clear();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            "Add",
                            style: myTextStyle24(
                                fontColor: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.orangeAccent.shade200,
        foregroundColor: Colors.white,
        label: Row(
          children: [
            Icon(
              Icons.add,
              size: 30,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "TODO",
              style: myTextStyle24(fontColor: Colors.white),
            ),
          ],
        ),
      ),

      /// ................................... BODY PART ...................//
      body: Column(
        children: [
          ///--------------------- search box -----------------------///
          Search(onSearchChanged: _searchTask),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(child: PiChartTaskDone(refreshChart: refreshChart)),
          ),

          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: allTodo.isNotEmpty
                ? ListView.builder(
                    itemCount: allTodo.length,
                    itemBuilder: (context, index) {
                      String todoTitle =
                          allTodo[index][DataBaseHelper.columnTodoTitle];
                      String todoMessage =
                          allTodo[index][DataBaseHelper.columnTodoMessage];
                      String todoDate =
                          allTodo[index][DataBaseHelper.columnTodoDate];
                      DateTime parsedDate = DateTime.parse(todoDate);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12),
                        child: Card(
                          color: const Color(0xfbffe5ad),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: allTodo[index]
                                            [DataBaseHelper.columnTodoIsDone] ==
                                        1,
                                    onChanged: (bool? value) async {
                                      await mainDB.updateTodoStatus(
                                        id: allTodo[index]
                                            [DataBaseHelper.columnTodoSno],
                                        isDone: value!,
                                      );

                                      setState(() {
                                        getAllTodo();
                                      });

                                      refreshChart();
                                    },
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          todoTitle,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "myFont",
                                          ),
                                        ),
                                        Text(
                                          todoMessage,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: "myFont",
                                          ),
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///  Edit & Delete Buttons
                                  Column(
                                    children: [
                                      /// ----------------- Delete Button --------------------///
                                      IconButton(
                                        onPressed: () async {
                                          bool confirmDelete = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                "Confirm Delete",
                                                style: myTextStyle24(),
                                              ),
                                              content: Text(
                                                "Are you sure you want to delete this task?",
                                                style: myTextStyle12(),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context,
                                                        false); // Cancel delete
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: myTextStyle18(
                                                        fontColor:
                                                            Colors.black45),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context,
                                                        true); // Confirm delete
                                                  },
                                                  child: Text(
                                                    "Delete",
                                                    style: myTextStyle18(
                                                        fontColor: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirmDelete == true) {
                                            await mainDB.deleteTodo(
                                              id: allTodo[index][
                                                  DataBaseHelper.columnTodoSno],
                                            );

                                            setState(() {
                                              getAllTodo();
                                            });

                                            refreshChart();
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                      ),

                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          _showEditBottomSheet(allTodo[index]);
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),

                              ///  Divider
                              const Divider(),

                              ///  Display Date
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  DateFormat('MMM d, yyyy hh:mm a')
                                      .format(parsedDate),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: "myFont",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "Todo is Empty",
                      style: myTextStyle24(
                          fontColor: Colors.black45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
