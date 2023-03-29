import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String versionNumber = '';

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  Future<void> _getPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      versionNumber = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: width,
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('NextApp',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w600)),
                  Container(
                    width: 150,
                    height: 2,
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(height: 30),
                  Text('Version',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  Text(versionNumber,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  SizedBox(height: 30),
                  Text('Last Update',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  Text('March 2023',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  SizedBox(height: 30),
                  Text(
                      'NextApp App is cloud ERP System on mobile to make your work easier .',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Powered by'),
                      TextButton(
                        onPressed: () {
                          launchUrl(Uri.parse('https://www.erpcloud.systems/'));
                        },
                        child: Text(
                          'ERPCloud.systems',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
