import 'package:flutter/material.dart';

import '/screen/community/community_screen.dart';
import '/screen/office/office_screen.dart';
import '/screen/student/student_screen.dart';
import '/screen/teacher/teacher_screen.dart';
import '../../../constants.dart';
import '../widgets/category_card.dart';
import 'headline.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //category title
        const Headline(title: 'Categories'),

        //category card grid
        GridView.count(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: .8,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          children: const [
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
