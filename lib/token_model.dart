import 'package:intl/intl.dart';

/// Model to store a Token instance
class Token {
	
	String name;
	String description;
	String timestamp;
	int status;
	String tokenName;
	int pid;

	Token( {
		this.name,
		this.description,
		this.timestamp,
		this.status,
		this.tokenName,
		this.pid
	} );

	/// Returns a Token instance from JSON provided
	factory Token.fromJSON( Map< String, dynamic > json ) {
		for ( String key in [ "name", "description", "timestamp", "status", "tokenName", "other" ] ) {
			if ( ! json.containsKey( key ) ) {
				throw Exception( "Invalid JSON to parse!" );
			}
		}

		final dateTime = DateTime.fromMillisecondsSinceEpoch( json[ "timestamp" ] * 1000 );
		final formatedDateTime = DateFormat( "dd-MMM" ).format( dateTime ) + " " +  DateFormat.jm().format( dateTime );

		return Token(
			name: json[ "name" ],
			description: json[ "description" ],
			timestamp: formatedDateTime,
			status: json[ "status" ],
			tokenName: json[ "tokenName" ],
			pid: json[ "other" ][ "pid" ]
		);
	}
}

