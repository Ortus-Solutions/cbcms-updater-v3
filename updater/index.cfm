<cfsetting requesttimeout="9999999">
<cffunction name="flushit" output="false">
	<cfflush>
</cffunction>
<cfcontent reset="true">
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ContentBox 3 Updater</title>

    <!-- Bootstrap -->
   <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <div class="container">
	<h1>Updating ContentBox, please wait....</h1>
	<hr>
	<cfflush>
<cfscript>
	/**
	* Clean up Application Scope to force a reinit of the App when we relocate to the next step
	*/
	function cleanUpApplication(){
		//writeDump( application );
		structDelete( application, "wirebox" );
		structDelete( application, "cbController" );
		structDelete( application, "CBBOOTSTRAP" );
	}
	
	/**
	* Create a backup file of existing Application.cfc and write the new Application.cfc
	* from the Update form starting the update.
	*/
	function cleanUpApplicationCFC( newCFC ){
		fileCopy( appPath & 'Application.cfc', appPath & 'Application_backup.cfc' );
		fileWrite( appPath & 'Application.cfc', newCFC );
	}
	
	/**
	* Update the ColdBox Config to remove the old Coldbox Tracer and add a simple Console appender
	*/
	function cleanColdBoxConfig(){
		var theFile = fileRead( appPath & 'config/Coldbox.cfc');
		var oldLogger = 'coldboxTracer = { class="coldbox.system.logging.appenders.ColdboxTracerAppender" }'; 
		var newLogger = 'console = { class="coldbox.system.logging.appenders.ConsoleAppender" }';
		theFile = replaceNoCase( theFile, oldLogger, newLogger, "all" );
		fileWrite( appPath & 'config/Coldbox.cfc', theFile );
	}
	
	/**
	* Process patch update removals if any
	*/
	function processRemovals( required path, required log ){
		// verify the path exists on the incoming path
		if( !fileExists( arguments.path ) ){
			arguments.log.append( "Skipping file removals as file does not exist: #arguments.path#<br/>" );
			return;
		}
		// read the files to remove
		var removalText = fileRead( arguments.path );
		arguments.log.append( "Starting to process removals from: #arguments.path#<br/>" );

		// if there are files, then remove, else continue
		if( len( removalText ) ){
			var files = listToArray( removalText, chr(10) );
			for( var thisFile in files ){
				if( fileExists( expandPath("/#thisFile#" ) ) ){
					fileDelete( expandPath("/#thisFile#" ) );
					arguments.log.append( "Removed: #thisFile#<br/>" );
				} else {
					arguments.log.append( "File Not Found, so not removed: #thisFile#<br/>" );
				}
			}
		} else {
			arguments.log.append( "No updated files to remove. <br/>" );
		}

		// remove deletes.txt file
		//fileDelete( arguments.path );
		writeOutput( log.toString() );flushit();
	}
	
	/**
	* Process updated files
	*/
	function processUpdates(required path, required log){

		// Verify patch exists
		if( !fileExists( arguments.path ) ){
			arguments.log.append( "Skipping patch extraction as no patch.zip found in update patch.<br/>" );
			return;
		}

		// test zip has files?
		try{
			var listing = zipUtil.list( arguments.path );
		} catch( Any e ) {
			// bad zip file.
			arguments.log.append( "Error getting listing of zip archive, bad zip.<br />" );
			rethrow;
		}

		// good zip file
		arguments.log.append( "Patch Zip archive detected, beginning to expand update: #arguments.path#<br />" );
		// extract it
		zipUtil.extract( zipFilePath=arguments.path, extractPath=appPath, overwriteFiles="true" );
		// more logging
		arguments.log.append("Patch Updates uncompressed.<br />");

		// remove patch
		//fileDelete( arguments.path );
		writeOutput( log.toString() );flushit();
	}

	private function updateTimestampFields( required log ){
		
		var tables = [
			"cb_author",
			"cb_category",
			"cb_comment",
			"cb_content",
			"cb_contentVersion",
			"cb_customField",
			"cb_loginAttempts",
			"cb_menu",
			"cb_menuItem",
			"cb_module",
			"cb_permission",
			"cb_role",
			"cb_securityRule",
			"cb_setting",
			"cb_stats",
			"cb_subscribers",
			"cb_subscriptions"
		];

		for( var thisTable in tables ){
			var q = new Query( sql = "update #thisTable# set modifiedDate = :modifiedDate" );
			q.addParam( name="modifiedDate", value ="#createODBCDateTime( now() )#", cfsqltype="CF_SQL_TIMESTAMP" );
			var results = q.execute().getResult();
			arguments.log.append( "Update #thisTable# modified date", results );	
			writeOutput( log.toString() );flushit();
		}
		
		// Creation tables now
		tables = [
			"cb_category",
			"cb_customField",
			"cb_menu",
			"cb_menuItem",
			"cb_module",
			"cb_permission",
			"cb_role",
			"cb_securityRule",
			"cb_setting",
			"cb_stats",
			"cb_subscribers"
		];
		for( var thisTable in tables ){
			var q = new Query( sql = "update #thisTable# set createdDate = :createdDate" );
			q.addParam( name="createdDate", value ="#createODBCDateTime( now() )#", cfsqltype="CF_SQL_TIMESTAMP" );
			var results = q.execute().getResult();
			arguments.log.append( "Update #thisTable# created date", results );	
			writeOutput( log.toString() );flushit();
		}
			
	}

	// Setup Variables
	log 		= createObject( "java", "java.lang.StringBuilder" ).init( "" );
	zipUtil 	= new coldbox.system.core.util.Zip();
	appPath 	= form.appPath;
	modulePath 	= form.modulePath;

	// Build Updater
	oUpdater = application.wirebox.getInstance( "#modulePath#.assets.Update" );

	// do preInstallation
	oUpdater.preInstallation( log );
	log.append( "Update.cfc - called preInstallation() method.<br/>" );

	writeOutput( log.toString() );flushit();

	// Backup old Application.cfc and Create new Application.cfc from Update Form
	cleanUpApplicationCFC( form.newCFC );
	log.append( "Application.cfc backedup and updated.<br/>" );
	
	writeOutput( log.toString() );flushit();
	
	// Do deletes first
	processRemovals( expandPath( '../assets/deletes.txt' ), log );
	
	// Do updates second
	processUpdates( expandPath( '../assets/patch.zip' ), log );

	// Final cleanup
	directoryDelete( "#appPath#/modules/contentbox/model", true );
	directoryDelete( "#appPath#/modules/contentbox/modules", true );
	directoryDelete( "#appPath#/modules/contentbox/plugins", true );
	directoryDelete( "#appPath#/modules/contentbox-filebrowser", true );
	directoryDelete( "#appPath#/modules/contentbox-security", true );
	directoryCreate( "#appPath#/modules/contentbox/modules" );

	// Compat Shim to startup the ORM
	directoryCreate( "#appPath#/modules/contentbox/model" );
	directoryCreate( "#appPath#/modules/contentbox/model/system" );
	fileCopy( "#appPath#/modules/contentbox/models/system/EventHandler.cfc", "#appPath#/modules/contentbox/model/system/EventHandler.cfc" );

	//Stop App + Clear Caches
	applicationstop();
	if( structKeyExists( server, "lucee" ) ){
		pagePoolClear();
	}

	writeOutput( "<h1>Starting up new ORM files....</h1>" );flushit();

	// Creation of new cborm mapping, to do hard core startup
	if( structKeyExists( server, "lucee" ) ){
		mappingHelper = new LuceeMappingHelper();
	} else {
		mappingHelper = new CFMappingHelper();
	}
	mappingHelper.addMapping( "cborm", "#appPath#/coldbox/system/modules/cborm" );

	// Reload ORM, create new stuff
	ORMReload();

	// Update timestamps to startup the APP, if not, app does not start
	updateTimestampFields( log );
</cfscript>

<cfoutput>
<h1>Finalized first part of the updater, please wait, relocating to next section of updater</h1>
<meta http-equiv="refresh" content="1; url=#appRoot#/CB3Updater/main/postProcess" />
</cfoutput>