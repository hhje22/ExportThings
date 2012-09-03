# ExportThings - for exporting Things database to the Desktop as Things Backup.txt
# Dexter Ang - @thepoch on Twitter
# Copyright (c) 2012, Dexter Ang
#
# Somewhat based on "Export Things to text file (ver 1)" by John Wittig
# and from reading the Things AppleScript Guide (rev 13).
#
# Tested with Things 2.0.1 and OS X Mountain Lion
#
# TODO:
# - Get Repeating ToDos (currently no way via AppleScript).
# - Make tags tab delimited by heirarchy.
# - Export Areas. Maybe.
# - For each exported ToDo, also include their tags and areas. Maybe.
#

set theFilePath to (path to desktop as Unicode text) & "Things Backup.txt"
set theFile to (open for access file theFilePath with write permission)
set eof of theFile to 0

tell application "Things" to activate

tell application "Things"
	
	log completed now
	empty trash
	
	set theList to {"Inbox", "Today", "Next", "Scheduled", "Someday", "Projects"}
	
	write "----------" & linefeed to theFile
	
	repeat with theListItem in theList
		
		write "| " & theListItem & ":" & linefeed & linefeed to theFile
		set toDos to to dos of list theListItem
		repeat with toDo in toDos
			set tdName to the name of toDo
			set tdDueDate to the due date of toDo
			set tdNotes to the notes of toDo
			
			write "- " & tdName & linefeed to theFile
			if tdDueDate is not missing value then
				write ">> Due: " & date string of tdDueDate & linefeed to theFile
			end if
			if tdNotes is not "" then
				# Append a "tab" to each line of tdNotes.
				repeat with noteParagraph in paragraphs of tdNotes
					write tab & noteParagraph & linefeed to theFile
				end repeat
			end if
			
			# Special case for Projects, we get the tasks for each project.
			if (theListItem as string = "Projects") then
				set prToDos to to dos of project tdName
				repeat with prToDo in prToDos
					set prtdName to the name of prToDo
					set prtdDueDate to the due date of prToDo
					set prtdNotes to the notes of prToDo
					
					write tab & "- " & prtdName & linefeed to theFile
					if prtdDueDate is not missing value then
						write tab & ">> Due: " & date string of prtdDueDate & linefeed to theFile
					end if
					if prtdNotes is not "" then
						# Append a "tab" to each line of tdNotes.
						repeat with prnoteParagraph in paragraphs of prtdNotes
							write tab & tab & prnoteParagraph & linefeed to theFile
						end repeat
					end if
				end repeat
			end if
		end repeat
		
		write linefeed & "----------" & linefeed to theFile
		
	end repeat
	
	write "| Tags:" & linefeed & linefeed to theFile
	repeat with aTag in tags
		write "- " & name of aTag & linefeed to theFile
	end repeat
	
	close access theFile
	
end tell
