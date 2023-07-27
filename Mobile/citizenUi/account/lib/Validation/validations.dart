
 
class Validation{
 
 String? inputValidate(String? value) {
     if (value!.isEmpty) {
      return "Field is Required";
    } else {
      return null;
    }
  }

   String? validateMobile(String ?value) {
// Indian Mobile number are of 10 digit only
    if (value!.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else {
      return null;
    }
  }

   String? validateName(String? value) {
     if (value!.isEmpty) {
      return "Field is Required";
    } 
    if (value.length < 3) {
      return 'Name must be more than 2 charater';
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    String pattern =
       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"; // email validation regex pattern
    RegExp regex = RegExp(pattern);
     if (value!.isEmpty) {
      
      return "Email is Required";
     }
    else if (!regex.hasMatch(value)) {
       
      return 'Please enter a valid email address';
    } else {
      
      return null;
    }
  }
 String? validateUsername(String? value) {
 
        if (value == null || value.isEmpty) {
         
          return 'Username is required.';
        }
        else if (!RegExp(r'^[a-z][a-z0-9_.-]*$').hasMatch(value)) {
          
          return 'Invalid username. Usernames must start with a letter. Allowed characters are a-z (only lower case), 0-9, _, - (dash), and .(dot).';
        }
        else {
         
          return null;} // Return null if the value is valid
      }
}




