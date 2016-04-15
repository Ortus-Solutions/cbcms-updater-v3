component{

	// DI
	property name="updateService" inject="id:UpdateService@cb";
	
	/**
	* Renders the Application Update form, allowing the user to make simple updates to the Application
	* CFC before the update starts 
	*/
	public void function index(event,rc,prc){
		event.setView("main/index");
	}	
	
	/**
	* Event to run after the initial install, and application clear.
	* This should force the app to reinit, to complete the update.
	*/
	function complete( event, rc, prc ){
		writeDump( updateService );
		event.setView("main/complete");
	}

}