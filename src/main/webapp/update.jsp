<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
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
		if (userID == null) { //아이디 정보가 없다면
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
			<!-- 이미 로그인이 되어있다고 간주하기 때문에 로그인하기 전 보여주는 부분은 삭제 -->
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
		</div>
	</nav>
	<div class="container">
		<div class="row"><!-- 각 행의 색을 번갈아가며 다르게 출력 -->	
			<form method="post" action="updateAction.jsp?bbsID=<%=bbsID%>">	<!-- 글이 등록될 수 있게 해주는 jsp 파일 -->																	<!-- 회색빛 테두리 생성 -->
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead><!-- 테이블의 제목 -->
						<tr><!-- 테이블 하나의 행 -->
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글수정 양식</th><!-- 속성(열) 명시 -->
							<!-- colspan 2개의 행을 차지하게 함 -->
						</tr>
					</thead>
					<tbody>
						<tr>    <!-- 데이터베이스에서 생성한 조건과 같이 50글자길이로 제한하는 text input을 생성 -->
							<td><input type="text" class="form-control" placeholder="글제목" name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle() %>"></td><!-- 높이 제한 -->
						</tr>																								<!-- 수정 전 글제목 보여줌 -->
						<tr>	<!-- 각각 한줄 씩 들어갈 수 있도록 tr태그에 하나씩 넣어줌 -->
							<td><textarea class="form-control" placeholder="글내용" name="bbsContent" maxlength="2048" style="height: 350px"><%= bbs.getBbsContent() %></textarea></td>
						</tr> <!-- textarea 장문의 글을 작성할때 사용 -->																			<!-- 수정 전 글 내용 보여줌 -->		
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