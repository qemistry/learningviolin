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
Your question will
Please follow these guidelines:
<form action="myquiznewqProcess.asp"
method="POST">
<INPUT type=text size=75 maxlength=255 name="Question">
<option> </option>
<option>A</option>
<option>B</option>
<option>C</option>
<option>D</option></select>
<option>Easy</option>
<option>Medium</option>
<option>Hard</option></select>
<INPUT type=text size=75 maxlength=255 name="Comment">
<input type="submit" value="Submit My Question">
<input type="reset" value="Reset">
</form>
