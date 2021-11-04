import 'package:flutter/material.dart';

import '/screen/office/stuff_list.dart';
import 'cr_list.dart';

class OfficeScreen extends StatelessWidget {
  static const routeName = 'office_screen';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CR & Office Stuff'),
          centerTitle: true,
          bottom: const TabBar(
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
            Scrollbar(
              radius: const Radius.circular(8),
              interactive: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    children: const [
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
            ),

            // stuff list
            const StuffList(),
          ],
        ),
      ),
    );
  }
}
