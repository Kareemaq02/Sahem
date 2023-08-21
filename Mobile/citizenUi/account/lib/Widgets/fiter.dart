import 'package:account/API/get_complaints_types.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

class TypeFilter extends StatefulWidget {
  const TypeFilter({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _TypeFilterState createState() => _TypeFilterState();
}

class _TypeFilterState extends State<TypeFilter> {
  List<ComplaintType>? selectedUserList = [];
    List<User>? selectedUserList2 = [];


    List<String> brands=[
   "Pending",
    "In progress",
    "Completed",
    "Rejected",
    "Aproved",
  
   ];
  List<bool> isSelected = List<bool>.generate(4, (_) => false);

  // Future<void> openFilterDelegate() async {
  //   await FilterListDelegate.show<User>(
  //     context: context,
  //     list: userList,
  //     selectedListData: selectedUserList,
  //     theme: FilterListDelegateThemeData(
  //       listTileTheme: ListTileThemeData(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         tileColor: Colors.white,
  //         selectedColor: Colors.red,
  //         selectedTileColor: const Color(0xFF649BEC).withOpacity(.5),
  //         textColor: Colors.blue,
  //       ),
  //     ),
  //     // enableOnlySingleSelection: true,
  //     onItemSearch: (user, query) {
  //       return user.name!.toLowerCase().contains(query.toLowerCase());
  //     },
  //     tileLabel: (user) => user!.name,
  //     emptySearchChild: const Center(child: Text('No user found')),
  //     searchFieldHint: 'Search Here..',
  //     onApplyButtonClick: (list) {
  //       setState(() {
  //         selectedUserList = list;
  //       });
  //     },
  //   );
  // }
  ComplaintTypeRequest type=ComplaintTypeRequest();
  Future<void> _openFilterDialog() async {
   List<ComplaintType> complaintTypes = await type.getAllCategory();
    await FilterListDialog.display<ComplaintType>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Complaint Types',
      height: 500,
      listData: complaintTypes,
      selectedListData: selectedUserList,
      choiceChipLabel: (item) => item!.strNameAr,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.strNameAr.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = List.from(list!);
        });
        Navigator.pop(context);
      },

    );
  }

  // Future<void> _openFilterDialog2() async {
 
  //   await FilterListDialog.display<User>(
  //     context,
  //     hideSelectedTextCount: true,
  //     themeData: FilterListThemeData(context),
  //     headlineText: 'Complaint Types',
  //     height: 500,
  //     listData: userList2,
  //     selectedListData: selectedUserList2,
  //     choiceChipLabel: (item) => item!.name,
  //     validateSelectedItem: (list, val) => list!.contains(val),
  //     controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
  //     onItemSearch: (user, query) {
  //       /// When search query change in search bar then this method will be called
  //       ///
  //       /// Check if items contains query
  //       return user.name!.toLowerCase().contains(query.toLowerCase());
  //     },

  //     onApplyButtonClick: (list) {
  //       setState(() {
  //         selectedUserList = List.from(list!);
  //       });
  //       Navigator.pop(context);
  //     },

  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [

           Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0), 
                padding: EdgeInsets.all(8.0), 
                decoration: BoxDecoration(
                   border: Border.all(
                  color: Colors.grey, 
                 width: 2.0,), 
                
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(60.0), 
                ),
                child: Text("Rest")),

                 Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0), 
                padding: EdgeInsets.all(8.0), 
                decoration: BoxDecoration(
                   border: Border.all(
                  color: Colors.grey, 
                 width: 2.0,), 
                
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(60.0), 
                ),
                child: Text("Apply")),
           
         
        ],
      ),
      appBar: AppBar(
        title: Text("Filter"),
      ),
      backgroundColor: Colors.grey[300],
     
      body: ListView(
       scrollDirection: Axis.vertical,
        children: <Widget>[
          const Text(
            'Complaint Status',
            textAlign: TextAlign.start,
             style: TextStyle(
              fontWeight: FontWeight.bold
             ),
            ),
            Container(
            color: Colors.white,
            width: double.infinity,
            height: 85,
            child:ListView(
        scrollDirection: Axis.horizontal,children:[
            Row(
            
              children: [
                    for (int index = 0; index <4; index++)
            GestureDetector(
              onTap: () {
                setState(() {
                  isSelected[index] = !isSelected[index];
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0), 
                padding: EdgeInsets.all(8.0), 
                decoration: BoxDecoration(
                   border: Border.all(
                  color: Colors.grey, // Change the border color to your preference
                 width: 2.0,), // Adjust the border width as needed
                
                  color: isSelected[index] ? Colors.purple : Colors.white,
                  borderRadius: BorderRadius.circular(10.0), // Add borderRadius for rounded corners
                ),
                child: 
                    Text(brands[index]),
                    
                 
              ),
            ),
              ],
            ) ,
         ] ),
      ),
       SizedBox(height: 10,),
         Container(
  color: Colors.white,
  width: double.infinity,
  //height: double.infinity, // Set a fixed height, or use double.infinity to take up all available vertical space
  child: DatePickerDialog(
    initialDate: DateTime(2023, 7, 31), // Correctly specify year, month, and day
    firstDate: DateTime(2020, 1, 1), // Correctly specify year, month, and day
    lastDate: DateTime(2025, 1, 1), // Correctly specify year, month, and day
  ),
),

Text("Compalint Types"),
   Container(
            color: Colors.white,
            width: double.infinity,
            height: 40,
            child: Row(
              children: [
              Text("Pick a type"),
              IconButton(onPressed:() =>  _openFilterDialog(), icon: Icon(Icons.navigate_next))
              ],)
   ),
      
      ]
     
      ),

    );
  }
}



class User {
  final String? name;
  final String? avatar;
  User({this.name, this.avatar});
}


List<User> userList2 = [
  User(name: "Abigail", avatar: "user.png"),
  User(name: "Audrey", avatar: "user.png"),
  User(name: "Ava", avatar: "user.png"),
  User(name: "Bella", avatar: "user.png"),
  User(name: "Bernadette", avatar: "user.png"),
  User(name: "Carol", avatar: "user.png"),
 
];
