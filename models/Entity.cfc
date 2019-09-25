component {

	property name="dateCreated" type="date";


	/**
	* Constructor
	* I initalize the component, populate properties, and return an instance of this
	*/
	function init() {

		// create the component utilities. Normally you would do this via dependency injection (e.g. Wirebox)
		variables.componentUtils = new models.utils.ComponentUtilities();

		variables.dateCreated = now();

		onInit( 
			argumentCollection = arguments 
		);

		return this;

	}



	/**
	* On Init
	* This function should be overloaded by whatever component inherits this base class.
	* The throw is important here to prevent anyone from instancing a base class directly.
	*/
	function onInit() {
		throw( "you can not instance a base class!" );
	}



	/**
	* getDto
	* This exposes one of the utility classes which will allos us to get the DTO from the entity
	*/
	function getDto() {
		return variables.componentUtils.getDto( this );
	}

}