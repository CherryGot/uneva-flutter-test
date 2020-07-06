/// Model to store a Patient instance
class Patient {
	
	String fullName;
	String gender;
	String picUrl;
	String age;
	String phoneNo;
	int pid;

	Patient( {
		this.fullName,
		this.gender,
		this.picUrl,
		this.age,
		this.phoneNo,
		this.pid
	} );

	/// Returns a Patient instance from JSON provided
	factory Patient.fromJSON( Map< String, dynamic > json ) {
		for ( String key in [ "person_full_name", "person_gender", "person_pic", "person_age", "person_phone", "_pk" ] ) {
			if ( ! json.containsKey( key ) ) {
				throw Exception( "Invalid JSON to parse!" );
			}
		}
	
		final userPicUrl = ( json[ "person_pic" ] != null ) ? json[ "person_pic" ] : "https://stratefix.com/wp-content/uploads/2016/04/dummy-profile-pic-male1.jpg";

		return Patient(
			fullName: json[ "person_full_name" ],
			gender: json[ "person_gender" ],
			picUrl: userPicUrl,
			age: json[ "person_age" ],
			phoneNo: json[ "person_phone" ],
			pid: json[ "_pk" ]
		);
	}
}
