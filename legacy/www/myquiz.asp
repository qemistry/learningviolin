<% Response.Buffer = TRUE %>
<%
QuizID = Session.Value("myquiz_QuizID")
'Ima has only one quiz
If QuizID = "" Then
QuizID="1"
End If
Set AdminTable = CreateObject("ADODB.Recordset")
AdminTable.Open "SELECT DISTINCTROW TOP 1 * FROM QuizAdminOptions Where ID=" & QuizID, "DSN=imamusic;"
QuizTitle = AdminTable.Fields("QuizTitle")
QuizDesc = AdminTable.Fields("QuizDescription")
QuizBackground = AdminTable.Fields("Background")
QuizImage = AdminTable.Fields("QuizImage")
QuizAllowQ = AdminTable.Fields("AllowQuestions")
QuizAllowComments = AdminTable.Fields("AllowComments")
QuizAllowProtests = AdminTable.Fields("AllowProtests")
QuizHardScore = AdminTable.Fields("HardScore")
QuizMediumScore = AdminTable.Fields("MediumScore")
QuizEasyScore = AdminTable.Fields("EasyScore")
QuizWebMaster = AdminTable.Fields("WebmasterName")
QuizWebMasterEmail = AdminTable.Fields("WebmasterEmail")
QuizTopScores = AdminTable.Fields("ShowTopScores")
QuizRecentScores = AdminTable.Fields("ShowRecentScores")
QuizNumberQuestions = AdminTable.Fields("NumberQuestions")
AdminTable.Close
%>
<%
adOpenStatic = 3
adOpenDynamic = 2
adOpenKeyset = 1
%>
<!-- #include file="globalinc.asp" -->
<%
pagelines = 75
%>
<!-- #include file="metainc.asp" -->
<! The Main Page Table>
<form action="myquizresults.asp"
method="POST">
<%
PlayerName = Request.Form("Player")
Increment = Request.Form("increment")
LastID = Request.Form("LastID")
If IsNull(Increment) or Increment = "" Then
Increment = 0
Else
Increment = CDbl(Increment)
End If
If IsNull(LastID) or LastID = "" Then
LastID = 0
Else
LastID = CInt(LastID)
End If
%>
Your Player Name : <input type="text" size=20 name="player" value="<%=PlayerName%>">
<%
PlayLevel = Request.Form("PlayLevel")
Set QuizTable = CreateObject("ADODB.Recordset")
If PlayLevel = "E" Then
LevelText = "and LEVEL='Easy'"
End If
If PlayLevel = "M" Then
LevelText = "and LEVEL='Medium'"
End If
If PlayLevel = "H" Then
LevelText = "and Level='Hard'"
End If
If PlayLevel <> "E" and PlayLevel <> "M" and PlayLevel <> "H" Then
LevelText = " "
End If
QuizTable.Open "SELECT * FROM Quiz WHERE UseInGame=Yes " & LevelText & " and QuizID="& QuizID, "DSN=imamusic;", adOpenStatic
dim QuestArray
QuestArray = Array(-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1)
dim UseIncArray
UseIncArray = Array(357437, 357473, 357503, 357509, 357517, 357551, 357559, 357563, 357569, 357571)
Got10Questions = 1
If NOT(QuizTable.EOF) Then
QuizTable.MoveLast
NumOfRecords = QuizTable.RecordCount
QuizTable.MoveFirst
If LastID=0 or LastID > NumOfRecords or Increment=0 Then
Rnd(-1)
Randomize()
LastID = (CInt(((NumOfRecords-1)*Rnd) + 1))
UseInc = (second(Now()) mod 10)
Increment = UseIncArray(UseInc)
End If
Do Until Got10Questions > QuizNumberQuestions or Got10Questions > NumOfRecords
AlreadyUsed = 0
RandomRecord =
((Increment+LastID) MOD NumOfRecords)
For each Quest in QuestArray
If RandomRecord = Quest Then
AlreadyUsed = 1
End If
Next
If AlreadyUsed = 0 Then
QuestArray(Got10Questions) = RandomRecord
Got10Questions = Got10Questions + 1
LastID = RandomRecord
End If
Loop
dim i
i = 1
Do Until i = Got10Questions
QuizTable.MoveFirst
If QuestArray(i) > 0 Then
QuizTable.Move QuestArray(i)-1
Else
QuizTable.MoveLast
End If
radioname = "option" & i
questname = "quest" & i
ansname = "ans" & i
commentname = "comment" & i
levelname = "level" & i
anstext = "anstext" & i
TimesUsedName = "timesused" & i
TimesAnsweredCorrectName = "timesansweredcorrect" & i
IDName = "id" & i
ThanksName = "thanks" & i
ReviewedName = "review" & i
%>
<%
if (QuizTable.Fields("Reviewed") = 0 or IsNull(QuizTable.Fields("Reviewed"))) and QuizAllowProtests Then
%>
<%
end if
%>
<%
i = i + 1
Loop
End If
QuizTable.Close
%>
<input type="submit" value="How Did I Do?">
<input type="reset" value="Reset">
</form>
<form action="myquiz.asp"
method="POST">
<hr>
<input type="hidden" name="qnumber"
value ="<%=i-1%>">
<input type="hidden" name="lastid" value=0>
<input type="hidden" name="increment" value=0>
<input type="hidden" name="player" value="<%=PlayerName%>">
<input type="hidden" name="PlayLevel" value="<%=PlayLevel%>">
<input type="submit" value="Start Over with New Questions">
</form>
<!-- #include file="bottominc.asp" -->
