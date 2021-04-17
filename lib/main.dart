import 'package:flutter/material.dart';
import 'package:myapp/services/api_client.dart';
import 'package:myapp/widgets/drop_down.dart';

void main() {
  runApp(MyApp());
}

// สร้าง widget Stateless คือ จะไม่สามารถเปลี่ยนแปลงค่าได้
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      home: MyHomePage(),
    );
  }
}

// สร้าง widget Stateful คือ จะสามารถเปลี่ยนแปลงค่าได้ ควบคุมการทำงานของแอพตามที่ต้องการ
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // create an instance of the API Client
  ApiClient client = ApiClient();
  //ตั้งค่า main colors
  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);
  //ตั้งค่าตัวแปร
  List<String> currencies;
  String from;
  String to;

  //variables for exchange rate
  double rate;
  String result = "";

  // ฟังก์ชันเรียก api
  Future<List<String>> getCurrencyList() async {
    return await client.getCurrencies();
  }

  void initState() {
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 300.0,
              child: Text(
                "แปลงสกุลเงิน",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Text Field
                  TextField(
                    onSubmitted: (value) async {
                      //เรียกใช้ฟังก์ชัน exchange rate
                      rate = await client.getRate(from, to);
                      setState(() {
                        result =
                            (rate * double.parse(value)).toStringAsFixed(3);
                      });
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "ป้อนค่าเงินที่ต้องการแปลง",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          color: secondColor,
                        )),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // สร้าง widget dropdown button
                      customDropDown(currencies, from, (val) {
                        setState(() {
                          from = val;
                        });
                      }),
                      FloatingActionButton(
                        onPressed: () {
                          String temp = from;
                          setState(() {
                            from = to;
                            to = temp;
                          });
                        },
                        child: Icon(Icons.swap_horiz),
                        elevation: 0.0,
                        backgroundColor: secondColor,
                      ),
                      customDropDown(currencies, to, (val) {
                        setState(() {
                          to = val;
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Text("Result",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          result,
                          style: TextStyle(
                            color: secondColor,
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      )),
    );
  }
}
