//%attributes = {"invisible":true,"preemptive":"capable"}
var $h : cs:C1710.HTTPHandler
$h:=cs:C1710.HTTPHandler.me

var $t : Text
$t:=$h._encodeURIComponent("AZaz09-_.!~*'()あいうえお")
$t:=$h._encodeURI("AZaz09;,/?:@&=+$-_.!~*'()#あいうえお")