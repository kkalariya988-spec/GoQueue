import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/mock_user_data.dart';
import '../../data/models/salon.dart';
import '../../presentation/widgets/salon_card.dart';

/// Customer panel "Salons" tab.
///
/// Shows the top salons near the user as a responsive card grid. Each card
/// carries an [onView] (open the salon detail) and an [onBook] (start the
/// booking flow). The temporary placeholder copy is swapped for the real
/// detail/booking screens in the next iterations.
class SalonsListPage extends StatelessWidget {
  const SalonsListPage({super.key});

  static void navigateToSalon(BuildContext context, Salon salon) {
    Navigator.pushNamed(
      context,
      RouteNames.userSalonDetails,
      arguments: salon,
    );
  }

  static void _bookAppointment(BuildContext context, Salon salon) {
    Navigator.pushNamed(
      context,
      RouteNames.userSalonDetails,
      arguments: salon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: AppScaffold(
        title: 'Salons',
        subtitle: 'Start your appointment',
        body: _SalonsListBody(),
      ),
    );
  }
}

class _SalonsListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = AppSpacing.pagePadding(constraints.maxWidth);
        return ListView(
          padding: EdgeInsets.fromLTRB(padding, 8, padding, 12),
          children: [_SectionWithHeader(), SizedBox(height: 12), _SalonGrid()],
        );
      },
    );
  }
}

class _SectionWithHeader extends StatelessWidget {
  const _SectionWithHeader();

  @override
  Widget build(BuildContext context) {
    return const SectionHeader(title: 'Top Salons Near You');
  }
}

class _SalonGrid extends StatelessWidget {
  const _SalonGrid();

  static const double _gap = 12;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final columns = width >= 1100 ? 3 : (width >= 600 ? 2 : 1);
        final cardWidth = (width - _gap * (columns - 1)) / columns;

        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: _cardList(context, cardWidth),
        );
      },
    );
  }
}

List<Widget> _cardList(BuildContext context, double width) {
  final list = <Widget>[];
  for (var i = 0; i < MockUserData.topSalons.length; i++) {
    final salon = MockUserData.topSalons[i];
    list.add(
      SizedBox(
        width: width,
        child: SalonCard(
          salon: salon,
          paletteIndex: i,
          onView: () => SalonsListPage.navigateToSalon(context, salon),
          onBook: () => SalonsListPage._bookAppointment(context, salon),
        ),
      ),
    );
  }
  return list;
}
