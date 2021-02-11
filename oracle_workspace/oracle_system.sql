--================================
-- system 관리자 계정
--================================
--한줄 주석
/*
여러줄 주석
*/
show user;

--현재 등록된 사용자목록 조회
--sys 슈퍼관리자 db생성/삭제 권한 있음
--system 일반관리자 db생성/삭제 권한 없음.
select *
from dba_users;

--SQL문은 대소문자를 구분하지 않는다.
--사용자계정의 비밀번호, 테이블 내의 데이터는 대소문자로 구분한다.
select *
from DBA_USERS;



--관리자는 일반사용자를 생성할 수 있다.
create user kh
identified by kh --비밀번호(대소문자구분)
default tablespace users; --데이터가 저장될 영역 system | users

--사용자 삭제
--drop user kh; 
--접속권한 create session 이 포함된 role(권한묶음) connect 부여
--grant connect to kh;
--oracle_kh에서 에러(ORA-01031: insufficient privileges :
-- 생성테이블등 객체 생성권한이 포함된 role resource 부여(
--grant RESOURCE to kh;

--테이블 생성권한만 부여
grant create table to kh;
--한번에 부여하기
grant CONNECT,resource to kh;
--테이블 생성 권한만 주고 싶다면 (권한 줄 대상만 작성해주면 됨)
--grant create table to kh;

--grant connect resource to kh;
grant connect,resource to kh;


--chun계정 생성
create user chun
identified by chun
default tablespace users;

--connect,resource를 부여
grant connect, resource to chun;


--role(권한묶음)에 포함된 권한 확인
--DataDictionary db의 각 객체에 대한 메타정보를 확인할 수 있는 road-only 테이블
select *
from dba_sys_privs
where grantee in('CONNECT',RESOURCE) ;


-- create view 권한을 부여 받아야한다.
--resource 롤에 포함되지 않는다
grant create view to kh;