--========================================
-- CHUN 계정
--==========================================

--학과테이블
select * 
from tb_department ;

--학생테이블
select*
from tb_student;

--과목테이블
select *
from tb_class;

--교수과목테이블
select*
from tb_class_professor;

--교수테이블
select*
from tb_professor;

--점수등급테이블
select *
from tb_grade;

--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 
--단, 출력 헤더는 "학과 명", "계열"  으로 표시하도록한다.
select department_name 학과명, category 계열
from tb_department
where category = '인문사회';

--2.	학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
-----------------------------------------------------------------------------
--국어국문학과의 정원은 20 명 입니다.  영어영문학과의 정원은 36 명 입니다.
--
--사학과의 정원은 28 명 입니다.  철학과의 정원은 28 명 입니다.
--...
--...
--
--63 rows selected
-----------------------------------------------------------------------------
--distinct 칼럼의 중복되는 값을 제거 후 보여준다.
select distinct department_name ||'의 정원은 ' ||capacity ||'명 입니다.' "학과별 정원"
from tb_department;


--3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이  들어왔다.
--누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을  조회해서  찾아 내도록 하자)?
-----------------------------------------------------------------------------
--STUDENT_NAME
----------------------
--한수현
-----------------------------------------------------------------------------
select  student_name
from tb_student
where absence_yn = 'Y' and department_no =001 and substr(student_ssn,8,1) =2;

/*
4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 그 대상자들의
학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.
A513079, A513090, A513091, A513110, A513119
STUDENT_NAME
--------------------
홍경희
최경희
정경훈
정경환
이경환
*/
select student_name
from tb_student
where student_no in('A513079','A513090', 'A513091', 'A513110', 'A513119');

/*
5. 입학정원이 20 명 이상 30 명 이하인 학과들의 학과 이름과 계열을 출력하시오.
DEPARTMENT_NAME CATEGORY
-------------------- --------------------
국어국문학과 인문사회
사학과 인문사회
철학과 인문사회
…
…
미술학과 예체능
산업디자인학과 예체능
체육학과 예체능
24 rows selected
*/

select  department_name
from tb_department
where capacity between 20 and 30;

/*
6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다. 그럼 춘
기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
PROFESSOR_NAME
--------------------
임해정
*/
select professor_name
from tb_professor
where department_no is null;

/*
7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다.
어떠한 SQL 문장을 사용하면 될 것인지 작성하시오.
*/

select *
from tb_student
where department_no is null;

/*
8. 수강신청을 하려고 핚다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는
과목들은 어떤 과목인지 과목번호를 조회해보시오.
CLASS_NO
----------
C0405500
C0409000
C3745400
C0432500
C3051900
C3221500
6 rows selected
*/

select class_no
from tb_class
where preattending_class_no is null;

/*
9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.
CATEGORY
--------------------
공학
예체능
의학
인문사회
자연과학
*/

select distinct category
from tb_department;

/*
10. 02 학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외한 재학중인
학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.
STUDENT_NO STUDENT_NAME STUDENT_SSN
---------- -------------------- --------------
A217005 고수현 821119-2122202
…
…
A211375 최허현 841102-1154425
11 rows selected
*/

select student_no, student_name, student_ssn
from tb_student
where extract(year from entrance_date) = 2002 
        and absence_yn = 'N' 
        and instr(student_address, '전주') = 1;
--        where absence_yn = 'N' and extract(year from entrance_date) = 2002 and student_address like '전주%';


--1. 학과테이블에서 계열별 정원의 평균을 조회(정원 내림차순 정렬)
select category, trunc(avg(capacity),0)capacity
from tb_department
group by category
order by capacity;

---------------------강사---------------------
select category,
            trunc(avg(capacity))
from tb_department
group by category
order by 2 desc;

--2. 휴학생을 제외하고, 학과별로 학생수를 조회(학과별 인원수 내림차순)
select department_no 학과, count(department_no) 학과별인원수
from tb_student
where absence_yn = 'Y'
group by department_no
order by count(department_no);

---------------------강사---------------------
select department_no, count(*)
from tb_student
where absence_yn = 'N'
group by department_no
order by 1 desc;

--3. 과목별 지정된 교수가 2명이상이 과목번호와 교수인원수를 조회
select class_no, count(professor_no)
from tb_class_professor
group by class_no
having count(class_no) >= 2;

---------------------강사---------------------
select class_no, count(*)
from tb_class_professor
group by class_no
having count(*) >=2
order by 2 desc;


--4. 학과별로 과목을 구분했을때, 과목구분이 "전공선택"에 한하여 과목수가 10개 이상인 행의 학과번호, 과목구분(class_type), 과목수를 조회(전공선택만 조회)


---------------------강사---------------------
select department_no ,
                class_type,
                count(*)
from tb_class
group by department_no , class_type
having class_type = '전공선택' and count(*)>= 10
order by 3 desc;




-- 학번/학생명tb_student/담당교수명 조회
-- 1. 두테이블의 기준컬럼 파악.
-- 2. on조건절에 해당되지 않는 데이터파악.

select *
from tb_student; --교수이름이 X = coach_professor_no
select *
from tb_professor; -- 학생이름이 X = professor_no

--담당교수 담당학생이 배정되지 않은 학생이나 교수 제외 inner 579
--담당교수가 배정되지 않은 학생 포함 left 588 = 579+9
-- 담당학생이 없는 교수 포함 right 580 = 579+1

select *
from tb_student S  join tb_professor P
        on S.coach_professor_no = P.professor_no;

--1. 교수 배정받지 않은 학생 조회 -- 9
select count(*)
from tb_student
where coach_professor_no is null;

-- 2. 담당학생이 한명도 없는 교수
-- 전체 교수 수

select count(*) -- 114
from tb_professor;

-- 중복 없는 담당교수 수 --113
SELECT count(distinct coach_professor_no)
from tb_student;
