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
ID = Request.QueryString("ID")
Set QuizTable = CreateObject("ADODB.Recordset")
QuizTable.Open "quiz WHERE id=" & id & " and QuizID=" & QuizID, "DSN=imamusic;", 1, 3, 2
QuestionText = Server.HTMLEncode(QuizTable.Fields("Questions"))
Answer1 = Server.HTMLEncode(QuizTable.Fields("Answer1"))
Answer2 = Server.HTMLEncode(QuizTable.Fields("Answer2"))
Answer3 = Server.HTMLEncode(QuizTable.Fields("Answer3"))
Answer4 = Server.HTMLEncode(QuizTable.Fields("Answer4"))
AnswerC = Server.HTMLEncode(QuizTable.Fields("AnswerC"))
Reviewed = QuizTable.Fields("Reviewed")
QuizTable.Close
%>
Only submit this form if the question is inappropriate for this game, such as:
- spam
- private information that should not be public
- inappropriate topics
- pornography
All other comments about this question should be made at <a href=myquizcomments.asp?id=<%=ID%>>Comments.</a>
<%
if Reviewed=0 or IsNull(Reviewed) Then
%>
The question you are protesting has not yet been reviewed.
The protest process is:
1.
2. Your protest will be reviewed.
3. If your protest is upheld, the question will remain removed or changed.
4. If your protest is overturned, the question will go back in the rotation of the quiz.
<%
else
%>
The question you are protesting has already been reviewed.
Therefore:
1. Your protest will be reviewed.
2. If your protest is upheld, the question will be removed or changed.
3. If your protest is overturned, the question will remain in the rotation of the quiz.
<%
end if
%>
<%=QuestionText%>
A - <%=Answer1%>
B - <%=Answer2%>
C - <%=Answer3%>
D - <%=Answer4%>
Correct Answer - <%=AnswerC%>
<form action="myquizprotestProcess.asp"
method="POST">
<INPUT type="hidden" name="QuestionID" value=<%=id%>>
<INPUT type=text size=75 maxlength=255 name="Comment">
<input type="submit" value="Submit My Protest">
<input type="reset" value="Reset">
</form>
