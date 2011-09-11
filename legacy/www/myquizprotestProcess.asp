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
Please go back and enter your name ...
<%
Prob = 1
End If
If ( IsNull( Request.Form("QuestionID") ) OR "" =
Request.Form("QuestionID") ) Then
%>
There is no question. Go back.
<%
Prob = 1
End If
If ( IsNull( Request.Form("Comment") ) OR "" =
Request.Form("Comment") ) Then
%>
You didn't a reason for your protest.
<%
Prob = 1
End If
If Prob = 0 Then
%>
Thank You!
Your protest has been registered.
<%
Set NewPTable = CreateObject("ADODB.Recordset")
NewPTable.Open "quizprotest", "DSN=imamusic;", 1, 3, 2
NewPTable.AddNew
NewPTable.Fields("Submitted By") = Request.Form("Submitted By")
NewPTable.Fields("QuestionID") = Request.Form("QuestionID")
NewPTable.Fields("Email") = Request.Form("Email") & " "
NewPTable.Fields("Comment") = Request.Form("Comment") & " "
NewPTable.Fields("Date") = Now()
NewPTable.Fields("QuizID") = QuizID
NewPTable.Update
NewPTable.Close
Set QuizTable = CreateObject("ADODB.Recordset")
QuizTable.Open "quiz WHERE id=" & Request.Form("QuestionID") & " and QuizID="& QuizID, "DSN=imamusic;", 1, 3, 2
if QuizTable.Fields("Reviewed")=0 or IsNull(QuizTable.Fields("Reviewed")) Then
QuizTable.Fields("UseInGame") = 0
QuizTable.Update
%>
The question has been removed from the game until your protest is reviewed.
<%
End If
QuizTable.Close
%>
<%
End If
%>
