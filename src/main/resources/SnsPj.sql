/*create user sns identified by java;
grant resource, connect to sns;
conn sns/java;
*/


delete from BOARD_LIKE;
delete from BOARD_REPLY;
delete from BOARD_FILE;
delete from BOARD;
delete from FOLLOW;
delete from MAIL_AUTH;
delete from MEMBER;

drop table BOARD_LIKE;
drop table BOARD_REPLY;
drop table BOARD_FILE;
drop table BOARD;
drop table FOLLOW;
drop table MAIL_AUTH;
drop table MEMBER;

drop sequence BOARD_FILE_SEQ;
drop sequence BOARD_SEQ;
drop sequence BOARD_REPLY_SEQ;

create table MEMBER(
MEM_EMAIL varchar2(100) constraint MEMBER_PK primary key,
MEM_PWD varchar2(100),
MEM_RDATE date,
MEM_PROFILE varchar2(1000),
MEM_STATE number
);

insert into MEMBER values('a@naver.com', '1234', SYSDATE, 'a������.jpg', 1);
insert into MEMBER values('b@naver.com', '1234', SYSDATE, 'b������.jpg', 1);
insert into MEMBER values('c@naver.com', '1234', SYSDATE, 'c������.jpg', 1);
insert into MEMBER values('d@naver.com', '1234', SYSDATE, 'd������.jpg', 1);

insert into MEMBER values('e@naver.com', '1234', SYSDATE, 'defaultProfile.jpg', 0);
insert into MEMBER values('f@naver.com', '1234', SYSDATE, 'defaultProfile.jpg', 0);
insert into MEMBER values('g@naver.com', '1234', SYSDATE, 'defaultProfile.jpg', 0);
insert into MEMBER values('h@naver.com', '1234', SYSDATE, 'defaultProfile.jpg', 0);



insert into MEMBER values('b1@naver.com', '1234', SYSDATE, 'b1������.jpg', 1);
insert into MEMBER values('b2@naver.com', '1234', SYSDATE, 'b2������.jpg', 1);
insert into MEMBER values('b3@naver.com', '1234', SYSDATE, 'b3������.jpg', 1);
insert into MEMBER values('b4@naver.com', '1234', SYSDATE, 'b4������.jpg', 1);


commit;
select * from member;

create table MAIL_AUTH(
MEM_EMAIL varchar2(100) constraint MAIL_AUTH_PK primary key,
MAIL_AUTHKEY varchar2(100)
);

create table FOLLOW(
FLR_EMAIL varchar2(100),
MEM_EMAIL varchar2(100) constraint FOLLOWER_FK references MEMBER(MEM_EMAIL) on delete cascade
);

insert into FOLLOW values('b@naver.com', 'a@naver.com');
insert into FOLLOW values('c@naver.com', 'a@naver.com');
insert into FOLLOW values('d@naver.com', 'a@naver.com');

insert into FOLLOW values('a@naver.com', 'b@naver.com');
insert into FOLLOW values('c@naver.com', 'b@naver.com');
insert into FOLLOW values('d@naver.com', 'b@naver.com');


commit;
select * from FOLLOW;



--delete from FOLLOW where mem_email = 'a@naver.com' and FLR_EMAIL = 'b@naver.com';



create table BOARD(
B_SEQ number constraint BOARD_PK primary key,
B_CONTENT varchar2(3000),
MEM_EMAIL varchar2(100) constraint BOARD_FK references MEMBER(MEM_EMAIL) on delete cascade,
B_RDATE date
);
create sequence BOARD_SEQ minvalue 0 start with 0 increment by 1 nocache;

insert into BOARD values(BOARD_SEQ.nextval, '���� �Ϸ�� ���?', 'b@naver.com', '2020-01-27');
insert into BOARD values(BOARD_SEQ.nextval, '������ ����.', 'b@naver.com', '2020-02-28');

insert into BOARD values(BOARD_SEQ.nextval, '�谡 ������.', 'c@naver.com', '2020-01-25');
insert into BOARD values(BOARD_SEQ.nextval, '��ǰ�� ���´�.', 'c@naver.com', '2020-02-26');
insert into BOARD values(BOARD_SEQ.nextval, '������ ��ſ�̿���.', 'b@naver.com', '2020-03-02');


insert into BOARD values(BOARD_SEQ.nextval, '����� �ؾ��մϴ�', 'b1@naver.com', '2020-01-15');
insert into BOARD values(BOARD_SEQ.nextval, '���α׷��� ��վ��', 'b1@naver.com', '2020-02-08');
insert into BOARD values(BOARD_SEQ.nextval, '��� �� �� �ִ�', 'b2@naver.com', '2020-03-03');


commit;
select * from BOARD order by B_RDATE desc;

select * from (select ROWNUM rnum, board.* from (select * from BOARD order by B_RDATE desc) board order by B_RDATE desc) where rnum > 0 and rnum <= 3 and MEM_EMAIL = 'b@naver.com';

--myboardlist ����
select A.B_SEQ, A.B_CONTENT from (select ROWNUM rnum, BOARD.* from BOARD where mem_email = 'b@naver.com' order by b_rdate desc) A where rnum > 0 and rnum <= 3 and A.MEM_EMAIL = 'b@naver.com';


--�ȷ��� �۵� list ����
select boardlist.B_SEQ, boardlist.B_CONTENT, boardlist.MEM_EMAIL, TO_CHAR(boardlist.B_RDATE, 'yyyy-MM-dd') 
from (select ROWNUM rnum, board.* from (select * from board where mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc) board) boardlist 
where rnum > 0 and rnum <= 3 and 
mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc;


/*
select boardlist.B_SEQ, boardlist.B_CONTENT, boardlist.MEM_EMAIL, TO_CHAR(boardlist.B_RDATE, 'yyyy-MM-dd'), filelist.BF_SEQ, filelist.BF_OFNAME, filelist.BF_FNAME, filelist.B_SEQ
from (select ROWNUM rnum, board.* from (select * from board where mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc) board) 
boardlist 
left outer join BOARD_FILE filelist ON boardlist.B_SEQ = filelist.B_SEQ
where rnum > 0 and rnum <= 3 and 
mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc;


select b.B_SEQ B_SEQ,
b.B_CONTENT B_CONTENT,
b.MEM_EMAIL MEM_EMAIL,
b.B_RDATE B_RDATE,
f.BF_SEQ BF_SEQ,
f.BF_OFNAME BF_OFNAME,
f.BF_FNAME BF_FNAME,
f.BF_SIZE BF_SIZE,
f.B_SEQ B_SEQ_0,
m.MEM_EMAIL MEM_EMAIL_1,
m.MEM_PWD MEM_PWD,
m.MEM_RDATE MEM_RDATE,
m.MEM_PROFILE MEM_PROFILE,
m.MEM_STATE MEM_STATE,
bl.*,
br.*
from (select ROWNUM rnum, board.* from(select * from board where mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc) board) b 
left outer join board_file f on b.b_seq = f.b_seq 
left outer join member m on b.mem_email = m.mem_email
left outer join board_like bl on bl.b_seq = b.b_seq
left outer join board_reply br on br.b_seq = b.b_seq
where rnum > 0 and rnum <=3
;
*/

select b.B_SEQ B_SEQ,
b.B_CONTENT B_CONTENT,
b.MEM_EMAIL MEM_EMAIL,
b.B_RDATE B_RDATE,
f.BF_SEQ BF_SEQ,
f.BF_FNAME BF_FNAME,
f.B_SEQ BF_B_SEQ,
m.MEM_PROFILE MEM_PROFILE,
bl.b_seq B_SEQ,
bl.mem_email MEM_EMAIL,
br.brp_seq BRP_SEQ,
br.mem_email MEM_MAIL
from (select ROWNUM rnum, board.* from(select * from board where mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc) board) b 
left outer join board_file f on b.b_seq = f.b_seq 
left outer join member m on b.mem_email = m.mem_email
left outer join board_like bl on bl.b_seq = b.b_seq
left outer join board_reply br on br.b_seq = b.b_seq
where rnum > 0 and rnum <=3 and b.mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc
;





select * from board left outer join board_file on board.b_seq = board_file.b_seq ;

select * from board_file;


--select B_SEQ, B_CONTENT, MEM_EMAIL, B_RDATE from (select ROWNUM rnum, aa.* from (select * from BOARD where MEM_EMAIL = 'a@naver.com' order by B_RDATE desc) aa) where rnum > 0 and rnum <= 3;
--select flr_email from follow where mem_email = 'a@naver.com';
--select ROWNUM rnum, b.* from BOARD b where mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc;
--select * from (select ROWNUM rnum, board.* from (select * from board order by b_rdate desc) board) where rnum > 0 and rnum <= 3 and mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc;
select boardlist.B_SEQ, boardlist.B_CONTENT, boardlist.MEM_EMAIL, TO_CHAR(boardlist.B_RDATE, 'yyyy-MM-dd') from (select ROWNUM rnum, board.* from (select * from board order by b_rdate desc) board) boardlist where rnum > 0 and rnum <= 3 and mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc;

create table BOARD_FILE(
BF_SEQ number constraint BOARD_FILE_PK primary key,
BF_OFNAME varchar2(1000),
BF_FNAME varchar2(1000),
BF_SIZE varchar2(1000),
B_SEQ number constraint BOARD_FILE_FK references BOARD(B_SEQ) on delete cascade
);
create sequence BOARD_FILE_SEQ minvalue 0 start with 0 increment by 1 nocache;

insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����1.jpg', '����1.jpg', '1000', 5);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����2,jpg', '����2.jpg', '1000', 5);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����3,jpg', '����3.jpg', '1000', 5);

insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����4.jpg', '����4.jpg', '1000', 2);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����5,jpg', '����5.jpg', '1000', 2);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����6,jpg', '����6.jpg', '1000', 2);

insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����7.jpg', '����7.jpg', '1000', 1);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����8,jpg', '����8.jpg', '1000', 1);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����9,jpg', '����9.jpg', '1000', 1);

insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '����10.jpg', '����10.jpg', '1000', 2);


commit;

select * from BOARD_FILE;

create table BOARD_LIKE(
MEM_EMAIL varchar2(100) constraint BOARD_LIKE_FK1 references MEMBER(MEM_EMAIL) on delete cascade,
B_SEQ number constraint BOARD_LIKE_FK2 references BOARD(B_SEQ) on delete cascade,
constraint BOARD_LIKE_PK primary key (MEM_EMAIL, B_SEQ)
);


insert into BOARD_LIKE values('a@naver.com', 5);
insert into BOARD_LIKE values('c@naver.com', 5);
insert into BOARD_LIKE values('d@naver.com', 5);

insert into BOARD_LIKE values('a@naver.com', 2);

insert into BOARD_LIKE values('a@naver.com', 1);

insert into BOARD_LIKE values('b@naver.com', 3);


select * from board_like;





create table BOARD_REPLY(
BRP_SEQ number constraint REPLY_PK primary key,
BRP_CONTENT varchar2(3000),
BRP_RDATE date,
MEM_EMAIL varchar2(100) constraint REPLY_FK1 references MEMBER(MEM_EMAIL) on delete cascade,
B_SEQ number constraint REPLY_FK2 references BOARD(B_SEQ) on delete cascade
);
create sequence BOARD_REPLY_SEQ minvalue 0 start with 0 increment by 1 nocache;

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�����ϰ� �;��', '2020-01-25', 'a@naver.com', 5);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�ȳ��ϼ���', '2020-01-26', 'b@naver.com', 5);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '���׿�', '2020-01-27', 'c@naver.com', 5);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'nice photo', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�����������������������', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�����׿� ����~', '2020-01-27', 'c@naver.com', 2);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�����ϴ�', '2020-02-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�ʹ� ���׿�', '2020-02-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�帮�� ���Ծ��', '2020-02-27', 'c@naver.com', 2);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '��������׿�', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�׷��� �ʳ׿�', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '��Ʈ �������', '2020-01-27', 'c@naver.com', 2);


insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '����� �ߴ޷���', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'Ajax ��վ�', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'Restful�ϴ�', '2020-01-27', 'c@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'cloud and bubble', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'miss u', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'i luv', '2020-01-27', 'c@naver.com', 2);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '���� ���ΰ���?', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�Ƹ޸�ī�� �����ؿ�', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '���� �����Ƿ���?', '2020-01-27', 'c@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�ұ� ���ƿ�', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '���ٳ��� ���ƿ�', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�������ϴ� �׷��� �����ϽŴٸ�', '2020-01-27', 'c@naver.com', 2);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '��ǰ���Ϳ�', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�� �����ؿ�', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '�󶼴� ���̾�', '2020-01-27', 'c@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '��������;�', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'ȭ�����սô�', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '���� ȭ����', '2020-01-27', 'c@naver.com', 2);




commit;

select boardreply.* from (select ROWNUM rnum, br.* from (select * from BOARD_REPLY where B_SEQ = 1) br) boardreply where rnum > 0 and rnum <= 3 order by BRP_RDATE desc;

select boardreply.brp_seq, boardreply.brp_content, TO_CHAR(boardreply.brp_rdate, 'YYYY-MM-DD') as brp_rdate, boardreply.mem_email, boardreply.b_seq from (select ROWNUM rnum, br.* from (select * from BOARD_REPLY where B_SEQ = 1) br) boardreply where rnum > 0 and rnum <= 3 order by BRP_RDATE desc;




delete from B;
delete from A;
drop table B;
drop table A;

create table A (
a_seq number constraint A_PK primary key,
a_name varchar2(100)
);

insert into A values(1, '�̸�1');
insert into A values(2, '�̸�2');

create table B(
b_seq number constraint B_PK primary key,
b_name varchar2(100),
a_seq number constraint B_FK references A(a_seq) on delete cascade

);

insert into B values(1, '�̸�1', 1);
insert into B values(2, '�̸�2', 1);
insert into B values(3, '�̸�3', 1);

commit;

select * from A left join B on  A.a_seq = B.a_seq;


select A.A_SEQ, A.A_NAME, B.B_SEQ, B.B_NAME, B.A_SEQ from A left join B on  A.a_seq = B.a_seq;


	select a.A_SEQ, a.A_NAME, b.B_SEQ, b.B_NAME, b.A_SEQ 
	from A a left outer join B b on  a.a_seq = b.a_seq;



















