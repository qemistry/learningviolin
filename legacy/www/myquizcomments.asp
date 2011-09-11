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
if IsNull(ID) or ID="" or ID=0 Then
%>
Invalid Question.
<%
else
Set QuizTable = CreateObject("ADODB.Recordset")
QuizTable.Open "quiz WHERE id=" & id & " and QuizID=" & QuizID, "DSN=imamusic;", 1, 3, 2
QuestionText = Server.HTMLEncode(QuizTable.Fields("Questions")&"")
Answer1 = Server.HTMLEncode(QuizTable.Fields("Answer1")&"")
Answer2 = Server.HTMLEncode(QuizTable.Fields("Answer2")&"")
Answer3 = Server.HTMLEncode(QuizTable.Fields("Answer3")&"")
Answer4 = Server.HTMLEncode(QuizTable.Fields("Answer4")&"")
AnswerC = Server.HTMLEncode(QuizTable.Fields("AnswerC")&"")
Level = Server.HTMLEncode(QuizTable.Fields("Level")&"")
TimesCorrect = QuizTable.Fields("TimesAnsweredCorrect")
TimesUsed = QuizTable.Fields("TimesUsed")
Reviewed = QuizTable.Fields("Reviewed")
ThanksTo = Server.HTMLEncode(QuizTable.Fields("ThanksTo")&"")
SubmittedDate = Server.HTMLEncode(QuizTable.Fields("SubmittedDate")&"")
'QComment = Server.HTMLEncode(QuizTable.Fields("Comment")&"")
QComment = QuizTable.Fields("Comment")&""
QuizTable.Close
If ThanksTo = " " or ThanksTo = "" or IsNull(ThanksTo) Then
ThanksTo = "QuizMaster"
End If
If TimesUsed <> 0 Then
PercentCorrect = CStr(CInt(TimesCorrect/TimesUsed*100)) & "%"
Else
PercentCorrect = "New Question!"
End If
End If
if QuestionText="" or IsNull(QuestionText) or QuestionText=" " Then
%>
Sorry.
Can't find the question you want to comment on.
<a href=myquizhome.asp>Return to Game</a>
<%
else
%>
<%=QComment%>
<%
if Reviewed=0 or IsNull(Reviewed) Then
%>
This question has not yet been reviewed.
<a href=myquizprotest.asp?id=<%=id%>> Click here to remove this question if it is inappropriate.</a>
<%
End If
Set CommentTable = CreateObject("ADODB.Recordset")
CommentTable.Open "SELECT * FROM quizcomments WHERE QuestionID=" & ID &" ORDER BY Date", "DSN=imamusic;"
dim i
i = 1
%>
<%
Do Until CommentTable.EOF
%>
<%
CommentTable.MoveNext
i = i + 1
Loop
CommentTable.Close
if i-1 = 0 Then
%>
<%
End If
%>
<form action="myquizcommentsProcess.asp"
method="POST">
</form>
<%
End If
%>
