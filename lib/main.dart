import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final ValueNotifier<DateTime> _selectedDay = ValueNotifier(DateTime.now());
  List<Flight> flights = [];

  void _openAddFlightPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFlightPage(onAddFlight: _addFlight)),
    );
  }

  void _addFlight(Flight flight) {
    setState(() {
      flights.add(flight);
    });
  }

  void _openFlightDetailsPage(Flight flight) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlightDetailsPage(flight: flight)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier de Pilote de Ligne'),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1), // Date de début du calendrier
            lastDay: DateTime.utc(2023, 12, 31), // Date de fin du calendrier
            focusedDay: _selectedDay.value, // Utilisez la date sélectionnée comme date de focus
            selectedDayPredicate: (DateTime day) {
              return isSameDay(_selectedDay.value, day);
            },
            onDaySelected: (date, events) {
              _selectedDay.value = date;
            },
          ),
          ElevatedButton(
            onPressed: _openAddFlightPage,
            child: Text('Ajouter un vol'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];
                return ListTile(
                  title: Text('Vol ${flight.id}'),
                  subtitle: Text('Destination : ${flight.destination}'),
                  onTap: () => _openFlightDetailsPage(flight),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Flight {
  final String id;
  final DateTime date;
  final String destination;

  Flight({required this.id, required this.date, required this.destination});
}

class AddFlightPage extends StatefulWidget {
  final Function(Flight) onAddFlight;

  AddFlightPage({required this.onAddFlight});

  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _newFlightId;
  DateTime? _newFlightDate;
  String? _newFlightDestination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Vol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'ID du vol'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un ID de vol';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newFlightId = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (_newFlightId != null && _newFlightDate != null && _newFlightDestination != null) {
                      final newFlight = Flight(
                        id: _newFlightId!,
                        date: _newFlightDate!,
                        destination: _newFlightDestination!,
                      );
                      widget.onAddFlight(newFlight);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Ajouter un vol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlightDetailsPage extends StatelessWidget {
  final Flight flight;

  FlightDetailsPage({required this.flight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Vol'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('ID du vol : ${flight.id}'),
            Text('Date : ${flight.date.toString()}'),
            Text('Destination : ${flight.destination}'),
          ],
        ),
      ),
    );
  }
}
