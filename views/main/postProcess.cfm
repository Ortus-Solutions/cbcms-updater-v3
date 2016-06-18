<cfoutput>
<div class="jumbotron">
	<div class="pull-left">
		<img src="#event.getModuleRoot()#/assets/ContentBox_300.png">
	</div>
	<h1>Updater Complete</h1>
	<p>&nbsp;</p>
</div>

<h2>Updater Log File </h2>
<pre>
#prc.log.toString()#
</pre>

<hr>

<p>The udpater has finished successfully.  You can now log in to your new <a href="/cbadmin">new admin</a> or visit <a href="/">your new site</a></p>
</cfoutput>