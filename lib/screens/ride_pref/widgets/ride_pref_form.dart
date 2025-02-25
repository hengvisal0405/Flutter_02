import 'package:flutter/material.dart';

import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../widgets/display/bla_divider.dart';
import '../../../widgets/actions/bla_button.dart';
import '../../../theme/theme.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;

  /// Callback triggered when form is submitted with valid data
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
  /// Selected departure location
  Location? departure;

  /// Selected arrival location
  Location? arrival;

  /// Selected travel date
  late DateTime departureDate;

  /// Number of passengers
  late int requestedSeats;

  /// Form is valid when both locations are selected and date is in the future
  bool get _isFormValid =>
      departure != null &&
      arrival != null &&
      departureDate.isAfter(DateTime.now());

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  /// Initialize form fields from provided RidePref or defaults
  void _initializeFormData() {
    final pref = widget.initRidePref;
    departure = pref?.departure;
    arrival = pref?.arrival;
    departureDate = pref?.departureDate ?? DateTime.now();
    requestedSeats = pref?.requestedSeats ?? 1;
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  void _handleDepartureSelected(Location location) {}

  void _handleArrivalSelected(Location location) {}

  void _handleDateSelected(DateTime date) {}

  void _handleSeatsChanged(int seats) {}

  /// Creates and submits a RidePref object when form is valid
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

  /// Switches departure and arrival locations if both are set
  void _handleLocationSwitch() {
    setState(() {
      if (departure != null && arrival != null) {
        // Only swap if both locations are set
        final temp = departure;
        departure = arrival;
        arrival = temp;
      }
    });
  }

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Departure location field
                    _buildLocationField(
                      hint: 'Leaving from',
                      initialLocation: departure,
                      onLocationSelected: _handleDepartureSelected,
                      icon: Icons.radio_button_checked_outlined,
                    ),
                    // Add switch button between locations
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.swap_vert),
                        onPressed: _handleLocationSwitch,
                        color: BlaColors.neutralLight,
                        tooltip: 'Switch locations',
                      ),
                    ),
                  ],
                ),
                const BlaDivider(),
                // Arrival location field
                _buildLocationField(
                  hint: 'Going to',
                  initialLocation: arrival,
                  onLocationSelected: _handleArrivalSelected,
                  icon: Icons.radio_button_checked_outlined,
                ),
                const BlaDivider(),

                // Date selection field
                _buildDateField(),
                const BlaDivider(),

                // Passenger count field
                _buildPassengerField(),
                //const SizedBox(height: BlaSpacings.xl),
              ],
            ),
          ),
          // Submit button
         SizedBox(
            width: double.infinity,
            child: BlaButton(
              label: 'Search',
              onPressed: _handleSubmit,
              style:
                  BlaButtonStyle.filled, // Make sure to set the style as needed
              icon: Icon(Icons.search), // Optional: Add an icon if desired
            ),
          ),

        ],
      ),
    );
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  /// Builds a location selection field with icon and text
  Widget _buildLocationField({
    required String hint,
    required Location? initialLocation,
    required ValueChanged<Location> onLocationSelected,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        // TODO: Implement location selection
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BlaSpacings.s),
        child: Row(
          children: [
            Icon(
              icon,
              color: BlaColors.neutralLight,
              size: 24,
            ),
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

  /// Builds the date selection field
  Widget _buildDateField() {
    return InkWell(
      onTap: () {
        // TODO: Implement date selection
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BlaSpacings.s),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color: BlaColors.neutralLight,
              size: 24,
            ),
            const SizedBox(width: BlaSpacings.m),
            Text(
              'Today',
              style: BlaTextStyles.body.copyWith(
                color: BlaColors.textNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the passenger count selection field
  Widget _buildPassengerField() {
    return InkWell(
      onTap: () {
        // TODO: Implement passenger selection
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BlaSpacings.s),
        child: Row(
          children: [
            Icon(
              Icons.person_outline,
              color: BlaColors.neutralLight,
              size: 24,
            ),
            const SizedBox(width: BlaSpacings.m),
            Text(
              '$requestedSeats',
              style: BlaTextStyles.body.copyWith(
                color: BlaColors.textNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
