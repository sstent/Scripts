Option Explicit
On Error Resume Next

Dim StartTime,EndTime: StartTime = Now ' For seeing how long the script takes to run
Wscript.Echo "StartTime = " & StartTime
' ***************************************************************** '
Dim objParent, strSite, ComputerName, strOutput
ComputerName = "pnymvp01"
Set objParent = GetObject("IIS://" & ComputerName & "/W3SVC")
    If err.number <> 0 Then
        Wscript.Echo "Error enumerating sites on: " & ComputerName & " - " & err.number & " - " & err.description
    Else
        Wscript.Echo "Enumerating sites on: " & ComputerName
    End If
For Each strSite in objParent
    If IsNumeric(strSite.Name) Then
        strOutput = strSite.Name & " - " & strSite.ServerComment
        Wscript.Echo strOutput
    End If
Next
' ***************************************************************** '
EndTime = Now
'Wscript.Echo vbCrLf & "EndTime = " & EndTime
'Wscript.Echo "Seconds Elapsed: " & DateDiff("s", StartTime, EndTime)
Wscript.Echo "Script Complete"
Wscript.Quit(0)