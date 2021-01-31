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

/*
2021-01-27
*/
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
select dept_code,
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