strComputer = "."

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")

Set colNetAdapters = objWMIService.ExecQuery _
    ("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled=True")

arrSubnetMask = Array("255.255.255.0")

For Each objNetAdapter in colNetAdapters
    For Each strAddress in objNetAdapter.IPAddress
        arrOctets = Split(strAddress, ".")
        If arrOctets(0) = "10" and arrOctets(1) = "10" Then

            arrSubnetMask = Array("255.255.255.0")
            arrGW = Array("192.168.1.1")
            arrDNSServers = Array("192.168.0.1", "192.168.0.2", "192.168.0.3")
            strWINSPrimaryServer = "192.168.0.1"
            strWINSSecondaryServer = "192.168.0.2"

            strNewAddress = "192.168." & arrOctets(2) & "." & arrOctets(3)
            arrIPAddress = Array(strNewAddress)

            errEnable = objNetAdapter.EnableStatic(arrIPAddress, arrSubnetMask)
            errGW = objNetAdapter.DefaultIPGateway(arrGW)
            errDns = objNetAdapter.SetDNSServerSearchOrder(arrDNSServers)
            errWins = objNetAdapter.SetWINSServer(strWINSPrimaryServer, strWINSSecondaryServer)
        End If
    Next
Next
