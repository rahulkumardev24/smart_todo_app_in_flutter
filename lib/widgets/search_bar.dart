import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final Function(String) onSearchChanged;

  const Search({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: widget.onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search Todo',
                hintStyle: TextStyle(
                    fontFamily: "myFont", color: Colors.white, fontSize: 22),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.orange,
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.deepPurple,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(
                  Icons.search,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
