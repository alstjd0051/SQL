--===============================
--kh 계정
--===============================
show user;

--table sample 생성
-- ORA-0103 1: insufficient privileges부적절한 권한 ->create table을 만들어줘야한다
create table sample(id number);

-- 현제 계정의 소유 테이블 목록 조회
SELECT * 
FROM tab;

--사원 테이블
select * 
from employee;

--부서 테이블
SELECT * FROM department;
--직급테이블 
SELECT * From job;
--지역테이블 
SELECT * From location;
--국가테이블 
SELECT * From nation;
--급여등급테이블 
SELECT *
From sal_grade;

--table = entity relation
--데이터를 보관하는 객체

--열 column field attribute
--행 row, record, tuple
--도메인 domain 하나의 컬럼에 취할 수 있는 값의 그룹(범위)

--테이블 명세
--컬럼명    널여부    자료형
 DESCRIBE employee;
 desc employee;
 
 --====================
 --DATA TYPE
 --====================
 --컬럼에 지정해서 값을 제한적으로 허용
 --1. 문자형 vachar2 | char
 --2. 숫자형 number
 --3. 날짜 시간형 date | timestamp
 --4. LOB
 --데이터 타입은 컬럼에 지정해서 값을 제한적으로 허용하기 위함
--해당컬럼에 지정해준 type만 올 수 있도록
--ex. salary -> 숫자만 , hire_date -> 날짜만
 
 --====================
 --문자형
 --====================
 --1)고정형 = char(byte)크기지정  - 최대 2000byte
 -- char(10)'korea' 영소문자는 1byte이므로 실제크기 5byte(korea), 고정형 10byte로 저장된다.
 --2)가변형 = barchar2(byte)크기지정
 --'korea' 영소문자는 글자당 1byte씩 처리됨 ->실제데이터의 크기에 맞게 가변형 5byte로 저장됨
--'안녕' 한글은 글자당 3byte(11g EX)이므로 실제크기 6byte, 가변형 6byte로 저장됨
--cf. 고정형, 가변형 모두 지정한 크기 이상의 값은 추가불가

--가변형 long : 최대 2GB (문자형임, 숫자가 아님!)
--숫자를 써도 되는데, 문자로 저장됨
--LOB타입(Large Object) 중의 CLOB(Character LOB)는 최대 4GB까지 지원

create table tb_datatype (
-- 컬럼명 자료형 널여부 기본값
    a char(10),
    b varchar2(10)
);



--테이블조회
--select * -- *는 모든 컬럼
select a, b -- 컬럼을 지정
from tb_datatype; --테이블명

--데이터추가 : 한행을 추가
insert into tb_datatype --테이블명
values('hello', 'hello');

insert into tb_datatype
values('123', '안녕');

insert into tb_datatype
values('에브리바디', '안녕');

--데이터가 변경(insert, update, delete)되는 경우, 메모리상에서 먼저 처리됨
-- 메모리상에서 먼저 처리되고, 반영되는 건 아님
--commit을 통해 실제 database에 적용해야 한다
commit;

--lengthb(컬럼명); number - 저장된 데이터의 실제크기를 리턴
select a, lengthb(a), b, lengthb(b)
from tb_datatype;

---------------------------------------------
--숫자형
---------------------------------------------
--정수, 실수를 구분하지 않는다
--number(p, s)
--p : 표현가능한 전체 자리수
--s : p 중 소수점 이하 자리수
/*
값 1234.567 
--------------
number      1234.567
number(7)       1235
 (why? 7, 0이랑 똑같음 소수점이하 자리수를 설정해주지 않으면, 0 이 생략됨)
number(7, 1) 1234.6 --자동반올림
number(7, -2) 1200 --반올림
*/


--rollback; --마지막 commit시점이후 변경사항은 취소된다
create table tb_datatype_number (
    a number,
    b number(7),
    c number(7,1),
    d number(7,-2)
);

select * from tb_datatype_number;

insert into tb_datatype_number 
values(1234.567, 1234.567, 1234.567, 1234.567);

--지정한 크기보다 큰 숫자는 ORA-01438: value larger than specified precision allowed for this column 유발
insert into tb_datatype_number 
values(1234567890.123, 1234567.567, 12345678.5678, 1234.567);

drop table tb_datatype_number;

create table tb_datatype_number (
    a number,
    b number(7),
    c number(7,1),
    d number(7,-2)
);

select * from tb_datatype_number;

insert into tb_datatype_number 
values(1234.567, 1234.567, 1234.567, 1234.567);

--지정한 크기보다 큰 숫자는 ORA-01438: value larger than specified precision allowed for this column 유발
insert into tb_datatype_number 
values(1234567890.123, 1234567.567, 12345678.5678, 1234.567);


commit;
--마지막 commit시점 이후 변경사항은 취소된다.
rollback; 

---------------------------------------------
--날짜시간형
---------------------------------------------
--date 년월일시분초 (보통의 경우)
--timestamp 년월일시분초 밀리초 지역대 (정밀하게 다뤄야할 경우)

create table tb_datatype_date (
    a date,
    b timestamp
 );
 
 --문자열로 표현하는 함수 : to_char
 select to_char(a, 'yyyy/mm/dd hh24:mi:ss'), b
from tb_datatype_date;
 
insert into tb_datatype_date
values (sysdate, systimestamp);

--날짜형 - 날짜형 = 숫자(1=하루)
--날짜형 +- 숫자(1=하루) = 날짜형
 select to_char(a , 'yyyy/mm/dd hh24:mi:ss'),
             to_char(a - 1, 'yyyy/mm/dd hh24:mi:ss'),
            b
from tb_datatype_date;

--날짜형-날짜형 = 숫자(1=하루)
select sysdate - a --0.009일차
from tb_datatype_date;

--to_date : 문자열을 날짜형으로 변환하는 함수
select to_date('2021/01/23') - a
from tb_datatype_date;

--dual 가상테이블 -> create하지 않아도 가능
select (sysdate + 1) - sysdate
from dual;

--===================================================
--DQL (Data Query Language)
--===================================================
--데이터 조회(검색)을 위한 언어
--select문
--쿼리 조회결과를 ResultSet (결과집합)이라고 하며, 0행以上을 포함한다
--from절에 조회하고자 하는 테이블 명시
--where절에 의해 특정행을 filtering 가능 (특정행을 추릴수 있음)
--select절에 의해 컬럼을 filtering 또는 추가 가능
--order by절에 의해 행을 정렬할 수 있다 (어떤 컬럼기준으로 행을 정렬할지)
/*
select 컬럼名 (5)                      필수
from 테이블名 (1)                     필수
where 조건点 (2)                     선택
group by 그룹기준 컬럼 (3)    선택
having 그룹조건点 (4)             선택
order by 정렬기준컬럼 (6)      선택
*/

select *
from employee
where dept_code = 'D9' -- 데이터는 대소문자 구분
order by emp_name asc; --오름차순

--1. job테이블에서 job_name컬럼정보만 출력
select *
from job;



--2. department테이블에서 모든 컬럼을 출력
select *
from department;

--3. employee테이블에서 이름, 이메일, 전화번호, 입사일 출력
select emp_name,email,phone, hir_date
from employee;

--4. employee테이블에서 급여가 2,500,000원 이상인 사원의 이름과 급여출력
select *
from employee
where salary >=2500000;

--5. employee테이블에서 급여가 3,500,000원 이상이며, 직급코드가 a3인 사원을 조회
--not && || / but and or
select *
from employee
where salary >= 3500000 and job_code = 'J3';



--6. employee테이블에서 현재 근무중인 사원을 이름오름차순으로 정렬

from employee
where quit_yn = 'N'
order by emp_name; --ascending(기본값) | descending


--------------------------------------------------------------
--SELECT
--------------------------------------------------------------
--table의 존재하는 컬럼
--가상컬럼 (산술연산)
--임의의 값(literal)최적화
--각 칼럼의 별칭(alias)를 가질 수 있다. as와 "(쌍다움표)는 생략가능
--(별칭에 공백, 특수문자가 있거나 숫자로 시작하는 경우 쌍다움표 필수)
select emp_name as "사원명",phone as 전화번호,salary 급여,salary * 12 연봉,123,'안녕'
from employee;

--실급여 : salary + (salary * bonus_
select emp_name, salary,bonus,(salary *nvl(bonus,0)) 실급여
from employee;


--null값과는 산설연산 할 수 없다. 그결과는 무조건 null이다.
--null &1(X) 나머지연산자는 사용불가
select null+1, null-1, null* 1, null/1
from dual; --1행짜리 가상테이블

--nvl(col,null일떄 값)null처리 함수
--col의 값이 null이 아니면, (col)값 리턴
--col의 값이 null이면, (null일때 값)을 리턴 
select bonus, nvl(bonus,0) null처리후
from employee;

--distinct 중복제거용 키워드
--select절에 단 한번 사용가능하다.
--직급코드를 중복없이 출력
select distinct job_code
from employee;

--여러 컬럼사용시 컬럼을 묶어서 고유한 값으로 취급한다.
select distinct job_code,dept_code
from employee;

--문자 연산자 ||
-- +는 산술연산만 가능하다.
select '안녕'||'하세요' ||123 
from dual;

select emp_name || '(' || phone ||')'
from employee;

------------------------------------------
--where절
------------------------------------------
--테이블의 모든 행 중 결과집합에 포함된 행을 필터링한다.
--특정행에 대해서 true(포함) | false(제외) 결과를 리턴한다.
/*
 =                      같은가
 != ,^= ,<>             다른가
 >,<,>,>=,<=
 between.. and..        범위연산
 like, not like         문자패턴연산
 is null, is not null   null여부
 in,not in              값목록에 포함여부
 
 and, or, not
*/
-- 부서코드가 D6인 사원 조회
select *
from employee
where dept_code ='D6'; -- != ^= <>가능

--급여가 2,000,000원보다 많은 사원조회
select emp_name,salary
from employee
where salary >=2000000;

--부서코드가 D6이거나 D9인 사원조회
select emp_name, dept_code
from employee
where dept_code = 'D6' or dept_code = 'D9';

--날짜형 크기비교 가능
select emp_name, hire_date
from employee
where hire_date < '2000/01/01';  --날짜형식의 문자열은 자동으로 날짜형으로 형변환

--20년이상 근무한 사원조회 : 날짜형-날짜형 = 숫자(1=하루)
select emp_name, hire_date, quit_yn
from employee
where quit_yn = 'N' and 
to_date('2021/01/22') - hire_date > (20*365);

--범위 연산
--급여가 200만원이상 400만원 이하인 사원조회 (사원명,급여)
SELECT emp_name, salary
FROM employee
where salary between 2000000 and 4000000; --where salary>=2000000 and salary <=4000000;


--  입사일이 1990/01/01 ~ 2001/01/01 인  사원조회(사원명,입사일)
select emp_name,hire_Date
from employee
where hire_Date >'1990/0101' and '2001/01/01'< hire_Date;
--between  and  사용 
select emp_name, hire_date
from employee
where hire_date between to_date('1990/01/01') and to_date('2001/01/01');


--like ,not like 
--문자열  패턴 비교 연산 
--wild card : 패턴의미를 가지는 특수문자 
-- 아무문자 1개 
--%아무문자 0개 이상 
select emp_name
from employee
where emp_name like '전%' ;  --전으로 시작,0개이상의 문자가 존재하는가
--전형동, 전전전(O)
--파전, 전진, 파전, 전당포아저씨(X)


--이름에 가운데글자가 '옹'인 사원 조회. 단, 이름은 3글자이다.
select emp_name
from employee
where emp_name like '_옹%_' ;

--이름에 '이'가 들어가는 사원조회
select emp_name
from employee
where emp_name like '%이%';

--email컬럼값의 '_'이전의 글자가 3글자인 이메일을 조회
select email
from employee
--where email like '____%';  --4글자 이후 0개이상의 문자열 뒤따르는가 ->문자열이 4글자이상인가?
where email like '___#_%' escape '#'; --임의의 escaping문자 등록, 데이터에 존재하지 않을것

--값(in, not in)목록에 포함여부
--부서코드가 D6 또는 D8인 사원 조회
select emp_name, dept_code
from employee 
where dept_code = 'D6' or dept_code = 'D8';

select emp_name, dept_code
from employee
where dept_code in ('D6','D8'); -- 계수제한없이 값나열

select emp_name, dept_code
from employee
where not dept_code  in ('D6','D8')
order by dept_code; -- D6~D8 값 안나옴

select emp_name, dept_code
from employee
where dept_code != 'D6' or dept_code != 'D8'-- D6~D8 값 안나옴
order by dept_code; --dept_code 오름차순

--is null, is not null = null 비교연산
--인턴사원 조회(dept_code = null)
--null값은 산술연산, 비교연산 모두 불가능하다.
select emp_name, dept_code
from employee
--where dept_code = 'null';
where dept_code is null
order by dept_code;

--null아닌 사람 출력
select emp_name, dept_code
from employee
--where dept_code = 'null';
where dept_code is not null
order by dept_code;


--D6, D8부서원이 아닌사원조회(인턴사원 포함)
select emp_name, dept_code
from employee
where dept_code not in ('D6','D8') or dept_code is null
order by dept_code; --dept_code 오름차순

select emp_name, dept_code
from employee
where dept_code is null or (dept_code != 'D6' and dept_code != 'D8');

--nvl버전
select emp_name, dept_code
from employee
where dept_code not in('D6','D8');
order by dept_code;

select emp_name, nvl(dept_code,'인턴')dept_code
from employee
where nvl(dept_code,'D0') not in('D6','D8');
order by dept_code;

--------------------------------
--order by
--------------------------------
--select구문 중 가장 마지막에 처리.
--지정한 컬럼 기준으로 결과집합을 정렬해서 보여준다

-- number 0 < 10
-- string ㄱ < ㅎ , a< z
-- date 과거 < 미래
-- null값 위치를 결정가능 : null first | nulls last
--desc = 뒤집기(내림차순)
--asc 오름차순
--복수개의 컬럼 차례로 정렬가능

select emp_id, emp_name, dept_code, job_code, hire_date
from employee
order by dept_code desc nulls last;

select emp_id, emp_name, dept_code, job_code, hire_date
from employee
order by emp_id desc;

select emp_id, emp_name, dept_code, job_code, hire_date
from employee
order by dept_code, job_code;

--급여 내림차순
select emp_id, emp_name, dept_code, job_code, hire_date,salary
from employee
order by salary desc;

--급여 오름차순
select emp_id, emp_name, dept_code, job_code, hire_date,salary
from employee
order by salary asc;

-- alias 사용가능
select emp_id 사번, emp_name 사원명
from employee
order by 사원명 desc;

--1부터 시작하는 컬럼순서 사용가능
select *
from employee
order by 9 asc;

-- salary 오름차순
select *
from employee
order by 9 desc;

select emp_id 사번, emp_name 사원명,dept_code 부서코드
from employee
where 부서코드 = 'D9'
order by 사원명 desc; -- from 다음 where 순서

select emp_id 사번, emp_name 사원명, dept_code, job_code, hire_date,salary
from employee
order by 4 desc;

--====================================
--Built-in Function
--====================================
-- 일련의 실행 코드 작성해두고 호출해서 사용함.
-- 반드시 하나의 리턴값을 갖는다.
-- 1.단일행 함수 : 각 행마다 반복 호출되어서 호출된 수 만큼 결과를 리턴함.
--      a. 문자처리함수
--      b. 숫자처리함수
--      c. 날짜처리함수
--      d. 형변환함수
--      e. 기타함수
-- 2.그룹함수 : 여러행을 그룹핑한후, 그룹당 하나의 결과를 리턴함.

-------------------------------------------------
--단일행 함수
-------------------------------------------------

--************************************************
--a.문자처리함수
--************************************************

-- length(col):number
-- 문자열의 길이를 리턴

select emp_name, length(emp_name)
from employee;
where length(email) < 15;

--lengthb(col)
--값의 byte수 리턴
select emp_name, lengthb (emp_name), email, lengthb(email)
from employee;

-- instr(string, search[,position],occurence]])
--string에서 search가 위치한 index를 반환.
--oracle에서는 1-based index, 1부터시작
--startPosition 검색시작 위치
--occurence 출현순서

select instr('kh정보교육원 국가정보원','정보'),
              intstr('kh정보교육원 국가정보원','안녕') ,
              instr('kh정보교육원 국가정보원','정보',5),
              instr('kh정보교육원 국가정보원 정보문화사', '정보', 1, 3), --15리턴
              instr('kh정보교육원 국가정보원', '정보', -1) -- 11 startPosition이 음수면 뒤에서부터 검색
from dual;

--email컬럼값중 '@'의 위치는 (이메일,인덱스)
select  email, instr(email,'@')
from employee;

--subst(string, startIndex[,length])
--string에서 startIndex부터 length개수만큼 잘라내어 리턴
--length 생략시에는 문자열 끝까지 반환

select substr('show me the money', 6, 2), --me
            substr('show me the money', 6), -- me the money
            substr('show me the money', -5, 3), --mon
            substr('show me the money', -5, 5)
from dual;

--@실습문제 : 사원명에서 성만(1글자로 가정) 중복없이 사전순으로 출력
select distinct substr(emp_name, 1, 1)  first_name
from employee
order by first_name;

select distinct substr(emp_name, 1, 1) "사원의성"
from employee
order by 사원의성 desc;

-- lpad | rpad(string, byte[, padding_char])
-- byte 수의 공간에 string을 대입하고, 남은 공간은 padding_char를 (왼쪽 | 오른쪽) 채울것.
-- paddiing char는 생략시 공백문자.
select lpad(email, 20, '#'),
            rpad(email, 20,'#'),
            lpad(email, 20),
            rpad(email, 20)
from employee;


--@실습문제 : 남자사원만 사번, 사원명, 주민번호, 연봉조회
-- 주민번호 뒤 6자리는 ***** 숨김처리할 것.

select  emp_id,emp_name, rpad(substr(emp_no,1,8),14,'*') ,salary
from employee
where substr(emp_no,8,1)=1 or substr(emp_no,8,1)=3;

select emp_id, emp_name, rpad(substr(emp_no,1,7),13,'*'),salary*12 연봉 --emp_no  총13자리중 1~7까지표시 해주고 나머지는 *로 처리
from employee
where instr(emp_no,'1')=8;

select emp_id, emp_name, rpad(substr(emp_no,1,7),13,'*'),salary*12 연봉 --emp_no  총13자리중 1~7까지표시 해주고 나머지는 *로 처리
from employee
where instr(emp_no,'1')=8;

select emp_id, 
            emp_name, 
             substr(emp_no,1,8) || '*****' emp_no,
             rpad(substr(emp_no,1,7),14,'*'),salary*12  annul_pay --emp_no  총13자리중 1~7까지표시 해주고 나머지는 *로 처리
from employee
where substr(emp_no,8,1)in ('1','3');


--@실습문제
create table tbl_escape_watch(watchname   varchar2(40),
                    description varchar2(200 ); --drop table tbl_escape_watch;
    insert into tbl_escape_watch values('금시계', '순금 99.99% 함유 고급시계');
    insert into tbl_escape_watch values('은시계', '고객 만족도 99.99점를 획득한 고급시계');
    commit;
    select * from tbl_escape_watch;
--tbl_escape_watch 테이블에서 description 컬럼에 99.99% 라는 글자가 들어있는 행만 추출하세요.
    
    select *
    from tbl_escape_watch
    where description like '%99.99\%%' escape '\'; -- '\'말고 다른 문자(숫자,문자)가 와도 좋지만, 헷가릴 수 있으니 사용빈도가 적은 역슬래시 '\'를 사용한다.
    
--@실습문제
--파일경로를 제외하고 파일명만 아래와 같이 출력하세요.
    create table tbl_files
    (fileno number(3),
    filepath varchar2(500) );
    insert into tbl_files values(1, 'c:\abc\deft\salesinfo.xls') ;
    insert into tbl_files values(2, 'c:\music.mp3');
    insert into tbl_files values(3, 'c:\documents\resume.hwp');
    commit;
    
    select * 
    from tbl_files;
    
--출력결과 :
--------------------------
--파일번호          파일명
---------------------------
--1             salesinfo.xls
--2             music.mp3
--3             resume.hwp
---------------------------
--substr함수, instr함수
    
    select fileno 파일번호
--        ,instr(filepath,'\',-1) 인덱스
        ,substr(filepath,instr(filepath,'\',-1)+1) 파일명
    from tbl_files;




--***********************************************
--b. 숫자처리함수
--***********************************************

--mod(피젯수, 젯수)
--나머지 함수, 오라클에서는 나머지 연산자 %가 없다.

select mod(10,2),
            mod(10,3),
            mod(10,4)
from dual;


--입사년도가 짝수 인 사원 조회
select emp_name,
            extract(year from hire_date) year --날짜함수 : 년도추출
from employee
where mod (extract(year from hire_date),2)  = 0
order by year;

--ceil(number)
--소수점 기준으로 올림.
select ceil(123.456),
            ceil (123.456*100) / 100 --부동소수점 방식으로 처리
from dual;


--floor(number)
--소수점기준으로 버림
select floor(456.789),  
                floor(456.789 * 10) / 10
from dual;


--round(number[,position])
--position기준(기본값 0, 소수점기준)으로 반올림 처리

select round(234.567),
             round(234.567,2),
             round(234.567,-1),
             round(235.567,-1)
from dual;


--trunc(number[,position])
--버림

select trunc(123.567),
            trunc(123.567,2)
from dual;


--***********************************************
--c. 날짜처리함수
--***********************************************
--★날짜형 + 숫자 = 날짜형
--★날짜형 - 날짜 = 숫자


--add_month(date, number)
--date기준으로 몇달(number) 전 후의 날짜형을 리턴

select sysdate,
        sysdate +5,
        add_months(sysdate,1),
        add_months(sysdate,-1),
        add_months(sysdate + 5, 1) --말일을 지정.
from dual;


--months_between(미래,과거)
--두날짜형의 개월수 차이를 리턴한다.

select sysdate,
            to_date('2021/07/08'),  --날짜형으로 변환하는 함수
            months_between(to_date('2021/07/08'), sysdate) diff,
            trunc(months_between(to_date('2021/07/08'), sysdate),1) diff
from dual;


--이름, 입사일, 근무개월수 (n개월), 근무개월수(n년 m개월) 조회

select emp_name, 
                hire_date,
            trunc(months_between(sysdate, hire_date)) || '개월' 근무개월수,
            trunc(months_between(sysdate,hire_date)/12) || '년' ||
            trunc(mod(months_between(sysdate, hire_date), 12)) || '개월' 근무개월수
           from employee;

-----------------------------------------------------------------------------------------------
select emp_name "이름", hire_date "입사일",
       trunc(months_between(sysdate, hire_date)) "근무 개월수",
       trunc(months_between(sysdate, hire_date) / 12) || '년' ||
       mod(trunc(months_between(sysdate, hire_date)), 12) || '개월' "근무 개월수"
from employee;
-----------------------------------------------------------------------------------------------


-- extract(year | month | day | hour | minute | second  from date) : number
-- 날짜형 데이터에서 특정필드만 숫자형으로 리턴.

select extract(year from sysdate) yyyy,
            extract(month from sysdate) mm, -- java에서는 0부터 시작했지만 지금은 1~12개월 인덱스기반 X
            extract(day from sysdate) dd,
            extract(hour from cast(sysdate as timestamp)) hh,
            extract(minute from cast(sysdate as timestamp)) mi,
            extract(second from cast(sysdate as timestamp))  ss,
            
            TO_CHAR(SYSDATE, 'HH:MI:SS') --현재시간 포맷 (12시간)
 from dual;
 
 
 
 
 -- trunc(date)
 -- 시분초 정보를 제외한 년월일 정보만 리턴
 
 select to_char(sysdate, 'yyyy/mm/dd hh24:mi:ss')date1, --형변환 함수
            to_char(sysdate, 'yyyy/mm/dd hh12:mi:ss')date1,
            to_char(trunc(sysdate), 'yyyy/mm/dd hh24:mi:ss')date2 
 from dual;
 
 
--***********************************************
--d. 형변환 함수
--***********************************************
/*
            to_char             to_date
            ------>                 ------>
nuber                string             date
            <------                <------
            to_number       to_char
            
*/

--to_cahr(date | number[, format])

select to_char(sysdate, 'yyyy/mm/dd hh24 : mi : ss') now,
            to_char(sysdate, 'yyyy/mm/dd(day) hh24 : mi : ss') now,
            to_char(sysdate, 'fm yyyy/mm/dd(day) hh24 : mi : ss') now, --형식문자로 인한 앞글자 0을 제거
            to_char(sysdate, 'fm yyyy(year)/mm"월"/dd"일"') now
from dual;

select to_char(1234567,'fml9,999,999,999') won, --L은 지역화폐
             to_char(1234567,'fml9,999') won, --자리수가 모잘라서 오류
              to_char(123.4,'999,99') two, --999 = 소수점이상의 빈자리는 공란, 소수점이하 빈자리는 0처리
              to_char(123.4,'0000.00') three --000 = 빈자리는 0처리
from dual;

-- 이름(emp_name), 급여(salary), 입사일(hire_date)을 조회
-- 급여 = 3자리마다 콤마
-- 입사일(1990-09-03(화))을 조회

select emp_name,
             to_char(salary,'fmL999,999,999')급여,
            to_char(hire_date,'fmyyyy"-"mm"-"dd(dy)')입사일
from employee;


--to_number(string,format)
select to_number('1,234,456','9,999,999') + 100,
            to_number('￦3,000','L9,999') --ㄹ + 한자
--            '1,234,567' + 100
from dual;

--자동형변환 지원
select '1000' +100,
            '99' + '1',
            '99'|| '1'
from dual;


--to_date(string, format)
--string이 작성된 형식문자 format으로 전달
select to_date('2020/09/09','yyyy/mm/dd') +1
from dual;

--@실습문제
--'2021/07/08 21:50:50' 를 2시간후의 날짜 정보를 yyyy/mm/dd hh24:mi:ss형식으로 출력
select to_char(
                to_date ( '2021/07/08 21:50:50','yyyy/mm/dd hh24:mi:ss')  + (2/24),
                    'yyyy/mm/dd hh24:mi:ss'
                    )result
from dual;

-----------------------------------------------
select to_char(to_date('2021/07/08 21:50:00', 'yyyy/mm/dd hh24:mi:ss')+
                    (1/12), 'yyyy/mm/dd hh24:mi:ss')
from dual;

--현재시각 기준 1일 2시간 3 분 4초후의 날짜 정보를 yyyy/mm/dd hh24:mi: ss형식으로 출력
-- 1시간 1 / 24
-- 1분 : 1/ (24*60)
-- 1초 : 1 / (24*60*60)
select to_char(
                sysdate + 1 + (2/24) + (3/ (24*60) ) + (4/ (24* 60* 60)), 
                'yyyy/mm/dd hh24:mi:ss'
                )result
from dual;

---------------------------------------------------
select systimestamp now,
    to_char(sysdate+1+(2/24)+((3/24)/60)+(((4/24)/60)/60), 'yyyy/mm/dd hh24:mi:ss') result
from dual;


--기간타입
--interval year to month : 년 월 기간
--interval date to second : 일 시 분 초 기간 

-- 지금부터 1년 2개월 3일 4시간5분 6초후 조회
select to_char(
                add_months (sysdate,14) + 3 + (4/24) + (5/24/60) + (6/24/60/60),
                'yyyy/mm/dd hh24:mi:ss') 
                result
from dual;


select to_char(
                sysdate + to_yminterval('+01-02') + to_dsinterval('3 04:05:06'), --to_dsinterval = day, hour,minute, second
                'yyyy/mm/dd hh24:mi:ss'
                ) result
from dual;

--numboinsterval( diff,unit)
--numtoyminterval(diff,unit)
-- diff : 날짜차이
--unit : year | month |day | hour | minute | second 
select  extract( day from
                numtodsinterval(
                    to_date('20210708',' yyyymmdd') - sysdate,
                            'day'
                            )) diff
from dual;


--***********************************************
--e. 기타함수
--***********************************************
--null처리 함수
 --nvl(col,nullvalue)
 --nvl2(col,notnullvalue,nullvalue)
 
 select emp_name,
                bonus,
                nvl(bonus,0) nvl1,
                nvl2(bonus,'있음','없음') nvl2
from employee;

--선택함수1
--decode(expr, 값1, 결과값1, 결과값2, ...[,기본값])
select emp_name,
            emp_no,
            decode(substr(emp_no,8,1), '1','남','2','여','3','남','4','여') gender
from employee;


--직급코드(dept_code)에 따라서 J1-대표,J2/J3-임원, 나머지 평사원으로 출력(사원명,직급코드,직위)
select emp_name 사원명, 
            job_code 직급코드,
            decode(job_code,'J1','대표','J2','임원','J3','임원','평사원') 직위
from employee;

--where절에도 사용가능
--여사원만 조회

select emp_name 사번, 
            emp_no 사원명,
            decode(substr(emp_no,8,1), '1','남','2','여','3','남','4','여') gender
from employee
where decode(substr(emp_no,8,1), '1','남','2','여','3','남','4','여') = '여';

-- 선택함수 2
-- case
/*
type 1(decode와 유사)

case 표현식
    when 값1 then 결과 1
    when 값2 then 결과2
    ...
    [else 기본값]
    end
type2

case
    when 조건식1 then 결과1
    when 조건식2 then 결과2
    ...
    [else 기본값]
    end
    
    */

select emp_name,emp_no,
            case substr(emp_no, 8,1)
            when '1' then '남'
            when '3' then '남'
            else '여'
            end gender,
            case
                when substr(emp_no,8,1) = '1' then '남'
                when substr(emp_no,8,1) = '3' then '남'
                else '여'
                end gender
            job_code,
            case job_code
                when 'J1' then  '대표'
                when 'J2' then  '임원'
                when 'J3' then  '임원'
                else '평사원'
                end job,
            case
                when job_code = 'J1'  then  '대표'
                when job_code in ('J2', 'J3')  then  '임원'
                else '평사원'
                end job
from employee;



-----------------------------------------------------
-- GROUP FUNCTION
-----------------------------------------------------
-- 여러행을 그룹핑하고, 그룹당 하나의 결과를 리턴하는 함수
-- 모든 행을 하나의 그룹, 또는 group by를 통해서 세부그룹지정이 가능하다.

--sum(col)


select emp_name sum(salary)
from employee;
--ORA-00923: FROM keyword not found where expected
--그룹함수의 결과와 일반컬럼을 동시에 조회할 수 없다.

select  sum(salary), 
                sum(bonus), --null인 컬럼은 제외하고 누계처리
                sum(salary + (salary + nvl(bonus, 0))) sum-- 가공된 컬럼도 그룹함수 가능
from employee;


--avg(col) 
--평균

select round(avg(salary),1) avg
from employee;

select to_char(
        round(avg(salary),1),'fmL999,999,999,999') avg
from employee;
----------------------------------------------------------------
select round(avg(salary),1) avg,
            to_char(round(avg(salary),1), 'fml9,999,999,999')avg
from employee;

--부서코드(dept_code)가 D5인 부서원의 평균급여(salary) 조회
select to_char(round(avg(salary),1) ,'fml999,999,999,999') D5
from employee
where dept_code = 'D5';
--김주연코드
select round(avg(salary),1)
from employee
where dept_code = 'D5';

--남자사원의 평균급여 조회
select to_char(round(avg(salary),1) ,'fml999,999,999,999') avg
from employee
where substr(emp_no,8,1) in ('1','3');


select to_char(round(avg(salary), 1), 'fmL9,999,999')||'원' 남사원평균급여
from employee
where substr(emp_no, 8, 1) in ('1', '3');


-- count(col)
-- null이 아닌 컬럼의 개수
-- *(아스탈리스트) 모든컬럼, 즉 하나의 행을 의미
select count(*) ,
            count(bonus), --9 bonus컬럼이  null이 아닌 행의 수
            count(dept_code)
from employee;

--보너스를 받는 사원수 조회
select count(*)
from employee
where bonus is not null;


select bonus,
            case 
                when bonus is not null then 1
                when bonus is null then 0
                end
from employee;

--가상컬럼의 합을 구해서 처리
select sum(
            case 
                when bonus is not null then 1
                when bonus is null then 0
                end
            ) bonusman
from employee;


-- 사원이 속한 부서 총수(중복없음)

select count(distinct dept_code)
from employee;


-- max(col) | min(col)
-- 숫자, 날짜(과거->미래), 문자(ㄱ->ㅎ)

select max(salary), min(salary),
            max(hire_date), min(hire_date),
            max(emp_name),min(emp_name)
from employee;


--2021-01-27

--나이 추출시 주의점
--현재년도 - 탄생년도 + 1 => 한국식 나이
select emp_name,
            emp_no,
            substr(emp_no, 1, 2) 나이,
--            extract(year from to_date(substr(emp_no, 1, 2), 'yy')),
--           extract(year from sysdate) -  extract(year from to_date(substr(emp_no, 1, 2), 'yy')) + 1,
--           extract(year from to_date(substr(emp_no, 1, 2), 'rr')),
--           extract(year from sysdate) -  extract(year from to_date(substr(emp_no, 1, 2), 'rr')) + 1
            extract(year from sysdate) -
            (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2)) + 1 age
from employee;

--yy는 현재년도 2021 기준으로 현재세기(2000~2099)범위에서 추측한다.
--rr는 현재년도 2021 기준으로 (1950~2049)범위에서 추측한다.

--==========================================
--DQL2
--==========================================
--------------------------------------------------------------------
--GROUP BY
--------------------------------------------------------------------
--지정컬럼기준으로 세부적인 그룹핑이 가능하다.
--group by구문없이는 전체를 하나의 그룹으로 취급한다.

select dept_code, 
-- emp_name, 
-- ORA-00979: not a GROUP BY expression
            sum(salary)
from employee
group by dept_code; --일반컬럼 | 가공컬럼이 가능


select job_code,
            trunc(avg(salary), 1)
from employee
group by job_code
order by job_code;

--부서코드별 사원수, 급여평균, 급여합계 조회
select nvl(dept_code, 'intern') dept_code, 
            count(*) count,
            to_char(sum(salary), 'fml9,999,999,999') sum,
            to_char(trunc(avg(salary), 1), 'fml9,999,999,999.0') avg
from employee
group by dept_code
order by dept_code;

--성별 인원수, 평균급여 조회
select decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender,
            count(*) count,
            to_char(trunc(avg(salary), 1), 'fml9,999,999,999.0') avg
from employee
group by decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여');

--직급코드 J1을 제외하고, 입사년도별 인원수를 조회

select extract(year from hire_date) yyyy, 
           count(*) count
from employee
where job_code <> 'J1'
group by extract(year from hire_date)
order by yyyy;

--두개 이상의 컬럼으로 그룹핑 가능
select nvl(dept_code, '인턴') dept_code,
            job_code,
            count(*)
from employee
group by dept_code, job_code
order by 1, 2;

--부서별 성별 인원수 조회
select dept_code, 
            decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender, 
            count(*)
from employee
group by dept_code, decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여')
order by 1, 2;


------------------------------------------
-- HAVING
------------------------------------------
--group by 이후 조건절

--부서별 평균 급여가 3,000,000원 이상인 부서만 조회
select 
dept_code 부서코드,
            trunc(avg(salary)) avg
from employee
group by dept_code
having avg(salary) >= 3000000
order by 1;

--직급별 인원수가 3명이상인 직급과 인원수 조회
select job_code, count(*)
from employee
group by job_code
having count(*)  >= 3
order by job_code;

--관리하는 사원이 2명이상인 manager의 아이디와 관리하는 사원수 조회
select manager_id, 
           count(*)
from employee
where manager_id is not null
group by manager_id
having count(*) >= 2
order by 1;

select manager_id, 
           count(*)
from employee
group by manager_id
having count(manager_id) >= 2
order by 1;


--rollup | cube(col1, col2...)
--group by절에 사용하는 함수
--그룹핑 결과에 대해 소계를 제공

-- rollup 지정컬럼에 대해 단방향 소계 제공
-- cube 지정컬럼에 대해 양방향 소계 제공
-- 지정컬럼이 하나인 경우, rollup/cube의 결과는 같다.

select dept_code,
            count(*)
from employee
group by rollup(dept_code)
order by 1;

select dept_code,
            count(*)
from employee
group by cube(dept_code)
order by 1;

--grouping()
--실제데이터(0) | 집계데이터(1) 컬럼을 구분하는 함수
select decode(grouping(dept_code), 0, nvl(dept_code, '인턴'), 1, '합계') dept_code,
--            grouping(dept_code),
            count(*)
from employee
group by rollup(dept_code)
order by 1;

--두개이상의 컬럼을 rollup|cube에 전달하는 경우
select decode(grouping(dept_code), 0, nvl(dept_code, '인턴'), '합계') dept_code, 
            decode(grouping(job_code), 0, job_code, '소계') job_code,
            count(*)
from employee
group by rollup(dept_code, job_code)
order by 1, 2;

select dept_code,
            job_code,
            count(*)
from employee
group by cube(dept_code, job_code)
order by 1, 2;


select decode(grouping(dept_code),0,nvl(dept_code,'INTERN'),'소계') dept_code,
            decode(grouping(job_code),0,job_code,'소계')job_code,
            count(*)
from employee
group by cube(dept_code,job_code)
order by 1,2;

/*
select ...5
from ...1
where ...2
group by ...3
having ...4
order by ...6
*/


-- relation 만들기
-- 가로방향 합치기 JOIN 행 + 행
-- 세로방향 합치기 UNION 열 + 열

--==========================================
-- JOIN
--==========================================
-- 두개이상의 테이블을 연결해서 하나의 가상테이블(relation)을 생성
-- 기준컬럼을 가지고 행을 연결한다.

-- 송중기 사원의 부서명을 조회
select dept_code -- D9
from employee
where emp_name = '송종기';

select  dept_title -- 총무부
from department
where dept_id = 'D9';

--join
select D.dept_title
from employee E join department D
        on E.dept_code = D.dept_id
where E.emp_name = '송종기';

select * from employee;
select * from department;

-- join 종류
-- 1. EQUI-JOIN = 동등비교조건(=)에 의한 조인
-- 2. NON- EQUI JOIN  = 동등비교조건이 아닌(between and, in, not in, !=) 조인

-- JOIN 문법
-- 1. ANSI 표준문법 : 모든 DBMS 공통문법
-- 2. Vendor별 문법 : DBMS별로 지원하는 문법

--테이블 별칭
select employee.emp_name,
            job.job_code, --ORA-00918: column ambiguously defined 컬럼명이 다르기때문에 앞에(job.) 컬럼명을 써줘야한다.
            job_name
from employee join job
        on employee.job_code = job.job_code;
--------------------------------------------------------------------------------------------------------------------
 select E.emp_name,
            J.job_code, --ORA-00918: column ambiguously defined 컬럼명이 다르기때문에 앞에(job.) 컬럼명을 써줘야한다.
            J.job_name
from employee E join job J
        on employee.job_code = job.job_code;


--기준컬럼명이 좌우테이블에서 동일하다면, on 대신 using 사용가능
--using을 사용한 경우에는 해당컬럼에 별칭을 사용할 수 없다.
--(ORA-25154: column part of USING clause cannot have qualifier)
select E.emp_name,
                job_code, -- 별칭 사용할수 X
                J.job_name
from employee E join job J
            using(job_code);
        
--------------------------------------------------------------------------------------------------------------------
select *
from employee join job
        on employee.job_code = job.job_code;
        
select * 
from employee;
select *
from job;

--equi - join 종류
/*
1. inner join 교집합

2.outer join 합집합
        - left outer join 좌측테이블 기준 합집합
        - right outer join 우측테이블 기준 합집합
        - full outer join 양테이블 기준 합집합

3. cross join
    두 테이블간의 조인할 수 있는 최대경우의 수를 표현

4.self join
    같은 테이블의 조인

5. multiple join
    3개이상의 테이블을 조인
*/

--------------------------------------------------------------------------------------------------------------------
-- INNER JOIN
--------------------------------------------------------------------------------------------------------------------
-- A(INNER) JOIN B
-- 교집합
-- 1. 기준컬럽이 NULL인 경우, 결과집합에서 제외.
-- 2. 기준컬럼값이 상대테이블 존재하지 않는 경우, 결과집합에서 제외

--1. employee에서 dept_code가 null인 행이 제외 : 인턴사원 2행 제외
--2. department에서 dept_id가 D3,D4,D7인 행은 제외
select *
from employee E join department D
        on E.dept_code = D.dept_id;
        
        
select distinct D.dept_id
from employee E join department D
        on E.dept_code = D.dept_id;
        
select *
from department;

select *
from employee E join job J
        on E.job_code = J.job_code;
    
    
--(oracle) ,(콤마)로 구분한다. where절에 추가로 필요하다면 and로 추가
select *
from employee E, department D
where E.dept_code = D.dept_id and E.dept_code = 'D5';

select *
from employee E,  job J
where E.job_code = J.job_code;

--------------------------------------------------------------------------------------------------------------------
-- OUTER JOIN
--------------------------------------------------------------------------------------------------------------------
--1. LEFT (OUTER) JOIN
-- 좌측테이블 기준
-- 좌측테이블 모든 행이 포함, 우측테이블에는 ON조건절에 만족하는 행만 포함.
--24 = 22 + 2(left table)

select *
from employee E left outer join department D
    on E.dept_code  = D.dept_id;
    
-- (oracle)
-- 기준테이블의 반대편 컬럼에 (+)를 추가
select *
from employee E, department D
where E.dept_code = D.dept_id(+);
    
--2.RIGHT (OUTER) JOIN
-- 우측테이블 기준
-- 우측테이블 모든 행이 포함, 좌측테이블에는 On 조건절에 만족하는 행만 포함.
-- 25= 22 + 3(right)

select *
from employee E right join department D
        on E.dept_code = D.dept_id;
 -- (oracle)
-- 기준테이블의 반대편 컬럼에 (+)를 추가 
select *
from department D, employee E 
where d.dept_id =  e.dept_code(+);
        
--3. FULL(OUTER) JOIN
-- 완전 조인
-- 좌우 테이블 모두 포함

select *
from employee E full join department D
        on E.dept_code = D.dept_id;
        
        
--(oracle)에서는 full outer join을 지원하지 않는다.

-- 사원명/부서명 조회시
-- 부서지정이 안된 사원은 제외한다면 inner join으로 충분
-- 부서지정이 안되도 포함시켜준다면 left join
-- 사원부원도 안된 부서도 포함시켜야한다면 right join





--------------------------------------------------------------------------------------------------------------------
--CROSS JOIN
--------------------------------------------------------------------------------------------------------------------
--상호조인.
--ON조건절 없이, 좌측테이블 행과 우측테이블의 행이 연결될 수 있는 모든 경우의 수를 포함한 결과 집합을 리턴.

--216  = 24 * 9
SELECT*
FROM employee E cross join department D;

--(oracle)
SELECT*
FROM employee E ,department D;



-- 일반컬럼, 그룹함수 결과를 함께 보고자 할때.


select trunc(avg(salary))
from employee;


select emp_name, salary, avg, salary - avg diff
from employee E cross join(select trunc(avg(salary)) avg 
                                                    from employee) A;
                                                    
--------------------------------------------------------------------------------------------------------------------
--SELF JOIN
--------------------------------------------------------------------------------------------------------------------
--조인시 같은 테이블을 좌/우측 테이블로 사용


--사번, 사원명, 관리자사번, 관리자명 조회

select E1.emp_id, E1.emp_name,E1.manager_id,
            E2.emp_id, E2.emp_name
from employee E1 join employee E2 
        on E1.manager_id = E2.emp_id;

    
    
    --(oracle)
    select E1.emp_id,
                E1.emp_name,
                E1.manager_id,
                E2.emp_name
    from employee E1, employee E2
    where E1.manager_id = E2.emp_id;
    
    
    
--------------------------------------------------------------------------------------------------------------------
--MULTIPLE JOIN
-- it is easy
--------------------------------------------------------------------------------------------------------------------
--여러테이블 3개이상의 테이블을 JOIN
--한번에 무조건 좌우 두 테이블씩 조인하여 3개이상의 테이블을 연결한다.

--사원명, 부서명, 지역명, 직급명

select *
from employee; --E.dept_code
select *
from department; -- D.location_id, D.location_id
select * 
from location; -- L.local_code

--사원명, 부서명, 지역명, 직급명
select E.emp_name,
             D.dept_title,
             L.local_name,
             J.job_name
from employee E
    join department D
        on E. dept_code = D.dept_id
    join location L
        on D.location_id = L.local_code
        join job J
        on E.job_code = J.job_code;
--where E.emp_name = '송종기';

--조인하는 순서를 잘 고려할 것.
-- left join으로 시작했으면, 끝까지 유지해줘야 데이터가 누락되지 않는 경우가 있다.



--(oracle)
select *
from employee E, department D, location L, job J
where E.dept_code = D.dept_id(+)
        and D.location_id = L.local_code(+)
        and E.job_code = J.job_code;












-- 직급이 대리, 과장이면서 ASIA지역에 근무하는 사원 조회
-- 사번, 이름, 직급명, 부서명, 급여, 근무지역, 국가

select E.emp_id 사번,
            E.emp_name 이름,
            J.job_name 직급명,
            D.dept_title 부서명,
            E.salary 급여,
            L.local_name 근무지역,
            L.national_code 국가
from employee E
    join job J
        on E.job_code = J.job_code
    join department D
        on E.dept_code = D.dept_id
    join location L
        on D.location_id = L.local_code
where J.job_name in ('대리','과장')
        and L.local_name like 'ASIA%';
        
--------------강사------------------------
select E.emp_id,
            E.emp_name,
            J.job_name,
            D.dept_title,
            E.salary,
            L.local_name,
            N.national_name
from employee E
    join job J
        on E.job_code = J.job_code
    join department D
        on E.dept_code = D.dept_id
    join location L
        on D.location_id = L.local_code
    join nation N
        on L.national_code = N.national_code
    where j.job_name in ('대리', '과장')
            and L.local_name like  'ASIA%';
            select * from employee;
            

--select * from department;
--select * from job;
--select * from location;
--select * from nation


--------------------------------------------------------------------------------------------------------------------
-- NON-EQUI JOIN
--------------------------------------------------------------------------------------------------------------------
--employee.sal_grade테이블을 조인
--employee테이블의 sal_level컬럼이 없다고 가정.
--employee.salary 컬럼과 sal_grade.min_sal | sal_grade.max_sal을 비교해서 Join

select * from employee;
select * from sal_grade;

select *
from employee E
    join sal_grade S
            on E.salary between S.min_sal and S.max_sal;

-- 조인조건절에 따라 1행에 여러행이 연결된 결과를 얻을 수 있다.
select *
from employee E
    join department D
            on E.dept_code != D.dept_id
        order by E. emp_id, D.dept_id;
        
--==================================================
--SET OPERATOR (집합연산자)
--==================================================
--집합연산자. ENTITY를 컬럼수가 동일하다는 조건하에 상하로 연결한것.
-- SELECT 절의 컬럼수가 동일.
-- 컬럼별 자료형이 상호호환 가능해야 한다.(문자형CHAR, VARCHAR2) 끼리 OK, 날짜형 + 문자열 ERROR
-- 컬럼명이 다른 경우, 첫번쨰 ENTITY의 컬럼명을 결과집합에 반영
-- ORDER BY 은 마지막 ENTITY에서 딱 한번만 사용가능

--UNION 합집합
--UNION ALL 합집합
--INTERSECT 교집합
--MINUS 차집합

/*
 A = {1,3,2,5}
 B = {2,4,6}
 
 A UNION B => {1,2,3,4,5,6} (합친후 중복제거, 첫번째컬럼 기준 오름차순 정렬까지)
 A UNION ALL B => {1,3,2,5,2,4,6} (합친후 중복제거 X, 정렬 X)
 A INTERESCT B => {2}
 A MINUS B => {1,3,5}
 
*/



--==================================================
-- UNION | UNION ALL
--==================================================
--A : D5부서원의 사번, 사원명, 부서코드, 급여
select emp_id,emp_name,dept_code,salary
from employee
where dept_code = 'D5';

--B : 급여가 300만원이 넘는 사원조회(사번, 사원명, 부서코드, 급여)
select emp_id,emp_name,dept_code,salary
from employee
where salary > 3000000;

--A UNION B
select emp_id,emp_name,dept_code,salary
from employee
where dept_code = 'D5'
--order by은 마지막 entity에서만 사용가능
union
select emp_id,emp_name,dept_code,salary
from employee
where salary > 3000000
order by dept_code;

--A UNION ALL B
select emp_id,emp_name,dept_code,salary
from employee
where dept_code = 'D5'
union all
select emp_id,emp_name,dept_code,salary
from employee
where salary > 3000000;

--==================================================
-- INTERSECT | MINUS
--==================================================
-- A INTERSECT B
select emp_id,emp_name,dept_code,salary
from employee
where dept_code = 'D5'
intersect
select emp_id,emp_name,dept_code,salary
from employee
where salary > 3000000;

-- A MINUS B
select emp_id,emp_name,dept_code,salary
from employee
where dept_code = 'D5'
minus
select emp_id,emp_name,dept_code,salary
from employee
where salary > 3000000;

select emp_id,emp_name,dept_code,salary
from employee
where salary > 3000000
minus
select emp_id,emp_name,dept_code,salary
from employee
where dept_code = 'D5';

--==================================================
-- SUB QUERY
--==================================================
-- 하나의 SQL문(MAIN-QUERY)안에 종속된 또 다른 SQL문(SUB-QUERY)
-- 존재하지 않는 값, 조건에 근거한 검색등을 실행할 때 사용.

-- 반드시 소괄호로 묶어서 처리!.
-- SUB-QUERY내에는 ORDER BY문법지우너 안한다.
-- 연산자 오른쪽에서 사용해야한다. WHERE COL = ()

-- 노옹철사원의 관리자 이름을 조회
select E1.emp_id,
             E1.emp_name,
             E1.manager_id,
             E2.emp_name
from employee E1 
        join employee E2 
            on E1. manager_id = E2.emp_id
where E1.emp_name = '노옹철';

-- 1. 노옹철사원행의 manager_id조회
-- 2. emp_id가 manager_id와 동일한 행의 emp_name을 조회
select manager_id
from employee
where emp_name = '노옹철';

select emp_name
from employee
where emp_id = (select manager_id
                                    from employee
                                    where emp_name = '노옹철');

/*
리턴값의 개수에 따른 분류
1. 단일행 단일컬럼 서브쿼리
2. 다중행 단일컬럼 서브쿼리 
3. 다중열 서브쿼리(단일행/다중행)

4.상관 서브쿼리
5.스칼라 서브쿼리

6. inline - view
*/
-------------------------------------------------------------------------------------------------------
-- 단일행 단일컬럼 서브쿼리
-------------------------------------------------------------------------------------------------------
-- 서브쿼리 조회결과가 1행 1열일때 

--(전체 평균급여)보다 많은 급여를 받는 사원 조회
select emp_name, salary
from employee
where salary > (전체 평균급여);

select emp_name, salary
from employee
where salary > (select avg(salary) 
                                from employee);
                                
 select emp_name,
                salary,
                trunc((select avg(salary)
                                from employee)) avg
from employee
where salary > (select avg(salary) 
                                from employee);
--1742~1757 = 다같은 내용

--(윤은해 사원과 같은 급여)를 받는 사원 조회(사번, 이름, 급여)
select emp_id,emp_name,salary
from employee
where salary = (select salary
                                from employee
                                where emp_name = '윤은해');
                                
select emp_id, emp_name,salary
from employee
where salary = (윤은해 사원과 같은 급여);

select emp_id, emp_name,salary
from employee
where salary = (
                                select salary
                                        from employee
                                            where emp_name = '윤은해'
)
and emp_name !='윤은해';

--D1,D2부서원 중에 D5부서의 평균급여보다 많은 급여를 받는 사원 조회(부서코드, 사번, 사원명, 급여)
                                    
select dept_code,emp_id,emp_name,salary
from employee
where dept_code in ('D1','D2')
    and salary > (D5부서의 평균급여);
    
select dept_code,emp_id,emp_name,salary
from employee
where dept_code in ('D1','D2')
    and salary > (
                                    select avg(salary)
                                    from employee
                                    where dept_code = 'D5'
                                    );
                                    
-------------------------------------------------------------------------------------------------------
--다중행 단일컬럼 서브쿼리
-------------------------------------------------------------------------------------------------------
-- 연산자 in | not in | any | all | exists 와 함께 사용가능한 서브쿼리
select emp_name
from employee;


--송종기, 하이유 사원이 속한 부서원 조회
select emp_name, dept_code
from employee
where dept_code in (select dept_code
                                            from employee
                                            where emp_name in ('송종기','하이유')
);


select dept_code
from employee
where emp_name in ('송종기','하이유');

-- 차태연, 전지연사원의 급여등급(sal_level)과 같은 사원 조회(사원명, 직급명, 급여등급 조회)
select emp_name 사원명,
        job_name 직급명,
        sal_level 급여등급
from employee
        join job
        using (job_code)
where sal_level in (
                    select sal_level
                    from employee
                    where emp_name in ('차태연', '전지연')
                    )
     and emp_name not in ('차태연', '전지연');
     
select emp_name 사원명,
            job_name 직급명,
            sal_level 급여등급
from employee
        join job
            using(job_code)
where sal_level in (
                                       select sal_level
                                        from employee
                                        where emp_name in ('차태연','전지연')
                                        )
and emp_name not in ('차태연', '전지연');

-- 직급명(job.job_name)이 대표, 부사장이 아닌 사원조회 (사번, 사원명, 직급코드)
select    emp_id,
                emp_name,
                job_code
from employee E
where e.job_code not in (
                                                                select job_code
                                                                from job
                                                                where job_name in ('대표','부사장')
                                                                );
                                                                
                                                                
--ASIA1지역에 근무하는 사원조회 (사원명, 부서코드)
--location.local_name : ASIA1
--department.location_id --- location.local_code
--employee.dept_code --- department.dept_id

select local_code
from location
where local_name = 'ASIA1';

select *
from department
where location_id = 'L1';

from employee
where dept_ code in ('D1','D2','D3','D4','D9');


select emp_name, dept_code
from employee
where dept_code in(
                                select dept_id
                                from department
                                where location_id in(
                                                                select local_code
                                                                from location
                                                                where local_name = 'ASIA1'
                                                                )
                             );

-------------------------------------------------------------------------------------------------------
-- 다중열 서브쿼리
-------------------------------------------------------------------------------------------------------
-- 서브쿼리의 리턴된 컬럼이 여러개인 경우,

--(퇴사한 사원)과 같은 부서, 같은 직급의 사원 조회(사번,부서코드, 직급코드 조회)

select dept_code, job_code
from employee
where quit_yn ='Y';

select emp_name,
            dept_code,
            job_code
from employee
where dept_code = (
                                            select dept_code
                                            from employee
                                            where quit_yn ='Y'
                                        )
        and job_code = (
                                        select job_code
                                        from employee
                                         where quit_yn ='Y'
                                        );
                                        
                                        
select emp_name,
            dept_code,
            job_code
from employee
where (dept_code,job_code) = (
                                                                select dept_code, job_code
                                                                from employee
                                                                where quit_yn = 'Y'
                                                                );
                                                                
--메인 쿼리와 서브쿼리의 짝을 맞춰서 합칠 수도 있음
--컬럼명과 상관없이 나오는 컬럼에 들어있는 값을 가지고 판단함
                                                                

--manager가 존재하지 않는 사원과 같은 부서코드, 직접코드를 가진 사원 조회
-- in 연산자 = 다중행 다중컬럼 처리 가능
select emp_name,
            dept_code,
            job_code
from employee
where (nvl(dept_code ,'D0'),job_code) in (
                                                                select nvl(dept_code, 'D0'),ob_code
                                                                from employee
                                                                where manager_id is null
                                                                );
                                                                
--부서별 최대급여를 받는 사원 조회(사원명, 부서코드, 급여)
select emp_name 사원명,
       dept_code 부서코드,
       salary 급여
from employee
where salary   in (
                                        select max(salary)
                                        from employee
                                        group by dept_code
                                  );
                                  
                                  
select dept_code, 
            max(salary)
from employee
group by dept_code;

select emp_name, nvl(dept_code,'인턴') dept_code,
                salary
from employee
where (nvl(dept_code,'D0'), salary) in (
                                                            select nvl(dept_code, 'D0'),
                                                                            max(salary)
                                                            from employee
                                                            group by dept_code
                                                            )
order by dept_code;


select *
from employee
where dept_code = 'D6';

-------------------------------------------------------------------------------------------------------
-- 상관 서브쿼리
-------------------------------------------------------------------------------------------------------
-- 상호연관 서브쿼리.
-- 메인쿼리의 값을 서브쿼리에 전달하고, 서브쿼리 수행 후 결과를 다시 메인쿼리에 반환.

--직급별 평균급여보다 많은 급여를 받는 사원 조회
-- join으로 처리
select *
from employee E
    join (select job_code, avg(salary) avg
             from employee
             group by job_code
            )EA
            using(job_code)
where E.salary > EA.avg
order by job_code;



select emp_name 사원명 , job_code 사원코드,
salary 급여
from employee E
where salary > (select avg(salary)
                from employee
                where job_code = E.job_code);

-- 상관서브쿼리로 처리
select *
from employee E
where salary > (직급별 평균급여);
--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
select emp_name, job_code, salary
from employee E --메인쿼리의 테이블 별칭이 반드시 필요
where salary > (
                                select avg(salary)
                                from employee
                                where job_code = E.job_code
                                );
                                
--부서별 평균급여보다 적은 급여를 받는 사원 조회(인턴포함)
select emp_name 사원명, 
             nvl(dept_code, '인턴') 부서코드, --  인턴포함 nvl
             salary 급여
from employee E
where salary < (select avg (salary)
                                from employee
                                where nvl(dept_code, '인턴') = nvl (E.dept_code, '인턴'))
order by 2;



--exists 연ㅅ나자
-- exist (sub-query) sub - query에 행이 존재하면 참, 행이 존재하지 않으면 거짓

select *
from employee
where 1= 1; -- true 결과행이 존재하여 실행

select *
from employee
where 1 =0; -- false 결과행이 존재하지 않음으로 실행X


--행이 존재하는 subquery -> exists true
select *
from employee
where exists(select emp_name
                            from employee
                            where 1= 1
                            );
                            
--행이 존재하는 subquery -> exists false
select *
from employee
where exists(select emp_name
                            from employee
                            where 1= 0
                            );
                            
                            
-- 관리하는 직원이 한명이라도 존재하는 관리자사원을 조회
-- 내 emp_id값이 누군가의 manager_id로 사용된다면, 나는 관리자
-- 내 emp_id값이 누군가의 manager_id로 사용되지 않는다면, 나는 관리자가 아니다.

select emp_id, emp_name
from employee E
where exists (
                            select *
                            from employee
                            where manager_id = E.emp_id
                            );

select *
from employee E;

 select *
from employee
where manager_id = '204';


-- 부서 테이블에서 실제 사원이 존재하는 부서만 조회(부서코드, 부서명)
select dept_id 부서코드,
            dept_title 부서명
from department D
where exists(
                            select *
                            from employee
                            where dept_code = D.dept_id)
order by 1;

select dept_id 부서코드,
       dept_title 부서명
from department D
where exists (
            select 1
            from employee E
            where D.dept_id = E.dept_code
        );
        
select *
from employee
where dept_code = 'D2';


-- 부서 테이블에서 실제 사원이 존재하는 않는 부서만 조회(부서코드, 부서명)
-- not exists(sub-query) :
--  sub-query의 결과행이 존재하지 않으면 true
select dept_id 부서코드,
       dept_title 부서명
from department D
where not exists (
            select 1
            from employee E
            where D.dept_id = E.dept_code
        );
        
-- 최대/최소값 구하기(not exists)
-- 가장 많은 급여를 받는 사원의 조회
--  가장 많은 급여를 받는 다는건 -> 본인보다 많은 급여를 받는 사원이 존재하지 않는다.
select *
from employee e
where not exists(
                                    select *
                                    from employee e2
                                    where e.salary < e2.salary
                                    );
                                    
select emp_name 사원명, salary 급여
from employee E
where not exists(
                                    select 1
                                    from employee 
                                    where salary > E.salary
                                    );
-----------------------------------------------------------------------------------------------
-- SCALA SUBQUERY
-----------------------------------------------------------------------------------------------
-- SCALA = 단일
-- 서브쿼리의 실행결과1(단일행 단일컬럼)인 selec절에 사용된 상관서브쿼리

-- 관리자 이름 조회

select emp_name, 
              (
                    select emp_name
                    from employee
                    where emp_id = E.manager_id
              )manager_name
from employee E;

select emp_name, 
              (
                    select nvl(emp_name, ' dddd')
                    from employee
                    where emp_id = E.manager_id
              )manager_name
from employee E;



-- 사원명, 부서명, 직급명 조회
select E.emp_name 사원명,
                (
                select D.dept_title
                from department D
                where E.dept_code = D.dept_id
                ) 부서명,
                (select J.job_name
                from job J
                where E.job_code = J.job_code
                )직급명
from employee E;

select emp_name,nvl((select dept_title
                                                    from department
                                                    where E.dept_code = dept_id), '부서없음') dept_title
                                                    (select job_name
                                                    from job
                                                    where  E.job_code = job_code) job_name
from employee E; --null값 없애준 버젼

-----------------------------------------------------------------------------------------------
-- INLINE VIEW
-----------------------------------------------------------------------------------------------
-- FROM절에 사용된 SUBQUERY. 가상테이블

--_여사원의 사번, 사원명, 성별조회
select emp_id,
            emp_name,
            decode(substr(emp_no, 8, 1),'1','남','3','남','여') gender
from employee
where decode(substr(emp_no, 8, 1),'1','남','3','남','여') = '여';

select emp_id, 
            emp_name, 
            gender
from (
            select emp_id,
            emp_name,
            decode(substr(emp_no, 8, 1),'1','남','3','남','여' ) gender
from employee
            )
where gender = '여';

-- 30~50세 사이의 여사원 조회 (사번, 이름, 부서명,나이, 성별)
--inline-view 나이, 성별
select *
from (select emp_id,
                    emp_name,
                    nvl((
                            select dept_title
                             from department
                           where E.dept_code = dept_id
                          ), '인턴')dept_name,
                     decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender,
                     extract(year from sysdate) - 
                     case
                      when substr(emp_no,1,2) > 20 then '19'||substr(emp_no,1,2)
                      when substr(emp_no,1,2) < 20 then '20'||substr(emp_no,1,2)
                       end + 1 age
            from employee E
            )
where gender = '여' and age between 30 and 50;

select * --강사 코드
from (
            select emp_id, 
                        emp_name,
                        nvl((select dept_title from department where dept_id = E.dept_code), '인턴') dept_title,
                        extract(year from sysdate) -
                        (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2)) + 1 age,
                        decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
            from employee E
        ) 
where age between 30 and 50 
    and gender = '여';
    
--=============================================
-- 고급 쿼리
--=============================================

-------------------------------------------------------------------------
--TOP-N 분석
-------------------------------------------------------------------------
--급여를 많이 받는 Top 5, 입사일이 가장 최근인 Top-10조회등

select emp_name, salary
from employee
order by salary desc;

--rownum | rowid
--rownum : 테이블에 레코드 추가시 1부터 1씩 증가하면서 부여된 일련번호. 부여된 번호는 변경불가.
--rowid : 테이블 특정 레코드에 접근하기 위한 논리적 주소값(hash코드와 비슷하다고 생각)
select rownum,
            rowid,
            E.*
from employee E
order by salary desc;

--where절 사용시 rownum 새로 부여
select rownum, E.*
from employee E
where dept_code = 'D5';

select rownum old,
                emp_name, 
                salary
from employee
order by salary desc;

--inline view 사용 -> rownum이 새로 부여
select rownum, E.*
from (
            select 
--                                rownum old,
                            emp_name, 
                            salary
            from employee
            order by salary desc
            ) E
where rownum between 1 and 5;


--입사일이 빠른 10명 조회
--rownum은 where절이 시작하면서 부여되고, where절이 끝나면 모든행에 대해 부여가 끝난다.
--offset이있다면, 정상적으로 가져올 수 없다.
--inlineview를 한계층 더 사용해야 한다.
select rownum 번호, E.*
from(  
            select  
                        emp_name 이름,
                        hire_date 입사일
            from employee
            order by hire_date
            ) E   
where rownum between 1 and 10;

select *
from(            
            select emp_name, -- 강사코드
                        hire_date
            from employee
            order by hire_date asc
            ) E
 where rownum between 1 and 10;
 
 
select E.*
from(            
            select rownum rnum, E.* -- 강사코드
            from( 
                        select emp_name,  
                                        hire_date
                        from employee
                        order by hire_date asc
                        ) E
            ) E
 where rnum between 6 and 10;
 
-- 직급이 대리인 사원중에 연봉 Top-3 조회(순위,이름,연봉)
select E.*
from (
                select rownum 순위, emp_name 이름, salary * 12 연봉
                from employee
                order by 연봉 desc
                ) E
where 순위 <=3;

-- 부서별 평균급여 Top-3조회(순위, 부서명, 평균급여)
select rownum 순위, E.*
from (
                select (select dept_title
                from department
                where E.dept_code = dept_id
                ) 부서명,
                trunc(avg(salary)) 평균급여
                from employee E
                group by dept_code
                order by 평균급여 desc
            )E
where rownum <= 3;

select dept_code, -- 강사코드
            trunc(avg(salary)) avg
from employee
group by dept_code
order by avg desc;

select E.* --강사코드
from (
        select rownum rnum, E.*
        from (
                select --nvl(dept_code, '인턴') dept_code,
                            nvl((
                                    select dept_title 
                                    from department D 
                                    where dept_id = E.dept_code
                                  ), '인턴') dept_title, 
                            trunc(avg(salary)) avg
                from employee E
                group by dept_code
                order by avg desc
                ) E
         ) E
where rnum between 4 and 6;


-- 부서별 평균급여 4~6위 조회(순위, 부서명, 평균급여)
select E.*
from(
                select rownum rnum ,E.*
                        from(
                            select d.dept_title 부서명, 
                                    trunc(avg(salary),1) 평균급여
                            from employee E join department D
                                on  dept_code = D.dept_id 
                                group by d.dept_title
                            order by 평균급여
                                  ) E
                                )E
                                where rnum between 4 and 6;
--with구문
--inlineview 서브쿼리에 별칭을 지정해 재사용하게 함.
with emp_hire_date_asc
as
(
select emp_name, 
            hire_date
from employee
order by hire_date asc
)
select E.*
from (
            select rownum rnum, E.*
            from emp_hire_date_asc E
            ) E        
where rnum between 6 and 10;

------------------------------------------------------------------------------------------------
--WINDOW FUNCTION
------------------------------------------------------------------------------------------------
--행과 행간의 관계를 쉽게 정의하기 위한 표준함수
--1. 순위함수
--2. 집계함수
--3. 분석함수
--여튼 많다.
/*
window_function(args) over([partition by절][order by절][windowing절])

1.args 윈도우함수 인자 0~n개지정 (없을수도있다.)
2.over - partition by : 그룹핑 기준 컬럼
3.order by절 : 정렬기준컬럼을 기준
4.windowing절 : 처리할 행의 범위를 지정.(어려워서 아직은 사용X)
    */

--rank() over() : 순위를 지정
--dense_rank() over() : 빠진 숫자없이 순위를 지정하지만 지정
select emp_name,
            salary,
            rank() over(order by salary desc) rank,
            dense_rank() over(order by salary desc) rank
from employee;

--그루핑에 따른 순위 지정
select emp_name,
                dept_code,
                salary,
                rank() over(partition by dept_code order by salary desc) rank_by_dept
from employee;

select E.*
from(
    select emp_name,
                dept_code,
                salary,
                rank() over(partition by dept_code order by salary desc) rank_by_dept
    from employee
    )E
where rank_by_dept between 1and 3;

--sum() over()
--일반컬럼과 같이 사용할 수 있다.
select emp_name,
            salary,
            dept_code,
--            (select sum(salary) from employee) sum,
            sum(salary) over() "전체사원급여합계",
            sum(salary) over(partition by dept_code) "부서별 급여합계",
            sum(salary) over(partition by dept_code order by salary) "부서별 급여누계"
from employee;

--avg() over()
select emp_name,
            dept_code,
            salary,
            trunc(avg(salary) over (partition by dept_code order by salary)) "사원급여평균"
from employee;

--count() over()
select emp_name,
            
from employee;

--===================================================
-- DML
--===================================================
-- Data  Manipulation  Language 데이터 조작어
-- CRUD Create Retrieve Update Delete 테이블 행에 대한 명령어
-- insert  행추가
-- update 행수정
-- delete 행삭제
-- select (DQL)


-----------------------------------------------------
-- INSERT
-----------------------------------------------------
--1. insert into 테이블 values(컬럼1값, 컬럼2값, ...) 
--    모든 컬럼을 빠짐없이 순서대로 작성해야 함.
--2. insert into 테이블 (컬럼1, 컬럼2, ...) values(컬럼1값, 컬럼2값, ...)
--    컬럼을 생략가능, 컬럼순서도 자유롭다.
--    not null컬럼이면서, 기본값이 없다면 생략이 불가하다.

create table dml_sample(
    id number,
    nick_name varchar2(100) default '홍길동',
    name varchar2(100) not null,
    enroll_date date default sysdate not null
);

select * from dml_sample;

--타입1
insert into dml_sample 
values (100, default, '신사임당', default);

insert into dml_sample 
values (100, default, '신사임당'); -- SQL 오류: ORA-00947: not enough values

insert into dml_sample 
values (100, default, '신사임당', default, 'ㅋㅋ');-- SQL 오류: ORA-00913: too many values

--타입2
insert into dml_sample (id, nick_name, name, enroll_date)
values(200, '제임스', '이황', sysdate);

insert into dml_sample (name, enroll_date)
values('세종', sysdate);--nullable한 컬럼은 생략가능하다. 기본값이 있다면, 기본값이 적용된다.

--not null이면서 기본값이 지정안된 경우 생략할 수 없다.
insert into dml_sample (id, enroll_date)
values(300, sysdate);--ORA-01400: cannot insert NULL into ("KH"."DML_SAMPLE"."NAME")

insert into dml_sample (name)
values('윤봉길');

--서브쿼리를 이용한 insert
create table emp_copy 
as
select * 
from employee
where 1 = 2; -- 테이블 구조만 복사해서 테이블을 생성

select * from emp_copy;

insert into emp_copy (
    select *
    from employee
);
rollback;

insert into emp_copy(emp_id, emp_name, emp_no, job_code, sal_level)(
    select emp_id, emp_name, emp_no, job_code, sal_level
    from employee
);

--emp_copy데이터 추가
select * from emp_copy;

--기본값 확인 data_default
select *
from user_tab_cols
where table_name = 'EMP_COPY';

--기본값 추가
alter table emp_copy
modify quit_yn default 'N'
modify hire_date default sysdate;

insert into emp_copy (emp_id,emp_name,emp_no,email,phone,dept_code,job_code,sal_level,salary,bonus,manager_id)
values (100,'홍길동','123456-7890000','naver.com','01000000000','D5','J3','S4',2520000,0.25,204);


--insert all을 이용한 여러테이블에 동시에 데이터 추가
--서브쿼리를 이용해서 2개이상테이블에 데이터를 추가. 조건부 추가도 가능
--입사일 관리 테이블
create table emp_hire_date
as
select emp_id, emp_name, hire_date
from employee
where 1 = 2;

--매니져 관리 테이블
create table emp_manager
as
select emp_id, 
            emp_name, 
            manager_id, 
            emp_name manager_name
from employee
where 1 = 2;

select * from emp_hire_date;
select * from emp_manager;

--manager_name을 null로 변경
alter table emp_manager
modify manager_name null;

-- from테이블과 to테이블의 컬럼명이 같아야한다.
insert all
into emp_hire_date values(emp_id, emp_name, hire_date)
into emp_manager values(emp_id, emp_name, manager_id, manager_name)
select E.*, 
            (select emp_name from employee where emp_id = E.manager_id) manager_name
from employee E;


--insert all을 이용한 여러행 한번에 추가하기
--오라클 다음 문법은 지원하지 않는다.
--insert into dml_sample 
--values(1, '치킨', '홍길동'),(2, '고구마', '장발장'),(3, '베베', '유관순');

insert all 
into dml_sample values(1, '치킨', '홍길동', default)
into dml_sample values(2, '고구마', '장발장', default)
into dml_sample values(3, '베베', '유관순', default)
select * from dual; --더미 쿼리



--------------------------------------------
-- UPDATE
--------------------------------------------
--update실행후에 행의 수에는 변화가 없다.
--0행, 1행이상을 동시에 수정한다.
--dml 처리된 행의 수를 반환.
drop table emp_copy;

create table emp_copy 
as
select * 
from employee;

select * from emp_copy;

update emp_copy
set dept_code = 'D7', job_code = 'J3'
where emp_id = '202';

commit; -- 메모리상 변경내역을 실제파일에 저장
rollback; -- 마지막커밋시점으로 돌리기

update emp_copy
set salary = salary + 500000 -- += 복합대입연산자 사용불가
where dept_code = 'D5';


--서브쿼리를 이용한 update
--방명수사원의 급여를 유재식사원과 동일하게 수정하라
update emp_copy
set salary = (유재식급여)
where emp_name = '방명수';

update emp_copy
set salary = (select salary from emp_copy where emp_name = '유재식')
where emp_name = '방명수';

commit;

--임시환 사원의 직급을 과장, 부서를 해외영업3부로 수정하세요.
--emp_copy
update emp_copy
set job_code = (select job_code
                        from job
                        where job_name = '과장'),
    dept_code = (select dept_id
                        from department
                        where dept_title = '해외영업3부'
                        )
where emp_name = '임시환';   

commit;
rollback;

------------------------------------------------------------
-- DELETE
------------------------------------------------------------
select * from emp_copy;

--delete from emp_copy
--where emp_id = '211';
--
delete from emp_copy

------------------------------------------------------------
-- TRUNCATE
------------------------------------------------------------
--테이블의 행을 자르는 명령.
--DDL명령어(create, alter,drop, truncate) 자동커밋을 지원.
--단점 : before image생성 작업이 없다.
--장점 : 실행속도가 빠름.

truncate table emp_copy;

select * from emp_copy;

insert into emp_copy
(select*from employee);


--=========================================
--DDL
--=========================================
-- Data Definition Language 데이터 정의어
-- 데이터베이스 객체를 생성/수정/삭제할 수 있는 명령어
-- create생성
-- alter 수정
-- drop 삭제
-- truncate 테이블관련 설정

--객체종류
-- table, view,sequence, index, package, procedure, function, trigger, synonym, scheduler, user....

--주석 cmooment
--테이블,컬럼에 대한 주석을 달 수 있다. (필수)
select *
from user_tab_comments;

select *
from user_col_comments
where table_name = 'TBL_FILES';

-- 테이블 주석
comment on table tbl_files is '파일경로테이블';

--컬럼 주석
comment on column tbl_files.fileno is '파일 고유번호';
comment on column tbl_files.filepath is '파일 경로';

--수정/삭제 명령은 없다.
--.... is ''; -- 삭제
comment on column tbl_files.filepath is ''; --null 과 동일

--============================================================
--제약조건 CONSTRAINT
--============================================================
-- 테이블 생성 수정시 컬럼값에 대한 제약조건을 설정할 수 있다.
-- 데이터에 대한 무결성(integrity)을 보장하기 위한 것.
-- 무결성은 데이터를 정확하고, 일관되게 유지하는 것

/*
1. not null : null을 허용하지 않음. 필수값 (컬럼을 지정)
2. unique : 중복값을 허용하지 않음.
3. primary key : not null + unique 레코드식별자로써, 테이블당 1개 허용
4. foreign key : 데이터 참조무결성 보장. 부모테이블의 데이터만 허용.
5. check : 저장가능한 값의 범위/조건을 제한

일절 허용하지 않음.
*/

-- 제약 조건 확인
-- user_constraints(컬럼명이 없음)
--user)cons_columns

select *
from user_constraints
where table_name = 'EMPLOYEE';
-- C = check | not null
-- U = unique
-- P = primary key
-- R = forign key

select *
from user_cons_columns
where table_name = 'EMPLOYEE';


select*
from user_constraints uc
    join user_cons_columns ucc
        using( constraint_name)
where uc.table_name = 'EMPLOYEE';

--제약조건 검색
select constraint_name,
            uc.table_name,
            ucc.column_name,
            uc.constraint_type,
            uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using( constraint_name)
where uc.table_name = 'EMPLOYEE';

------------------------------------------------------------
--NOT NULL
------------------------------------------------------------
-- 필수입력 컬럼에 not null 제약조건을 지정한다.
--default값 다음에 컬럼레벨에 작성한다.
--보통 제약조건명을 지정하지 않는다.

create table tb_cons_nn (
        id varchar2(20) not null, -- not null = 컬럼레벨
        name varchar2(100)
        -- 테이블레벨
);

insert into tb_cons_nn values(null,'홍길동'); --ORA-01400: cannot insert NULL into ("KH"."TB_CONS_NN"."ID")
insert into tb_cons_nn values('honggd','홍길동'); 

select * from tb_cons_nn;
update tb_cons_nn
set id = ''
where id = 'honggd'; --ORA-01407: cannot update ("KH"."TB_CONS_NN"."ID") to NULL

------------------------------------------------------------
--UNIQUE
------------------------------------------------------------
-- 이메일, 주민번호, 닉네임
-- 전화번호는 UQ사용하지말것.
--중복 허용하지 않음
create table tb_cons_uq (
    no number not null,
    email varchar2(50) ,
    --테이블 레벨
    constraint uq_email unique(email)
);

insert into tb_cons_uq values(1,'abc@naver.com');
insert into tb_cons_uq values(2,'가나다@naver.com');
insert into tb_cons_uq values(3,'abc@naver.com'); --ORA-00001: unique constraint (KH.UQ_EMAIL) violated (중복이 되서 에러가남)
insert into tb_cons_uq values(4,null); -- null 허용
insert into tb_cons_uq values(3,'wsc03002@naver.com');

select * from tb_cons_uq;

------------------------------------------------------------
-- PRIMARY KEY
------------------------------------------------------------
-- 레코드(행) 식별자
-- NOT NULL + UNIQUE기능을 자기고 있으며, 테이블당 한개만 설정 가능

create table tb_cons_pk(
    id varchar2(50),
    name varchar2(100) not null,
    email varchar2(200),
    constraint pk_conid primary key(id),
    constraint uq_email2 unique(email)
);

insert into tb_cons_pk
values('honggd', '홍길동','hgd@google.com'); --ORA-00001: unique constraint (KH.PK_CONID) violated

insert into tb_cons_pk
values('honggd', '홍길동','hgd@google.com');

select * from tb_cons_pk;

select constraint_name,
            uc.table_name,
            ucc.column_name,
            uc.constraint_type,
            uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using( constraint_name)
where uc.table_name = 'TB_CONS_PK';

-- 복합 기본키(주키 = primary key = pk)
-- 여러컬럼을 조합해서 하나의 PK로 사용.
-- 사용된 컬럼 하나라도 null이서는 안된다.
create table tb_order_pk (
    user_id varchar2(50),
    order_date date,
    amount number default 1 not null,
    constraint pk_user_id_order_date primary key(user_id, order_date)
);
insert into tb_order_pk
values('honggd', sysdate, 3);

insert into tb_order_pk
values(null, sysdate, 3);--ORA-01400: cannot insert NULL into ("KH"."TB_ORDER_PK"."USER_ID")

select user_id,
            to_char(order_date, 'yyyy/mm/dd hh24:mi:ss') order_date,
            amount
from tb_order_pk;

--------------------------------------------------------------------
-- FOREIGN KEY
--------------------------------------------------------------------
--참조 무결성을 유지하기 위한 조건
-- 참조하고 있는 부모테이블의 지정 컬럼값 중에서만 값을 취할 수 있게 하는 것.
-- 참조하고 있는 부모테이블의 지정 컬럼은 PK, UQ제약조건이 걸려있어야 한다.
--department.dept_id(부모테일블) <-------- employee.dept_code (자식테이블) //부모테이블 자식테이블이라하지만 부모테이블을 자식테이블에 가져다 쓰기위한것이다.
-- 자식테이블의 컬럼에 외래키(foreign key) 제약조건을 지정

create table shop_member(
    member_id varchar2(20),
    member_name varchar2(30) not null,
    constraint pk_shop_memer_id primary key(member_id)
);

insert into shop_member values('honggd', '홍길동');
insert into shop_member values('sinsa', '신사임당');
insert into shop_member values('sejong', '세종대왕');

select * from shop_member;

--drop table shop_buy
create table shop_buy (
    buy_no number,
    member_id varchar2(20),
    product_id varchar2(50),
    buy_date date default sysdate,
    constraints pk_shop_buy_no primary key(buy_no),
    constraints fk_shop_buy_member_id foreign key(member_id)
                                                                 references shop_member(member_id)
);

insert into shop_buy
values(1, 'honggd', 'soccer_shoes', default);

insert into shop_buy
values(2, 'sinsa', 'basketball_shoes', default);

insert into shop_buy
values(3, 'k12345', 'football_shoes', default); 
--ORA-02291: integrity constraint (KH.FK_SHOP_BUY_MEMBER_ID) violated - parent key not found

select * from shop_buy;

-- fk기준으로 join -> relation
-- 구매번호 회원아이디 회원이름 구매물품아이디 구매시각
select B.buy_no,
            member_id,
            M.member_name,
            B.product_id,
            B.buy_date
from shop_member M
    join shop_buy B
        using(member_id);

            
--정규화 Normalization
--이상현상 방지(anormaly)
select *
from employee;

select *
from department;

-- 삭제 옵션
-- on delete restricted : 기본값. 참조하는 자식행이 있는경우, 부모행 삭제불가
--                                                자식행을 먼저 삭제후, 부모행을 삭제
-- on delete set null : 부모행 삭제시 자식컬럼은 null로 변경
-- on delete cascade : 부모행 삭제시 자식행 삭제
delete from shop_buy
where member_id = 'honggd'; 

delete from shop_member
where member_id = 'honggd'; --ORA-02292: integrity constraint (KH.FK_SHOP_BUY_MEMBER_ID) violated - child record found

select * from shop_member;
select * from shop_buy;

-- 식별관계 | 비식별관계
-- 비식별관계 : 참조하고 있는 부모테이블 값을 PK로 사용하지 않는 경우, 여러행에서 참조가 가능(중복)
-- 식별관계 : 참조하고 있는 부모컬럼을 PK로 사용하는 경우.

create table shop_nickname(
    member_id varchar2(20),
    nickname varchar2(100),
    constraints fk_member_id foreign key(member_id) references shop_member(member_id),
    constraints pk_member_id primary key(member_id)
);


insert into shop_nickname
values('sinsa','신사112');

select *
from shop_nickname;

create table shop_buy (
    buy_no number,
    member_id varchar2(20),
    product_id varchar2(50),
    buy_date date default sysdate,
    constraints pk_shop_buy_no primary key(buy_no),
    constraints fk_shop_buy_member_id foreign key(member_id)
                                                                 references shop_member(member_id)
                                                                 on delete set null
);

-------------------------------------------------------------------------
-- CHECK
-------------------------------------------------------------------------
-- 해당 컬럼의 값의 범위 지정.
-- null 입력 가능

--drop table tb_cons_ck
create table tb_cons_ck (
        gender char(1),
        num number,
        constraints ck_gender check(gender in ('M','F')),
        constraints ck_num check(num between 0 and 100)
);

insert into tb_cons_ck
values('M',50);

insert into tb_cons_ck
values('F',100);

insert into tb_cons_ck
values('m',100); --ORA-02290: check constraint (KH.CK_GENDER) violated

insert into tb_cons_ck
values('M',1000); --ORA-02290: check constraint (KH.CK_NUM) violated

-----------------------------------------------------------------
-- CREATE
-----------------------------------------------------------------
--SUBQUERY를 이용한 CREATE는 NOT NULL제약조건을 제외한 모든 ㅔ약조건, 기본값등을 제거한다.

create table emp_bck
as
select * from employee;

select * from emp_bck;

--제약조건 검색
select constraint_name,
            uc.table_name,
            ucc.column_name,
            uc.constraint_type,
            uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'EMP_BCK';

-- 기본값확인
select *
from user_tab_cols
where table_name = 'EMP_BCK';

-----------------------------------------------------------------
-- ALTER
-----------------------------------------------------------------
-- TABLE관련 ALTER문은 컬럼,제약조건에 대해 수정이 가능하다.
/*
서브명령어
-- add 컬럼, 제약조건 추가
-- modify 컬럼(자료형, 기본값) 변경가능 (제약조건은 변경불가)
-- rename 컬럼명, 제약조건명 변경
-- drop 컬럼, 제약조건 삭제가능
*/

create table tb_alter (
    no number
);

--add 컬럼
--맨 마지막 컬럼으로 추가
alter table tb_alter 
add name varchar2(100) not null;

desc tb_alter; --desc=describe의 약자 - 명세를 보여주는것
--테이블 명세 (describe)
--컬럼명       널여부     자료형+(해당크기)

-- add 제약조건
-- not null제약조건은 추가가 아닌 수정(modify)으로 처리된다.
alter table tb_alter
add constraint pk_tb_alter_no primary key(no);

-- 제약조건 검색
select constraint_name,
            uc.table_name,
            ucc.column_name,
            uc.constraint_type,
            uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'TB_ALTER';

-- modify 컬럼
-- 자료형, 기본값, null여부 변경가능
-- 문자열에서 호환가능타입으로 변경가능(char --- varchar2)
alter table tb_alter
modify name varchar2(500) default '홍길동' null;

desc tb_alter;

-- modify
-- 행이 있다면 ,변경하는데 제한이 있다.
-- 존재하는 값보다는 작은 크기로 변경불가하다.
-- null값이 있는 컬럼을 not null로 변경불가.

-- modify 제약조건은 불가능.
-- 제약조건은 이름 변경외에 변경불가.
-- 변경하려면 해당 제약조건 삭제(테이블 삭제X,)후 재생성할 것.

-- rename 컬럼
alter table tb_alter
rename column no to num;

desc tb_alter;

-- rename 제약조건
select constraint_name,
            uc.table_name,
            ucc.column_name,
            uc.constraint_type,
            uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'TB_ALTER';

alter table tb_alter
rename CONSTRAINT PK_TB_ALTER_NO to pk_tb_alter_num;

--drop 컬럼
desc tb_alter;

alter table tb_alter
drop column name;

--drop 제약조건
alter table tb_alter
drop CONSTRAINT pk_tb_alter_num;

-- 테이블 이름 변경
alter table tb_alter_all_new
rename to miiin_sseong;

rename miiin_sseong to tb_alter_all_new;

select * from tb_alter_all_new;

-------------------------------------------------------------------------------
-- DROP
-------------------------------------------------------------------------------
-- 데이터베이스 객체(table, user, view등)삭제
drop table tb_alter_all_new;

--===================================================
-- DCL
--===================================================
-- Data Control Language
-- 권한 부여/회수 관련 명령어 : grant /revoke
-- TCL Transaction Control Language를 포함한다. - commit / rollback / savepoint

--system 관리자계정으로 시작!

--qwerty계정 생성 :
create user qwerty
identified by qwerty
default tablespace users;

--접속 권한 부여
--create session권한 또는  connect롤을 부여
grant connect to qwerty;
GRANT create session to qwerty;

-- 객체 생성권한 부여
-- create table, create index..... 권한을 일일이 부여.
-- resource롤 
grant resource to qwerty;

--system 관리자계정 끝!

--권한, 롤을 조회
select *
from user_sys_privs; --권한

select *
from user_role_privs; --롤

select *
from role_sys_privs; --부여받은 롤에 포함된 권한조회