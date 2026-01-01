import 'package:modibbogirei/features/screens/pages/populate_mobile.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/layouts/templates/site_layout.dart';

class PopulatingPage extends StatelessWidget {
  const PopulatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      mobile: PopulateMobile(),
      desktop: PopulateMobile(),
      tablet: PopulateMobile(),
    );
  }
}
