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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyOutlinedButton(
                text: 'Characters',
                callBack: () => _showCharacters(context, script.characters),
              ),
              MyOutlinedButton(
                text: 'Script',
                callBack: () => _showScript(context, script.id!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showScript(BuildContext context, String scriptId) {
    showBarModalBottomSheet(
        context: context,
        isDismissible: true,
        barrierColor: Colors.black,
        builder: (context) => Padding(
              padding: EdgeInsets.all(24.h),
              child: LinesPreview(scriptId: scriptId),
            ));
  }

  void _showCharacters(BuildContext context, List<String> characters) {
    showBarModalBottomSheet(
        context: context,
        isDismissible: true,
        barrierColor: Colors.black,
        builder: (context) => Container(
              padding: EdgeInsets.only(left: 24.h, top: 24.h),
              color: Theme.of(context).backgroundColor,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    characters[index],
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                itemCount: characters.length,
              ),
            ));
  }
}
