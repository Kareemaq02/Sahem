




import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';

 myAppBar(BuildContext context){
  return
  PreferredSize(
      preferredSize: const Size.fromHeight(45.0),
     child: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: double.infinity,
      leading: SizedBox(
          width:double.infinity,
          //height:10,
         
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            IconButton(onPressed:() { 
            }, icon:const Icon(Icons.notifications_none_outlined,color:AppColor.textTitle,size: 30,),),       
            
             SizedBox(width: MediaQuery.of(context).padding.right+60),
            Padding(
              padding: const EdgeInsets.only(bottom:8.0,left: 15),
              child: IconButton(onPressed:() {}, icon:const Icon(Icons.filter_alt_sharp,color:AppColor.main,size: 20,),
              ),
            ),
          
            const Text('البلاغات المعلنة',style:TextStyle(color: AppColor.textTitle,fontSize: 19,fontFamily:'DroidArabicKufi',)),
         
            ],),),
     ),);
}