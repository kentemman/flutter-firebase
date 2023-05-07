import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SendPage extends StatefulWidget {
  final DatabaseReference itemsRef;
  final String? id;
  final String? title;
  final String? description;

  const SendPage({
    Key? key,
    required this.itemsRef,
    this.id,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add Item' : 'Update Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final description = _descriptionController.text.trim();
                if (title.isEmpty || description.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please enter all fields'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  if (widget.id == null) {
                    final newItemRef = widget.itemsRef.push();
                    newItemRef.set({
                      'id': newItemRef.key,
                      'title': title,
                      'description': description,
                    }).then((_) {
                      Navigator.of(context).pop();
                    });
                  } else {
                    widget.itemsRef.child(widget.id!).update({
                      'title': title,
                      'description': description,
                    }).then((_) {
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      print("Failed to update item: $error");
                    });
                  }
                }
              },
              child: Text(widget.id == null ? 'Add Item' : 'Update Item'),
            ),
          ],
        ),
      ),
    );
  }
}
