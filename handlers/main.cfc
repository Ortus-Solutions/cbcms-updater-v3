/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox 3 Updater
**/
component{

	// DI
	property name="updateService" inject="id:UpdateService@cb";
	
	/**
	* Renders the Application Update form, allowing the user to make simple updates to the Application
	* CFC before the update starts 
	*/
	function index( event, rc, prc ){
		prc.appPath 				= getSetting( "applicationPath" );
		prc.oldApplicationCFC 		= fileRead( prc.appPath & 'Application.cfc' );
		prc.oldAppName 				= application.applicationName;
		prc.newAppCFC 				= cleanUpApplicationCFC( prc.oldApplicationCFC );
		prc.moduleInvocationPath	= getSetting( "modules")[ 'cbcms-updater-v3' ].invocationPath;

		event.setView( view="main/index" );
	}	
	
	/**
	* Event to run after the initial install, and application clear.
	* This should force the app to reinit, to complete the update.
	*/
	function postProcess( event, rc, prc ){
		// Setup Variables
		prc.log 					= createObject( "java", "java.lang.StringBuilder" ).init( "" );
		prc.moduleInvocationPath	= getSetting( "modules")[ 'cbcms-updater-v3' ].invocationPath;
		// Build Updater
		var oUpdater = getInstance( "#prc.moduleInvocationPath#.assets.Update" );
		// do postInstallation
		oUpdater.postInstallation( prc.log );
		event.setView( "main/postProcess" );		
	}

	/**************************************** PRIVATE ****************************************/

	private function cleanUpApplicationCFC( theFile ){
		var modulePath 		= getSetting( "modules")[ 'cbcms-updater-v3' ].path;
		var theDatasource 	= ReMatch( "this.datasource.*?;", arguments.theFile );
		var newFile 		= fileRead( '#modulePath#/assets/ApplicationTemplate.cfc' );
		var updatesArray 	= [
			{ from="@this.datasource@", to="#theDatasource[1]#" }
		];						
		for( var update in updatesArray ){
			newFile = replaceNoCase( newFile, update.from, update.to, "all" );
		}

		return newFile;
	}

}