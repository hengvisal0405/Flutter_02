import 'package:flutter/material.dart';
import 'package:my_app/dummy_data/dummy_data.dart';
import 'package:my_app/model/ride/locations.dart';
import 'package:my_app/theme/theme.dart';
import '../../../widgets/display/bla_divider.dart';

class LocationPickerScreen extends StatefulWidget {
  final String? initialQuery;

  const LocationPickerScreen({
    super.key,
    this.initialQuery,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Location> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
    if (widget.initialQuery?.isNotEmpty ?? false) {
      _onSearchChanged(); // Only filter if there's an initial query
    }
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty || query.length < 2) {
        _filteredLocations = []; // Clear the list when search is empty
      } else {
        _filteredLocations = fakeLocations.where((location) {
          return location.name.toLowerCase().startsWith(query);
        }).toList();

        // Sort the filtered locations alphabetically by name
        _filteredLocations.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BlaColors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_sharp, color: BlaColors.neutralLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          margin: EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: BlaColors.backgroundAccent,
            borderRadius: BorderRadius.circular(BlaSpacings.radius),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Station Road or The Bridge Cafe',
                    hintStyle: BlaTextStyles.body.copyWith(
                      color: BlaColors.neutralLight,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: BlaSpacings.m,
                      vertical: 8,
                    ),
                  ),
                  style: BlaTextStyles.body.copyWith(
                    color: BlaColors.neutralDark,
                  ),
                  autofocus: true,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: BlaColors.neutralLight),
                onPressed: () {
                  if (_searchController.text.isEmpty) {
                    Navigator.pop(context, null);
                  } else {
                    _searchController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (_searchController.text.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Type a city name',
                  style: TextStyle(
                    color: BlaColors.neutralLight,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemCount: _filteredLocations.length,
                  separatorBuilder: (context, index) => const BlaDivider(),
                  itemBuilder: (context, index) {
                    final location = _filteredLocations[index];
                    return ListTile(
                      title: Text(
                        location.name,
                        style: BlaTextStyles.body.copyWith(
                          color: BlaColors.textNormal,
                        ),
                      ),
                      subtitle: Text(
                        location.country.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: BlaColors.neutralLight,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right,
                          color: BlaColors.neutralLight),
                      onTap: () => Navigator.pop(context, location),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
