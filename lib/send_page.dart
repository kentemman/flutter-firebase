import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SendPage extends StatefulWidget {
  const SendPage({Key? key, required DatabaseReference itemsRef})
      : super(key: key);

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  // Add an item ID variable to store the ID of the item being edited (if any)
  String? _itemId;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments['isEditing'] == true) {
      // Editing an existing item
      _itemId = arguments['id']; // Store the ID of the item being edited
      _titleController.text = arguments['title'];
      _descriptionController.text = arguments['description'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments != null && arguments['isEditing'] == true
            ? 'Edit Item'
            : 'Create Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final databaseRef = FirebaseDatabase.instance.reference();
          final id = _itemId ?? databaseRef.child('items').push().key!;
// Use the current date/time as the timestamp for the item
          final date = DateTime.now().toIso8601String();
          final title = _titleController.text;
          final description = _descriptionController.text;
          final isEditing = arguments != null ? arguments['isEditing'] : false;

// Create a map of the item's data
          final Map<String, dynamic> itemData = {
            'id': id,
            'title': title,
            'description': description,
            'date': date,
          };

// Add or update the item in Firebase
          if (isEditing == true) {
            databaseRef.child('items/$id').update(itemData);
          } else {
            databaseRef.child('items/$id').set(itemData);
          }

// Pass the edited/created item back to the previous screen
          Navigator.pop(context, {
            'id': id,
            'title': title,
            'description': description,
            'date': date,
            'isEditing': isEditing,
          });
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
