// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'family_members.dart';

class GroceryTip {
  final int key;
  final String trip_name;
  final DateTime date;
  final fam_members = <FamilyMembersData>[];
  final String main_user_id;

  GroceryTip(this.key, this.trip_name, this.date, this.main_user_id);
}
