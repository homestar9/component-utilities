component
	extends="models.entity"
	accessors="true"
{

	property name="name" required="true" getter="true";
	property name="serialNumber" required="true" getter="true";
	property name="captain" required="true" getter="true";
	property name="shieldFrequency" required="true" getter="false"; // Private!

	
	/**
	* Constructor
	* initalizes this object and sets properties
	*/
	function onInit(
		required string name,
		required string serialNumber,
		required User captain,
		required numeric shieldFrequency
	) {

		variables.name = arguments.name;
		variables.serialNumber = arguments.serialNumber;
		variables.captain = arguments.captain;
		variables.shieldFrequency = arguments.shieldFrequency;

	}

}
