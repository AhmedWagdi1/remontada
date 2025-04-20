import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({super.key});

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              "Splash".png("images"),
            ),
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.system_update, size: 50, color: Colors.blue),
                SizedBox(height: 15),
                Text(
                  'تحديث جديد متاح!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'يرجى تحديث التطبيق للحصول على آخر الميزات وتحسينات الأداء.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Expanded(
                    //   flex: 2,
                    //   child: TextButton(
                    //     child: Text('لاحقاً'),
                    //     onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    //       context,
                    //       route,
                    //       (route) => false,
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          launchUrl(
                            Platform.isAndroid
                                ? Uri.parse(
                                    "https://play.google.com/store/apps/details?id=com.masader.remontada",
                                  )
                                : Uri.parse(
                                    "https://apps.apple.com/us/app/6550914902",
                                  ),
                            mode: LaunchMode.platformDefault,
                          );
                        },
                        child: Text(
                          'تحديث الآن',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
