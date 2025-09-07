import 'package:flutter/material.dart';

class IncidentPage extends StatelessWidget {
  const IncidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      '‹ Back',
                      style: TextStyle(color: Color(0xFFE6EDF7), fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header
                  const Text(
                    'Incident',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE6EDF7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '203.0.113.25 • OCPP → Modbus → IEC104',
                    style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 20),

                  // Summary Card
                  Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE6EDF7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'First seen: 12:41 • Duration: 00:02:18',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'VPN Likelihood: ~80% • ASN: AS14618',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F1628),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF223050),
                              ),
                            ),
                            child: const Text(
                              'Block IP',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFE6EDF7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Attack Path Card
                  Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Path',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE6EDF7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _PathNode(
                              color: const Color(0xFFFF4D4F),
                              label: 'OCPP',
                            ),
                            const SizedBox(width: 40),
                            _PathNode(
                              color: const Color(0xFF5B8CFF),
                              label: 'Modbus',
                            ),
                            const SizedBox(width: 40),
                            _PathNode(
                              color: const Color(0xFF52C41A),
                              label: 'IEC104',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ArrowLine(width: 88),
                            _ArrowLine(width: 88),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Commands Card
                  Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Captured Commands',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE6EDF7),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _CommandRow(
                          color: const Color(0xFFFF4D4F),
                          command: 'OCPP → BootNotification',
                          payload: 'payload {...}',
                        ),
                        _CommandRow(
                          color: const Color(0xFF5B8CFF),
                          command: 'Modbus → Read Holding Registers (FC3)',
                          payload: 'addr 0 len 3',
                        ),
                        _CommandRow(
                          color: const Color(0xFF52C41A),
                          command: 'IEC104 → Interrogation (QOI 20)',
                          payload: 'ASDU 1',
                        ),
                        _CommandRow(
                          color: const Color(0xFF5B8CFF),
                          command: 'OCPP → StartTransaction',
                          payload: 'idTag ABC123',
                        ),
                        _CommandRow(
                          color: const Color(0xFFFF4D4F),
                          command: 'OCPP → StopTransaction',
                          payload: 'reason Local',
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 30,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF223050),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helpers
class _PathNode extends StatelessWidget {
  final Color color;
  final String label;
  const _PathNode({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
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

class _ArrowLine extends StatelessWidget {
  final double width;
  const _ArrowLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 2.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5B8CFF), Color(0xFF7EC8FF)],
        ),
      ),
    );
  }
}

class _CommandRow extends StatelessWidget {
  final Color color;
  final String command;
  final String payload;
  const _CommandRow({
    required this.color,
    required this.command,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              command,
              style: const TextStyle(fontSize: 12, color: Color(0xFFE6EDF7)),
            ),
          ),
          Text(
            payload,
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}
