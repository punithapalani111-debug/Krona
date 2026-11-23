
import 'package:flutter/material.dart';

const String APP_USERNAME = 'Krona';
const String APP_PASSWORD = '18052013';

void main() {
  runApp(const KronaApp());
}

const Color oceanBlue = Color(0xFF00BFFF);
const Color darkBackground = Color(0xFF101820);

class KronaApp extends StatelessWidget {
  const KronaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'A.KRONA',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: oceanBlue,
          secondary: oceanBlue,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool hidePassword = true;
  String error = '';

  void login() {
    if (username.text.trim() == APP_USERNAME &&
        password.text == APP_PASSWORD) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainDashboard(),
        ),
      );
    } else {
      setState(() => error = 'Incorrect username or password');
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.smart_toy,
                    size: 90, color: oceanBlue),
                const SizedBox(height: 12),
                const Text('A.KRONA',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: oceanBlue,
                    )),
                const Text('ROBOT CONTROL SYSTEM',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 40),
                TextField(
                  controller: username,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: password,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() => hidePassword = !hidePassword);
                      },
                    ),
                  ),
                  onSubmitted: (_) => login(),
                ),
                const SizedBox(height: 12),
                Text(error, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text('LOGIN'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int selected = 0;
  bool connected = false;
  bool voiceEnabled = true;
  bool guestMode = false;
  bool demoMode = false;
  bool sleepMode = false;
  String emotion = 'Happy';

  final pages = const [
    HomePage(),
    RemotePage(),
    VoicePage(),
    ModesPage(),
    SettingsPage(),
  ];

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A.KRONA'),
        backgroundColor: const Color(0xFF172B3A),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF172B3A),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(Icons.circle, size: 12,
                    color: connected ? Colors.green : Colors.red),
                const SizedBox(width: 10),
                Text(connected ? 'Robot Connected' : 'Robot Offline'),
                const Spacer(),
                Switch(
                  value: connected,
                  onChanged: (v) => setState(() => connected = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: selected,
              children: [
                HomePage(emotion: emotion),
                const RemotePage(),
                VoicePage(
                  enabled: voiceEnabled,
                  onChanged: (v) => setState(() => voiceEnabled = v),
                ),
                ModesPage(
                  guest: guestMode,
                  demo: demoMode,
                  sleep: sleepMode,
                  onGuest: (v) => setState(() => guestMode = v),
                  onDemo: (v) => setState(() => demoMode = v),
                  onSleep: (v) => setState(() => sleepMode = v),
                ),
                const SettingsPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (v) => setState(() => selected = v),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.gamepad), label: 'Remote'),
          NavigationDestination(
              icon: Icon(Icons.mic), label: 'Voice'),
          NavigationDestination(
              icon: Icon(Icons.tune), label: 'Modes'),
          NavigationDestination(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String emotion;
  const HomePage({super.key, this.emotion = 'Happy'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('HELLO! I AM KRONA',
              style: TextStyle(fontSize: 20, color: oceanBlue)),
          const SizedBox(height: 25),
          Container(
            width: 190,
            height: 125,
            decoration: BoxDecoration(
              color: const Color(0xFF172B3A),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: oceanBlue, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _RobotEye(),
                _RobotEye(),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text('Emotion: $emotion',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          const Text('A.KRONA Robot Assistant',
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _RobotEye extends StatelessWidget {
  const _RobotEye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 55,
      decoration: BoxDecoration(
        color: oceanBlue,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: oceanBlue, blurRadius: 15),
        ],
      ),
    );
  }
}

class RemotePage extends StatelessWidget {
  const RemotePage({super.key});

  Widget controlButton(
      BuildContext context, IconData icon, String label) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label command selected')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Icon(icon, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('REMOTE CONTROL',
              style: TextStyle(fontSize: 20, color: oceanBlue)),
          const SizedBox(height: 20),
          controlButton(context, Icons.arrow_upward, 'Forward'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controlButton(context, Icons.arrow_back, 'Left'),
              const SizedBox(width: 15),
              controlButton(context, Icons.stop, 'Stop'),
              const SizedBox(width: 15),
              controlButton(context, Icons.arrow_forward, 'Right'),
            ],
          ),
          controlButton(context, Icons.arrow_downward, 'Backward'),
          const SizedBox(height: 15),
          const Text('Demo controls only'),
        ],
      ),
    );
  }
}

class VoicePage extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  const VoicePage({
    super.key,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.mic, size: 80, color: oceanBlue),
          const Text('VOICE CONTROL',
              style: TextStyle(fontSize: 22)),
          Switch(
            value: enabled,
            onChanged: onChanged,
          ),
          Text(enabled ? 'Voice enabled' : 'Voice disabled'),
          const SizedBox(height: 12),
          const Text('Wake phrase: Hey Krona'),
          const Text('English • Tamil • Hindi'),
        ],
      ),
    );
  }
}

class ModesPage extends StatelessWidget {
  final bool guest;
  final bool demo;
  final bool sleep;
  final ValueChanged<bool>? onGuest;
  final ValueChanged<bool>? onDemo;
  final ValueChanged<bool>? onSleep;

  const ModesPage({
    super.key,
    this.guest = false,
    this.demo = false,
    this.sleep = false,
    this.onGuest,
    this.onDemo,
    this.onSleep,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('ROBOT MODES',
            style: TextStyle(fontSize: 22, color: oceanBlue)),
        SwitchListTile(
          title: const Text('Guest Mode'),
          value: guest,
          onChanged: onGuest,
        ),
        SwitchListTile(
          title: const Text('Demo Mode'),
          value: demo,
          onChanged: onDemo,
        ),
        SwitchListTile(
          title: const Text('Sleep Mode'),
          value: sleep,
          onChanged: onSleep,
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text('SETTINGS',
            style: TextStyle(fontSize: 22, color: oceanBlue)),
        ListTile(
          leading: Icon(Icons.wifi),
          title: Text('Wi-Fi Connection'),
          subtitle: Text('Robot network setup'),
        ),
        ListTile(
          leading: Icon(Icons.security),
          title: Text('Security'),
          subtitle: Text('Account and access settings'),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('About A.KRONA'),
          subtitle: Text('Robot control application'),
        ),
      ],
    );
  }
}
