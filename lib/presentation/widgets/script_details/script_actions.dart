import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/presentation/widgets/script_details/lines_preview.dart';
import 'package:fonetic/presentation/widgets/script_details/my_outlined_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScriptActions extends StatelessWidget {
  final Script script;

  const ScriptActions({Key? key, required this.script}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyOutlinedButton(
            text: 'Characters',
            callBack: () => _showCharacters(context, script.characters),
          ),
          SizedBox(
            width: 16.w,
          ),
          MyOutlinedButton(
            text: 'Script',
            callBack: () => _showScript(context, script.id!),
          ),
        ],
      ),
    );
  }

  void _showScript(BuildContext context, String scriptId) {
    showBarModalBottomSheet(
        context: context,
        isDismissible: true,
        barrierColor: Colors.black,
        builder: (context) => Container(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: LinesPreview(scriptId: scriptId),
              ),
            ));
  }

  void _showCharacters(BuildContext context, List<String> characters) {
    showBarModalBottomSheet(
        context: context,
        isDismissible: true,
        barrierColor: Colors.black,
        builder: (context) => Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
              color: Theme.of(context).backgroundColor,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(characters[index],
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                itemCount: characters.length,
              ),
            ));
  }
}
