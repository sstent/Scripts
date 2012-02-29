'==========================================================================
'
' VBScript Source File -- Created with SAPIEN Technologies PrimalSCRIPT(TM)
'
' NAME: EnableKerbLog.vbs
'
' AUTHOR: Microsoft Corp.
' DATE  : 12/14/2001
'
' COMMENT: Script is designed to assist Customers with Enabling Kerberos Logging 
' on Multiple Clients.
'==========================================================================
Dim wsObj

Set wsObj = CreateObject("Wscript.Shell")

' Add the LogLevel Value to Kerberos Key in Registry.
On Error Resume Next 
WScript.Echo "Enabling Kerberos Logging..."
wsObj.RegWrite "HKLM\System\CurrentControlSet\Control\LSA\Kerberos\Parameters\LogLevel",1,"REG_DWORD"


Set wsObj = Nothing 

WScript.Echo "-=[Complete!]=-"