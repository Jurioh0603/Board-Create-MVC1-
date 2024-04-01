package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

	private Connection conn;
	private PreparedStatement pstmt; //오른쪽 별칭
	private ResultSet rs; //결과를 담는 객체
	//pstmt에 입력한 값을 가지고 추가적으로 (if문 등) 작업이 필요한 경우에 rs객체에 담아서 사용

	//mysql의 root계정에 접속하는 생성자 만들기
	public UserDAO() { 
		try {           //컴퓨터에 설치된 mysql 서버가 BBS에 접속할 수 있게 해주는 구문
			//String dbURL = "jdbc:mysql://localhost:3306/BBS"; //localhost:3306 -> 내컴퓨터 서버주소
			String dbURL = "jdbc:oracle:thin:@localhost:1521/xe";
			String dbID = "BBS"; //mysql root계정에 접속
			String dbPassword = "BBS"; //내가 설정한 root 계정 비밀번호 작성
			//Class.forName("com.mysql.jdbc.Driver"); //mysql드라이버에 접속할 수 있도록 해줌
			Class.forName("oracle.jdbc.OracleDriver");
			conn = DriverManager.getConnection(dbURL,dbID,dbPassword); //conn 객체 안에 접속된 정보 담김
		} catch (Exception e) {
			e.printStackTrace(); //오류가 발생했을 때 어떤 오류인지 출력
		}
	}
	
	//로그인을 시도하는 메서드 함수
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM MEMBER WHERE userID = ?"; //해당 사용자의 비밀번호를 가져오게 함
		try {                                                         //실제 쿼리문을 " "안에 작성
			pstmt = conn.prepareStatement(SQL); //정해진 SQL문을 데이터베이스에 삽입하는 형식
			pstmt.setString(1, userID); //userID를 매개변수로 가져와 '?'에 넣어줌
			rs = pstmt.executeQuery(); //이 결과를 rs에 담음
			if(rs.next()) { //=> rs에 값이 있다면
				if(rs.getString(1).equals(userPassword))
					return 1; //로그인 성공
				else
					return 0; //비밀번호 불일치
			}
			return -1; //아이디가 없음
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; //데이터베이스 오류
	}
	//회원가입을 시도하는 메서드 함수
	public int join(User user) {
		String SQL = "INSERT INTO MEMBER VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate(); 
			//INSERT문이 실행되면 반드시 0이상의 값이 되기 때문에 정상적으로 회원가입 된것
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스오류
	}
}