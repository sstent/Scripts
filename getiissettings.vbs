strComputer = "pnyweb02" 
 
Set objWMIService = GetObject _ 
    ("winmgmts:{authenticationLevel=pktPrivacy}\\" _ 
        & strComputer & "\root\microsoftiisv2") 
 
Set colItems = objWMIService.ExecQuery _ 
    ("Select * from IIsWebServerSetting") 
 
For Each objItem in colItems 
    For i = 0 to Ubound(objItem.ServerBindings) 
        Wscript.Echo "" & objItem.ServerBindings(i).IP & " " & objItem.ServerBindings(i).Port & " " & objItem.ServerBindings(i).Hostname
    Next 
Next