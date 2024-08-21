import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants.dart';
import '../../service/service.dart';

class HomeItemTest extends StatelessWidget {
  final String imageUrl, title;
  final VoidCallback onPressed;

  const HomeItemTest({
    required this.title,
    required this.imageUrl,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: 120.h,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: ORANGE_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )),
          Align(
            alignment: const AlignmentDirectional(0, -1.6),
            child: Container(
              width: 120.w,
              height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      imageUrl,
                      headers: APIService().getHeaders,
                      loadingBuilder: (context, child, progress) {
                        return progress != null
                            ? const SizedBox(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 60,
                                ),
                              )
                            : child;
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const SizedBox(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 60,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
