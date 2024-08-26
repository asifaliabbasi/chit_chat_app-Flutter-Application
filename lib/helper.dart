import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dailogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.blueAccent,
      behavior: SnackBarBehavior.floating,
    ));
  }
  static void showProgressBar(BuildContext context){
    showDialog(context: context, builder:(_) {
      return Center(child: const CircularProgressIndicator(color: Colors.blueAccent,));
    });
  }


}


//getting formate in time
class MyDateUtil{
  static String getFormatedTime({required BuildContext context, required String time}){
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time) );
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime({required BuildContext context, required String time, bool showYear = false}){
    final DateTime sentTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time) );
    final DateTime now = DateTime.now();
    if(now.day == sentTime.day && now.month == sentTime.month && now.year == sentTime.year){
    return TimeOfDay.fromDateTime(sentTime).format(context);
    }
    return showYear ?'${sentTime.day} ${_getMonth(sentTime)} ${DateTime.now().year}' :'${sentTime.day}${_getMonth(sentTime)}';

  }

  static String getLastActiveTime({required BuildContext context, required String lastActive}){
    final int i = int.tryParse(lastActive)?? -1;

    //if time not available
    if(i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if(time.day == now.day && time.month == now.month && time.year == now.year){
      return 'Last seen today at $formattedTime';
    }
    else {
      return 'Last seen on ${time.day} ${_getMonth(time)} at $formattedTime';
    }
  }


  static String _getMonth(DateTime date ){
    switch (date.month){
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'Aug';
      case 9: return 'Sept';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';


    }
    return 'NA';
  }


  //get sent time
  static String getSentTime({required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day && now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }
    return now.year == sent.year
        ?'$formattedTime - ${sent.day} ${_getMonth(sent)}'
        :'$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';

  }
}




