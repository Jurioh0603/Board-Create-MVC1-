<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트를 사용할 수 있게 해줌 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- request 객체는 내장 객체이기 때문에 import 안해도 사용가능 -->
<jsp:useBean id="user" class="user.User" scope="page"/> <!-- User 파일을 javaBean파일로 사용하겠다는 뜻 -->
									<!-- scope="page" 현재 페이지 안에서만 bean 파일을 사용한다는 뜻 -->
<jsp:setProperty name="user" property="userID"/> <!-- 입력한 ID를 받아서 한명의 사용자의 userID에 넣어줌 -->
<jsp:setProperty name="user" property="userPassword"/> <!-- 위와 동일 -->
<!DOCTYPE html>						
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%	//이미 로그인 된 사람 로그인 할 수 없도록 함
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID"); //userID에 값이 있으면 세션 가져오기
		}//이미 로그인 된 사람 또 로그인 할 수 없도록 처리
		if (userID != null) {
			PrintWriter script = response.getWriter();
			script.print("<script>");
			script.print("alert('이미 로그인이 되어있습니다.')");
			script.print("location.href = 'main.jsp'");
			script.print("</script>");
		}
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		//로그인 시도->login 페이지에서 입력한 값이 넘어옴
		if(result == 1) {
			session.setAttribute("userID", user.getUserID()); //사용자의 세션 등록
			PrintWriter script = response.getWriter(); //script 사용할 수 있게함
			script.println("<script>");
			script.println("location.href = 'main.jsp'"); //로그인 성공시 이동 페이지
			script.println("</script>");
		} else if (result == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')"); //로그인 실패
			script.println("history.back()"); //이전 페이지로 사용자를 이동시킴
			script.println("</script>");
		} else if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')"); //로그인 실패
			script.println("history.back()"); //이전 페이지로 사용자를 이동시킴
			script.println("</script>");
		} else if (result == -2) {
			PrintWriter script = response.getWriter(); 
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')"); //로그인 실패
			script.println("history.back()"); //이전 페이지로 사용자를 이동시킴
			script.println("</script>");
		}
	%>
</body>
</html>