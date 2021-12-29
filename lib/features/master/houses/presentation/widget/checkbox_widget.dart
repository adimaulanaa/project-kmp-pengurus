import 'package:flutter/material.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';

class CheckBoxWidget extends StatefulWidget {
  final Base? data;
  final Function? onChange;
  const CheckBoxWidget({Key? key, this.data, this.onChange}) : super(key: key);

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Color(0xff58C863),
        contentPadding: EdgeInsets.all(2),
        title: Text(
          widget.data!.name!,
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontStyle: FontStyle.normal),
        ),
        subtitle: Text(
          "Rp." + widget.data!.amount.toString(),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xff121212),
              fontStyle: FontStyle.normal),
        ),
        value: check,
        onChanged: (newValue) {
          setState(() {
            check = newValue!;
            _add(widget.data!, check);
          });
        },
      ),
    );
  }

  void _add(Base data, bool checked) {
    widget.onChange!(data, checked);
  }
}
