import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'services/location_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService();

  // State variables
  String _displayText = '';
  Position? _currentPosition;
  String? _errorMessage;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    // Try to get location when app starts
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        if (position != null) {
          _displayText = _locationService.formatLocation(position);
        }
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingLocation = false;
        _displayText = 'Please enter a city name to get weather information';
      });

      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _searchLocation() {
    // Implement search functionality
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _displayText = _searchController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Searching for: ${_searchController.text}')),
      );
      _searchController.clear(); // Clear the search field after searching
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Helper method to build tab content
  Widget _buildTabContent(String tabName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tabName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Show loading indicator when fetching location
            if (_isLoadingLocation)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Getting your location...'),
                ],
              )
            // Show error message if there's an error
            else if (_errorMessage != null)
              Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to access location',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please enter a city name in the search bar',
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            // Show location information when available
            else if (_currentPosition != null)
              Column(
                children: [
                  const Icon(Icons.location_on, color: Colors.green, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Current Location',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _displayText,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ready to fetch weather data',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              )
            // Show a default message
            else
              const Text(
                'Search for a location or use your current location',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  filled: true,
                  fillColor: Colors.white.withAlpha((0.85 * 255).round()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchLocation,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchLocation(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.my_location, color: Colors.white),
              onPressed: _getLocation,
              tooltip: 'Get current location',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent('Currently'),
          _buildTabContent('Today'),
          _buildTabContent('Weekly'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Currently',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_week),
            label: 'Weekly',
          ),
        ],
        currentIndex: _tabController.index,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          _tabController.animateTo(index);
        },
      ),
    );
  }
}
