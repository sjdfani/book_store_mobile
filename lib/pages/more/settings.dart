import 'package:book_store_mobile/basic/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<SettingNotifier>().theme;
    var fontSize = context.watch<SettingNotifier>().fontSize;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/more");
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Row(
          children: [
            SizedBox(
              width: 70,
            ),
            Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ),
            SizedBox(width: 9),
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Theme Mode:",
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            Slider(
              min: 0,
              max: 20,
              value: theme == 'light'
                  ? 0
                  : theme == 'blue'
                      ? 10
                      : 20,
              divisions: 2,
              label: "${_value.round()}",
              activeColor: Colors.green[700],
              inactiveColor: Colors.green[200],
              thumbColor: Colors.blue,
              onChanged: (value) async {
                setState(() {
                  _value = value;
                  if (value == 0) {
                    context.read<SettingNotifier>().setTheme('light');
                  } else if (value == 10) {
                    context.read<SettingNotifier>().setTheme('blue');
                  } else {
                    context.read<SettingNotifier>().setTheme('dark');
                  }
                });
              },
            ),
            Center(
              child: Text(
                theme[0].toUpperCase() + theme.substring(1),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Font Size:",
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    context.read<SettingNotifier>().setFont(fontSize - 1);
                  },
                ),
                Text(
                  fontSize.toInt().toString(),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<SettingNotifier>().setFont(fontSize + 1);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
