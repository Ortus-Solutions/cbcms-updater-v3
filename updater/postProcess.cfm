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
    <title>ContentBox 3 Updater Post Process</title>

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
	<h1>Finalizing Updater for ContentBox, please wait....</h1>
	<hr>
	<cfflush><cfflush>

<cfscript>
	// Setup Variables
	log 		= createObject( "java", "java.lang.StringBuilder" ).init( "" );
	modulePath 	= url.modulePath;

	// Build Updater
	oUpdater = application.wirebox.getInstance( "#modulePath#.assets.Update" );

	log.append( "About to call post processing for Installation, please wait... <br/>" );
	writeOutput( log.toString() );flushit();	

	// do postInstallation
	oUpdater.postInstallation( log );
	log.append( "Update.cfc - called postInstallation() method.<br/>" );

	writeOutput( log.toString() );flushit();

</cfscript>


</body>
</html>