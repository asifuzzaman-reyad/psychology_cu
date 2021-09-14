import 'package:flutter/material.dart';
import 'package:psychology_cu/screen/community/community_screen.dart';
import 'package:psychology_cu/screen/office/office_screen.dart';
import 'package:psychology_cu/screen/student/student_screen.dart';
import 'package:psychology_cu/screen/teacher/teacher_screen.dart';

import '../../constants.dart';
import 'components/category_card.dart';
import 'components/headline.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //category title
        Headline(title: 'Categories'),

        //category card grid
        GridView.count(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: .8,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          children: [
            CategoryCard(
              title: 'About\nDepartment',
              color: kCardColor1,
              routeName: CommunityScreen.routeName,
            ),
            CategoryCard(
              title: 'Teacher\nInformation',
              color: kCardColor2,
              routeName: TeacherScreen.routeName,
            ),
            CategoryCard(
              title: 'Student\nInformation',
              color: kCardColor3,
              routeName: StudentScreen.routeName,
            ),
            CategoryCard(
              title: 'CR &\nOffice staff',
              color: kCardColor4,
              routeName: OfficeScreen.routeName,
            ),
          ],
        ),
      ],
    );
  }
}