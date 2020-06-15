<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%! //선언부라한다
	
	//맴버변수와 메서드를 기재할 수 있는 jsp 영역!!
	String url ="jdbc:oracle:thin:@localhost:1521:XE";
	String user="c##java";
	String pw="1234";

	Connection con;
	

%>
<%
	//클라이언트가 전송한 데이터(전송 파라미터)를 확인해보자!!

	//클라이언트의 요청 정보를 모두 담고있는 request 객체로 하여금 전송받은
	//파라미터값들을 추출해보자!!

	//클라이언트가 전송한 파라미터 데이터에 대한 인코딩!!
	//주의) 현재 페이지에 대한 디자인 인코딩이 아니다!
	request.setCharacterEncoding("utf-8");
	String m_id = request.getParameter("m_id");
	String pass = request.getParameter("pass");
	String jumin1 = request.getParameter("jumin1");
	String jumin2 = request.getParameter("jumin2");
	String gender = request.getParameter("gender");
	String email_id = request.getParameter("email_id");
	String email_server = request.getParameter("email_server");
	String[] title = request.getParameterValues("title"); //취미
	String profile = request.getParameter("profile");

	//클라이언트가 전송한 데이터 즉 파라미터들을 넘겨받아 db에 넣기
	out.print("클라이언트가 전송한 아이디값: "+m_id+"<br>");
	out.print("클라이언트가 전송한 비번값: "+pass+"<br>");
	out.print("클라이언트가 전송한 주번앞자리: "+jumin1+"<br>");
	out.print("클라이언트가 전송한 뒷자리: "+jumin2+"<br>");
	out.print("클라이언트가 전송한 성별 값은: "+gender+"<br>");
	out.print("클라이언트가 전송한 이메일: "+email_id+"<br>");
	out.print("클라이언트가 전송한 이메일서버: "+email_server+"<br>");
	for(int i=0; i<title.length;i++){
		out.print("클라이언트가 전송한 취미: "+title[i]+"<br>");
	}
	out.print("클라이언트가 전송한 프로필: "+profile+"<br>");


	out.print("db에 넣을 꺼임");
/*
1) Driver Load
2) 접속
3) 쿼리문 수행
4) DB 자원 해제(접속해제 등)
*/
	Class.forName("oracle.jdbc.driver.OracleDriver");
	out.print("드라이버 로드 성공");

	PreparedStatement pstmt=null;
	ResultSet rs = null; //pk 가져올 rs

	//접속
	try{
		con=DriverManager.getConnection(url,user,pw);
		con.setAutoCommit(false); //자동 커밋 속성 해제	

		if(con!=null){
			out.print("접속성공");
			StringBuilder sql = new StringBuilder();
			sql.append("insert into web_member(web_member_id");
			sql.append(",m_id, pass, jumin1, jumin2, gender, email_id");
			sql.append(", email_server, profile)");
			sql.append(" values(seq_web_member.nextval,?,?,?,?,?,?,?,?)");

			//바인드 변수값 지정하기!!
			pstmt = con.prepareStatement(sql.toString());

			pstmt.setString(1,m_id); //회원 아이디
			pstmt.setString(2,pass); //비밀번호
			pstmt.setString(3,jumin1); //주민번호 앞자리
			pstmt.setString(4,jumin2); //주민번호 뒷자리
			pstmt.setString(5,gender); //성별
			pstmt.setString(6,email_id); //이메일 아이디
			pstmt.setString(7,email_server); //이메일 서버
			pstmt.setString(8,profile); //자기소개 profile
			
			//입력시도!
			
			int result = pstmt.executeUpdate(); //DML
			if(result!=0){

				out.print("입력성공");

				//입력된 회원의 pk추출해보자!!
				//sql 객체 비우기!!
				sql.delete(0,sql.length());

				sql.append("select seq_web_member.currval as pk from dual");
				pstmt=con.prepareStatement(sql.toString());
				rs=pstmt.executeQuery(); //쿼리수행!!

				int web_member_id=0;

				if(rs.next()){ //데이터가 있다면..
					web_member_id=rs.getInt("pk");
					out.print("방금 들어간 회원의 pk는 "+web_member_id+"<br>");

					//부모테이블인 web_member에 입력이 성공되었으므로
					//자식 테이블인 hobby에 취미데이터를 넣자!!
					//몇번? 파라미터의 갯수만큼...
					for(int i=0; i<title.length;i++){
						sql.delete(0,sql.length()); //StringBuilder 초기화

						sql.append("insert into hobby(hobby_id,web_member_id,title)");
						sql.append(" values(seq_hobby.nextval,?,?)");
						
						pstmt=con.prepareStatement(sql.toString());
						pstmt.setInt(1,web_member_id); //pk
						pstmt.setString(2,title[i]); //취미

						pstmt.executeUpdate(); //쿼리 수행!!
					}
				}
				con.commit(); //트랜잭션 확정!!
			}else{
				out.print("입력실패");
			}

		}else{
			out.print("접속실패");
		}
	}catch(java.sql.SQLException e){
		e.printStackTrace();
		con.rollback();
	}finally{
		con.setAutoCommit(true); //다시 돌려놓기!
	}

	rs.close();
	con.close();
	pstmt.close();
%>