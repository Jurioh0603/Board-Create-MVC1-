<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				<!-- '#'은 연결된 주소가 없는 a 태그 --> 	<!-- dropdown은 아래로 내릴 수 있는 메뉴 -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expended="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li class="active"><a href="login.jsp">로그인</a></li> <!-- active는 현재 홈페이지라는 뜻 -->
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<div class="container"> <!-- 아이디, 비밀번호 꾸며주는 네모 박스 생성 -->
		<div class="col-lg-4"></div>
		<div class="col-lg-4"></div>
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="loginAction.jsp">
					<h3 style="text-align:center;">로그인 화면</h3>
						<div class="form-group">			<!-- placeholder 커서 눌러도 사라지지 않는 글씨 -->
							<input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20">
						</div>
						<div class="form-group">
							<input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
						</div>
						<input type="submit" class="btn btn-primary form-control" value="로그인">
				</form>
			</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script> <!-- bootstrap js 연결 -->
</body>
</html>