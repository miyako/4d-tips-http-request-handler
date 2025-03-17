shared singleton Class constructor()
	
Function login($request : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	var $response:=4D:C1709.OutgoingMessage.new()
	
	var $success : Boolean:=Session:C1714.setPrivileges("member")
	
	$response.setHeader("Location"; $request.headers.referer)
	$response.setStatus(302)
	
	return $response
	
Function logout($request : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	var $response:=4D:C1709.OutgoingMessage.new()
	
	var $success : Boolean:=Session:C1714.clearPrivileges()
	
	$response.setHeader("Location"; $request.headers.referer)
	$response.setStatus(302)
	
	return $response
	
Function _getContentType($file : 4D:C1709.File) : Text
	
	Case of 
		: ($file.extension=".txt")
			return "text/plain"
		: ($file.extension=".pdf")
			return "application/pdf"
		: ($file.extension=".jpg") || ($file.extension=".jpeg")
			return "image/jpeg"
		: ($file.extension=".tif") || ($file.extension=".tiff")
			return "image/tiff"
		: ($file.extension=".png")
			return "image/png"
		: ($file.extension=".gif")
			return "image/gif"
		: ($file.extension=".webp")
			return "image/webp"
		Else 
			return "application/octet-stream"
/*
https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types/Common_types
*/
	End case 
	
Function _escape($unescaped : Text)->$escaped : Text
	
	var $code:="<!--#4dtext $1-->"
	PROCESS 4D TAGS:C816($code; $escaped; $unescaped)
	
Function _encodeURI($unescaped : Text)->$escaped : Text
	
	var $shouldEscape : Boolean
	var $i; $j; $code : Integer
	var $char; $hex : Text
	var $data : Blob
	
	For ($i; 1; Length:C16($unescaped))
		$char:=Substring:C12($unescaped; $i; 1)
		$code:=Character code:C91($char)
		$shouldEscape:=False:C215
		
		Case of 
			: ($code>63) & ($code<91)  //A-Z
			: ($code>96) & ($code<123)  //a-z
			: ($code>47) & ($code<58)  //0-9
			: ($code=59)  //;
			: ($code=44)  //,
			: ($code=47)  ///
			: ($code=63)  //?
			: ($code=58)  //:
			: ($code=64)  //@
			: ($code=38)  //&
			: ($code=61)  //=
			: ($code=43)  //+
			: ($code=36)  //$
			: ($code=45)  //-
			: ($code=95)  //_
			: ($code=46)  //.
			: ($code=33)  //!
			: ($code=126)  //~
			: ($code=42)  //*
			: ($code=39)  //'
			: ($code=40)  //(
			: ($code=41)  //)
			: ($code=35)  //#
			Else 
				$shouldEscape:=True:C214
		End case 
		
		If ($shouldEscape)
			CONVERT FROM TEXT:C1011($char; "utf-8"; $data)
			For ($j; 0; BLOB size:C605($data)-1)
				$hex:=String:C10($data{$j}; "&x")
				$escaped+=("%"+Substring:C12($hex; Length:C16($hex)-1))
			End for 
		Else 
			$escaped+=$char
		End if 
		
	End for 
	
	return $escaped
	
Function _encodeURIComponent($unescaped : Text)->$escaped : Text
	
	var $shouldEscape : Boolean
	var $i; $j; $code : Integer
	var $char; $hex : Text
	var $data : Blob
	
	For ($i; 1; Length:C16($unescaped))
		$char:=Substring:C12($unescaped; $i; 1)
		$code:=Character code:C91($char)
		$shouldEscape:=False:C215
		
		Case of 
			: ($code>63) & ($code<91)  //A-Z
			: ($code>96) & ($code<123)  //a-z
			: ($code>47) & ($code<58)  //0-9
			: ($code=45)  //-
			: ($code=95)  //_
			: ($code=46)  //.
			: ($code=33)  //!
			: ($code=126)  //~
			: ($code=42)  //*
			: ($code=39)  //'
			: ($code=40)  //(
			: ($code=41)  //)
			Else 
				$shouldEscape:=True:C214
		End case 
		
		If ($shouldEscape)
			CONVERT FROM TEXT:C1011($char; "utf-8"; $data)
			For ($j; 0; BLOB size:C605($data)-1)
				$hex:=String:C10($data{$j}; "&x")
				$escaped+=("%"+Substring:C12($hex; Length:C16($hex)-1))
			End for 
		Else 
			$escaped+=$char
		End if 
		
	End for 
	
	return $escaped