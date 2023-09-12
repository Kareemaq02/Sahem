
 
class Validation{
 
 String? inputValidate(String? value) {
     if (value!.isEmpty) {
      return "الرجاء تعبئة الحقل";
    } else {
      return null;
    }
  }

   String? validateMobile(String ?value) {
    if (value!.length != 10) {
      return 'يجب ان يحتوي رقم الهاتف على 10 خانات';
    } else {
      return null;
    }
  }

   String? validateName(String? value) {
     if (value!.isEmpty) {
      return "Field is Required";
    } 
    if (value.length < 3) {
      return 'يجب أن يحتوي الاسم أكثر من حرفين';
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    String pattern =
       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"; 
    RegExp regex = RegExp(pattern);
     if (value!.isEmpty) {
      
      return "يرجى تعبئة الحقل";
     }
    else if (!regex.hasMatch(value)) {
       
      return 'البريد الالكتروني غير صالح';
    } else {
      
      return null;
    }
  }
 String? validateUsername(String? value) {
 
        if (value == null || value.isEmpty) {
         
      return "يرجى تعبئة الحقل";
        }
        else if (!RegExp(r'^[a-z][a-z0-9_.-]*$').hasMatch(value)) {
          
          return 'Invalid username. Usernames must start with a letter. Allowed characters are a-z (only lower case), 0-9, _, - (dash), and .(dot).';
        }
        else {
         
          return null;} 

      }
}




