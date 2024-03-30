package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	//데이터에 접근하는 각 함수끼리 데이터베이스에서 충돌을 막기위해 pstmt 제거
	private ResultSet rs; //결과를 담는 객체
	//pstmt에 입력한 값을 가지고 추가적으로 (if문 등) 작업이 필요한 경우에 rs객체에 담아서 사용
	
	//mysql의 root계정에 접속하는 생성자 만들기
	public BbsDAO() { 
		try {           //컴퓨터에 설치된 mysql 서버가 BBS에 접속할 수 있게 해주는 구문
			String dbURL = "jdbc:mysql://localhost:3306/BBS"; //localhost:3306 -> 내컴퓨터 서버주소
			String dbID = "root"; //mysql root계정에 접속
			String dbPassword = "1234"; //내가 설정한 root 계정 비밀번호 작성
			Class.forName("com.mysql.jdbc.Driver"); //mysql드라이버에 접속할 수 있도록 해줌
			conn = DriverManager.getConnection(dbURL,dbID,dbPassword); //conn 객체 안에 접속된 정보 담김
		} catch (Exception e) {
			e.printStackTrace(); //오류가 발생했을 때 어떤 오류인지 출력
		}
	}
	//게시판의 글 작성하면 현재시간 가져오는 메서드
	public String getDate() {
		String SQL = "SELECT NOW()"; //현재 시스템상 시간 가져오는 쿼리문
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //pstmt 지역변수로 선언해서 각 메서드간 충돌이 일어나지 않도록 함
			//현재 연결된 객체를 이용해 SQL문을 실행 준비단계로 만들어줌 
			rs = pstmt.executeQuery(); //실행했을 때 가져오는 결과
			if (rs.next()) { //결과가 있는 경우
				return rs.getString(1); //현재 날짜 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류 시 빈문장 가져오기
	}
	//다음으로 작성될 글 번호
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; //글번호 내림차순(최신글이 맨 첫 페이지)
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //pstmt 지역변수로 선언해서 각 메서드간 충돌이 일어나지 않도록 함
			//현재 연결된 객체를 이용해 SQL문을 실행 준비단계로 만들어줌 
			rs = pstmt.executeQuery(); //실행했을 때 가져오는 결과
			if (rs.next()) { //결과가 있는 경우
				return rs.getInt(1) + 1; //다음 게시글 번호
			}
			return 1; //첫 게시글 번호는 1
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS VALUE (?, ?, ?, ?, ?, ?)"; //입력한 데이터 생성
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //pstmt 지역변수로 선언해서 각 메서드간 충돌이 일어나지 않도록 함
			pstmt.setInt(1, getNext()); //글번호 추가, 매개변수로 가져와 n번째"?"에 값 삽입
			pstmt.setString(2, bbsTitle); //제목
			pstmt.setString(3, userID); //id
			pstmt.setString(4, getDate()); //날짜
			pstmt.setString(5, bbsContent); //내용
			pstmt.setInt(6, 1); //삭제되지 않은 정보라는 의미인 1
			return pstmt.executeUpdate(); //성공시 0이상의 값 반환
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	//특정한 페이지에 따라 10개의 글 목록 가져오는 함수
	public ArrayList<Bbs> getList(int pageNumber) {
		//bbsID가 특정 숫자보다 작고 bbsAvailable이 1인 모든 정보를 10개 가져옴
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			//현재 연결된 객체를 이용해 SQL문을 실행 준비단계로 만들어줌
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			//다음으로 작성될 글 번호
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery(); //실행했을 때 가져오는 결과
			while (rs.next()) { //결과 모두 데이터베이스에 입력
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs); //입력한 정보 list에 담기
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list; //결과 반환
	}
	
	public boolean nextPage(int pageNumber) {
		//bbsID가 특정 숫자보다 작고 bbsAvailable이 1인 모든 정보를 10개 가져옴
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
		try {
			//현재 연결된 객체를 이용해 SQL문을 실행 준비단계로 만들어줌
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			//다음으로 작성될 글 번호
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery(); //실행했을 때 가져오는 결과
			if (rs.next()) { //결과가 하나라도 존재한다면 true를 반환해 다음페이지로 넘어갈 수 있음 알려줌
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false; //결과 반환
	}
	
	//글 내용을 불러오는 함수
	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		try {
			//현재 연결된 객체를 이용해 SQL문을 실행 준비단계로 만들어줌
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			//bbsID 가져와서 pstmt에 저장
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery(); //실행했을 때 가져오는 결과
			if (rs.next()) { //해당 글이 존재한다면
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs; //bbs에 저장
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null; //값이 없으면 null반환
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //pstmt 지역변수로 선언해서 각 메서드간 충돌이 일어나지 않도록 함
			pstmt.setString(1, bbsTitle); //재목
			pstmt.setString(2, bbsContent); //내용
			pstmt.setInt(3, bbsID); //id
			return pstmt.executeUpdate(); //성공시 0이상의 값 반환(1,2,3 중)
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	public int delete(int bbsID) {//삭제하더라도 글이 정보는 남도록 Available을 0값으로 준다.(기본값은 1)
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //pstmt 지역변수로 선언해서 각 메서드간 충돌이 일어나지 않도록 함
			pstmt.setInt(1, bbsID); //글번호
			return pstmt.executeUpdate(); //성공시 0이상의 값 반환(1)
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
}
