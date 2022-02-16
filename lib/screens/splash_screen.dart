import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 153, 102, 255),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 153, 102, 255),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          'DIGI',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.white, fontSize: 86),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Divider(
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            child: Container(
                              decoration: BoxDecoration(color:Color.fromARGB(255, 153, 102, 255) ),
                                child: Text(
                              'Mobile',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(color: Colors.white, fontSize: 32),
                            )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Text(
                  'Powered By DigiFin',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
