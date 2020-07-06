import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './patient_details.dart';
import './token_model.dart';


/// A PatientQueue widget to see a list of patients
class PatientQueue extends StatefulWidget {
	
	PatientQueue( { Key key, @required this.title } ) : super( key: key );

	/// String for Scaffold title
	final String title;

	@override
	_PatientQueueState createState() => _PatientQueueState();
}


/// State Class for the PatientQueue Widget
class _PatientQueueState extends State< PatientQueue > {
	
	final List< Token > _tokenQueue = [];

	Future< String > _tokenQueueFuture;

	@override
	void initState() {
		super.initState();

		_tokenQueueFuture = _fetchTokenQueue();
	}


	/// Fetch Token Queue
	Future< String > _fetchTokenQueue() async {
		final response = await http.get( "https://dev.uneva.in/task_721/list.php" );

		if ( response.statusCode == 200 ) {
			return response.body;
		}
		else {
			throw Exception( "Failed to load data from endpoint." );
		}
	}

	/// Widget to build Token Row
	Widget _buildTokenRow( Token tknInstance ) {
		return ListTile(
			leading: Text(
				"${ tknInstance.tokenName }",
				style: TextStyle(
					fontSize: 24,
					fontWeight: FontWeight.bold,
					color: Colors.red
				)
			),
			title: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: < Widget >[
					Text( "${ tknInstance.name }" ),
					Text( 
						"${ tknInstance.description }", 
						style: TextStyle(
							fontSize: 14
						) 
					),
					Text( 
						"${ tknInstance.timestamp }", 
						style: TextStyle(
							fontSize: 12
						),
						textAlign: TextAlign.right,
					),
				]
			),
			trailing: Column(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: < Widget >[
					Icon(
						Icons.more_vert
					),
					Icon(
						tknInstance.status == 0 ? Icons.radio_button_unchecked : Icons.radio_button_checked,
						color: tknInstance.status == 0 ? Colors.red : Colors.green
					)
				]
			),
			onTap: () {
				Navigator.of( context ).push(
					MaterialPageRoute< void >(
						builder: ( BuildContext context ) {
							return PatientDetails( pid: tknInstance.pid );
						}
					)
				);
			},
		);
	}

	/// Displays Patient Queue Details
	Widget _buildPatientQueue() {
		_tokenQueue.sort( ( Token a, Token b ) {
			return a.tokenName.compareTo( b.tokenName );
		} );

		int waiting = _tokenQueue.where( ( Token a ) {
			return a.status == 0;
		} ).length;

		int seen = _tokenQueue.where( ( Token a ) {
			return a.status == 1;
		} ).length;

		int total = waiting + seen;

		// Custom scrollview for queue count and items
		return CustomScrollView(
		  	slivers: < Widget >[
				SliverAppBar(
			  		pinned: true,
					backgroundColor: Colors.white,
			  		flexibleSpace: Padding(
						padding: EdgeInsets.all( 8.0 ),
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: < Widget >[
								Center(
									child: Text( "Waiting: ${ waiting }" )
								),
								Center(
									child: Text( "Seen: ${ seen }" 
									)
								),
								Center(
									child: Text( "Total: ${ total }" )
								)
							]
						)
					)
				),
				SliverList(
					delegate: SliverChildBuilderDelegate(
						( BuildContext context, int i ) {
							if ( i.isOdd ) {
								return Divider();
							}

							final index = i ~/ 2;
							return _buildTokenRow( _tokenQueue[ index ] );
						},
						childCount: 2 * total - 1
					),
				)
		  	],
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
					)
				]
			)
		);
	}

	/// Displays data and status in a future builder widget
	Widget _buildArena() {
		return FutureBuilder< String >(
			future: _tokenQueueFuture,
			builder: ( BuildContext context, AsyncSnapshot< String > snapshot ) {
				Widget finalRender;

				if ( snapshot.hasData ) {
					try {
						if ( _tokenQueue.isEmpty ) {
							final data = jsonDecode( snapshot.data );
						
							for ( dynamic map in data ) {
								_tokenQueue.add( Token.fromJSON( map ) );
							}
						}

						finalRender = _buildPatientQueue();
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
										"Loading token queue...",
										textAlign: TextAlign.center,
									)
								)
							],
						)
					);
				}

				return finalRender;
			}
		);
	}

	@override
	Widget build( BuildContext context ) {
		return Scaffold(
			appBar: AppBar(
				title: Text( widget.title )
			),
			body: _buildArena()
		);
	}
}
