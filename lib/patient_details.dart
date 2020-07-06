import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './patient_model.dart';

/// A PatientDetails widget to see details of a patient
class PatientDetails extends StatefulWidget {
	
	PatientDetails( { Key key, @required this.pid } ) : super( key: key );

	/// Id of the Patient
	final pid;

	@override
	_PatientDetailsState createState() => _PatientDetailsState();
}


/// State Class for the PatientDetails Widget
class _PatientDetailsState extends State< PatientDetails > {

	Patient _patient;
	Future< String > _patientFuture;

	@override
	void initState() {
		super.initState();

		_patientFuture = _fetchPatientData();
	}

	/// Fetch patient data from API
	Future< String > _fetchPatientData() async {
		final response = await http.get( "https://dev.uneva.in/task_721/patient.php?id=" + widget.pid.toString() );
		
		if ( response.statusCode == 200 ) {
			return response.body;
		}
		else {
			throw Exception( "Failed to load data from endpoint." );
		}
	}

	/// Build patient details widget
	Widget _buildPatientDetails() {
		return Scaffold(
			appBar: AppBar(
				title: Text( _patient.fullName )
			),
			body: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: < Widget >[
					Center(
						child: Padding(
							padding: EdgeInsets.all( 16.0 ),
							child: CircleAvatar(
								radius: 50,
								backgroundImage: NetworkImage( _patient.picUrl ),
							)
						)
					),
					Container(
						margin: EdgeInsets.symmetric( horizontal: 64.0 ),
						child: Column(
							children: [
								Row(
									children: [
										SizedBox(
											width: 80,
											child: Text( "PID" )
										),
										Text( "${ _patient.pid }" )
									]
								),
								Row(
									children: [
										SizedBox(
											width: 80,
											child: Text( "Name" )
										),
										Text( _patient.fullName )
									]
								),
								Row(
									children: [
										SizedBox(
											width: 80,
											child: Text( "Gender" )
										),
										Text( _patient.gender )
									]
								),
								Row(
									children: [
										SizedBox(
											width: 80,
											child: Text( "Age" )
										),
										Text( _patient.age )
									]
								),
								Row(
									children: [
										SizedBox(
											width: 80,
											child: Text( "Phone" )
										),
										Text( _patient.phoneNo )
									]
								)
							]
						)
					)
				]
			)
		);
	}

	/// Displays error message
	Widget _displayError( String message ) {
 		return Center(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: < Widget >[
					Icon(
						Icons.error_outline,
						color: Colors.red,
						size: 20
					),
					Padding(
						padding: EdgeInsets.all( 8.0 ),
						child: Text(
							message,
							textAlign: TextAlign.center,
						)
					),
					Padding(
						padding: EdgeInsets.symmetric( vertical: 8.0 ),
						child: RaisedButton(
							child: Text( "Go Back" ),
							onPressed: () {
								Navigator.of( context ).pop();
							}
						)
					)
				]
			)
		);
	}


	@override
	Widget build( BuildContext context ) {
		return Scaffold(
			appBar: null,
			body: FutureBuilder< String >(
				future: _patientFuture,
				builder: ( BuildContext context, AsyncSnapshot< String > snapshot ) {
					Widget finalRender;

					if ( snapshot.hasData ) {
						try {
							final data = jsonDecode( snapshot.data );
							_patient = Patient.fromJSON( data );

							finalRender = _buildPatientDetails();
						}
						catch ( err ) {
							finalRender = _displayError( err );
						}
					}
					else if ( snapshot.hasError ) {
						finalRender = _displayError( "${ snapshot.error }" );
					}
					else {
						finalRender = Center(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children: < Widget >[
									SizedBox(
										child: CircularProgressIndicator(),
										width: 20,
										height: 20
									),
									Padding(
										padding: EdgeInsets.all( 8.0 ),
										child: Text(
											"Loading patient data...",
											textAlign: TextAlign.center,
										)
									)
								],
							)
						);
					}

					return finalRender;

				}
			)
		);
	}
}
