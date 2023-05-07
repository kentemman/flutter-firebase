import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required DatabaseReference itemsRef})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseReference =
      FirebaseDatabase.instance.reference().child('items');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: StreamBuilder(
        stream: databaseReference.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.snapshot?.value == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final value = snapshot.data!.snapshot!.value;
            if (value is Map<dynamic, dynamic>) {
              final itemList = Map<String, dynamic>.from(value).values.toList();
              return ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  final item = itemList[index];
                  return ExpansionTile(
                    title: Text(item['title']),
                    children: [
                      ListTile(
                        title: Text(item['description']),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Item'),
                                    content: const Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          databaseReference
                                              .child(item['id'])
                                              .remove();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Yes'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/send', arguments: {
                                'id': item['id'],
                                'title': item['title'],
                                'description': item['description'],
                              });
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            } else {
              // Handle the case when the value is not a Map object
              return const Center(child: Text('Value is not a Map object'));
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/send');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
