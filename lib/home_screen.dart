import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {

  //Variables for checking when scan is completed and store the scanned text

  bool isScanComplete = false;
  String scannedText = '';

  //Function to detect the scanned value

  void _onDetect(BarcodeCapture capture) {
    if (!isScanComplete) {
      final String code = capture.barcodes.first.rawValue ?? 'Unknown';
      setState(() {
        isScanComplete = true;
        scannedText = code;
      });
    }
  }

  //Function to retake the scan

  void _retake() {
    setState(() {
      isScanComplete = false;
      scannedText = '';
    });
  }

  //Function to copy the scanned text to Clipboard

  void _copyText() {
    Clipboard.setData(ClipboardData(text: scannedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  //Function to launch url(if the scanned text is detected as an url)

  void _launchURL() async {
    if (await canLaunch(scannedText)) {
      await launch(scannedText);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    //Check if scanned text is a link or not
    final bool isLink = Uri.tryParse(scannedText)?.hasAbsolutePath ?? false;

    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 239, 229, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          //Main Logo
          Expanded(
            flex: 1,
            child: SvgPicture.asset(
              'assets/logo.svg',
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          //Camera region for scanning

          Container(
            height: 292,
            width: 295,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,

            // Using Stack to meet the design requirements

            child: Stack(children: [
              if (!isScanComplete)
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  clipBehavior: Clip.hardEdge,
                  child: MobileScanner(
                    onDetect: _onDetect,
                    fit: BoxFit.fill,
                  ),
                ),

              // Frame where the scanning would take place
              SvgPicture.asset(
                'assets/frame.svg',
              ),

              //Upon completion of scan

              if (isScanComplete)
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Scanned Text',
                        style: TextStyle(
                          fontFamily : 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),

                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 10 , right: 30 , top: 10 , bottom: 10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(241, 239, 229, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: isLink ? _launchURL : null,
                          child: Text(
                            scannedText,
                            style: TextStyle(fontSize: 16,
                              color: isLink ? Colors.blue : Colors.black,
                              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'Roboto',
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _copyText,
                            child: Text('Copy'),
                          ),
                          SizedBox(width: 20,),
                          ElevatedButton(
                            onPressed: _retake,
                            child: Text('Retake'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ]),
          ),


          SizedBox(
            height: MediaQuery.of(context).size.height * 0.007,
          ),

          // Ending text
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      "Scannen Sie den QR-Code",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    "Scannen Sie den QR-Code auf der Unterseite des Gateways, um die Installation fortzusetzen",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic,
                      color: Color(0xff898989),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
        ],
      ),
    );
  }
}
