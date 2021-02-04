--1select emp_name, job_code,count(bonus) as 보너스를받는사원
from employee
--where nonus != '0'
group by job_code,emp_name
order by job_code asc;
. 직원테이블(EMP)이 존재한다.
--직원 테이블에서 사원명,직급코드, 보너스를 받는 사원 수를 조회하여 직급코드 순으로 오름차순 정렬하는 구문을 작성하였다.
--이 때 발생하는 문제점을 [원인](10점)에 기술하고, 이를 해결하기 위한 모든 방법과 구문을 [조치내용](30점)에 기술하시오.
SELECT EMPNAME, JOBCODE, COUNT(*) AS 사원수
FROM EMP
WHERE BONUS != 'NULL'
GROUP BY JOBCODE
ORDER BY JOBCODE;

SELECT EMP_NAME 사원명, JOB_CODE 직급코드, 
COUNT(BONUS) AS 사원수
FROM EMP
WHERE BONUS != '0'
GROUP BY EMP_NAME, JOB_CODE
ORDER BY JOBCODE ASC;


select emp_name 직원명, job_code 직급코드,count(bonus) as 사원수
from employee
where bonus != '0'
group by job_code,emp_name
order by job_code asc;


--직원 테이블(EMP)에서 부서 코드별 그룹을 지정하여 부서코드, 그룹별 급여의 합계, 그룹별 급여의 평균(정수처리), 
--인원수를 조회하고 부서코드순으로 나열되어있는 코드 아래와 같이 제시되어있다. 
--아래의 SQL구문을 평균 월급이 2800000초과하는 부서를 조회하도록 수정하려고한다.
--수정해야하는 조건을[원인](30점)에 기술하고, 제시된 코드에 추가하여 [조치내용](30점)에 작성하시오.(60점)
SELECT DEPT, SUM(SALARY) 합계, FLOOR(AVG(SALARY)) 평균, COUNT(*) 인원수
FROM EMP
GROUP BY DEPT
ORDER BY DEPT ASC;

select dept_code 부서코드, sum(salary) 합계, floor(avg(salary)) 평균, count(*) 인원수
from employee
group by dept_code
order by dept_code asc;

select  nvl(d. dept_title, '인턴') , sum(salary)합계 , trunc(avg(salary))평균급여 ,count(*) 인원수 
from employee e join department d 
on e.dept_code =d.dept_id
where 2800000 < (select trunc (avg(salary))
            from employee
                where nvl(dept_code, '인턴') = nvl(E.dept_code, '인턴'))
group by nvl(d.dept_title, '인턴'); 


SELECT DEPT, SUM(SALARY) 합계, FLOOR(AVG(SALARY)) 평균, COUNT(*) 인원수
FROM EMP
GROUP BY DEPT
HAVING FLOOR(AVG(SALARY)) > 2800000
ORDER BY DEPT ASC;
