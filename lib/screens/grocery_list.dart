import 'package:flutter/material.dart';
import 'package:groseri/data/grocery_list.dart';
import 'package:groseri/screens/grocery_trips.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key, required this.tripDetails}) : super(key: key);

  final Map<String, dynamic> tripDetails;

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  // List<dynamic> _items = [];
  List<GroceryListData> _items = [];
  List<int> _selected_box = [];
  bool? _valueCheck = false;
  //Map<String, dynamic> tripDeet;

  final _groceryList = Hive.box<GroceryListData>('grocery_list');

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    //final data = _groceryList.keys.map((key) {
    final data = _groceryList.values
        .where((el) => el.trip_id == widget.tripDetails['key']);
    // return {
    //   "key": key,
    //   "item_name": value["trip_name"],
    //   "quantity": value["quantity"],
    //   "trip_id": widget.tripDetails['key'],
    //   "family_members": widget.tripDetails['fam_members']
    // };
    //}).toList();

    setState(() {
      _items = data.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }

  // Create new item
  Future<void> _createItem(GroceryListData newItem) async {
    await _groceryList.add(newItem);
    _refreshItems(); // update the UI
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  GroceryListData_readItem(int key) {
    final item = _groceryList.get(key);
    return item;
  }

  // Update a single item
  Future<void> _updateItem(int itemKey, GroceryListData item) async {
    await _groceryList.put(itemKey, item);
    _refreshItems(); // Update the UI
  }

  // Delete a single item
  Future<void> _deleteItem(int itemKey) async {
    await _groceryList.delete(itemKey);
    _refreshItems(); // update the UI

    // Display a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A grocery item has been deleted')));
  }

  // TextFields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an itema
  void _showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element.key == itemKey);
      _nameController.text = existingItem.item_name;
      _quantityController.text = existingItem.quantity.toString();
      // _isDoneController = existingItem["is_done"];
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
                    decoration: const InputDecoration(hintText: 'Item Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Quantity'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null) {
                        final createItem = new GroceryListData(
                            _nameController.text,
                            int.parse(_quantityController.text),
                            widget.tripDetails['key']);

                        _createItem(createItem);
                      }

                      // update an existing item
                      if (itemKey != null) {
                        final updateItem = new GroceryListData(
                            _nameController.text,
                            int.parse(_quantityController.text),
                            widget.tripDetails['key']);

                        _updateItem(itemKey, updateItem);
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _quantityController.text = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripDetails['trip_name']),
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
                    title: Text(currentItem.item_name
                        // style: TextStyle(
                        //   fontSize: 18.0,
                        //   decoration: _valueCheck
                        //       ? TextDecoration.lineThrough
                        //       : null,
                        // ),
                        ),
                    subtitle: Text(currentItem.quantity.toString()),
                    leading: Checkbox(
                        value: _selected_box.contains(index),
                        onChanged: (bool? value) {
                          setState(() {
                            if (_selected_box.contains(index)) {
                              _selected_box.remove(index);
                            } else {
                              _selected_box.add(index);
                            }

                            //_valueCheck = value;
                          });
                        }),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showForm(context, currentItem.key)),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(currentItem.key),
                        ),
                      ],
                    ),
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

// class GroceryList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Grocery List'),
//       ),
//       body: Container(
//         child: Center(
//           child: Text('List of Grocery items to buy'),
//         ),
//       ),
//     );
//   }
// }
