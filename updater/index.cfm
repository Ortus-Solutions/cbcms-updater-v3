<h1>Updating</h1>
<cfscript>
	//writeDump( getApplicationSettings() );
	
	// Setup Variables
	log = createObject("java","java.lang.StringBuilder").init("");
	zipUtil = new coldbox.system.core.util.Zip();
	appPath = expandPath( "../../../../../" );
	
	// Backup old Application.cfc and Create new Application.cfc from Update Form
	cleanUpApplicationCFC( form.newCFC );
	
	// Do deletes first
	processRemovals( expandPath( '../assets/deletes.txt' ), log );
	
	// Do updates second
	processUpdates( expandPath( '../assets/patch.zip' ), log );
	//writeDump( log );	
	
</cfscript>
<!--- When complete, relocate to complete next step in the Updater. --->
<cflocation url="/index.cfm/CB3Updater/main/complete" addtoken="false">

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
	function processRemovals(required path, required log){
		// verify the path exists on the incoming path
		if( !fileExists( arguments.path ) ){
			arguments.log.append("Skipping file removals as file does not exist: #arguments.path#<br/>");
			return;
		}
		// read the files to remove
		var removalText = fileRead( arguments.path );
		arguments.log.append("Starting to process removals from: #arguments.path#<br/>");

		// if there are files, then remove, else continue
		if( len( removalText ) ){
			var files = listToArray( removalText, chr(10) );
			for(var thisFile in files){
				if( fileExists( expandPath("/#thisFile#" ) ) ){
					fileDelete( expandPath("/#thisFile#" ) );
					arguments.log.append("Removed: #thisFile#<br/>");
				}
				else{
					arguments.log.append("File Not Found, so not removed: #thisFile#<br/>");
				}
			}
		}
		else{
			arguments.log.append("No updated files to remove. <br/>");
		}

		// remove deletes.txt file
		//fileDelete( arguments.path );
	}
	
	/**
	* Process updated files
	*/
	function processUpdates(required path, required log){

		// Verify patch exists
		if( !fileExists( arguments.path ) ){
			arguments.log.append("Skipping patch extraction as no patch.zip found in update patch.<br/>");
			return;
		}

		// test zip has files?
		try{
			var listing = zipUtil.list( arguments.path );
		}
		catch(Any e){
			// bad zip file.
			arguments.log.append("Error getting listing of zip archive, bad zip.<br />");
			rethrow;
		}

		// good zip file
		arguments.log.append("Patch Zip archive detected, beginning to expand update: #arguments.path#<br />");
		// extract it
		zipUtil.extract(zipFilePath=arguments.path, extractPath=appPath, overwriteFiles="true");
		// more logging
		arguments.log.append("Patch Updates uncompressed.<br />");

		// remove patch
		//fileDelete( arguments.path );
	}
</cfscript>