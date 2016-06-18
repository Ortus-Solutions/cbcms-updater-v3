<cfoutput>
<div class="jumbotron">
	<div class="pull-left">
		<img src="#event.getModuleRoot()#/assets/ContentBox_300.png">
	</div>
	<h1>Updater Module</h1>
	<p>&nbsp;</p>
</div>

<form action="#event.getModuleRoot()#/updater/index.cfm?appName=#prc.oldAppName#" method="post">
	<input type="hidden" name="appPath" 	value="#prc.appPath#">
	<input type="hidden" name="modulePath" 	value="#prc.moduleInvocationPath#">
	<input type="hidden" name="moduleRoot" 	value="#event.getModuleRoot()#">
	<input type="hidden" name="appRoot" 	value="#event.buildLink( '' )#">
	
	<p class="alert alert-danger">
		ContentBox 3 is a major upgrade and it will require some input from you in order to seamlessly upgrade your ContentBox 2.X installation.  Please follow the instructions below.
	</p>

	<section id="step1">
		<h1>Step1: ColdBox 3 -> 4 Updates</h1>
		<p>
			ContentBox 3 is now based on ColdBox 4 and will require upgrading your core framework code as well.  There are many incompatibilities between ColdBox 3 and ColdBox 4.  You can read more about them in our <a href="https://coldbox.ortusbooks.com/content/introduction/upgrading_to_coldbox_400.html" target="_blank">compatibility guide</a>.  Below are the major updates you need to do on vanilla ContentBox installations.  If you have more code or modules around the application, you will have to upgrade those modules and code as well.
		</p>

		<p>
		Open the <code>config/ColdBox.cfc</code> and remove/rename the following deprecated settings. Once you are done, click on the <kbd>Continue</kbd> button.
		</p>

<pre>
// ColdBox Tracer: Remove
coldboxTracer = { class="coldbox.system.logging.appenders.ColdboxTracerAppender" }

// AsyncLoggers
// If you are using any async loggers, remove the 'Async' prefix and use the 'async' property instead
// Below is an example
logbox.appenders.files={class="coldbox.system.logging.appenders.RollingFileAppender",
	properties = {
		filename = "ContentBox", filePath="../logs", async="true"
	}
};

// Plugins Location: Remove
coldbox.pluginsExternalLocation

// Application helper setting - rename it to: coldbox.applicationHelper
coldbox.UDFLibraryFile

// Remove debugging settings
coldbox.debugMode;
coldbox.debugPassword;
</pre>
	
	<button type="button" class="btn btn-lg btn-danger" onclick="step2()">Continue</button>

	<hr>
	</section>

	<section id="step2" style="display:none;">
		<h1>Step 2: Updated Application.cfc</h1>
		<p>
			We have transferred your <kbd>datasource</kbd> and <kbd>application name</kbd> to the new Updated CFC. If your <code>Application.cfc</code> has any other customizations, please copy them from your original (shown at the bottom of the page) into the <strong>Updated Application.cfc</strong> below.
		</p>
		
		<textarea name="newCFC" style="width:100%;height:500px;">
#prc.newAppCFC#
		</textarea>
		
		<p class="text-center">
			<input type="submit" value="Save Application.cfc and Continue Upgrade" class="btn btn-lg btn-danger">
		</p>
		
		<h3>Original Application.cfc</h3>
		<textarea style="width:100%;height:500px;">
#prc.oldApplicationCFC#
		</textarea>	
	</section>
</form>	
</cfoutput>