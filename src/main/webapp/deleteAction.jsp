<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트를 사용할 수 있게 해줌 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- request 객체는 내장 객체이기 때문에 import 안해도 사용가능 -->
<!-- 빈즈 사용 안하는게 편해서 이번 페이지에는 삭제 -->
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
			script.print("alert('로그인을 하세요.')");
			script.print("location.href = 'login.jsp'");
			script.print("</script>");
		} 
		int bbsID = 0; //현재 수정하고자하는 글번호 값이 들어오지 않았다면
		if (request.getParameter("bbsID") != null) {//bbsID가 존재한다면 bbsID 값 받아오기
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.print("<script>");
			script.print("alert('유효하지 않은 글입니다.')");
			script.print("location.href = 'bbs.jsp'");
			script.print("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);//BbsDAO클래스에서 bbsID룰 getBbs 메소드의 매개변수로 가져옴
		if (!userID.equals(bbs.getUserID())) {//
			PrintWriter script = response.getWriter();
			script.print("<script>");
			script.print("alert('권한이 없습니다.')");
			script.print("location.href = 'bbs.jsp'");
			script.print("</script>");
		} else { //로그인한(권한이 있는) 사람에게 보이는 내용
				//입력안된 사항이 있습니다 부분은 필요 없는 기능이라 삭제
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.delete(bbsID); 
				//위에 bbsDAO에 저장된 값이 delete 함수를 수행하도록 매개변수로 들어감
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 삭제에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} //회원가입 성공하여 로그인 페이지로 이동
				else {
					PrintWriter script = response.getWriter(); 
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'"); //성공시 게시판으로 돌아감
					script.println("</script>");
				}
		 }
		
		
	%>
</body>
</html>