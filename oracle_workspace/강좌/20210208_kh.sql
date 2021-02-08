--==============================================
--PL/SQL
--==============================================
--procedural Language/SQL
--SQL한계를 보완해서 SQL문안에서 변수정의/조건처리/반복처리등의 문법을 지원

--유형
--1. 익명블럭(Anonymous Block) : PL/SQL 실행가능한 1회용블럭
--2. Procedure : 특정구문을 모아둔 서브프로그램. DB서버에 저장하고, 클라이언트에 의해 실행
--3. 함수(Function) : 반드시 하나의 값을 리턴하는 서브프로그램. DB서버에 저장하고, 클라이언트에 의해 실행

--4.Trigger
--5. Scheduler

/* 블럭 사용법.
declare           -- 1. 변수선언부(선택)

begin               -- 2. 실행부 (필수)
                            --조건문, 반복문, 출력문

exception      -- 3.예외처리부(선택)

end;                -- 4. 블럭종료선언(필수)
/                       **종료슬레시에 라인주석달지말것.(컴파일오류)
*/

-- 세션별로 설정
-- 서버콘솔 출력모드 지정 ON
set serveroutput on;

begin 
        --dbms_output패키지의 put_line프로시져 :출력구문
    dbms_output.put_line('Hello PL/SQL'); -- (출력구문)
end;
/


-- 사원 조회
declare
    v_id number;
begin
    select emp_id
    into v_id
    from employee
    where emp_name = '&사원명';
    
    dbms_output.put_line('사번 = ' ||v_id);
exception
    when no_data_found then dbms_output.put_line('해당 이름을 가진사원이 없습니다.');
    
end;
/

--------------------------------------------------------------------------------------------------
-- 변수선언 / 대입
--------------------------------------------------------------------------------------------------
-- 변수명  [constant 상수] 자료형 [not null] [:= 초기값];

declare
    num number := 100;
    name varchar2(100) not null := '홍길동'; --nout null은 초기값 지정 필수
    result number;
begin
    dbms_output.put_line('num = ' || num);
--    num := 200; -- 상수기때문에 값 변경 불가
    dbms_output.put_line('num = ' || num);
    name := '&이름';
    dbms_output.put_line('이름 : ' || name);
end;
/


-- PL/SQL 자료형
-- 1. 기본자료형
--      문자형 : varchar2, char, clob
--      숫자형 : number
--      날짜형 : date
--      논리형 : boolean(true/false)
-- 2. 복합자료형
--      레코드
--      커서
--      컬렉션

-- 참조형은 다른 테이블의 자료형을 차용해서 쓸 수 있다.
-- 1. %type
-- 2. %rowtype
-- 3. record

declare
--    v_emp_name  varchar2(32767);
--    v_emp_no  varchar2(32767);

    --테이블해당컬럼 타입 지정
    v_emp_name employee.emp_name%type;
    v_emp_no employee.emp_no%type;
    
begin
    select emp_name, emp_no
    into v_emp_name, v_emp_no
    from employee
    where emp_id = '&사번';
    
    dbms_output.put_line('이름 : ' || v_emp_name);
    dbms_output.put_line('주민번호 : ' || v_emp_no);
end;
/

--%rowtype : 테이블 한행을 타입으로 지정

declare
    v_emp employee%rowtype;
begin
    select *
    into v_emp
    from employee
    where emp_id = '&사번';
    dbms_output.put_line('사원명 : ' || v_emp.emp_name);
    dbms_output.put_line('부서코드 : ' || v_emp.dept_code);
end;
/



-- record
-- 사번,사원명, 부서명등 존재하지 않는 컬럼조합을 타입으로 선언

declare
    type my_emp_rec is record(
        emp_id employee.emp_id%type, 
        emp_name employee.emp_name%type,
        dept_title department.dept_title%type
    );
    
    my_row my_emp_rec;
begin
    select E.emp_id,
                E.emp_name,
                D.dept_title
    into my_row
    from employee E
        left join department D
            on E.dept_code = D.dept_id
    where emp_id = '&사번';
    --출력
    dbms_output.put_line('사번 : ' || + my_row.emp_id);
    dbms_output.put_line('사원명 : ' || + my_row.emp_name);
    dbms_output.put_line('부서명 : ' || + my_row.dept_title);
end;
/


--사원명을 입력받고, 사번, 사원명, 직급명, 부서명을 참조형 변수를 통해 출력하세요
declare
    type my_emp_rec is record (
        emp_id employee.emp_id%type, 
        emp_name employee.emp_name%type,
        job_name job.job_name%type,
        dept_title department.dept_title%type
    );    --무엇으로 구성된
    my_row my_emp_rec;
begin
    select E.emp_id,
                E.emp_name,
                J.job_name,
                D.dept_title
    into my_row
    from employee E
        left join department D
            on E.dept_code = D.dept_id
        left join job J
            on E.job_code = J.job_code
    where emp_name = '&사원명';
    --출력
    dbms_output.put_line('사번 : ' || my_row.emp_id);
    dbms_output.put_line('사원명 : ' || my_row.emp_name);
    dbms_output.put_line('직급명 : ' || my_row.job_name);    
    dbms_output.put_line('부서명 : ' || my_row.dept_title);
end;
/
-------강사코드
declare
    type my_rec_type is record(
        emp_id employee.emp_id%type,
        emp_name employee.emp_name%type,
        job_name job.job_name%type,
        dept_title department.dept_title%type
    );
    
    my_row my_rec_type;
    v_emp_name employee.emp_name%type;
begin
    v_emp_name := '&사원명';

    select E.emp_id, E.emp_name, J.job_name, D.dept_title
    into my_row
    from employee E
        left join department D
            on E.dept_code = D.dept_id
        left join job J
            using (job_code)
    where E.emp_name = v_emp_name;
    
    dbms_output.put_line('사번 : ' || my_row.emp_id);
    dbms_output.put_line('사원명 : ' || my_row.emp_name);
    dbms_output.put_line('직급명 : ' || my_row.job_name);
    dbms_output.put_line('부서명 : ' || my_row.dept_title);
end;
/

---------------------------------------------------------------------------------
-- PL/SQL 안의 DML
---------------------------------------------------------------------------------
-- 이 안에서 commit/rollback트랜잭션(=더 쪼갤수 없는 작업단위) 처리까지 해줄것.

create table member(
    id varchar2(30),
    pwd varchar2(50) not null,
    name varchar2(100) not null,
    constraint member_id_pk primary key(id)
);

desc member;

begin
--    insert into member
--    values('honggd','1234','홍길동');

    update member set pwd = 'abcd'
    where id = 'honggd';
    
    --트랜잭션 처리
    commit;
end;
/

select * from member;

-- 사용자 입력값을 받아서 id,pwd, name을 새로운 행으로 추가하는 익명블럭을 작성하세요.
begin
    insert into member
    values('&id', '&pwd', '&name');
    commit;
end;
/
select * from member;


-- emp_copy에 사번마지막번호에 +1 처리한 사번으로 
--이름, 주민번호, 전화번호, 직급코드, 급여등급을 등록하는 PL/SQL작성하기

select * from emp_copy;

declare
    last_num number;
begin
    --1. 사번 마지막 번호 구하기
    select max(emp_id)
    into last_num
    from emp_copy;
    dbms_output.put_line('last_num = ' || last_num);
    
    --2. 사용자입력값으로 insert문 실행
    insert into emp_copy (emp_id, emp_name, emp_no, phone, job_code, sal_level)
    values(last_num + 1, '&사원명', '&주민번호', '&전화번호', '&직급코드', '&급여등급');

    --3. transaction처리
    commit;
end;
/

---------------------------------------------------------------
--조건문
----------------------------------------------------------------
-- 1. if 조건식 then..... end if;
-- 2. if 조건식 then..... else .... end if;
-- 3. if 조건식1 then.... elsif 조건식2 ....then .... end if;

declare
     name varchar2(100) := '&이름';
begin
    if name = '홍길동' then 
        dbms_output.put_line('반갑습니다.홍길동님');
    else
        dbms_output.put_line('AMF');
    end if;
    dbms_output.put_line('goodbye moderfucker');
end;
/
--3의 배수
declare
    num number := &숫자;
begin
    if mod(num,3) = 0 then
        dbms_output.put_line('3의 배수를 입력하셨습니다.');
    elsif mod(num,3) = 1 then
        dbms_output.put_line('나머지가 1입니다.');
    elsif mod(num,3) = 2 then
        dbms_output.put_line('나머지가 2입니다.');
    end if;
    
end;
/

-- 사번을 입력받고, 해당사원 직급이 J1이면 '대표' 출력
-- 또, J2라면 '임원'
-- 그 외에는 '평사원'이라고 출력하세요.
declare
    v_emp_id employee.emp_id%type := '&사번';
    v_job_code employee.job_code%type;
begin
    select job_code
    into v_job_code
    from employee
    where emp_id = v_emp_id;
    
    if v_job_code = 'J1' then
        dbms_output.put_line('대표');
    elsif v_job_code = 'J2' then
        dbms_output.put_line('임원');
    else 
        dbms_output.put_line('평사원');
    end if;
end;
/

----------------------------------------------------------------
-- 반복문
----------------------------------------------------------------
-- 1. 기본 loop - 무한반복(탈출조건식)
-- 2. while loop - 조건에 따른 반복
-- 3. for loop - 지정횟수만큼 반복실행

declare
    n number := 1;
begin
    loop
        dbms_output.put_line(n);             --무한반복
        n := n+1;
        
        
        -- exit구문 필수
--        if n > 100 then 
--            exit;
--        end if;
        exit when n >50;
    end loop;
end;
/

--난수 출력
-- 1부터 10까지의 난수를 10개 출력하기
declare
    rnd number;
begin
    --start 이상, end 미만의 난수
    rnd := trunc(dbms_random.value(1, 11));
    dbms_output.put_line(rnd);
end;
/

declare
    rnd number;
    n number :=1;
begin
    loop
    --start 이상, end 미만의 난수
    rnd := trunc(dbms_random.value(1, 11));
    dbms_output.put_line(rnd);
    
    n := n+1;
    exit when n>10;
    end loop;
end;
/

declare
    rnd number;
    n number := 1;
begin 
    loop
        --start 이상, end 미만의 난수 
        rnd := trunc(dbms_random.value(1, 11));
        dbms_output.put_line(n || ' : ' || rnd);
        
        n :=  n + 1;
        exit when n > 10;
    end loop;
end;
/

--while loop
declare
    n number := 0;
begin
    while n< 10 loop
        dbms_output.put_line(n);
        n := n +1;
    end loop;
end;
/

--0~10까지 짝수
declare
    n number := 0;
begin
    while n< 10 loop
        if mod(n,2) = 0 then
            dbms_output.put_line(n);
    end if;
        n := n +1;
    end loop;
end;
/

--사용자로부터 단수(2~9단)을 입력받아 해당단수의 구구단을 출력하기
-- 2~9외의 숫자를 입력하면, 잘못입력하셨습니다. 출력 후 종료
declare
    num number :=&숫자;
--    num number :=7;
    i number :=1;
begin
    if num between 2 and 9 then
        while i<10 loop
            dbms_output.put_line(num || ' * ' || i || ' = ' || num*i);
            i := i+1;
        end loop;
    else
         dbms_output.put_line('잘못 입력하셨습니다');
    end if;
end;

--강사코드
declare 
    dan number := &단;
    n number := 1;
begin
    
    if dan between 2 and 9 then
        while n < 10 loop
            dbms_output.put_line(dan || ' * ' || n || ' = ' || (dan * n) );
            n := n +1;
        end loop;
    else 
        dbms_output.put_line('단수를 잘못 입력하셨습니다.');
    end if;

end;
/


--for in... loop
-- 증감변수를 별도로 선언하지 않아도 좋다.
-- 자동 증가처리
-- reverse 1씩 감소
-- 1~5까지
begin
    --n을 선언없이 바로 사용가능.
    --시작값..종료값 (시작값 < 종료값)
    for n in 1..5 loop
        dbms_output.put_line(n);
    end loop;
    
end;
/
--5~1까지 (reverse사용)
begin
    --n을 선언없이 바로 사용가능.
    --시작값..종료값 (시작값 < 종료값)
    for n in reverse 1..5 loop
        dbms_output.put_line(n);
    end loop;
    
end;
/

--210 ~ 220 번 사이의 사원을 조회(사번, 이름, 전화번호)
declare
    e employee%rowtype;
begin
    
    for n in 210..220 loop
        select *
        into e
        from employee
        where emp_id = n;
        
        dbms_output.put_line('사번 : '|| e.emp_id);
        dbms_output.put_line('이름 : '|| e.emp_name);
        dbms_output.put_line('전화번호 : '|| e.phone);
        dbms_output.put_line(' ');
    end loop;
end;
/

--@실습문제 : tb_number테이블에 난수 100개(0~999)를 저장하는 익명블럭을 생성하세요.
-- 실행시마다 생성된 모든 난수의 합을 콘솔에 출력할 것.
create table tb_number(
    id number, -- pk sequence객체로 부터 채번
    num number, --난수
    reg_date date default sysdate, 
    constraint pk_tb_number_id primary key(id)
);