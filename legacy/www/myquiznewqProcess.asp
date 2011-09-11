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
<%
Dim Prob
Prob = 0
If ( IsNull( Request.Form("Submitted By") ) OR "" =
Request.Form("Submitted By") ) Then
%>
You didn't enter your name.
<%
Prob = 1
End If
If ( IsNull( Request.Form("Question") ) OR "" =
Request.Form("Question") ) Then
%>
You forgot to enter your question.
<%
Prob = 1
End If
If ( IsNull( Request.Form("Answer1") ) OR "" =
Request.Form("Answer1") ) Then
%>
You didn't enter answer A.
<%
Prob = 1
End If
If ( IsNull( Request.Form("Answer2") ) OR "" =
Request.Form("Answer2") ) Then
%>
You didn't enter answer B.
<%
Prob = 1
End If
If ( IsNull( Request.Form("Answer3") ) OR "" =
Request.Form("Answer3") ) Then
%>
You didn't enter answer C.
<%
Prob = 1
End If
If ( IsNull( Request.Form("Answer4") ) OR "" =
Request.Form("Answer4") ) Then
%>
You didn't enter answer D.
<%
Prob = 1
End If
If ( IsNull( Request.Form("AnswerC") ) OR "" =
Request.Form("AnswerC") ) Then
%>
You didn't enter the correct answer.
<%
Prob = 1
End If
If ( IsNull( Request.Form("Level") ) OR "" =
Request.Form("Level") ) Then
%>
You didn't enter a difficulty level for the question.
<%
Prob = 1
End If
If Prob = 0 Then
submittedby = Request.Form("Submitted By")
question = Request.Form("Question")
answer1 = Request.Form("Answer1")
answer2 = Request.Form("Answer2")
answer3 = Request.Form("Answer3")
answer4 = Request.Form("Answer4")
answerc = Request.Form("AnswerC")
level = Request.Form("Level")
email = Request.Form("Email")
comment = Request.Form("Comment")
if submittedby = "" or IsNull(submittedby) then
submittedby = " "
end if
if question = "" or IsNull(question) then
question = " "
end if
if answer1 = "" or IsNull(answer1) then
answer1 = " "
end if
if answer2 = "" or IsNull(answer2) then
answer2 = " "
end if
if answer3 = "" or IsNull(answer3) then
answer3 = " "
end if
if answer4 = "" or IsNull(answer4) then
answer4 = " "
end if
if answerc = "" or IsNull(answerc) then
answerc = " "
end if
if level = "" or IsNull(level) then
level = " "
end if
if email = "" or IsNull(email) then
email = " "
end if
if comment = "" or IsNull(comment) then
comment = " "
end if
Set NewQTable = CreateObject("ADODB.Recordset")
NewQTable.Open "quiz", "DSN=imamusic;", 1, 3, 2
NewQTable.AddNew
NewQTable.Fields("ThanksTo") = submittedby
NewQTable.Fields("Questions") = question
NewQTable.Fields("Answer1") = answer1
NewQTable.Fields("Answer2") = answer2
NewQTable.Fields("Answer3") = answer3
NewQTable.Fields("Answer4") = answer4
NewQTable.Fields("AnswerC") = answerc
NewQTable.Fields("Level") = level
NewQTable.Fields("ThanksToEmail") = email
NewQTable.Fields("Comment") = comment
NewQTable.Fields("UseInGame") = 1
NewQTable.Fields("SubmittedDate") = Now()
NewQTable.Fields("QuizID") =QuizID
NewQTable.Update
NewQTable.Close
%>
Thank you!
Your question has been added to the game.
<%
Else
%>
Please go back.
<%
End If
%>
<a href=myquiznewq.asp>Submit Another Question</a>
