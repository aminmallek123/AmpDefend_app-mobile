import 'package:ampdefend/incidentPage.dart';
import 'package:ampdefend/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AMPDefendApp());
}

class AMPDefendApp extends StatelessWidget {
  const AMPDefendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMPDefend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        fontFamily: 'Segoe UI',
      ),
      home: LoginPage(),
    );
  }
}

// ------------------ MAIN SCREEN WITH NAVIGATION ------------------
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    IncidentPage(),
    SettingsPage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ------------------ HOME SCREEN ------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', false);
            await FirebaseAuth.instance.signOut();

            // 🚪 Déconnexion = retour vers LoginPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        title: const Text("Home"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HeaderSection(),
              SizedBox(height: 16),
              MapCard(),
              SizedBox(height: 16),
              RecentActivityCard(),
              SizedBox(height: 16),
              SelectedSourceCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ HEADER ------------------
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AMPDefend',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE6EDF7),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Live Attack Map',
          style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF121A2B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF223050)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF4D4F), Color(0xFFFF7875)],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'VPN ~ 80%',
                style: TextStyle(fontSize: 12, color: Color(0xFFE6EDF7)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ------------------ DATA MODELS ------------------
class Node {
  final Offset position;
  final List<Color> colors;
  final String label;
  Node({required this.position, required this.colors, required this.label});
}

class AttackPath {
  final Offset from;
  final Offset to;
  final Color color;
  AttackPath({required this.from, required this.to, required this.color});
}

class Activity {
  final Color color;
  final String title;
  final String subtitle;
  Activity({required this.color, required this.title, required this.subtitle});
}

// ------------------ MAP CARD ------------------
class MapCard extends StatelessWidget {
  const MapCard({super.key});

  @override
  Widget build(BuildContext context) {
    final nodes = [
      Node(
        position: const Offset(60, 60),
        colors: [Color(0xFFFF4D4F), Color(0xFFFF7875)],
        label: "Attacker",
      ),
      Node(
        position: const Offset(140, 110),
        colors: [Color(0xFF5B8CFF), Color(0xFF7EC8FF)],
        label: "VPN",
      ),
      Node(
        position: const Offset(210, 160),
        colors: [Color(0xFF52C41A), Color(0xFF52C41A)],
        label: "EV Decoy",
      ),
      Node(
        position: const Offset(270, 220),
        colors: [Color(0xFF52C41A), Color(0xFF52C41A)],
        label: "SM Decoy",
      ),
    ];

    final paths = [
      AttackPath(
        from: const Offset(68, 68),
        to: const Offset(140, 110),
        color: const Color(0xFFFF4D4F),
      ),
      AttackPath(
        from: const Offset(140, 110),
        to: const Offset(210, 160),
        color: const Color(0xFF5B8CFF),
      ),
      AttackPath(
        from: const Offset(210, 160),
        to: const Offset(270, 220),
        color: const Color(0xFF52C41A),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1C2540)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: MapGridPainter())),
            Positioned.fill(
              child: CustomPaint(painter: AttackPathPainter(paths)),
            ),
            ...nodes.map(
              (n) => Positioned(
                left: n.position.dx,
                top: n.position.dy,
                child: NodeWidget(color: n.colors, label: n.label),
              ),
            ),
            const Positioned(top: 10, left: 10, child: EventToast()),
          ],
        ),
      ),
    );
  }
}

// ------------------ GRID & PATHS ------------------
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1F2A47)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += 58) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AttackPathPainter extends CustomPainter {
  final List<AttackPath> paths;
  AttackPathPainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    for (var path in paths) {
      final paint = Paint()
        ..color = path.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawLine(path.from, path.to, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ------------------ NODE WIDGET ------------------
class NodeWidget extends StatelessWidget {
  final List<Color> color;
  final String label;
  const NodeWidget({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }
}

// ------------------ EVENT TOAST ------------------
class EventToast extends StatelessWidget {
  const EventToast({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1628),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF223050)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.warning, size: 14, color: Color(0xFFFF4D4F)),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Intrusion detected',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE6EDF7),
                ),
              ),
              Text(
                'OCPP probe • 203.0.113.25',
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------ RECENT ACTIVITY ------------------
class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      Activity(
        color: const Color(0xFFFF4D4F),
        title: "OCPP BootNotification",
        subtitle: "from 203.0.113.25",
      ),
      Activity(
        color: const Color(0xFF5B8CFF),
        title: "Modbus Read (FC3)",
        subtitle: "to :502",
      ),
      Activity(
        color: const Color(0xFF52C41A),
        title: "IEC104 Interrogation",
        subtitle: "to :2404",
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1C2540)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Activity",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE6EDF7),
            ),
          ),
          const SizedBox(height: 16),
          ...activities.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: a.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      a.title,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE6EDF7),
                      ),
                    ),
                  ),
                  Text(
                    a.subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ SELECTED SOURCE ------------------
class SelectedSourceCard extends StatelessWidget {
  const SelectedSourceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1C2540)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Source',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE6EDF7),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'IP 203.0.113.25 • VPN Likelihood ~ 80%',
            style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
          const Text(
            'ASN: AS14618 (Example) • Region: EU',
            style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1628),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF223050)),
              ),
              child: const Text(
                'Block IP',
                style: TextStyle(fontSize: 12, color: Color(0xFFE6EDF7)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ DYNAMIC BOTTOM NAVBAR ------------------
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.map, 'label': 'Map'},
      {'icon': Icons.warning, 'label': 'Incidents'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF0B1220),
        border: Border(top: BorderSide(color: Color(0xFF1C2540))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          return GestureDetector(
            onTap: () => onTap(index),
            child: _NavItem(
              icon: item['icon'] as IconData,
              label: item['label'] as String,
              isActive: currentIndex == index,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: isActive ? const Color(0xFF5B8CFF) : const Color(0xFF94A3B8),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? const Color(0xFFE6EDF7) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}

// ------------------ ALERT MODEL ------------------
class Alert {
  final String id;
  final String alertType;
  final String deviceId;
  final String rawMessage;
  final String severity;
  final String timestamp;
  final String uploadedAt;

  Alert({
    required this.id,
    required this.alertType,
    required this.deviceId,
    required this.rawMessage,
    required this.severity,
    required this.timestamp,
    required this.uploadedAt,
  });

  factory Alert.fromMap(String id, Map<dynamic, dynamic> map) {
    return Alert(
      id: id,
      alertType: map['alert_type'] ?? '',
      deviceId: map['device_id'] ?? '',
      rawMessage: map['raw_message'] ?? '',
      severity: map['severity'] ?? '',
      timestamp: map['timestamp'] ?? '',
      uploadedAt: map['uploaded_at'] ?? '',
    );
  }
}

// ------------------ SETTINGS PAGE ------------------
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseReference _alertsRef = FirebaseDatabase.instance.ref().child(
    'alerts',
  );

  List<Alert> alertsList = [];

  @override
  void initState() {
    super.initState();
    _fetchAlerts();
  }

  void _fetchAlerts() async {
    final snapshot = await _alertsRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<Object?, Object?>;
      final List<Alert> tempList = [];
      data.forEach((key, value) {
        tempList.add(Alert.fromMap(key.toString(), value as Map));
      });
      setState(() {
        alertsList = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: ListView.builder(
        itemCount: alertsList.length,
        itemBuilder: (context, index) {
          final alert = alertsList[index];
          return ListTile(
            title: Text(alert.alertType),
            subtitle: Text('${alert.deviceId} - ${alert.timestamp}'),
            trailing: Text(alert.severity),
          );
        },
      ),
    );
  }
}
