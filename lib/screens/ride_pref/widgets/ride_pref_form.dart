import 'package:flutter/material.dart';
import 'package:my_app/screens/ride_pref/widgets/location_picker.dart';
import 'package:my_app/utils/animations_util.dart';

import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../widgets/display/bla_divider.dart';
import '../../../widgets/actions/bla_button.dart';
import '../../../theme/theme.dart';

class RidePrefForm extends StatefulWidget {
  final RidePref? initRidePref;
  final ValueChanged<RidePref> onSubmit;

  const RidePrefForm({
    super.key,
    this.initRidePref,
    required this.onSubmit,
  });

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  Location? arrival;
  late DateTime departureDate;
  late int requestedSeats;

  bool get _isFormValid =>
      departure != null &&
      arrival != null &&
      departureDate.isAfter(DateTime.now());

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    final pref = widget.initRidePref;
    departure = pref?.departure;
    arrival = pref?.arrival;
    departureDate = pref?.departureDate ?? DateTime.now();
    requestedSeats = pref?.requestedSeats ?? 1;
  }

  void _handleDepartureSelected(Location location) {
    setState(() {
      departure = location;
    });
  }

  void _handleArrivalSelected(Location location) {
    setState(() {
      arrival = location;
    });
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      departureDate = date;
    });
  }

  void _handleSeatsChanged(int seats) {
    setState(() {
      requestedSeats = seats;
    });
  }

  void _handleSubmit() {
    if (_isFormValid) {
      widget.onSubmit(RidePref(
        departure: departure!,
        arrival: arrival!,
        departureDate: departureDate,
        requestedSeats: requestedSeats,
      ));
    }
  }

  void _handleLocationSwitch() {
    setState(() {
      if (departure != null && arrival != null) {
        final temp = departure;
        departure = arrival;
        arrival = temp;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLocationField(
                      hint: 'Leaving from',
                      initialLocation: departure,
                      onLocationSelected: _handleDepartureSelected,
                      icon: Icons.radio_button_checked_outlined,
                    ),
                    IconButton(
                      icon: const Icon(Icons.swap_vert),
                      onPressed: _handleLocationSwitch,
                      color: BlaColors.neutralLight,
                      tooltip: 'Switch locations',
                    ),
                  ],
                ),
                const BlaDivider(),
                _buildLocationField(
                  hint: 'Going to',
                  initialLocation: arrival,
                  onLocationSelected: _handleArrivalSelected,
                  icon: Icons.radio_button_checked_outlined,
                ),
                const BlaDivider(),
                _buildDateField(),
                const BlaDivider(),
                _buildPassengerField(),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: BlaButton(
              label: 'Search',
              onPressed: _handleSubmit,
              style: BlaButtonStyle.filled,
              icon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required String hint,
    required Location? initialLocation,
    required ValueChanged<Location> onLocationSelected,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        _showLocationPicker(initialLocation, onLocationSelected);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BlaSpacings.s),
        child: Row(
          children: [
            Icon(icon, color: BlaColors.neutralLight, size: 24),
            const SizedBox(width: BlaSpacings.m),
            Text(
              initialLocation?.name ?? hint,
              style: BlaTextStyles.body.copyWith(
                color: initialLocation != null
                    ? BlaColors.textNormal
                    : BlaColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: departureDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (selectedDate != null) {
          _handleDateSelected(selectedDate);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BlaSpacings.s),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined,
                color: BlaColors.neutralLight, size: 24),
            const SizedBox(width: BlaSpacings.m),
            Text(
              "${departureDate.day}/${departureDate.month}/${departureDate.year}",
              style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerField() {
    return InkWell(
      onTap: () async {
        int? selectedSeats = await showModalBottomSheet<int>(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Select number of passengers"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        icon: Text("${index + 1}"),
                        onPressed: () {
                          Navigator.pop(context, index + 1);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

        if (selectedSeats != null) {
          _handleSeatsChanged(selectedSeats);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BlaSpacings.s),
        child: Row(
          children: [
            Icon(Icons.person_outline, color: BlaColors.neutralLight, size: 24),
            const SizedBox(width: BlaSpacings.m),
            Text(
              '$requestedSeats',
              style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLocationPicker(
    Location? initialLocation,
    ValueChanged<Location> onLocationSelected,
  ) async {
    final Location? result = await Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        LocationPickerScreen(initialQuery: initialLocation?.name),
      ),
    );

    if (result != null) {
      onLocationSelected(result);
    }
  }
}
