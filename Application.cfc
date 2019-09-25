component {
	
	this.name = hash( getCurrentTemplatePath() );
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	this.setClientCookies = true;

    this.base = getDirectoryFromPath( getCurrentTemplatePath() );
    
}