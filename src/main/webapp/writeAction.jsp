<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트를 사용할 수 있게 해줌 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- request 객체는 내장 객체이기 때문에 import 안해도 사용가능 -->
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/> <!-- Bbs 파일을 javaBean파일로 사용하겠다는 뜻 -->
									<!-- scope="page" 현재 페이지 안에서만 bean 파일을 사용한다는 뜻 -->
<jsp:setProperty name="bbs" property="bbsTitle"/> <!-- 입력한 title을 받아서 bbsTitle에 넣어줌 -->
<jsp:setProperty name="bbs" property="bbsContent"/> <!-- 위와 동일 -->
<!DOCTYPE html>						
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%	//로그인이 된 사람은 회원가입 페이지에 접속 할 수 없도록 함
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID"); //userID에 값이 있으면 세션 가져오기
		}//로그인 안되어있는 사람에게 나타다는 메세지
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.print("<script>");
			script.print("alert('로그인을 하세요.');");
			script.print("location.href = 'login.jsp';");
			script.print("</script>");
		} else { //로그인한 사람에게 보이는 내용
			if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null) { //내용 제목 입력 안하면 아래 결과
				PrintWriter script = response.getWriter(); //script 사용할 수 있게함
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.');");
				script.println("history.back();"); //이전 페이지로 사용자를 이동시킴
				script.println("</script>");
			} else {
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent()); 
				//위에 bbsDAO에 저장된 값이 write 함수를 수행하도록 매개변수로 들어감
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다.');");
					script.println("history.back();");
					script.println("</script>");
				} //회원가입 성공하여 로그인 페이지로 이동
				else {
					PrintWriter script = response.getWriter(); 
					script.println("<script>");
					script.println("location.href = 'bbs.jsp';"); //성공시 게시판으로 돌아감
					script.println("</script>");
				}
			}
		}
		
		
	%>
</body>
</html>