import 'package:daakia_vc_flutter_sdk/daakia_vc_flutter_sdk.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: SafeArea(child: DataEntryScreen()),
      ),
    );
  }
}

class DataEntryScreen extends StatefulWidget {
  const DataEntryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DataEntryState();
  }
}

class _DataEntryState extends State<DataEntryScreen> {
  var licenseKey = "0D16716AFADABE17F5A42C6642CF2711ED9F59F2C89C12B2";
  var meetingUID = "1882ddccfc107d54667849fe";
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
              decoration: const InputDecoration(
                labelText: 'License Key*',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
              enabled: true,
              onChanged: (String? value) {
                setState(() {
                  licenseKey = value ?? "";
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Meeting UID*',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
              enabled: true,
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
                      isHost = isSelected;
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
