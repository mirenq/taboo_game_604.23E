import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../widgets/score_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final LocalStorageService _storageService = LocalStorageService();
  List<RoundResults> _gameHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameHistory();
  }

  Future<void> _loadGameHistory() async {
    try {
      final history = await _storageService.getRounds();
      setState(() {
        _gameHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      //print('Error loading game history: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteRound(int id) async {
    try {
      await _storageService.deleteRound(id);
      // Reload the data
      _loadGameHistory();
    } catch (e) {
      //print('Error deleting round: $e');
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game History'), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE3F2FD)],
          ),
        ),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _gameHistory.isEmpty
                ? const Center(child: Text('No game history found'))
                : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _gameHistory.length,
                  separatorBuilder:
                      (context, index) => const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final game = _gameHistory[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text('${game.round}'),
                        ),
                        title: Text(
                          'Round ${game.round}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text('${game.teamA} vs ${game.teamB}', style: TextStyle(fontSize: 20)),
                            Text('Score: ${game.scoreA} - ${game.scoreB}', style: TextStyle(fontSize: 20)),
                            Text(
                              'Winner: ${game.winner == "Tie" ? "Tie Game" : "${game.winner} won!"}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: game.winner == "Tie" 
                                    ? Colors.blue 
                                    : (game.winner == game.teamA ? Colors.green : Colors.orange),
                              ),
                            ),
                            Text('Date: ${_formatDate(game.timestamp)}', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteRound(game.id!),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
