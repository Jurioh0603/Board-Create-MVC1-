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
		int bbsID = 0;
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
		Bbs bbs = new BbsDAO().getBbs(bbsID);//BbsDAO에 있는 getBbs를 bbs객체에 담기
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
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead><!-- 테이블의 제목 -->
					<tr><!-- 테이블 하나의 행 -->
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th><!-- 속성(열) 명시 -->
						<!-- colspan 2개의 행을 차지하게 함 -->
					</tr>
				</thead>
				<tbody>
					<tr>   
						<td style="width: 20%;">글 제목</td>
						<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>					<!-- 제목에 스크립트문 사용해서 페이지 불편하게 만드는 해킹기법을 방지하기 위해 스크립트 문이 먹히지 않도록 특수문자 치환을 시켜줌 -->
					<tr>  
						<td>작성자</td>
						<td colspan="2"><%= bbs.getUserID() %></td>
					</tr>	
					<tr>  
						<td>작성일자</td>
						<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분" %></td>
					</tr>	
					<tr>  
						<td>내용</td>
						<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>																						<!-- 특수문자 입력하기 -->
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<%	//userID가 존재하고 게시글 작성자가 userID와 일치하면 글 수정, 삭제 가능하도록 함
				if (userID != null && userID.equals(bbs.getUserID())) {
			%>
					<a href="update.jsp?bbsID=<%=bbsID %>" class="btn btn-primary">수정</a>
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%=bbsID %>" class="btn btn-primary">삭제</a>
			<%			//삭제 경고창 추가
				}
			%>
			<!-- 글쓰는 페이지 -->  <!-- 버튼이 오른쪽에 들어갈 수 있도록 함 -->
			<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
		</div>		
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script> <!-- bootstrap js 연결 -->
</body>
</html>