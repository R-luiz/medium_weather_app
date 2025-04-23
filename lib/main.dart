import 'package:flutter/material.dart';

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

  // State variable to track the displayed text
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  void _getLocation() {
    // Update state for geolocation
    setState(() {
      _displayText = "Geolocation";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Getting current location...')),
    );
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tabName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (_displayText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _displayText,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
        ],
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
                  fillColor: Colors.white.withOpacity(0.85),
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