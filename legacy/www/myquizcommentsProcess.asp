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
If ( IsNull( Request.Form("QuestionID") ) OR "" =
Request.Form("QuestionID") ) Then
%>
There is an error.
The question you are commenting on could not be found.
<%
Prob = 1
End If
If ( IsNull( Request.Form("Comment") ) OR "" =
Request.Form("Comment") ) Then
%>
You didn't a comment.
<%
Prob = 1
End If
If Prob = 0 Then
Set NewCTable = CreateObject("ADODB.Recordset")
NewCTable.Open "quizcomments where QuizID=" & QuizID, "DSN=imamusic;", 1, 3, 2
NewCTable.AddNew
NewCTable.Fields("Submitted By") = Request.Form("Submitted By")
NewCTable.Fields("QuestionID") = Request.Form("QuestionID")
NewCTable.Fields("Email") = Request.Form("Email") & " "
NewCTable.Fields("Comment") = Request.Form("Comment") & " "
NewCTable.Fields("Date") = Now()
NewCTable.Fields("QuizID") = QuizID
NewCTable.Update
NewCTable.Close
%>
Thank you!
Your comment has been added.
<%
Else
%>
Go back to the previous page.
<%
End If
%>
<a href=myquizcomments.asp?id=<%=Request.Form("QuestionID")%>> Return to Comments.</a>
