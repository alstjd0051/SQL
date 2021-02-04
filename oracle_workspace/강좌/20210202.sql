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
                                                                select nvl(dept_code, 'D0'),job_code
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



--exists 연산자
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
order by salary desc; -- desc 내림차순

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
            dept_code,
            count(*) over(partition by dept_code) cnt_by_dept
from employee;