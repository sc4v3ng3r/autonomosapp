import 'package:flutter/services.dart';

class PhoneTextInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    print("OLD: ${oldValue.text.length} NEW: ${newValue.text.length}");
    // digitando
    if (newValue.text.length > oldValue.text.length ){
      print("CUrrent position ${newValue.selection.base.offset}");
      switch(newValue.text.length){
        case 1:
          return getTextEditingValue("${oldValue.text}(${newValue.text}",
              TextSelection.collapsed(offset: newValue.selection.end+1) );

        case 3:
          return getTextEditingValue("${newValue.text}) ",
              TextSelection.collapsed(offset: newValue.selection.end+2) );

        case 4:
          return getTextEditingValue("${oldValue.text}) ${newValue.text[newValue.text.length-1]}",
              TextSelection.collapsed(offset: newValue.selection.end+2));

        case 5:
          return getTextEditingValue("${oldValue.text} ${newValue.text[newValue.text.length-1]}",
              TextSelection.collapsed(offset: newValue.selection.end+1));
        default:
          return newValue;
      }
    }

    //apagando
    else {
      return newValue;
    }
  }

  TextEditingValue getTextEditingValue(String text, TextSelection selection){
    return TextEditingValue(
        text: text,
        selection: selection
    );
  }
}