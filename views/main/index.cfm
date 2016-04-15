<cfset appPath = expandPath( "../../../../../" )>
<cfset oldCFC = getOldCFC()>
<h1>Running Tests</h1>

<form action="/modules/contentbox/modules/cb3updater/updater/index.cfm?appName=<cfoutput>#application.applicationname#</cfoutput>" method="post">
	<p>Upgrading from Contentbox 2.x to 3.x requires a ColdBox upgrade, and changes to your Application.cfc. 
	We have transferred your datasource and application name to the new Updated CFC. If your Application.cfc has any other customizations, please copy them from your original (shown at the bottom of the page) into the Updated Application.cfc below</p>
	
	<h3>Updated Application.cfc</h3>
	
	<textarea name="newCFC" style="width:100%;height:500px;">
<cfoutput>#cleanUpApplicationCFC( oldCFC )#</cfoutput>		
	</textarea>
	
	<p>
		<input type="submit" value="Save Application.cfc and Continue Upgrade">
	</p>
	
	<h3>Original Application.cfc</h3>
	<textarea style="width:100%;height:250px;">
<cfoutput>#oldCFC#</cfoutput>	
	</textarea>	
</form>	

<cfscript>
	
	function getOldCFC(){
		theFile = fileRead( appPath & 'Application.cfc' );
		return theFile;
	}
	
	function cleanUpApplicationCFC( theFile ){
		theName = ReMatch( "this.name.*?;", theFile );
		if ( arrayLen( theName ) > 0 ) {
			theName = theName[1];
		}
		theDatasource = ReMatch( "this.datasource.*?;", theFile );
		
		theFile = fileRead( expandPath( 'modules/contentbox/modules/CB3Updater/assets/ApplicationTemplate.cfc' ) );
		updatesArray = [
						{ from="@this.name@", to="#theName#" },
						{ from="@this.datasource@", to="#theDatasource[1]#" }
						];						
		for ( update in updatesArray ){
			theFile = replaceNoCase( theFile, update.from, update.to, "all" );	
		}
		return theFile;
	}
	
</cfscript>
