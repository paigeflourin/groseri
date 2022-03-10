import 'package:flutter/material.dart';
import 'package:groseri/data/family_members.dart';
import 'package:groseri/screens/grocery_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GroceryTrips extends StatefulWidget {
  const GroceryTrips({Key? key}) : super(key: key);

  @override
  _GroceryTripsState createState() => _GroceryTripsState();
}

class _GroceryTripsState extends State<GroceryTrips> {
  List<Map<String, dynamic>> _items = [];

  final _groceryTrip = Hive.box('grocery_trip');
  final _familyMembers = Hive.box('family_members');

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    final data = _groceryTrip.keys.map((key) {
      final value = _groceryTrip.get(key);
      return {
        "key": key,
        "trip_name": value["trip_name"],
        "date": value['date'],
        "fam_members": value['fam_members'],
        "main_user_id": value['main_user_id']
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }

  //TODO: get fam members from table
  List<dynamic> _getFamilyMembers() {
    final familyMemList = Hive.box('family_members')
        .values
        .toList()
        .where(
            (fam) => fam['main_user_id'] == 'user01') //hardcoded user for now
        .toList();
    return familyMemList;
  }

  // Create new item
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _groceryTrip.add(newItem);
    _refreshItems(); // update the UI
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  Map<String, dynamic> _readItem(int key) {
    final item = _groceryTrip.get(key);
    return item;
  }

  // Update a single item
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _groceryTrip.put(itemKey, item);
    _refreshItems(); // Update the UI
  }

  // Delete a single item
  Future<void> _deleteItem(int itemKey) async {
    await _groceryTrip.delete(itemKey);
    _refreshItems(); // update the UI

    // Display a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A grocery item has been deleted')));
  }

  // TextFields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _familyMemController = TextEditingController();
  var _selectedFamilyMembers = <Object?>[];
  DateTime selectedDate = DateTime.now();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['trip_name'];
      _dateController.text = existingItem['date'];
    }

    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(hintText: 'Grocery Trip Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _dateController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(hintText: 'Date'),
                    onTap: () => _selectDate(context),
                  ),
                  MultiSelectDialogField(
                    items: _getFamilyMembers()
                        .map((e) => MultiSelectItem(e, e['name']))
                        .toList(),
                    onConfirm: (values) {
                      _selectedFamilyMembers = values;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null) {
                        _createItem({
                          "trip_name": _nameController.text,
                          "date": _dateController.text,
                          "fam_members": _familyMemController.text
                        });
                      }

                      // update an existing item
                      if (itemKey != null) {
                        _updateItem(itemKey, {
                          'trip_name': _nameController.text.trim(),
                          'date': _dateController.text.trim(),
                          "fam_members": _familyMemController.text
                        });
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _dateController.text = '';
                      _familyMemController.text = '';

                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateFormat formatter =
        DateFormat('dd/MM/yyyy'); //specifies day/month/year format

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.value = TextEditingValue(
            text: formatter.format(
                picked)); //Use formatter to format selected date and assign to text field
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Trip'),
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              // the list of items
              itemCount: _items.length,
              itemBuilder: (_, index) {
                final currentItem = _items[index];
                return Card(
                  color: Colors.orange.shade100,
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: ListTile(
                    title: Text(currentItem['trip_name']),
                    subtitle: Text(currentItem['date'].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showForm(context, currentItem['key'])),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(currentItem['key']),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GroceryList(tripDetails: _items[index]),
                          ));
                    },
                  ),
                );
              }),
      // Add new item button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// class GroceryTrips extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Grocery Trips'),
//       ),
//       body: Container(
//         child: Center(
//           child: Text('List of Grocery trips here'),
//         ),
//       ),
//     );
//   }
// }
