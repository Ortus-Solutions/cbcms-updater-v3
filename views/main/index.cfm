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

	<p>Upgrading from Contentbox 2.x to 3.x requires a ColdBox upgrade, and changes to your <code>Application.cfc</code>. 
	We have transferred your <kbd>datasource</kbd> and <kbd>application name</kbd> to the new Updated CFC. If your <code>Application.cfc</code> has any other customizations, please copy them from your original (shown at the bottom of the page) into the <strong>Updated Application.cfc</strong> below.</p>
	
	<h3>Updated Application.cfc</h3>
	
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
</form>	
</cfoutput>