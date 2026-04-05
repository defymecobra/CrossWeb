import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const EmissionCalculatorApp());
}

class EmissionCalculatorApp extends StatelessWidget {
  const EmissionCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Емісія Твердих Частинок',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF3B82F6),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF10B981),
          surface: Color(0x991E293B),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradients
          Positioned(
            left: MediaQuery.of(context).size.width * 0.15 - 200,
            top: MediaQuery.of(context).size.height * 0.5 - 200,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.15),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.15 - 200,
            top: MediaQuery.of(context).size.height * 0.3 - 200,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.15),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Розрахунок валових викидів',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Тверді частинки (Вугілля, Мазут, Газ) - ПР2',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xFF3B82F6),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white54,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: 'Вугілля'),
                        Tab(text: 'Мазут'),
                        Tab(text: 'Газ'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        CoalTab(),
                        MazutTab(),
                        GasTab(),
                      ],
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

// ======================= GLASS CARD WIDGET =======================
class GlassCard extends StatelessWidget {
  final Widget child;
  final bool highlight;

  const GlassCard({super.key, required this.child, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: highlight 
                ? const Color(0xFF10B981).withOpacity(0.05) 
                : const Color(0xFF1E293B).withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlight ? const Color(0xFF10B981) : const Color(0xFF334155),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ======================= INPUT FIELD WIDGET =======================
class CustomInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomInput({super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A).withOpacity(0.6),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ======================= RESULT ROW =======================
class ResRow extends StatelessWidget {
  final String label;
  final String value;
  const ResRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}

// ======================= COAL TAB (Варіант 4) =======================
class CoalTab extends StatefulWidget {
  const CoalTab({super.key});

  @override
  State<CoalTab> createState() => _CoalTabState();
}

class _CoalTabState extends State<CoalTab> {
  final Map<String, TextEditingController> ctrl = {
    'Qi_r (МДж/кг)': TextEditingController(text: "20.47"),
    'a_vin': TextEditingController(text: "0.8"),
    'A_r (%)': TextEditingController(text: "25.20"),
    'G_vin (%)': TextEditingController(text: "1.5"),
    'eta_zu': TextEditingController(text: "0.985"),
    'B (т)': TextEditingController(text: "672419.96"),
  };

  Map<String, double>? result;

  void _calculate() {
    try {
      double Qi = double.parse(ctrl['Qi_r (МДж/кг)']!.text.replaceAll(',', '.'));
      double aVin = double.parse(ctrl['a_vin']!.text.replaceAll(',', '.'));
      double Ar = double.parse(ctrl['A_r (%)']!.text.replaceAll(',', '.'));
      double G_vin = double.parse(ctrl['G_vin (%)']!.text.replaceAll(',', '.'));
      double etaZu = double.parse(ctrl['eta_zu']!.text.replaceAll(',', '.'));
      double B = double.parse(ctrl['B (т)']!.text.replaceAll(',', '.'));

      double ktv = (pow(10, 6) / Qi) * aVin * (Ar / (100 - G_vin)) * (1 - etaZu);
      double E = pow(10, -6) * ktv * Qi * B;

      setState(() {
        result = {
          'k_tv': ktv,
          'E': E,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть коректні числа')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Спалювання вугілля (Варіант 4)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(color: Color(0xFF334155), height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: ctrl.entries.map((e) => SizedBox(
                        width: 150,
                        child: CustomInput(label: e.key, controller: e.value),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _calculate,
                        child: const Text('РОЗРАХУВАТИ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              if (result != null) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(width: 4, height: 24, color: const Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    const Text('Результати розрахунку', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                GlassCard(
                  highlight: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResRow(label: 'Показник емісії (k_тв), г/ГДж:', value: result!['k_tv']!.toStringAsFixed(2)),
                      const SizedBox(height: 8),
                      ResRow(label: 'Валовий викид (E_тв), т:', value: result!['E']!.toStringAsFixed(2)),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// ======================= MAZUT TAB (Варіант 4) =======================
class MazutTab extends StatefulWidget {
  const MazutTab({super.key});

  @override
  State<MazutTab> createState() => _MazutTabState();
}

class _MazutTabState extends State<MazutTab> {
  final Map<String, TextEditingController> ctrl = {
    'Qi_r (МДж/кг)': TextEditingController(text: "39.48"), // From PR1
    'a_vin': TextEditingController(text: "1.0"),
    'A_r (%)': TextEditingController(text: "0.15"),
    'G_vin (%)': TextEditingController(text: "0.0"), // None for mazut
    'eta_zu': TextEditingController(text: "0.985"),
    'B (т)': TextEditingController(text: "111633.33"), // Variant 4
  };

  Map<String, double>? result;

  void _calculate() {
    try {
      double Qi = double.parse(ctrl['Qi_r (МДж/кг)']!.text.replaceAll(',', '.'));
      double aVin = double.parse(ctrl['a_vin']!.text.replaceAll(',', '.'));
      double Ar = double.parse(ctrl['A_r (%)']!.text.replaceAll(',', '.'));
      double G_vin = double.parse(ctrl['G_vin (%)']!.text.replaceAll(',', '.'));
      double etaZu = double.parse(ctrl['eta_zu']!.text.replaceAll(',', '.'));
      double B = double.parse(ctrl['B (т)']!.text.replaceAll(',', '.'));

      double ktv = (pow(10, 6) / Qi) * aVin * (Ar / (100 - G_vin)) * (1 - etaZu);
      double E = pow(10, -6) * ktv * Qi * B;

      setState(() {
        result = {
          'k_tv': ktv,
          'E': E,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть коректні числа')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Спалювання мазуту (Варіант 4)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(color: Color(0xFF334155), height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: ctrl.entries.map((e) => SizedBox(
                        width: 150,
                        child: CustomInput(label: e.key, controller: e.value),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _calculate,
                        child: const Text('РОЗРАХУВАТИ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              if (result != null) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(width: 4, height: 24, color: const Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    const Text('Результати розрахунку', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                GlassCard(
                  highlight: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResRow(label: 'Показник емісії (k_тв), г/ГДж:', value: result!['k_tv']!.toStringAsFixed(2)),
                      const SizedBox(height: 8),
                      ResRow(label: 'Валовий викид (E_тв), т:', value: result!['E']!.toStringAsFixed(2)),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// ======================= GAS TAB (Варіант 4) =======================
class GasTab extends StatefulWidget {
  const GasTab({super.key});

  @override
  State<GasTab> createState() => _GasTabState();
}

class _GasTabState extends State<GasTab> {
  final Map<String, TextEditingController> ctrl = {
    'B (м3)': TextEditingController(text: "128674.68"), // Variant 4
  };

  Map<String, double>? result;

  void _calculate() {
    try {
      // Natural gas has no solid particle emissions
      setState(() {
        result = {
          'k_tv': 0.0,
          'E': 0.0,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть коректні числа')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Спалювання природного газу', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(color: Color(0xFF334155), height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: ctrl.entries.map((e) => SizedBox(
                        width: 150,
                        child: CustomInput(label: e.key, controller: e.value),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _calculate,
                        child: const Text('РОЗРАХУВАТИ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              if (result != null) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(width: 4, height: 24, color: const Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    const Text('Результати розрахунку', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                GlassCard(
                  highlight: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResRow(label: 'Показник емісії (k_тв), г/ГДж:', value: result!['k_tv']!.toStringAsFixed(2)),
                      const SizedBox(height: 8),
                      ResRow(label: 'Валовий викид (E_тв), т:', value: result!['E']!.toStringAsFixed(2)),
                      const SizedBox(height: 16),
                      Text(
                        '* При спалюванні природного газу тверді частинки відсутні.',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
