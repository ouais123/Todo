import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = "";

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _payload.split("|")[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  "Hello, Owais",
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "You have a new reminder",
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), color: primaryClr),
                child: SingleChildScrollView(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.text_format,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Title",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _payload.split("|")[0],
                        style:const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.description,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Description",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _payload.split("|")[1],
                        style:const TextStyle(
                          color: Colors.white,
                        ),
                        // textAlign:TextAlign.
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_today,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Calender today",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _payload.split("|")[2],
                        style:const TextStyle(
                          color: Colors.white,
                        ),
                        // textAlign:TextAlign.
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
