import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../widgets/tags.dart';
import '../bloc/faq_bloc.dart';
import '../widgets/faqs_list_screen.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/resources/strings_manager.dart';

class FAQ extends StatelessWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Here we send an event to get all the data when entering the screen,
    // and it won't rebuild the full screen again so we sure it won't be called multiple times.
    BlocProvider.of<FaqBloc>(context).add(const GetFagsEvent());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: DoublesManager.d_0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Text(
              StringsManager.faq,
              style: GoogleFonts.bebasNeue(
                fontSize: DoublesManager.d_70.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Tags(),
          const FaqsListScreen()
        ],
      ),
    );
  }
}
