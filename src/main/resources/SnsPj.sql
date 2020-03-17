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

insert into MEMBER values('a@naver.com', '1234', SYSDATE, 'a프로필.jpg', 1);
insert into MEMBER values('b@naver.com', '1234', SYSDATE, 'b프로필.jpg', 1);
insert into MEMBER values('c@naver.com', '1234', SYSDATE, 'c프로필.jpg', 1);
insert into MEMBER values('d@naver.com', '1234', SYSDATE, 'd프로필.jpg', 1);

insert into MEMBER values('e@naver.com', '1234', SYSDATE, 'defaultProfile.jpg', 0);
insert into MEMBER values('f@naver.com', '1234', SYSDATE, 'defaultProfile.jpg', 0);
insert into MEMBER values('g@naver.com', '1234', SYSDATE, 'defaultProfile.jpg', 0);
insert into MEMBER values('h@naver.com', '1234', SYSDATE, 'defaultProfile.jpg', 0);

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

create table BOARD(
B_SEQ number constraint BOARD_PK primary key,
B_CONTENT varchar2(3000),
MEM_EMAIL varchar2(100) constraint BOARD_FK references MEMBER(MEM_EMAIL) on delete cascade,
B_RDATE date
);
create sequence BOARD_SEQ minvalue 0 start with 0 increment by 1 nocache;

insert into BOARD values(BOARD_SEQ.nextval, '오늘 하루는 어떨까?', 'b@naver.com', '2020-01-27');
insert into BOARD values(BOARD_SEQ.nextval, '날씨가 좋다.', 'b@naver.com', '2020-02-28');

insert into BOARD values(BOARD_SEQ.nextval, '배가 고프다.', 'c@naver.com', '2020-01-25');
insert into BOARD values(BOARD_SEQ.nextval, '하품이 나온다.', 'c@naver.com', '2020-02-26');
insert into BOARD values(BOARD_SEQ.nextval, '오늘은 즐거운날이에요.', 'b@naver.com', '2020-03-02');


commit;
select * from BOARD order by B_RDATE desc;


--select B_SEQ, B_CONTENT, MEM_EMAIL, B_RDATE from (select ROWNUM rnum, aa.* from (select * from BOARD where MEM_EMAIL = 'a@naver.com' order by B_RDATE desc) aa) where rnum > 0 and rnum <= 3;
--select flr_email from follow where mem_email = 'a@naver.com';
--select ROWNUM rnum, b.* from BOARD b where mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc;
--select * from (select ROWNUM rnum, board.* from (select * from board order by b_rdate desc) board) where rnum > 0 and rnum <= 3 and mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc;
select boardlist.B_SEQ, boardlist.B_CONTENT, boardlist.MEM_EMAIL, TO_CHAR(boardlist.B_RDATE, 'yyyy-MM-dd') from (select ROWNUM rnum, board.* from (select * from board order by b_rdate desc) board) boardlist where rnum > 0 and rnum <= 3 and mem_email in (select flr_email from follow where mem_email = 'a@naver.com') order by b_rdate desc;

create table BOARD_FILE(
BF_SEQ number constraint BOARD_FILE_PK primary key,
BF_OFNAME varchar2(300),
BF_FNAME varchar2(300),
BF_SIZE number,
B_SEQ number constraint BOARD_FILE_FK references BOARD(B_SEQ) on delete cascade
);
create sequence BOARD_FILE_SEQ minvalue 0 start with 0 increment by 1 nocache;

insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일1.jpg', '파일1.jpg', 1000, 5);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일2,jpg', '파일2.jpg', 1000, 5);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일3,jpg', '파일3.jpg', 1000, 5);

insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일4.jpg', '파일4.jpg', 1000, 2);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일5,jpg', '파일5.jpg', 1000, 2);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일6,jpg', '파일6.jpg', 1000, 2);

insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일7.jpg', '파일7.jpg', 1000, 1);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일8,jpg', '파일8.jpg', 1000, 1);
insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일9,jpg', '파일9.jpg', 1000, 1);

insert into BOARD_FILE values(BOARD_FILE_SEQ.nextval, '파일10.jpg', '파일10.jpg', 1000, 2);


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


select * from board_like where mem_email = 'a@naver.com' and b_seq = 5;

create table BOARD_REPLY(
BRP_SEQ number constraint REPLY_PK primary key,
BRP_CONTENT varchar2(3000),
BRP_RDATE date,
MEM_EMAIL varchar2(100) constraint REPLY_FK1 references MEMBER(MEM_EMAIL) on delete cascade,
B_SEQ number constraint REPLY_FK2 references BOARD(B_SEQ) on delete cascade
);
create sequence BOARD_REPLY_SEQ minvalue 0 start with 0 increment by 1 nocache;

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '소통하고 싶어요', '2020-01-25', 'a@naver.com', 5);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '안녕하세요', '2020-01-26', 'b@naver.com', 5);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '좋네요', '2020-01-27', 'c@naver.com', 5);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'nice photo', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '아프지마세요아프지마세요', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '멋지네요 정말~', '2020-01-27', 'c@naver.com', 2);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '좋습니다', '2020-02-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '너무 좋네요', '2020-02-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '흐리게 나왔어요', '2020-02-27', 'c@naver.com', 2);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'ㅎㅎ웃기네요', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '그렇지 않네요', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '하트 눌렀어요', '2020-01-27', 'c@naver.com', 2);


insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '댓글이 잘달려요', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'Ajax 재밌어', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'Restful하다', '2020-01-27', 'c@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'cloud and bubble', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'miss u', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, 'i luv', '2020-01-27', 'c@naver.com', 2);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '오늘 어디로가요?', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '아메리카노 좋아해요', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '오늘 술마실래요?', '2020-01-27', 'c@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '소금 좋아요', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '지바노프 좋아요', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '괜찮습니다 그렇게 말씀하신다면', '2020-01-27', 'c@naver.com', 2);

insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '하품나와요', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '라떼 좋아해요', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '라떼는 말이야', '2020-01-27', 'c@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '집에가고싶어', '2020-01-25', 'a@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '화이팅합시다', '2020-01-26', 'b@naver.com', 2);
insert into BOARD_REPLY values(BOARD_REPLY_SEQ.nextval, '취준 화이팅', '2020-01-27', 'c@naver.com', 2);




commit;

select boardreply.* from (select ROWNUM rnum, br.* from (select * from BOARD_REPLY where B_SEQ = 1) br) boardreply where rnum > 0 and rnum <= 3 order by BRP_RDATE desc;



select boardreply.brp_seq, boardreply.brp_content, TO_CHAR(boardreply.brp_rdate, 'YYYY-MM-DD') as brp_rdate, boardreply.mem_email, boardreply.b_seq from (select ROWNUM rnum, br.* from (select * from BOARD_REPLY where B_SEQ = 1) br) boardreply where rnum > 0 and rnum <= 3 order by BRP_RDATE desc;

