import 'package:flutter/material.dart';
import 'package:psychology_cu/screen/home/components/headline.dart';
import 'package:psychology_cu/widget/custom_button.dart';

class CommunityScreen extends StatelessWidget {
  static const routeName = 'community_screen';

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: Text('Student Community'),
        // centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  'assets/images/dept_1.jpg',
                  fit: BoxFit.cover,
                  width: mediaQuery.width,
                  height: mediaQuery.height / 2.8,
                ),
                Container(
                  width: mediaQuery.width,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey.shade300.withOpacity(.5),
                  child: Text(
                    'Welcome to\nDepartment of Psychology'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1,
                    ),
                    // textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            // SizedBox(height: 16),
            Flexible(
              flex: 3,
              child: Container(
                width: mediaQuery.width,
                padding: EdgeInsets.fromLTRB(16,8,16,16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Headline(
                        title: 'Message from Chairman', noLeftPadding: true),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 4,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: AssetImage(
                                  'assets/images/bd_sir.jpg',
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Biplob Kumar Dey',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text('Assistant Professor'),
                                  ],
                                ),
                              ),
                              CustomButton(
                                type: 'tel:',
                                link: '01717810567',
                                icon: Icons.call,
                                color: Colors.green,
                              ),
                              SizedBox(width: 16
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                            'Welcome to the Department of Psychology, University of Chittagong. Psychology explores human (and animal) behavior, cognition, and emotion, and in doing so, plays a very significant role within other scientific disciplines. Psychology is the science of the human mental world and the human behavioral pattern. It is also an interdisciplinary discipline that employs the comprehensive use of behavioral measures and cutting-edge techniques. Psychological experiments lead to scientific discovery that can be applied to humans at both an individual and a societal level.'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Headline(
                      title: 'About',
                      noLeftPadding: true,
                    ),
                    Text(
                        'The Department of Psychology was established in 2005 under Biological Sciences Faculty with the headship of Professor Dr. Anisul Islam. It is located at the ground floor of Biological Sciences Building.',
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(height: 8),
                    Text(
                        'The Department has a total strength of 17 teaching faculties. The teaching and research program is supported by the technical staff at different levels. Apart from the student laboratory, meant for the practicum work for the students at the Honours and Master’s level, we have a research lab, equipped with necessary amenities. Moreover, the Seminar room is equipped with the State-of-the-Art facilities. Presently, the best and latest technology gadgets have been procured and set up to enhance the teaching and research activities. The M.S. Psychology Courses include the latest trends in Psychology, with emphasis on practical training and field work.  The courses lay special emphasis on the acquisition of knowledge and skills through theoretical understanding and its practical implications. The Department has already initiated the process of revising all the courses at the undergraduate and postgraduate level. In addition, to lecturing as the primary mode of instruction, teaching is also interactive with the emphasis on the seminar, presentations, and discussions and also experiential exercises and peer mentoring.',
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(height: 16),
                    Image.asset(
                      'assets/images/dept_2.jpg',
                      fit: BoxFit.fill,
                      width: mediaQuery.width,
                      height: mediaQuery.height / 4,
                    ),
                    SizedBox(height: 16),
                    Text(
                        'Furthermore, the Departmental teaching, research, and field training are centered around contemporary issues as stress and health, ageing, community mental health, parenting style, neuropsychological assessment and cross-cultural psychology, etc. A large number of our Master’s students after completing their degrees are employed by different organizations/ hospitals dealing with these issues. From time to time, the Department organizes seminars, refresher course, training, workshops, etc. for the benefit of faculty and students. In addition, many research projects have also been undertaken.',
                        style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
