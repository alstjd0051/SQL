--@실습문제 : tb_number테이블에 난수 100개(0 ~ 999)를 저장하는 익명블럭을 생성하세요.
--실행시마다 생성된 모든 난수의 합을 콘솔에 출력할 것.
create table tb_number(
    id number, --pk sequence객체로 부터 채번
    num number, --난수
    reg_date date default sysdate,
    constraints pk_tb_number_id primary key(id)
);
create sequence seq_tb_nubmer_id;
 --insert문 실행.
declare
    rnd number;
    v_sum number := 0;
begin
    for n in 1..100 loop
        --난수 생성
        rnd := trunc(dbms_random.value(0,1000));
        -- 데이터 추가
        insert into tb_number (id, num) 
        values(seq_tb_nubmer_id.nextval, rnd);
        --누적합
        v_sum := v_sum + rnd;
    end loop;
    
    dbms_output.put_line('합계 : '||v_sum);
    --트랜잭션처리
    commit;
end;
/
--데이터확인
select * from tb_number;
--데이터제거
--truncate table tbl_number;