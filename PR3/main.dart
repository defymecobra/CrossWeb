import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const SolarPredictorApp());
}

class SolarPredictorApp extends StatelessWidget {
  const SolarPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор СЕС',
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
                    const Color(0xFFEAB308).withOpacity(0.15), // Yellow for solar theme
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Розрахунок прибутку СЕС',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'З системою прогнозування потужності - ПР3',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 30),
                const Expanded(child: CalculatorForm()),
              ],
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
                ? const Color(0xFFEAB308).withOpacity(0.05) 
                : const Color(0xFF1E293B).withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlight ? const Color(0xFFEAB308) : const Color(0xFF334155),
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

// ======================= CALCULATOR FORM (ПР3) =======================
class CalculatorForm extends StatefulWidget {
  const CalculatorForm({super.key});

  @override
  State<CalculatorForm> createState() => _CalculatorFormState();
}

class _CalculatorFormState extends State<CalculatorForm> {
  final Map<String, TextEditingController> ctrl = {
    'Потужність Pc (МВт)': TextEditingController(text: "5.0"),
    'Похибка прогнозу (%)': TextEditingController(text: "5.0"),
    'Вартість B (грн/кВт*год)': TextEditingController(text: "7.0"),
    'Поточне σ1 (МВт)': TextEditingController(text: "1.0"),
    'Вдосконалене σ2 (МВт)': TextEditingController(text: "0.25"),
  };

  Map<String, dynamic>? result;

  // Numerical Integration using Trapezoidal Rule
  double integrateNormal(double mean, double stdDev, double lower, double upper) {
    int steps = 10000;
    double stepSize = (upper - lower) / steps;
    double sum = 0.0;
    for (int i = 0; i < steps; i++) {
      double x1 = lower + i * stepSize;
      double x2 = lower + (i + 1) * stepSize;
      double y1 = (1 / (stdDev * sqrt(2 * pi))) * exp(-pow(x1 - mean, 2) / (2 * pow(stdDev, 2)));
      double y2 = (1 / (stdDev * sqrt(2 * pi))) * exp(-pow(x2 - mean, 2) / (2 * pow(stdDev, 2)));
      sum += 0.5 * (y1 + y2) * stepSize;
    }
    return sum; // returns raw probability between 0 and 1
  }

  void _calculate() {
    try {
      double Pc = double.parse(ctrl['Потужність Pc (МВт)']!.text.replaceAll(',', '.'));
      double deltaPercent = double.parse(ctrl['Похибка прогнозу (%)']!.text.replaceAll(',', '.'));
      double B = double.parse(ctrl['Вартість B (грн/кВт*год)']!.text.replaceAll(',', '.'));
      double sigma1 = double.parse(ctrl['Поточне σ1 (МВт)']!.text.replaceAll(',', '.'));
      double sigma2 = double.parse(ctrl['Вдосконалене σ2 (МВт)']!.text.replaceAll(',', '.'));

      double deltaMW = Pc * (deltaPercent / 100.0);
      double lower = Pc - deltaMW;
      double upper = Pc + deltaMW;

      // Calculate for Sigma 1
      double rawIntegral1 = integrateNormal(Pc, sigma1, lower, upper);
      double dW1 = (rawIntegral1 * 100).round() / 100.0; // round to nearest integer percent e.g. 0.20
      
      double W1_no_imb = Pc * 24 * dW1;
      double P1 = W1_no_imb * B; // MWh * UAH/kWh = ths UAH
      double W1_imb = Pc * 24 * (1 - dW1);
      double Sh1 = W1_imb * B;
      double net1 = P1 - Sh1;

      // Calculate for Sigma 2
      double rawIntegral2 = integrateNormal(Pc, sigma2, lower, upper);
      double dW2 = (rawIntegral2 * 100).round() / 100.0; // e.g. 0.68

      double W2_no_imb = Pc * 24 * dW2;
      double P2 = W2_no_imb * B;
      double W2_imb = Pc * 24 * (1 - dW2);
      double Sh2 = W2_imb * B;
      double net2 = P2 - Sh2;

      setState(() {
        result = {
          'dW1': dW1,
          'W1_no': W1_no_imb,
          'W1_imb': W1_imb,
          'P1': P1,
          'Sh1': Sh1,
          'net1': net1,

          'dW2': dW2,
          'W2_no': W2_no_imb,
          'W2_imb': W2_imb,
          'P2': P2,
          'Sh2': Sh2,
          'net2': net2,
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
                    const Text('Вхідні параметри', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(color: Color(0xFF334155), height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: ctrl.entries.map((e) => SizedBox(
                        width: 155,
                        child: CustomInput(label: e.key, controller: e.value),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEAB308), // Yellow branding
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _calculate,
                        child: const Text('РОЗРАХУВАТИ ПРИБУТОК', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (result != null) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(width: 4, height: 24, color: const Color(0xFFEAB308)),
                    const SizedBox(width: 8),
                    const Text('Економічний ефект', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Result Cards Grid
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    // Before Improvement
                    SizedBox(
                      width: 400,
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('До вдосконалення', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white54)),
                            const SizedBox(height: 16),
                            _ResRow(label: 'Частка енергії (без небалансу), δ:', value: '${(result!['dW1'] * 100).toStringAsFixed(0)}%'),
                            _ResRow(label: 'Енергія W1 (без небалансу):', value: '${result!['W1_no'].toStringAsFixed(1)} МВт·год'),
                            _ResRow(label: 'Енергія W2 (з небалансом):', value: '${result!['W1_imb'].toStringAsFixed(1)} МВт·год'),
                            const Divider(color: Color(0xFF334155), height: 24),
                            _ResRow(label: 'Прибуток П1:', value: '${result!['P1'].toStringAsFixed(1)} тис. грн', color: Colors.greenAccent),
                            _ResRow(label: 'Штраф Ш1:', value: '${result!['Sh1'].toStringAsFixed(1)} тис. грн', color: Colors.redAccent),
                            const Divider(color: Color(0xFF334155), height: 24),
                            _ResRow(label: 'Чистий прибуток:', value: '${result!['net1'].toStringAsFixed(1)} тис. грн', 
                              color: result!['net1'] >= 0 ? Colors.greenAccent : Colors.redAccent, isBold: true),
                          ],
                        ),
                      ),
                    ),
                    
                    // After Improvement
                    SizedBox(
                      width: 400,
                      child: GlassCard(
                        highlight: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Після вдосконалення', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEAB308))),
                            const SizedBox(height: 16),
                            _ResRow(label: 'Частка енергії (без небалансу), δ:', value: '${(result!['dW2'] * 100).toStringAsFixed(0)}%'),
                            _ResRow(label: 'Енергія W1 (без небалансу):', value: '${result!['W2_no'].toStringAsFixed(1)} МВт·год'),
                            _ResRow(label: 'Енергія W2 (з небалансом):', value: '${result!['W2_imb'].toStringAsFixed(1)} МВт·год'),
                            const Divider(color: Color(0xFF334155), height: 24),
                            _ResRow(label: 'Прибуток П2:', value: '${result!['P2'].toStringAsFixed(1)} тис. грн', color: Colors.greenAccent),
                            _ResRow(label: 'Штраф Ш2:', value: '${result!['Sh2'].toStringAsFixed(1)} тис. грн', color: Colors.redAccent),
                            const Divider(color: Color(0xFF334155), height: 24),
                            _ResRow(label: 'Чистий прибуток:', value: '${result!['net2'].toStringAsFixed(1)} тис. грн', 
                              color: result!['net2'] >= 0 ? Colors.greenAccent : Colors.redAccent, isBold: true),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _ResRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _ResRow({
    required this.label, 
    required this.value, 
    this.color = Colors.white,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.w900 : FontWeight.bold, fontSize: isBold ? 18 : 16, color: color)),
        ],
      ),
    );
  }
}
