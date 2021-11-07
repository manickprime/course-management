import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RemainderList extends StatefulWidget {
  final List fetchedRemainders;
  final Function deleteRemainders;
  RemainderList(this.fetchedRemainders, this.deleteRemainders);

  @override
  _RemainderListState createState() => _RemainderListState();
}

class _RemainderListState extends State<RemainderList> {
  @override
  Widget build(BuildContext context) {
    final List currentList = widget.fetchedRemainders;
    return Expanded(
      child: ListView.builder(
          itemCount: currentList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                hoverColor: Colors.lightBlueAccent,
                title: Text('${currentList[index]['title']}'),
                subtitle: Text('${currentList[index]['time']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.blueAccent,
                  onPressed: () {
                    widget.deleteRemainders(currentList, index);
                  },
                ),
              ),
            );
          }),
    );
  }
}
