import 'package:NextApp/widgets/custom-button.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants.dart';
import '../../provider/module/module_provider.dart';

class CustomPageViewForm extends StatefulWidget {
  const CustomPageViewForm(
      {super.key,
      required this.submit,
      required this.widgetGroup,
      this.isAppBar = true});
  final bool isAppBar;
  final Function submit;
  final List<Widget> widgetGroup;

  @override
  _CustomPageViewFormState createState() => _CustomPageViewFormState();
}

class _CustomPageViewFormState extends State<CustomPageViewForm> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  List<GlobalKey<FormState>> _formKeys = [];
  @override
  void initState() {
    super.initState();

    // initial current index
    _pageController = PageController(initialPage: _currentPage);

    /// generate Number of from key to validator
    _formKeys = List.generate(
        widget.widgetGroup.length, (index) => GlobalKey<FormState>());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    if (_currentPage < widget.widgetGroup.length - 1) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moduleProvider = context.read<ModuleProvider>();
    String currentModule = moduleProvider.currentModule.title;

    return ColorfulSafeArea(
      color: APPBAR_COLOR,
      child: Scaffold(
        appBar: widget.isAppBar
            ? AppBar(
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                title: (moduleProvider.isEditing)
                    ? Text(
                        "Edit $currentModule".tr(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )
                    : Text(
                        "Create $currentModule".tr(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
              )
            : null,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, top: 10),
              child: PageView.builder(
                allowImplicitScrolling: true,
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: widget.widgetGroup.length,
                itemBuilder: (context, index) {
                  return Form(
                    key: _formKeys[index],
                    child: widget.widgetGroup[index],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (_currentPage > 0)
                      IconButton(
                        onPressed: () {
                          goToPreviousPage();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: APPBAR_COLOR,
                          size: 25,
                        ),
                      ),
                    if (_currentPage < widget.widgetGroup.length - 1)
                      Expanded(
                        child: CustomButton(
                          text: "Next".tr(),
                          color: APPBAR_COLOR,
                          onPressed: () {
                            if (_currentPage < widget.widgetGroup.length - 1) {
                              if (_formKeys[_currentPage]
                                  .currentState!
                                  .validate()) {
                                goToNextPage();
                                setState(() {});
                              }
                            }
                          },
                        ),
                      ),
                    if (_currentPage == widget.widgetGroup.length - 1)
                      Expanded(
                        child: CustomButton(
                          text: "Save".tr(),
                          color: APPBAR_COLOR,
                          onPressed: () {
                            if (_formKeys[_currentPage]
                                .currentState!
                                .validate()) {
                              _formKeys[_currentPage].currentState!.save();
                              widget.submit();
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: DotsIndicator(
                dotsCount: widget.widgetGroup.length,
                position: _currentPage,
                mainAxisSize: MainAxisSize.max,
                decorator: DotsDecorator(
                  spacing: const EdgeInsets.all(9),
                  activeColor: APPBAR_COLOR,
                  color: Colors.black54,
                  size: const Size.square(9.0),
                  activeSize: Size(60.w, 9.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
