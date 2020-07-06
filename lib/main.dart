import 'package:flutter/material.dart';
import './patient_queue.dart';

void main() => runApp( QueueMgmtApp() );
 
/// Root widget for Queue Management System.  
class QueueMgmtApp extends StatelessWidget {

	@override
  	Widget build( BuildContext context ) {
    	return MaterialApp(
			title: 'Queue Management System',
			theme: ThemeData(
				primarySwatch: Colors.indigo,	  
			),
			home: PatientQueue( title: 'Echo - ALL' ),
		);
	}
}
