Const Active = False 'Is script active or runing in test mode
Const sRootSource = "e:\BulkuploadFiles\" 'top level folders
Const sAppendSource = "\Listings\Listing_File_Archive\" ' subdir to append to subdirs of sRootSource
Const MaxAge = 60 'days
Const MaxSize = 52428800 'Size in bytes  -- Size in MB * 1024 * 1024
Const Recursive = True 'check subfolders

'reset other varibles
Checked = 0
Deleted = 0
totalSize = 0
toCheck = ""

'create File System Object and start logfile
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oLogFile = oFSO.OpenTextFile(oFSO.GetParentFolderName(WScript.ScriptFullName) & "\DeleteFilesScriptLog.txt", 8, True, -2)
oLogFile.Write "<----------------------Script started at: " & Now() & "---------------------->" & vbCrLf

'get parent dir list and the run CheckFolder on each subdir
ListFolder oFSO.GetFolder(sRootSource)

If Active Then verb = " file(s) and folder(s) were deleted." Else verb = " file(s) and folder(s) would be deleted."
'WScript.Echo Checked & " file(s) and folder(s) checked, " & Deleted & verb

'Gets top level folder names from sRootSource, checks to make sure the subdir exists and if true runs CheckFolder
Sub ListFolder (oRootFldr)
	For Each oSubfolder In oRootFldr.SubFolders
	toCheck = oSubfolder & sAppendSource
	if  oFSO.FolderExists(toCheck) Then
	CheckFolder oFSO.GetFolder(toCheck)
	end if
	Next
End Sub

'Takes the folder specified in sSource and deletes all files that are older than MaxAge days and that don't have
'the Read-only, Hidden, and/or System File attributes, and deletes all empty folders
Sub CheckFolder (oFldr)
    For Each oFile In oFldr.Files
              
        Checked = Checked + 1
                
        'If this is a trial run display if the old file would be deleted and record size to logfile
        If not Active Then
            If DateDiff("D", oFile.DateCreated, Now()) > MaxAge Then                            
                Deleted = Deleted + 1
				totalSize = totalSize + oFile.Size
                oLogFile.Write "The File <<" & oFile & ">> would be deleted because it's too OLD." & vbCrLf                           
            End If
	    If oFile.Size > MaxSize Then                            
                Deleted = Deleted + 1
				totalSize = totalSize + oFile.Size
                oLogFile.Write "The File <<" & oFile & ">> would be deleted because it's too BIG. " & oFile.Size & "bytes" & totalSize/1024/1024 & "GB" & vbCrLf                        
            End If
        End If
        
        'If this is a real run delete old items and write to log
        If Active Then            
            If DateDiff("D", oFile.DateCreated, Now()) > MaxAge Then
                Deleted = Deleted + 1
				totalSize = totalSize + oFile.Size
                oLogFile.Write "Deleted File (age): " & oFile & vbCrLf
                oFile.Delete
            End If            
		If oFile.Size > MaxSize Then
                Deleted = Deleted + 1
				totalSize = totalSize + oFile.Size
                oLogFile.Write "Deleted File (size): " & oFile & vbCrLf
                oFile.Delete
            End If          


	   End If
        
    'End of File Loop            
    Next

    'If we don't want this script to run into subfolders then exit the method here
    If not Recursive Then Exit Sub
        
    For Each oSubfolder In oFldr.Subfolders
        Checked = Checked + 1 
        
		'check the subfolder's files
		CheckFolder(oSubfolder)
		
        'If this is a trial run display if an empty folder would be deleted
        If not Active AND CountFiles(oFSO.GetFolder(oSubfolder)) = 0 Then
            Deleted = Deleted + 1
            WScript.Echo "The Folder <<" & oSubfolder & ">> is Empty."
        End If
        
        'If this is a real run delete the empty folder and write to log
        'If Active AND CountFiles(oFSO.GetFolder(oSubfolder)) = 0 Then
        '    Deleted = Deleted + 1
        '    oLogFile.Write "Deleted Folder:" & oSubfolder & vbCrLf
        '    oSubfolder.Delete
        'End If
        
    'End of Subfolder Loop
    Next        
    
End Sub

oLogFile.Write Checked & " file(s) and folder(s) checked, " & Deleted & verb
oLogFile.Write totalSize & "bytes would be freed up, or " & totalSize/1024/1024 & "GB"

oLogFile.Write "<----------------------Script ended at: " & Now() & "---------------------->" & vbCrLf
oLogFile.Close

' Takes a string argument containing the name of the directory
' returns an integer containing the nubmer of files in that direcrectory
' and all sub directories
'This Function modified from visualAd on www.vbforums.com's post on Apr 29th, 2004 at 06:18PM
Function CountFiles (ByVal StrFolder)
    Dim ParentFld
    Dim SubFld
    Dim IntCount
    
    Set ParentFld = oFSO.GetFolder (StrFolder)
    
    ' count the number of files in the current directory
    IntCount = ParentFld.Files.Count
    
    For Each SubFld In ParentFld.SubFolders
        ' count all files in each subfolder - recursion point
        IntCount = IntCount + CountFiles(SubFld.Path)
    Next

    ' return counted files
    CountFiles = IntCount
End Function