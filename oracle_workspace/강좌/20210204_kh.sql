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