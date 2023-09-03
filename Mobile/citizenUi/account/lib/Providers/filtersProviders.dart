

// final filterModel = Provider.of<FilterModel>(context);


// List<int> selectedStatus = filterModel.selectedStatus;
// List<int> selectedType = filterModel.selectedType;

import 'package:flutter/foundation.dart';

class FilterModel extends ChangeNotifier {
  List<int> selectedStatus = [];
  List<int> selectedType = [];
}


// // Modify the selectedStatus and selectedType lists
// filterModel.selectedStatus = updatedStatusList;
// filterModel.selectedType = updatedTypeList;

// // Notify listeners that the data has changed
// filterModel.notifyListeners();