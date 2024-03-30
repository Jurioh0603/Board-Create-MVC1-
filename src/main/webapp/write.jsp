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
		<div class="row"><!-- 각 행의 색을 번갈아가며 다르게 출력 -->	
			<form method="post" action="writeAction.jsp">	<!-- 글이 등록될 수 있게 해주는 jsp 파일 -->																	<!-- 회색빛 테두리 생성 -->
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead><!-- 테이블의 제목 -->
						<tr><!-- 테이블 하나의 행 -->
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th><!-- 속성(열) 명시 -->
							<!-- colspan 2개의 행을 차지하게 함 -->
						</tr>
					</thead>
					<tbody>
						<tr>    <!-- 데이터베이스에서 생성한 조건과 같이 50글자길이로 제한하는 text input을 생성 -->
							<td><input type="text" class="form-control" placeholder="글제목" name="bbsTitle" maxlength="50"></td><!-- 높이 제한 -->
						</tr>	
						<tr>	<!-- 각각 한줄 씩 들어갈 수 있도록 tr태그에 하나씩 넣어줌 -->
							<td><textarea class="form-control" placeholder="글내용" name="bbsContent" maxlength="2048" style="height: 350px"></textarea></td>
						</tr> <!-- textarea 장문의 글을 작성할때 사용 -->
					</tbody>
				</table><!-- 글쓰는 페이지 -->  <!-- 버튼이 오른쪽에 들어갈 수 있도록 함 -->
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
			</form>											<!-- 글쓰기 제출버튼 생성 -->
		</div>		
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script> <!-- bootstrap js 연결 -->
</body>
</html>