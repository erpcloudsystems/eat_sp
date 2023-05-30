import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageDetailsDialog extends StatelessWidget {
  final List<String> names, values;
  final String title;

  const PageDetailsDialog(
      {Key? key,
      required this.names,
      required this.values,
      required this.title})
      : assert(names.length == values.length),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(names);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LimitedBox(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          child: Dialog(
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.blueAccent),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    //padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    height: 50,
                    child: Center(
                        child: Text(title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)))),
                Flexible(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.blue
                        ],
                        stops: [0.0, 0.03, 0.97, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        itemBuilder: (_, i) => RichText(
                              text: TextSpan(
                                  text: names[i] + ': ',
                                  style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: values[i],
                                        style: GoogleFonts.cairo(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal))
                                  ]),
                            ),
                        separatorBuilder: (_, i) =>
                            Divider(color: Colors.grey.shade400, thickness: 1),
                        itemCount: names.length),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
