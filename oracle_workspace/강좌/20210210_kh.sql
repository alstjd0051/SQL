select * from emp_copy;
select * from emp_copy_del;

delete from emp_copy
where emp_id = 224;

commit;
rollback;

select * from user_triggers;
drop trigger trig_emp_name;

--상품 재고 관리
create table product (
    pcode number,
    pname varchar2(100),
    price number,
    stock_cnt number default 0,
    constraint pk_product_pcode primary key(pcode)
);

create table product_io (
    iocode number,
    pcode number,
    amount number,
    status char(1),
    io_date date default sysdate,
    constraint pk_product_io_code primary key(iocode),
    constraint fk_product_io_pcode foreign key(pcode)
                                                         references product(pcode)
);

alter table product_io
add constraint ck_product_io_status check(status in ('|','O'));

create sequence seq_product_pcode;
create sequence seq_product_io_iocode
start with 1000;
--drop sequence seq_product_io_iocode;

insert into product
values (seq_product_pcode.nextval, '아이폰12', 1500000, 0);

insert into product
values (seq_product_pcode.nextval, '갤럭시21', 990000, 0);


select * from product;
select * from product_io;

--입출고데이터가 insert되면, 해당상품의 재고수량을 변경하는 트리거
create or replace trigger trg_product
    before
    insert on product_io
    for each row
begin
    --입고
    if :new.status = 'I' then
        update product
        set stock_cnt = stock_cnt  + :new.amount
        where pcode = :new.pcode;
    --출고
    else 
        update product
        set stock_cnt = stock_cnt  - :new.amount
        where pcode = :new.pcode;
    
    end if;
end;
/

--입출고 내역
insert into product_io
values(seq_product_io_iocode.nextval, 1, 5, 'I', sysdate);
insert into product_io
values(seq_product_io_iocode.nextval, 1, 100, 'I', sysdate);
insert into product_io
values(seq_product_io_iocode.nextval, 1, 39, 'O', sysdate);

select * from product;
select * from product_io;
commit;

--1. 원DML문의 대상테이블에 접근할 수 없다.
--2. 트리거 안에서는 원DML문을 제어할 수 없다.