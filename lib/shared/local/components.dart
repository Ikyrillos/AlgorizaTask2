import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  // Function? onSubmit,
  void Function(String)? onChange,
  String? Function(String?)? validate,
  required String label,
  IconData? prefix,
  bool isPassword = false,
  IconData? suffix,
  Function? suffixPressed,
  onTap,
  // bool enabled = true,
  bool readOnly = false,
}) =>
    TextFormField(
      textAlign: TextAlign.start,
      cursorRadius: const Radius.circular(10.0),
      validator: validate,
      textInputAction: TextInputAction.next,
      readOnly: readOnly,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onChanged: onChange,
      onTap: onTap,
      decoration: InputDecoration(
        // labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        hintText: label,
        border: InputBorder.none,
        // prefixIcon: Icon(
        //   prefix,
        // ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: () {
                  suffixPressed!();
                },
              )
            : null,
      ),
    );

class FormFieldTitle extends StatelessWidget {
  const FormFieldTitle({Key? key, required this.label}) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DefaultFormField extends StatelessWidget {
  const DefaultFormField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      required this.isReadOnly,
      this.suffixButton,
      this.onTap,
      required this.errorMsg})
      : super(key: key);
  final String title;
  final String errorMsg;
  final String hint;
  final bool isReadOnly;
  final Widget? suffixButton;
  final TextEditingController? controller;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 16.w),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 60.h,
            width: 300.w,
            padding: EdgeInsets.only(left: 14.w),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return errorMsg;
                      }
                      return null;
                    },
                    readOnly: isReadOnly,
                    autofocus: false,
                    cursorColor: Colors.grey[600],
                    controller: controller,
                    decoration: InputDecoration(
                      suffixIcon: suffixButton,
                      hintText: hint,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                      focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
