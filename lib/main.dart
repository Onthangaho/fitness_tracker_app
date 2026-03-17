import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    String? username;
    
    String? displayName = username ?? 'Guest User';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[900],
        foregroundColor: Colors.white,
        title: Text(
          "Fitness Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Icon(Icons.fitness_center,),
        actions: [
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(Icons.account_circle),
            
          ),
           Stack(
            children:[ IconButton(
              onPressed: () {
                
              },
              icon: Icon(Icons.notifications),
              
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,

                ),
                constraints: BoxConstraints(
                  minWidth: 8,
                  minHeight: 8,
                ),
                child: Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
               
              ),
              

            )
            ]
          ),
        ],
        
      ),
      body: Center(

        child: Text("Welcome, ${displayName.toUpperCase()}! Ready to be fit?"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
