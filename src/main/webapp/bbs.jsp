<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.util.ArrayList"%><!-- 게시판 목록 가져오기 위함 -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel ="stylesheet" href="css/bootstrap.css"> <!-- bootstrap css 연결 -->
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	} <!-- a태그 글자들의 디자인 변경 -->
</style>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String)session.getAttribute("userID");
		}//userID 에 session에 있는 userID 값 담김, 만약 session에 없으면 null 값이 담김
		int pageNumber = 1; //기본페이지
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <!-- 게시판 상단 메뉴바 표시줄 3개 표시 -->
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>		
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul><!-- active는 현재 홈페이지라는 뜻 -->
			<% //로그인 되지 않은 사람에게 보여지는 페이지
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				<!-- '#'은 연결된 주소가 없는 a 태그 --> 	<!-- dropdown은 아래로 내릴 수 있는 메뉴 -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expended="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%//로그인이 된 사람에게 보여지는 페이지
				} else {
			%>	
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				<!-- '#'은 연결된 주소가 없는 a 태그 --> 	<!-- dropdown은 아래로 내릴 수 있는 메뉴 -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expended="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%	
				}
			%>
			
		</div>
	</nav>
	<div class="container">
		<div class="row"><!-- 각 행의 색을 번갈아가며 다르게 출력 -->							<!-- 회색빛 테두리 생성 -->
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead><!-- 테이블의 제목 -->
					<tr><!-- 테이블 하나의 행 -->
						<th style="background-color: #eeeeee; text-align: center;">번호</th><!-- 속성(열) 명시 -->
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber);//BbsDAO에서 getList메서드의 객체 생성
						for (int i = 0; i < list.size(); i++) {
					%>
					<tr>
						<td><%= list.get(i).getBbsID() %></td><!-- list에 담겨있는 getList메서드의 정보를 가져오기 -->
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
						<!-- 글 번호를 가져와서 해당하는 게시물을 보여주는 view페이지로 이동한다는 의미 -->
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시" + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
						<!-- 날짜 포맷 -->
					</tr>
					<%
						}
					%>
					
				</tbody>
			</table>
			<%
				if (pageNumber != 1) { //1페이지가 아니면
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arraw_left">이전</a>
			<%
				} if (bbsDAO.nextPage(pageNumber + 1)) {//=> 다음페이지가 존재하면
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arraw_left">다음</a>
			<%		
				}
			%>	<!-- 글쓰는 페이지 --> 		 <!-- 버튼이 오른쪽에 들어갈 수 있도록 함 -->
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script> <!-- bootstrap js 연결 -->
</body>
</html>