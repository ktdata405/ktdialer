import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/call_log_provider.dart';
import '../../../../core/services/call_service.dart';

class CallLogsScreen extends StatefulWidget {
  const CallLogsScreen({super.key});

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  int _selectedToggle = 0; // 0 for All, 1 for Missed

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CallLogProvider>(context, listen: false).fetchCallLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final callLogProvider = Provider.of<CallLogProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calls', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search, size: 28), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, size: 28), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              height: 36,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  _ToggleItem(
                    label: 'All',
                    isSelected: _selectedToggle == 0,
                    onTap: () => setState(() => _selectedToggle = 0),
                  ),
                  _ToggleItem(
                    label: 'Missed',
                    isSelected: _selectedToggle == 1,
                    onTap: () => setState(() => _selectedToggle = 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: callLogProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: callLogProvider.callLogs.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1, indent: 56),
              itemBuilder: (context, index) {
                final entry = callLogProvider.callLogs[index];
                if (_selectedToggle == 1 && entry.callType.toString().toLowerCase().contains('missed') == false) {
                  return const SizedBox.shrink();
                }
                
                final bool isMissed = entry.callType.toString().toLowerCase().contains('missed');
                
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Icon(
                    _getCallIcon(entry.callType),
                    color: isMissed ? Colors.redAccent : Colors.grey,
                    size: 20,
                  ),
                  title: Text(
                    entry.name ?? entry.number ?? 'Unknown',
                    style: TextStyle(
                      color: isMissed ? Colors.redAccent : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.lte_mobiledata, color: Colors.white38, size: 14),
                          const SizedBox(width: 4),
                          const Icon(Icons.sim_card_outlined, color: Colors.white38, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            entry.number ?? '',
                            style: const TextStyle(color: Colors.white38, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDate(entry.timestamp ?? 0),
                        style: const TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.info_outline, color: Colors.white, size: 24),
                    ],
                  ),
                  onTap: () {
                    if (entry.number != null) {
                      CallService.placeCall(entry.number!);
                    }
                  },
                );
              },
            ),
    );
  }

  String _formatDate(int timestamp) {
    if (timestamp == 0) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return DateFormat('HH:mm').format(dt);
    }
    return DateFormat('MMM d').format(dt);
  }

  IconData _getCallIcon(dynamic type) {
    String t = type.toString().toLowerCase();
    if (t.contains('incoming')) return Icons.call_received;
    if (t.contains('outgoing')) return Icons.call_made;
    return Icons.call_missed;
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleItem({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white24 : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
