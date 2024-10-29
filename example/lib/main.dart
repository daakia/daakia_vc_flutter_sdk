import 'package:daakia_vc_flutter_sdk/daakia_vc_flutter_sdk.dart';
import 'package:daakia_vc_flutter_sdk/screens/prejoin_screen.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: DataEntryScreen(),
        // body: DaakiaVideoConferenceWidget(meetingId: "f27d52e2ec3f607ddc5b8e68", secretKey: "0D16716AFADABE17F5A42C6642CF2711ED9F59F2C89C12B2"),
      ),
    );
  }
}

class DataEntryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DataEntryState();
  }
}

class _DataEntryState extends State<DataEntryScreen> {
  var licenseKey = "";
  var meetingUID = "";
  var isHost = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              // initialValue: "0D16716AFADABE17F5A42C6642CF2711ED9F59F2C89C12B2",
              decoration: const InputDecoration(
                labelText: 'License Key*', // Equivalent to hint="Name*"
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.black, // Equivalent to textColor="@color/black"
              ),
              enabled: true,
              // Equivalent to android:enabled="false"
              onChanged: (String? value) {
                setState(() {
                  licenseKey = value ?? "";
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              // initialValue: "13f8511dd0f043e6fe2e0091",
              decoration: const InputDecoration(
                labelText: 'Meeting UID*', // Equivalent to hint="Name*"
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.black, // Equivalent to textColor="@color/black"
              ),
              enabled: true, // Equivalent to android:enabled="false"
              onChanged: (String? value) {
                setState(() {
                  meetingUID = value ?? "";
                });
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text("Host"),
                Switch(
                  value: isHost,
                  onChanged: (isSelected) {
                    setState(() {
                      isHost = isSelected; // Directly set isHost to isSelected
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () async {
                  if(licenseKey.isEmpty || meetingUID.isEmpty){
                    Utils.showSnackBar(context, message: "Those fields are mandatory!");
                    return;
                  }
                  await Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DaakiaVideoConferenceWidget(
                              meetingId: meetingUID,
                              secretKey: licenseKey,
                              isHost: isHost,
                            )),
                  );
                },
                child: const Text("Test SDK"))
          ],
        ),
      ),
    );
  }
}
