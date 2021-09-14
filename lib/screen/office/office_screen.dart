import 'package:flutter/material.dart';
import 'package:psychology_cu/screen/office/stuff_list.dart';
import 'cr_list.dart';

class OfficeScreen extends StatelessWidget {
  static const routeName = 'office_screen';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('CR & Office Stuff'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Class Representative'),
              Tab(text: 'Office Stuff'),
            ],
            labelPadding: EdgeInsets.all(4),
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
          ),
        ),

        body: TabBarView(
          children: [
            //cr list
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  children: [
                    CrList(year: '1st Year'),
                    SizedBox(height: 8),
                    CrList(year: '2nd Year'),
                    SizedBox(height: 8),
                    CrList(year: '3rd Year'),
                    SizedBox(height: 8),
                    CrList(year: '4th Year'),
                  ],
                ),
              ),
            ),

            // stuff list
            StuffList(),
          ],
        ),
      ),
    );
  }
}
