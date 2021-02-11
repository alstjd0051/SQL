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

select * from miiin_sseong;

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

-- 커피테이블 생성
create table tb_coffee (
    cname varchar2(100),
    rice number,
    brand varchar2(100),
    CONSTRAINT pk_tb_coffee_cname primary key(cname)
);

insert into tb_coffee
values('maxim',2000,'동서식품');
insert into tb_coffee
values('kanu',3000,'동서식품');
insert into tb_coffee
values('nescafe',2000,'네슬레');

select * from tb_coffee;
commit;

--qwerty 계정에게 열람 권한 부여
grant select on tb_coffee to qwerty;

--수정권한 부여
grant insert, update, delete on tb_coffee to qwerty;

-- 수정권한 회수
revoke insert, update, delete on tb_coffee from qwerty;
revoke select on tb_coffee from qwerty;


--=================================================
--DATA BASE OBJECT 1
--=================================================
--DB의 효율적으로 관리하고, 작동하게 하는 단위.

select distinct object_type
from all_objects;

------------------------------------------------------------------------------
-- DATA DICTIONARY
------------------------------------------------------------------------------
-- 일반사용자 관리자로부터 열람권한을 얻어 사용하는 정보조회테이블
-- 읽기전용.
-- 객체 관련 작업을 하면 자동으로 그 내용이 반영.


--1. user_xxx : 사용자가 소유한 객체에 대한 정보
--2. all_xxx : user_xxx를 포함. 다른사용자로부터 사용권한을 부여받은 객체에 대한 정보
--3. dba_xxx : 관리자전용. 모든사용자의 모든 객체에 대한 정보

-- 이용가능한 모든 dd조회
select * 
from dict; --(dict = dictionary)

--*********************************************************************************
-- user_xxx
--*********************************************************************************
--xxx는 객체이름 보숙형을 사용한다.

--user_tables

select * from user_tables;
select * from tabs; --동의어(synonym)

--user_sys_privs : 권한
--user_role_privs : 롤(권한묶음)
--role_sys_privs : 사용자가 가진 롤에 포함된 모든 권한
select * from user_sys_privs; -- admin_option 권한을 다른 사용자에게 부여할수있는지 물어보는
select * from user_role_privs;
select * from role_sys_privs;

--user_sequences
select * from user_sequences;
--user_views
select * from user_views;
--user_indexes
select * from user_indexes;
--user_constraints
select* from user_constraints;

--*********************************************************************************
-- all_xxx
--*********************************************************************************
--현재 계정이 소유하거나 사용권한을 부여받은 객체조회
--all_tables
select * from all_tables;

--all_indexes
select * from all_indexes;

--*********************************************************************************
-- dba_xxx
--*********************************************************************************

select * from dba_tables; -- ORA-00942: table or view does not exist 일반사용자 접근 금지

--특정사용자의 테이블 조회
select * 
from dba_tables
where owner in ('KH', 'QWERTY');

-- 특정사용자의 권한 조회
select *
from dba_sys_privs
where grantee = 'KH';

select *
from dba_role_privs
where grantee = 'KH';

--테이블 관련 권한 확인
select *
from dba_tab_privs
where owner = 'KH';

--관리자가 kh.tb_coffee 읽기 권한을 qwerty에게 부여
grant select, insert, update, delete on kh.tb_coffee to qwerty;


------------------------------------------------------------------------------
-- STORED VIEW
------------------------------------------------------------------------------
--저장뷰.
-- INLINEVIEW는 일회성이었지만, 이를 객체로 저장해서재사용이 가능하다.
-- 가상테이블처럼 사용하지만, 실제로 데이터를 가지고 있는것은 아니다.
-- 실제테이블과 링크개념.

-- 뷰객체를 이용해서 제한적인 데이터만 다른 사용자에게 제공하는 것이 가능하다.
create view view_emp
as
select  emp_id,
                emp_name,
                substr(emp_no,1,8) || '******' emp_no,
                email,
                phone
from employee;

--테이블처럼 사용
select * from view_emp;

select *
from (
     select emp_id,
                emp_name,
                substr(emp_no,1,8) || '******' emp_no,
                email,
                phone
from employee
);

-- db에서 조회
select * from user_views;

--타 사용자에게 선별적인 데이터를 제공
grant select on kh.view_emp to qwerty;

--view특징
-- 1.실제 컬럼뿐 아니라 가공된 컬럼 사용가능
-- 2. join을 사용하는 view 가능
-- 3. or replace 옵션 사용가능
-- 4. with read only 옵션

create or replace view view_emp -- replace 없으면 생성해라
as
select emp_id,
                emp_name,
                substr(emp_no,1,8) || '******' emp_no,
                email,
                phone,
                nvl(dept_title, '인턴') dept_title
from employee E
        left join department D
            on E.dept_code = D.dept_id
with read only;

--성별, 나이등 복잡한 연산이 필요한 컬럼을 미리 view지정해두면 편리하다.
create or replace view view_employee_all
as
select E.*,
            decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
from employee E;

select *
from view_employee_all
where gender = '여';

------------------------------------------------------------------------------
-- SEQUENCE
------------------------------------------------------------------------------
-- 정수값을 순차적으로 자동생성하는 객체. 채번기
/*
create sequence 시퀀스명

start with 시작값 ----------------- 기본값 1
increment by 증가값 -------------- 기본값 1
maxvalue 최대값 | nomaxvalue ---- 기본값은 nomaxvalue.
                                                                    최대값에 도달하면,최대값에 도달하면, 다시 시작값(cycle)혹은 에러유발(nocycle)
minvalue 최소값  | nominvalue ------기본값은 nominvalue
                                                                      최소값에 도달하면,최대값에 도달하면, 다시 시작값(cycle)혹은 에러유발(nocycle)
cycle  | nocycle ------------------------순환여부, 기본값 nocycle
chche 캐싱개수 | nocache -------------- 기본값 cache 20. 시퀀스객체로부터 20개씩 가져와서 메모리에서 채번
                                                                            오류가 발생하여, 숫자를 건너뛸수도 있다
*/

create table tb_names(
    no number,
    name varchar2(100) not null,
    constraints pk_tb_names_no primary key(no)
);

create sequence seq_tb_names_no
start with 1000
increment by 1
nomaxvalue
nominvalue
nocycle
cache 20;

insert into tb_names
values(seq_tb_names_no.nextval,'홍길동');

select * from tb_names;

select seq_tb_names_no.nextval,
            seq_tb_names_no.currval
from dual;

-- DD에서 조회
select *
from user_sequences;

-- 복합문자열에 시퀀스 사용하기
-- 주문번호 kh-20210205-1001
create table tb_order(
    order_id varchar2(50),
    cnt number,
    constraints pk_tb_order_id primary key(order_id)
);
create sequence  seq_order_id;


insert into tb_order
values('kh-' || to_char(sysdate, 'yyyymmdd') || '-' || to_char(seq_order_id.nextval, 'FM0000'), 100);

select * from tb_order;

-- alter문을 통해 시작값 start with값은 절대 변경할 수 없다. 
--그때 시퀀스객체 삭재후 재생할것.

alter sequence seq_order_id increment by 10;

--------------------------------------------------------------------------------------------
-- INDEX
--------------------------------------------------------------------------------------------
-- 색인.
-- sql문 처리속도 향상을 위해 컬럼에 대해 생성하는 객체
-- key : 컬럼값, value : 레코드논리적주소값 rowid
-- 저장하는 데이터에 대한 별도의 공간이 필요함.

--장점 :
-- 검색속도가 빨라지고, 시스템 부하를 줄여서 성능향상

-- 단점 : 
-- 인덱스를 위한 추가저장공간이 필요.
-- 인덱스를 생성/수정하는데 별도의 시간이 소요됨.

--단순조회 업무보다 변경작업(insert/update/delete)가 많다면 index생성을 주의해야한다.

--인덱스로 사용하면 좋은 컬럼
--1. 선택도(selectivity)가 좋은 컬럼. 중복데이터가 적은 컬럼.
-- id | 주민번호 | email | 전화번호 > 이름 > 부서코드 >>>> 성별
-- pk | uq제약조건이 사용된 컬럼은 자동으로 인덱스를 생성함. -- 삭제하려면 제약조건을 삭제해야함.

-- 2. where절에 자주 사용되어지는 경우, 조인기준컬럼인 경우
-- 3.입력된 데이터의 변경이 적은 컬럼.

select *
from user_indexes;

-- job_code 인덱스가 없는 컬럼
select *
from employee
where job_code = 'J1'; -- table full scan

--emp_id 인덱스가 있는 컬럼
select *
from employee
where emp_id = '201'; --unique scan -> byindex rowid

--emp_name 조회
select *
from employee
where emp_name = '송종기';

--emp_name 컬럼으로 인덱스 생성
create index idx_employee_emp_name
on employee(emp_name);
