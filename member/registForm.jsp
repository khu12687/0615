<%@ page contentType="text/html;charset=utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8">
<style>
body {font-family: Arial, Helvetica, sans-serif;}
* {box-sizing: border-box;}

input[type=text], select, textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  margin-top: 6px;
  margin-bottom: 16px;
  resize: vertical;
}

input[type=password], select, textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  margin-top: 6px;
  margin-bottom: 16px;
  resize: vertical;
}

/* .email{
   width : 50%;
} */

input[type=submit] {
  background-color: #4CAF50;
  color: white;
  padding: 12px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

input[type=submit]:hover {
  background-color: #45a049;
}

.container {
  border-radius: 5px;
  background-color: #f2f2f2;
  padding: 20px;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script>



/* jQuery 정석
$(document).ready(function(){
   alert("문서로드완료")
});
*/
//jquery가 개발된 이유? 자바스크립트 문법을 상세히 모르더라도
//자바스크립트를 사용할 수 있도록 간편화 시킨 js라이브러리 사라질 플래시 기술에 대안으로 나옴
//단축
//$(function(){
   //alert("문서로드!");`
   //jquery로 원하는 요소 접근하기!!
   //jquery는 css의 선택자를 지원하므로, 기존 css에서 사용하던 스타일선택자를 그대로 사용하면된다!
 //  $("input[type='button']").click(function(){
  //    send();
 //  });
//});

 //javascript
addEventListener("load", function(){
	//css의 선택자를 이용하여 DOM요소에 접근하는 메서드
   var bt = document.getElementById("bt");
	bt.addEventListener("click",function(){
		send();
	});
	//주민번호 뒷자리 컴포넌트에 키보드 이벤트 !!
	var jumin2 = document.getElementById("jumin2");
	jumin2.addEventListener("keyup", function(){
		checkGender(this);
	});
});

//사용자가 키보드 칠때마다 호출하여 실시간 체크!
function checkGender(obj){
	//alert(obj.value)
	//사용자가 입력한 데이터가 7자에 도달하는 순간만 체크하자!!
	if(obj.value.length>=7){
		var n =parseInt(obj.value.charAt(0)); //맨앞자
		
		var g=document.getElementsByName("gender");
		if(n==1){ //남자에 체크
			//alert("남자군요");
			g[0].checked=true;
		}else if(n==2){ //여자에 체크
			//alert("여자군요");
			g[1].checked=true;
		}	
	}
}

//서버에 입력한 데이터들을 전송하는 함수 정의
function send() {
	var count=0; //취미를 체크용 변수!!
	//0이면 한번도 체크하지 않은 사람이므로, 유효성 체크 메세지 보여주자
	var hobby = document.getElementsByName("title");

	for(var i=0;i<hobby.length;i++){
		if(hobby[i].checked){ 
			count++;
		}
	}
	if(count<=0){
		alert("취미를 적어도 하나는 선택해주세요");
		return; //함수를 호출한 곳으로 실행부를 돌려버림!!
	}

   //전송전에 유효성 체크!
   //alert("지금 전송할게");
   //폼태그를 전송하자
   $("form").attr("action","/member/regist.jsp");
   $("form").attr("method","post"); //전송 body에 실어나른다
   $("form").submit(); //전송
}
</script>
</head>
<body>

<h3>Contact Form</h3>

<div class="container">
<!-- form태그의 역할?
   입력양식의 범위를 설정함. 즉 어디부터 어디까지를 양식에 포함시킬지를 결정해 주는 양식태그,
   따라서 이 양식태그에는 어디로 전송하지, 전송방법은 어떻게 할지 등을 명시할 수 있다.
-->
  <form action="/member/regist.jsp">

    <input type="text" id="uid" name="m_id" placeholder="Your ID..">

    <input type="password" id="upw" name="pass" placeholder="Your Password..">

   <input type="text" id="jumin1" name="jumin1" size="10" placeholder="주민번호 앞자리">

   <input type="text" id="jumin2" name="jumin2" size="10"  maxlength="7" placeholder="주민번호 뒷자리">

   <input type="radio" name="gender" value="남">남
   <input type="radio" name="gender" value="여">여

   <input type="text" class="email_id" name="email_id" placeholder="Your Email ID ..">
   @
    <select class="email" name="email_server">
      <option value="australia" >메일서버 선택</option>
      <option value="naver.com" >naver.com</option>
      <option value="gmail.com">google.com</option>
     <option value="daum.net">daum.net</option>
    </select>


   <input type="checkbox" name="title" value="여행">여행
   <input type="checkbox"  name="title" value="게임">게임
   <input type="checkbox"  name="title" value="독서">독서
   <input type="checkbox"  name="title" value="개발">개발

    <textarea id="subject" name="profile" placeholder="자기소개.." style="height:200px"></textarea>

    <input type="button" value="Submit" id="bt"/>

  </form>
</div>

</body>
</html>