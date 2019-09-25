<cfscript>
// create a new instance of a user entity
captain = new models.user.user(
	firstName = "Jean-Luc",
	lastName = "Picard",
	position = "Captain",
	quotes = [
		"make it so",
		"tea, earl grey, hot",
		"there... are... four... lights!"
	],
	secret = "Dr. Crusher is so hot"
);

writeOutput( "Captain DTO" );
writeDump( captain.getDto() );

vessel = new models.vessel.vessel(
	name = "USS Enterprise",
	serialNumber = "NCC-1701-D",
	captain = captain,
	shieldFrequency = 69
);

writeOutput( "Vessel DTO" );
writeDump( vessel.getDto() );

</cfscript>