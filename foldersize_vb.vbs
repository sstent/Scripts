dim oFS, oFolder
set oFS = WScript.CreateObject("Scripting.FileSystemObject")
set oFolder = oFS.GetFolder("c:\documents and settings\")

ShowFolderDetails oFolder

sub ShowFolderDetails(oF)
dim F
    wscript.echo oF.Name & ":Size=" & oF.Size
    wscript.echo oF.Name & ":#Files=" & oF.Files.Count
    wscript.echo oF.Name & ":#Folders=" & oF.Subfolders.count
    wscript.echo oF.Name & ":Size=" & oF.Size
    for each F in oF.Subfolders
        ShowFolderDetails(F)
    next
end sub