import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/models/doctor/experience.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class EditExperienceScreen extends StatefulWidget {
  final Experience? experience;
  const EditExperienceScreen({Key? key, this.experience}) : super(key: key);

  @override
  State<EditExperienceScreen> createState() => _EditExperienceScreenState();
}

class _EditExperienceScreenState extends State<EditExperienceScreen> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<DateTimeRange?> _notifier =
      ValueNotifier<DateTimeRange?>(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.experience != null) {
      _controller.text = widget.experience!.location!;
      _notifier.value = widget.experience!.dateTimeRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Stack(children: [
            Center(
              child: SingleChildScrollView(
                // controller: controller,
                padding: const EdgeInsets.all(36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Institution / Location'),
                    CustomTextFormField(
                      controller: _controller,
                      hintText: '',
                    ),
                    const SizedBox(height: 50),
                    ValueListenableBuilder<DateTimeRange?>(
                      valueListenable: _notifier,
                      builder: (BuildContext context, DateTimeRange? value,
                          Widget? child) {
                        return Center(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () async {
                                  _notifier.value = await showDateRangePicker(
                                      initialDateRange: value,
                                      context: context,
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.calendar_month_outlined),
                                    SizedBox(width: 10),
                                    Text(
                                      'Choose time range', //TODO: find better phrase
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                value == null
                                    ? '-'
                                    : '${DateFormat.yMMMMd().format(value.start)} - ${DateFormat.yMMMMd().format(value.end)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            CustomAppBar(
              title: 'Experience',
              leading: Icons.arrow_back,
              actions: [
                if (widget.experience != null)
                  OutlineIconButton(
                    iconData: Icons.delete,
                    onPressed: () {
                      showConfirmationDialog(context,
                          message: 'Delete experience?', confirmFunction: () {
                        Navigator.pop(
                            context, EditObject(action: EditAction.delete));
                      });
                    },
                  )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 48 + 72,
                child: Padding(
                  padding: const EdgeInsets.all(36),
                  child: CustomFlatButton(
                    child: Text(widget.experience == null ? 'Add' : 'Save'),
                    onPressed: () {
                      if (_controller.text.trim().isEmpty) {
                        showAlertDialog(context,
                            message: 'Textfield cannot be empty');
                      } else if (_notifier.value == null) {
                        showAlertDialog(context,
                            message: 'A date must be selected');
                      } else {
                        Navigator.pop(
                            context,
                            EditObject(
                                action: EditAction.edit,
                                object: Experience(
                                    location: _controller.text.trim(),
                                    dateTimeRange: _notifier.value)));
                      }
                    },
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _notifier.dispose();
    super.dispose();
  }
}
