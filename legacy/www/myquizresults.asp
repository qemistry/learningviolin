<% Response.Buffer = TRUE %>
<%
QuizID = Session.Value("myquiz_QuizID")
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
AdminTable.Close
%>
<!-- #include file="globalinc.asp" -->
<%
pagelines = 50
%>
<!-- #include file="metainc.asp" -->
<! The Main Page Table>
<%
PlayerName = Request.Form("Player")
If ( IsNull( PlayerName ) OR "" =
PlayerName ) Then
PlayerName = "Anonymous"
End If
Increment = Request.Form("increment")
LastID = Request.Form("LastID")
Q = Request.Form("qnumber")
If Q <=0 or IsNull(Q) Then
%>
To play the game, <a href=myquizhome.asp> click here</a>
<%
Else
%>
<%
dim i, numberright, easyright, medright, hardright, easyqs, medqs, hardqs
i = 1
numberright = 0
easyright = 0
medright = 0
hardright = 0
easyqs = 0
medqs = 0
hardqs = 0
score = 0
%>
<%
Do Until i > int(Q)
radioname = "option" & i
ansname = "ans" & i
questname = "quest" & i
commentname = "comment" & i
levelname = "level" & i
anstext = "anstext" & i
idname = "id" & i
TimesUsedName = "timesused" & i
TimesAnsweredCorrectName = "timesansweredcorrect" & i
ThanksName = "thanks" & i
ReviewedName = "review" & i
id = Request.Form(idname)
question = Request.Form(questname)
Set QuizTable = CreateObject("ADODB.Recordset")
QuizTable.Open "select * from quiz WHERE id=" & id & " and QuizID="& QuizID, "DSN=imamusic;"
correctanswer = QuizTable.Fields("AnswerC")
If correctanswer = "A" then
correctanswertext = Server.HTMLEncode(QuizTable.Fields("Answer1"))
End If
If correctanswer = "B" then
correctanswertext = Server.HTMLEncode(QuizTable.Fields("Answer2"))
End If
If correctanswer = "C" then
correctanswertext = Server.HTMLEncode(QuizTable.Fields("Answer3"))
End If
If correctanswer = "D" then
correctanswertext = Server.HTMLEncode(QuizTable.Fields("Answer4"))
End If
QuizTable.Close
playeranswer = Request.Form(radioname)
comment = Request.Form(commentname)
level = Request.Form(levelname)
ThanksTo = Request.Form(thanksname)
TimesUsed = Request.Form(TimesUsedName)
TimesAnsweredCorrect = Request.Form(TimesAnsweredCorrectName)
Reviewed = Request.Form(ReviewedName)
If TimesUsed <> 0 Then
PercentCorrect = CStr(CInt(TimesAnsweredCorrect/TimesUsed*100)) & "%"
Else
PercentCorrect = "New Question!"
End If
if level="Easy" then
easyqs = easyqs + 1
end if
if level="Medium" then
medqs = medqs + 1
end if
if level="Hard" then
hardqs = hardqs + 1
end if
if correctanswer = playeranswer then
resulttext = ""
numberright = numberright + 1
if level="Easy" then
easyright = easyright + 1
end if
if level="Medium" then
medright = medright + 1
end if
if level="Hard" then
hardright = hardright + 1
end if
else
resulttext = ""
end if
%>
<%
if Not(IsNull(ThanksTo)) and ThanksTo <> "" and ThanksTo <> " " and ThanksTo <> "QuizMaster" Then
%>
<%
End If
if (Reviewed = "0" or IsNull(Reviewed) or Reviewed = "" or Reviewed = " " or Reviewed<>"True") and QuizAllowProtests=true Then
%>
<%
End If
if QuizAllowComments=true then
Set CommentTable = CreateObject("ADODB.Recordset")
CommentTable.Open "select count(*) as CountComments from Quizcomments WHERE questionid=" & id & " and QuizID= " & QuizID & " GROUP BY questionid", "DSN=imamusic;"
If Not CommentTable.EOF Then
NumberOfComments =
CommentTable.Fields("CountComments")
Else
NumberOfComments = 0
End If
CommentTable.Close
%>
<%
end if
%>
<%
Set QuizTable = CreateObject("ADODB.Recordset")
QuizTable.Open "quiz WHERE id=" & id & " and QuizID=" & QuizID, "DSN=imamusic;", 1, 3, 2
QuizTable.Fields("TimesUsed") = QuizTable.Fields("TimesUsed") + 1
If correctanswer = playeranswer then
QuizTable.Fields("TimesAnsweredCorrect") = QuizTable.Fields("TimesAnsweredCorrect") +1
End If
QuizTable.Update
QuizTable.Close
i = i + 1
Loop
%>
<%
Dim Score
Score = (easyright*QuizEasyScore) + (medright*QuizMediumScore) + (hardright*QuizHardScore)
%>
<%
if score >= 850 and QuizAllowQ=true then
%>
<%
end if
%>
<%
if QuizAllowQ=true then
%>
<%
end if
%>
<%
Set QuizPlayerTable = CreateObject("ADODB.Recordset")
QuizPlayerTable.Open "QuizPlayers", "DSN=imamusic;", 1, 3, 2
QuizPlayerTable.AddNew
QuizPlayerTable.Fields("Player") = PlayerName
QuizPlayerTable.Fields("Score") = Score
QuizPlayerTable.Fields("Date") = Now()
QuizPlayerTable.Fields("QuizID") = QuizID
QuizPlayerTable.Update
QuizPlayerTable.Close
End If
%>
<!-- #include file="bottominc.asp" -->
