import 'package:flutter/services.dart';
import 'package:image_to_pdf_sample/main_screen.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController pageCountController = TextEditingController();
  String? _dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
                ],
                controller: widthController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Width',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
                ],
                controller: heightController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Height',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2)
                ],
                controller: pageCountController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Number of Print Page Count',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: DropdownButton(
                hint: _dropDownValue == null
                    ? const Text('Dropdown')
                    : Text(
                        _dropDownValue!,
                        style: const TextStyle(color: Colors.blue),
                      ),
                isExpanded: true,
                iconSize: 30.0,
                style: const TextStyle(color: Colors.blue),
                items: ['A1', 'A2', 'A3', 'A4', 'A5'].map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                    () {
                      _dropDownValue = val;
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: _nextScreen,
                  child: const Text('Next Screen'),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _nextScreen() async {
    final widthX = widthController.text;
    final heightY = heightController.text;
    final pageCount = pageCountController.text;
    final pageSize = _dropDownValue;
    print('Spinner Value : ${_dropDownValue}');

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MainScreen(
              width: widthX,
              height: heightY,
              pageCount: pageCount,
              pageSize: pageSize!)),
    );
  }
}
