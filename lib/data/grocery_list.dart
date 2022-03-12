// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:hive/hive.dart';

class GroceryListData extends HiveObject {
  // final int key;
  final String item_name;
  final int quantity;
  final int trip_id;

  GroceryListData(this.item_name, this.quantity, this.trip_id);
}

// Can be generated automatically
class GroceryListAdapter extends TypeAdapter<GroceryListData> {
  @override
  final typeId = 0;

  @override
  GroceryListData read(BinaryReader reader) {
    return GroceryListData(reader.read(), reader.read(), reader.read());
  }

  @override
  void write(BinaryWriter writer, GroceryListData obj) {
    writer.write(obj.item_name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroceryListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
