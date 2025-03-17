Class extends HTTPHandler

property documentsFolder : 4D:C1709.Folder

shared singleton Class constructor()
	
	Super:C1705()
	
	This:C1470.documentsFolder:=Folder:C1567("/PACKAGE/Documents/")
	
Function list($request : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	var $response:=4D:C1709.OutgoingMessage.new()
	
	var $file : 4D:C1709.File
	var $name : Text
	var $links:=[]
	
	For each ($file; This:C1470.documentsFolder.files())
		$name:=This:C1470._encodeURIComponent($file.fullName)
		$links.push([\
			"<a href=\""; \
			"/documents/download?name="; \
			$name; \
			"\""; \
			" download=\""; $name; \
			"\">"; \
			This:C1470._escape($file.fullName); \
			"</a>"; \
			"<br />"\
			]\
			.join(""))
	End for each 
	
	If (Session:C1714.isGuest()) || (Session:C1714.getPrivileges().length=0)
		$links.push("<p>you need to be logged in to download files!</p>")
		$links.push("<form action=\"/login\" method=\"post\">")
		$links.push("<button name=\"user\" value=\"login\">Login</button>")
		$links.push("</form>")
	Else 
		$links.push("<p>you are loggined in as "+This:C1470._escape(Session:C1714.getPrivileges().join(", "))+"</p>")
		$links.push("<form action=\"/logout\" method=\"post\">")
		$links.push("<button name=\"user\" value=\"logout\">Logout</button>")
		$links.push("</form>")
	End if 
	
	var $html : Text:=$links.join("\r")
	
	$response.setBody($html)
	$response.setHeader("Content-Type"; "text/html")
	
	return $response
	
Function download($request : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	var $response:=4D:C1709.OutgoingMessage.new()
	
	If ($request.urlQuery.name#Null:C1517)
		
		var $file : 4D:C1709.File
		$file:=This:C1470.documentsFolder.file($request.urlQuery.name)
		If ($file.exists)
			
			$response.setBody($file.getContent())
			$response.setHeader("Content-Type"; This:C1470._getContentType($file))
			
		End if 
	End if 
	
	return $response