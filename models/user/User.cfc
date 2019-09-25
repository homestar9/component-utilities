component
	extends="models.entity"
	accessors="true"
{

	property name="firstName" required="true" getter="true";
	property name="lastName" required="true" getter="true";
	property name="position" required="false" getter="true";
	property name="quotes" type="array" required="false" getter="true";
	property name="secret" required="false" getter="false";

	
	/**
	* Constructor
	* initalizes this object and sets properties
	*/
	function onInit(
		required string firstName,
		required string lastName,
		string position="",
		array quotes=[],
		string secret = ""
	) {

		variables.firstName = arguments.firstName;
		variables.lastName = arguments.lastName;
		variables.position = arguments.position;
		variables.quotes = arguments.quotes;
		variables.secret = arguments.secret;

	}

}