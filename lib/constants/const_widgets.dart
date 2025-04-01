import 'package:flutter/material.dart';
import 'package:hptracker/constants/colors.dart';

void showPopup(BuildContext context, String tittle, String text,
    void Function() onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tittle),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: onPressed,
            child: Text(
              "OK",
              style: TextStyle(color: accent),
            ),
            ),
          ],
        );
      },
    );
  }

Widget progressIndicator(Color color) {
  return Center(
    child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
          color: color,
        ),
        const SizedBox(height: 10),
            Text(
          'Please Wait',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          'Loading...',
          style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
  );
}

Widget rowElement(String title, String content, double width, MainAxisAlignment align) {
  return Padding(
    padding: EdgeInsets.all(width * 0.02),
    child: Row(
      mainAxisAlignment: align,
      children: [
        Text(
          "$title : ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          content,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}


Future<void> selectDate(BuildContext context, DateTime date, String selectedDOB,
    Function function) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: date,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (pickedDate != null && pickedDate != date) {
    function(pickedDate);
  }
}

Widget buildTextfield(
    String title, TextEditingController controller, bool val, TextInputType type, double width) {
  return Padding(
    padding: EdgeInsets.all(width * 0.023),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(
          height: width * 0.028,
        ),
        TextField(
          enabled: val,
          keyboardType: type,
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: "Enter $title",
          ),
        )
      ],
    ),
  );
}


 