--@실습문제 :
--emp_copy 에서 사원을 삭제할 경우, emp_copy_del 테이블로 데이터를 이전시키는 trigger를 생성하세요.
--quit_date에 현재날짜를 기록할 것.
create table emp_copy_del
as
select E.*
from emp_copy E
where 1 = 2;

create or replace trigger trig_emp_quit
    before delete on emp_copy
    for each row
begin
    insert into emp_copy_del
    (emp_id, emp_name, emp_no, email, phone, dept_code, job_code, sal_level, salary, bonus, manager_id, hire_date, quit_date, quit_yn)
    values (:old.emp_id, :old.emp_name, :old.emp_no, :old.email, :old.phone, :old.dept_code, :old.job_code, :old.sal_level, :old.salary, :old.bonus, :old.manager_id, :old.hire_date, sysdate, 'Y');
    
    dbms_output.put_line(:old.emp_id||'사원이 퇴사자 테이블로 이동했음');
end;
/

select * from emp_copy;
select * from emp_copy_del;

delete from emp_copy
where quit_yn = 'Y';