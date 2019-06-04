// import 'package:flutter/material.dart';

// typedef void Callback();

// class SimpleAlertDialog extends StatelessWidget {
//   final Color color;
//   final String title;
//   final String content;
//   final Callback onActionPressed;

//   SimpleAlertDialog({
//     @required this.title,
//     @required this.content,
//     @required this.color,
//     @required this.onActionPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FlatButton(
//       textColor: color,
//       child: Icon(Icons.delete),
//       onPressed: () {
//         showDialog(
//           context: context,
//           barrierDismissible: false, // user must tap button!
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text(title),
//               content: SingleChildScrollView(
//                 child: ListBody(
//                   children: <Widget>[
//                     Text(content),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text('Delete', style: TextStyle(fontWeight: FontWeight.w500)),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.of(context).pop();
//                     onActionPressed();
//                   },
//                 ),
//                 FlatButton(
//                   child: Text('Cancel'),
//                   textColor: Colors.grey,
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }