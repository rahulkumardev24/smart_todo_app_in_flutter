import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
// Import DateFormat for date formatting
import 'package:smart_todo/data/local/data_base_helper.dart';
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

  // Search
  void _searchTask(String keyword) async {
    if (keyword.isEmpty) {
      getAllTodo(); // Fetch all todos if search keyword is empty
    } else {
      List<Map<String, dynamic>> results = await mainDB.searchTodos(keyword);
      setState(() {
        allTodo = results; // Update the list with search results
      });
    }
  }

  void _showEditBottomSheet(Map<String, dynamic> todo) {
    // Initialize controllers with current todo values
    title.text = todo[DataBaseHelper.columnTodoTitle].toString();
    message.text = todo[DataBaseHelper.columnTodoMessage].toString();

    showModalBottomSheet(
      elevation: 15,
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
                  const Text(
                    "Update Todo",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: title,
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: message,
                    decoration: InputDecoration(
                      labelText: "Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(width: 1, color: Colors.red),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 22, color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
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
                            elevation: 8,
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            "Update",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.menu,
              size: 30,
            ),
            const Text(
              "TODO",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "myFont",
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                image: const DecorationImage(
                  image: AssetImage(
                    "assets/image/devrahul.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.orangeAccent.shade200,
            elevation: 15,
            context: context,
            builder: (context) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Add Todo",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "myFont",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: title,
                        decoration: InputDecoration(
                          filled: false,
                          border: InputBorder.none,
                          labelText: "Title",
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "myFont",
                            color: Colors.white,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          filled: false,
                          border: InputBorder.none,
                          labelText: "Message",
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontFamily: "myFont",
                            color: Colors.white,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 120,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(
                                width: 1,
                                color: Colors.red,
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontSize: 22, color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
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
                              shadowColor: Colors.green,
                              elevation: 8,
                              backgroundColor: Colors.deepPurple,
                            ),
                            child: const Text(
                              "Add",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
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
        label: const Row(
          children: [
            Icon(
              Icons.add,
              size: 30,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 3,
                  offset: Offset(2.0, 2.2),
                ),
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "TODO",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "myFont",
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 3,
                    offset: Offset(2.0, 2.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ................................... BODY PART ...................//
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Search(onSearchChanged: _searchTask),
          const Padding(
            padding:  EdgeInsets.all(10.0),
            child: Card(child: PiChartTaskDone()
            ),
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
                      return SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 7),
                          child: Card(
                            elevation: 5,
                            color: const Color(0xfbffe5ad),
                            shadowColor: Colors.deepPurple,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ...........CHECK......... BOX..........
                                      Checkbox(
                                        value: allTodo[index][DataBaseHelper.columnTodoIsDone] == 1,
                                        onChanged: (bool? value) async {
                                          await mainDB.updateTodoStatus(
                                            id: allTodo[index][DataBaseHelper.columnTodoSno],
                                            isDone: value!,
                                          );

                                          await getAllTodo();
                                          setState(() {});  // This will trigger the pie chart to refresh
                                        },
                                      ),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            // ...............TITLE............//
                                            Text(
                                              todoTitle,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "myFont",
                                              ),
                                              maxLines: 1,
                                            ),
                                            // ..............Message..........//
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
                                      Column(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                mainDB.deleteTodo(
                                                    id: allTodo[index][
                                                        DataBaseHelper
                                                            .columnTodoSno]);
                                                getAllTodo();
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 30,
                                                color: Colors.red,
                                              )),
                                          IconButton(
                                            icon: const Icon(
                                              (Icons.edit),
                                              size: 30,
                                              color: Colors.green,
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 3,
                                                    offset: Offset(2.0, 2.0))
                                              ],
                                            ),
                                            onPressed: () {
                                              _showEditBottomSheet(
                                                  allTodo[index]);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.deepPurple)),
                                  ),
                                ),

                                // .........DATE...............//
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    DateFormat('MMM d, yyyy hh:mm a')
                                        .format(parsedDate),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontFamily: "myFont"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 300.0),
                      child: Center(
                        child: Text(
                          "Todo is not found",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: "myFont",
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
