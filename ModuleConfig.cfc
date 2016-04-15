/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox 3 Updater
*/
component {

	// Module Properties
	this.title 				= "CB3 Updater";
	this.author 				= "Ortus Solutions, Corp";
	this.webURL 				= "http://www.ortussolutions.com";
	this.description 		= "This Updater Module helps upgrade from Contentbox 2.1 to 3.0";
	this.version				= "3.0.0-beta+@build.number@";
	this.viewParentLookup 	= true;
	this.layoutParentLookup 	= true;
	this.entryPoint			= "CB3Updater";
	this.modelNamespace 		= "CB3Updater";
	this.cfmapping 			= "CB3Updater";
	this.dependencies 		= [ ];

	function configure(){
		// parent settings
		parentSettings = {};

		// module settings - stored in modules.name.settings
		settings = {
		};

		// Layout Settings
		layoutSettings = {
			defaultLayout = ""
		};

		// datasources
		datasources = {};

		// web services
		webservices = {};

		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="main",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Points
		interceptorSettings = {
		};

		// Custom Declared Interceptors
		interceptors = [
		];
	}
	
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		
	}


}
