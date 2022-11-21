
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

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
                  Text('Next App',
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
                  Text('1.0',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  SizedBox(height: 30),
                  Text('Last Update',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  Text('November 2022',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  SizedBox(height: 30),
                  Text(
                      'Next App is cloud ERP System on mobile to make your work easier .',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Powered by'),
                      TextButton(
                        onPressed: (){
                          launchUrl(Uri.parse('https://www.erpcloud.systems/'));
                        } ,
                        child:Text('ERPCloud.systems',style: TextStyle(color: Colors.blue),),
                      ),

                    ],
                  ),
                  SizedBox(height: 30),

                  // Text('Term of services',
                  //     style:
                  //     TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




//
// Container(
// child: ButtonTheme(
// height: ScreenUtil().setHeight(50),
// minWidth: ScreenUtil().setWidth(230),
// child: RaisedButton(
// color: Colors.blue,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10)),
// splashColor: Colors.white.withAlpha(40),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: <Widget>[
// Text('Share App',
// textAlign: TextAlign.center),
// SizedBox(
// width: ScreenUtil().setWidth(10)),
// Icon(Icons.share),
// ],
// ),
//

//
// //===================================================
// //Perform a function when you press the share button
// //===================================================
// onPressed: () {
// setState(() {
// Share.share(
// 'https://google.com',
// subject: 'FlutterX UI',
// );
// });
// },
// ))),
