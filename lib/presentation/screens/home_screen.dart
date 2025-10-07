import 'package:flutter/material.dart';
import 'package:tp_final_componentes/data/repositorioes/ticket_repository.dart';
import 'package:tp_final_componentes/data/sources/hardcode_connection.dart';
import 'package:tp_final_componentes/domain/models/ticket.dart';
import 'package:tp_final_componentes/presentation/widgets/ticket_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TicketRepository ticketRepo;
  final String userId = 'u1'; // usuario harcodeado
  final String userName = 'Emiliano'; // nombre del usuario para mensajes
  late Future<List<Ticket>> futureTickets;

  @override
  void initState() {
    super.initState();
    ticketRepo = TicketRepository(HardcodeConnection());
    futureTickets = ticketRepo.getTicketsByUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Pantalla 1'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Pantalla 2'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Pantalla 3'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Ticket>>(
        future: futureTickets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Barra de carga mientras espera
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar tickets: ${snapshot.error}'));
          } else {
            final tickets = snapshot.data ?? [];

            if (tickets.isEmpty) {
              return Center(
                child: Text("No hay tickets abiertos para $userName"),
              );
            }

            // Lista deslizable de tickets
            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return TicketCard(ticket: tickets[index]);
              },
            );
          }
        },
      ),
    );
  }
}