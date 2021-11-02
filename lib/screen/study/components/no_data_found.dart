import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset('assets/icons/no_data_found.svg',
            height: 140, width: 140),
        const Text('No data found', textAlign: TextAlign.center),
      ],
    );
  }
}
