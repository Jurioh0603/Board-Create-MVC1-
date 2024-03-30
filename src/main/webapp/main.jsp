<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel ="stylesheet" href="css/bootstrap.css"> <!-- bootstrap css 연결 -->
<link rel ="stylesheet" href="css/custom.css"><!-- 직접 만든 css파일과 연결 -->
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String)session.getAttribute("userID");
		}//userID 에 session에 있는 userID 값 담김, 만약 session에 없으면 null 값이 담김
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
				<li class="active"><a href="main.jsp">메인</a></li><!-- active는 현재 홈페이지라는 뜻 -->
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
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
		<div class="jumbotron">
			<div class="container">
				<h1>웹 사이트 소개</h1>
				<p>이 웹사이트는 부트스트랩으로 만든 JSP 웹 사이트입니다. 최소한의 간단한 로직만을 이용하여 개발했습니다. 디자인 템플릿으로는 부트스트랩을 이용했습니다.</p>
				<p><a class="btn btn-primary btn-pull" href="#" role="button">자세히 알아보기</a></p><!-- 단순히 디자인 요소이기 때문에 링크에 #으로 대체 -->
			</div>
		
		</div>
	
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script> <!-- bootstrap js 연결 -->
</body>
</html>