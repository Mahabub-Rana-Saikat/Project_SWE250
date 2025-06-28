import 'package:climate_hope/quezz/exam_screen.dart';
import 'package:flutter/material.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  List<Map<String, dynamic>> _mcqs = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentQuestionIndex = 0;
  List<String?> _selectedAnswers = [];
  int _score = 0;
  bool _examFinished = false;

  final AIService _aiService = AIService();

  @override
  void initState() {
    super.initState();
    _fetchMCQs();
  }

  Future<void> _fetchMCQs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _mcqs = [];
      _currentQuestionIndex = 0;
      _selectedAnswers = [];
      _score = 0;
      _examFinished = false;
    });

    try {
      final generatedMCQs = await _aiService.generateMCQs();
      setState(() {
        _mcqs = generatedMCQs;
        _selectedAnswers = List<String?>.filled(generatedMCQs.length, null);
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onOptionSelected(String? selectedOption) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = selectedOption;
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _mcqs.length - 1) {
        _currentQuestionIndex++;
      } else {
        _calculateScore();
        _examFinished = true;
      }
    });
  }

  void _calculateScore() {
    _score = 0;
    for (int i = 0; i < _mcqs.length; i++) {
      if (_selectedAnswers[i] == _mcqs[i]['answer']) {
        _score++;
      }
    }
  }

  void _resetExam() {
    _fetchMCQs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate Quiz'),
        backgroundColor: Color.fromARGB(255, 1, 39, 2),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signin_img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child:
            _isLoading
                ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color.fromARGB(255, 236, 239, 236)),
                      SizedBox(height: 20),
                      Text(
                        'Generating quiz questions...',
                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 231, 235, 231)),
                      ),
                    ],
                  ),
                )
                : _errorMessage != null
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 60),
                        SizedBox(height: 10),
                        Text(
                          'Oops! Failed to load questions.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _fetchMCQs,
                          icon: Icon(Icons.refresh),
                          label: Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : _mcqs.isEmpty
                ? const Center(
                  child: Text(
                    'No questions generated. Try refreshing.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
                : _examFinished
                ? _buildResultScreen()
                : _buildQuestionScreen(),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final currentQuestion = _mcqs[_currentQuestionIndex];
    final options =
        (currentQuestion['options'] as List<dynamic>).cast<String>();
    final selectedOption = _selectedAnswers[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Question ${_currentQuestionIndex + 1} of ${_mcqs.length}',
            style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 247, 246, 246)),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                currentQuestion['question'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, optionIndex) {
                final option = options[optionIndex];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: OptionTile(
                    option: option,
                    isSelected: selectedOption == option,
                    onTap: () => _onOptionSelected(option),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed:
                selectedOption != null
                    ? _nextQuestion
                    : null, 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 10, 126, 68), 
              foregroundColor: const Color.fromARGB(255, 255, 254, 254),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              _currentQuestionIndex == _mcqs.length - 1
                  ? 'Submit Exam'
                  : 'Next Question',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Quiz Completed!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 107, 235, 111),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: $_score / ${_mcqs.length}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 234, 236, 236),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _resetExam,
              icon: Icon(Icons.replay),
              label: const Text('Retake Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.home),
              label: const Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class OptionTile extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      color: isSelected ? Colors.green.shade50 : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_off,
                color: isSelected ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
