'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''SFTP Folder Management Script'''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Author: Stuart Stent
'LastUpdated: 9/24/10
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Description: 
'This script looks in a root directory and for each subdirectory
'under that folder it manages the files in folders one level below that.
'
'i.e SrootSource = e:\BulkuploadFiles + \Username + \sAppendSource \ managedfolders
'
'For each of the managed folders three passes are run
'	1 - Delete files older than that defined in MaxAge -- eg. kill all files older than 60 days
'	2 - Zip remaining files in to archives - by week (named by final day of week - sunday)
'	3 - Deletes zip files older than MaxAge
'	4 - finally, check each folder to ensure it is within the prescribed size limit. If not delete old zip files until under defined limit
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Define Constants and Initialise environment
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Const sRootSource = "d:\test" 'top level folders
Const sAppendSource = "\Listings\" ' subdir to append to subdirs of sRootSource
const sWinzipLocation = "C:\Progra~1\WinZip\WZZIP.EXE -e0 " 'needs a trailing space-
Const MaxAgeInterval = "D" 'Accepts D for days or M for Months
Const ConstMaxAge = 60 'Maximum intervals to keep a file -- see MaxAgeInterval
Const WeeksofActiveFiles = 0 'number of weeks (over the current week) of active files (not zipped) to keep --zero = this week only
Const MaxSize = 524288000 'Size in bytes  -- Size in MB * 1024 * 1024 (524288000 = 500MB)
DIM MaxAge

Const TESTRUN = false 'Log stuff only, don't delete anything
' note: testrun will show duplicate files being zipped etc due to order of operations

' Turn Modules on/off
Const CleanUp = true 'Delete files older than MaxAge before zipping
Const ZipFiles = true 'Zip files into weekly packages
Const CheckZipFiles = true 'clean up zip files older than maxage
Const FoldersizeQuotas = true 'Cull old zip files to meet maximum foldersize

'EXCEPTIONS
'Seller ID BNA0000003 will carry different rules:
'-files will be kept for 30 days, regardless of folder size
Const Exceptions = True
XFolder = "BNA0000003"
XMaxAge = 30 'Maximum intervals to keep a file (on exception match) -- see MaxAgeInterval

'Setup Environment
Set objShell = wscript.createObject("wscript.shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oLogFile = oFSO.OpenTextFile(oFSO.GetParentFolderName(WScript.ScriptFullName) & "\Listings_Cleanup_Log-"&Year(now()) & Right("0" & Month(now()), 2) & Right("00" & Day(now()), 2) &".csv", 8, True, -2)
oLogFile.Write "<----------------------Script started at: " & Now() & "---------------------->" & vbCrLf
if TESTRUN then oLogFile.Write "<----------------------TESTING MODE---------------------->" & vbCrLf
if TESTRUN then oLogFile.Write "note: testrun will show duplicate files being zipped etc due to order of operations" & vbCrLf

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''' DO NOT EDIT BELOW THIS LINE'''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

ListFolder oFSO.GetFolder(sRootSource)

Sub ListFolder (oRootFldr)

	For Each oSubfolder In oRootFldr.SubFolders
	
		if  oSubfolder.name = XFolder and Exceptions then
			MaxAge = XMaxAge
			oLogFile.Write "ExceptionMatched,"& oSubfolder & vbCrLf
		Else 
			MaxAge = ConstMaxAge 
		end if

		if  oFSO.FolderExists(oSubfolder & sAppendSource) Then
			IterateSubfolders oFSO.GetFolder(oSubfolder & sAppendSource)
		end if

	Next
End Sub


Sub IterateSubfolders (oFldr)
    For Each oSubfolder In oFldr.Subfolders
		if CleanUp then	
			CheckFolder_Delete(oSubfolder) ' deletes files older than MaxAge(ConstMaxAge or XMaxAge)
		end if
		if ZipFiles then	
			CheckFolder_Zip(oSubfolder) 'zips up files into weekly archives
		end if
		if CheckZipFiles then
			CheckOld_Zip (oSubfolder) 'delete zips older than maxage
		end if
		if FoldersizeQuotas and not oSubfolder.name = XFolder then 
			CheckFoldersize(oSubfolder) 'deletes old zip files until MaxSize reached
		end if
	Next
End Sub

Sub CheckFolder_Delete (oFldr)
    For Each oFile In oFldr.Files
		if not (Right(oFile.Name, 3)) = "zip" then
			If DateDiff(MaxAgeInterval, oFile.DateCreated, Now()) > MaxAge Then
				oLogFile.Write "Deleted_OLD_File," & MaxAge & "," & oFile & vbCrLf
				if not TESTRUN then oFile.Delete
			End If            
        end if        
    Next 
End Sub

Sub CheckFolder_Zip (oFldr)
    	'determine number of weeks of zip files
		oldestZipDate = DateAdd(MaxAgeInterval,-(MaxAge), now())
		ZipIterations = DateDiff("w",oldestZipDate,now())
		i = ZipIterations + 5
		do until i = WeeksofActiveFiles
			'caluate ZipAge from WeeksofActiveFiles requirement and todays date
			ZipAge = ((WeekDay(Date, vbSaturday))-1) 
			'modify ZipAge keep current week + x weeks of active(unzipped) files
			if ZipAge = 0 then ZipAge = ((i-2) * 7) else ZipAge = ZipAge + 7 + ((i-2) * 7)
		
					For Each oFile In oFldr.Files
					if not (Right(oFile.Name, 3)) = "zip" then
						If DateDiff("D", oFile.DateLastModified, Now()) >= ZipAge Then
							  nDate = DateAdd("d", (0-(ZipAge+6)), now())
							  sDate = Year(nDate) & Right("0" & Month(nDate), 2) & Right("00" & Day(nDate), 2)
							  zipName = oFldr & "\WK_" & sDate & ".zip " 'zipfilename
							  if TESTRUN and not DateDiff(MaxAgeInterval, oFile.DateLastModified, Now()) > MaxAge and not DateDiff("D", oFile.DateLastModified, Now()) >= (ZipAge + 7) Then
								oLogFile.Write "Zipped_File_1," & oFile & "," & zipName & vbCrLf
							  end if
							  if not TESTRUN then 
								
								oLogFile.Write "Zipped_File," & oFile & "," & zipName & vbCrLf	
								zipFolder=oFldr & "\WK_" & sDate 
										If (Not oFSO.FolderExists(zipFolder)) Then
											Set f = oFSO.CreateFolder(zipFolder)
										End If
								
								oFSO.MoveFile oFile, zipFolder & "\"						
							  end if
						End If
					End If
			Next
			strCommand = sWinzipLocation & zipName & zipFolder & "\*.*"
			strRun = objShell.Run(strCommand, 0, True)
			If (oFSO.FolderExists(zipFolder)) Then
				oFSO.DeleteFolder zipFolder, force
			End If 
		i = i - 1
		Loop
	End Sub

	Sub CheckOld_Zip (oFldr)
    	'determine number of weeks of zip files
		oldestZipDate = DateAdd(MaxAgeInterval,-(MaxAge), now())
		NumberOfZips = DateDiff("w",oldestZipDate,now())
		
		'init array
		dim ZipNamesArray()
		redim ZipNamesArray(NumberOfZips)
		'calculate zip names
		
		i = 0
		do until i = NumberOfZips
		ZipAge = ((WeekDay(Date, vbSaturday))-1) 
		'modify ZipAge keep current week + x weeks of active(unzipped) files
		if ZipAge = 0 then ZipAge = ((i-2) * 7) else ZipAge = ZipAge + 7 + ((i-2) * 7)
		
		nDate = DateAdd("d", (0-(ZipAge+6)), now())
		sDate = Year(nDate) & Right("0" & Month(nDate), 2) & Right("00" & Day(nDate), 2)
		zipName = oFldr & "\WK_" & sDate & ".zip" 'zipfilename
		ZipNamesArray(i) = zipName 'add zipfilename to array
		i = i + 1
		loop
		
		' check each file to see if it matches any of the 'safe' zip names
		For Each oFile in oFldr.files
			toDelete = 0
			if (Right(oFile.Name, 3)) = "zip" then
			i=0
				do until i = NumberOfZips
				if not oFile = ZipNamesArray(i) then toDelete = toDelete + 1
				i = i + 1
				loop
			end if
			if toDelete = NumberOfZips then 
				oLogFile.Write "Deleted_OLD_Zip," & oFile & vbCrLf
				if not TESTRUN then oFSO.DeleteFile(oFile)
			end if
		next
End Sub
	
	
Sub CheckFoldersize(oFldr)
    i = 0
    subfolderSize = Int(oFldr.Size)
	    if TESTRUN then
			if subfolderSize > MaxSize then oLogFile.Write "Folder_Over_Quota," & oFldr & vbCrLf
		end if
	
	Do While subfolderSize > MaxSize And i < 100 and not TESTRUN
    
		
		OldestFile = ""
        dtmOldestDate = Now

        For Each oFile in oFldr.files
			if (Right(oFile.Name, 3)) = "zip" then
				dtmFileDate = oFile.DateLastModified
				If dtmFileDate < dtmOldestDate Then
					dtmOldestDate = dtmFileDate
					OldestFile = oFile
				End If
			end if
        Next
		oLogFile.Write "Deleted_OLDEST_File," & OldestFile & vbCrLf
        
		if not TESTRUN then 
			if not OldestFile = "" then oFSO.DeleteFile(OldestFile)
		end if
    
        subfolderSize = Int(oFldr.Size)
        i = i + 1
    Loop

End Sub

oLogFile.Write "<----------------------Script ended at: " & Now() & "---------------------->" & vbCrLf
oLogFile.Close
