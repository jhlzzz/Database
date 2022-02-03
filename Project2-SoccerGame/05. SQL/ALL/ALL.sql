--우승이라는 골을 향해 달려가는 구단에게
--맞춤 어시스트를!! ㈜축구인..

delete from TEAM;
delete from MANAGER;
delete from SPONSOR_PLAYER;
delete from AWARD;
delete from RECORD;
delete from WISHILIST;
delete from MY_PLAYER;
delete from CONTRACT;
delete from PLAYER;
delete from MEMBER;
delete from LEAGUE;

drop table TEAM;
drop table MANAGER;
drop table SPONSOR_PLAYER;
drop table AWARD;
drop table RECORD;
drop table WISHILIST;
drop table MY_PLAYER;
drop table CONTRACT;
drop table PLAYER;
drop table MEMBER;
drop table LEAGUE;
drop sequence PLAYER_SEQ;
drop sequence MNG_SEQ;
drop sequence SOP_SEQ;
drop sequence CONTRACT_SEQ;

purge recyclebin;

--리그
create table LEAGUE(
	L_NAME VARCHAR2(30) constraint LEA_NAME_NN not null,
	L_NATION VARCHAR2(30) constraint LEA_NATION_NN not null,
	constraint LG_PK primary key(L_NAME)
);


--회원
create table MEMBER(
	M_EMAIL VARCHAR2(30),
	L_NAME VARCHAR2(30) constraint MEM_LNAME_NN not null,
	M_PHONE VARCHAR2(20) constraint MEM_PHONE_NN not null,
	M_NAME VARCHAR2(30) constraint MEM_NAME_NN not null,
	M_PW VARCHAR2(20) constraint MEM_PW_NN not null,
	M_DATE DATE default SYSDATE,
	M_MONEY NUMBER(7) default 10000,
	constraint MEM_PK primary key(M_EMAIL, L_NAME),
	constraint MEM_FK foreign key (L_NAME) references LEAGUE(L_NAME) on delete cascade
);
alter table MEMBER add constraint MEM_UK unique(M_PHONE);


--선수
create table PLAYER(
	P_ID NUMBER,
	L_NAME VARCHAR2(40) constraint PLA_LNAME_NN not null,
	P_POSITION VARCHAR2(10),
	P_NAME VARCHAR2(40) constraint PLA_NAME_NN not null,
	P_MAINFOOT VARCHAR2(10),
	P_HEIGHT NUMBER(3) constraint PLA_HEIGHT_NN not null,
	P_WEIGHT NUMBER(3) constraint PLA_WEIGHT_NN not null,
	P_NATION VARCHAR2(30) constraint PLA_NATION_NN not null,
	P_SAL NUMBER(15) constraint PLA_SAL_NN not null,
	P_BIRTH DATE constraint PLA_BIRTH_NN not null,
	constraint PLA_PK primary key(P_ID, L_NAME),
	constraint PLA_FK foreign key (L_NAME) references LEAGUE(L_NAME) on delete cascade,
	constraint PLA_CK check (P_POSITION in ('FW', 'MF', 'DF', 'GK')),
	constraint PLA_CK2 check (P_MAINFOOT in ('오른발', '왼발', '양발'))
);

create SEQUENCE PLAYER_SEQ start with 1 increment by 1 nocache;

--계약
create table CONTRACT(
	C_NUMBER NUMBER,
	C_DATE DATE default SYSDATE,
	C_SAL NUMBER(15),
	C_DEAL NUMBER(1) constraint CON_DEAL_JJIM_NN not null,
	M_EMAIL VARCHAR2(30) not null,
	P_ID NUMBER constraint CON_PID_NN not null,
	L_NAME VARCHAR2(30),
	constraint CON_PK primary key(C_NUMBER),
	constraint CON_FK foreign key (M_EMAIL,L_NAME) references MEMBER(M_EMAIL,L_NAME) on delete cascade,
	constraint CON_FK2 foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade,
	constraint CON_DEAL_JJIM_CK check (C_DEAL in (0,1,2,3))
);
create SEQUENCE CONTRACT_SEQ start with 1 increment by 1 nocache;


--수상내역
create table AWARD(
	P_AWARD VARCHAR2(30),
	P_ID NUMBER constraint AWA_PID_NN not null,
	L_NAME VARCHAR2(30) constraint AWA_LNAME_NN not null,
	constraint AWA_PK primary key(P_AWARD),
	constraint AWA_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);

--선수전적
create table RECORD(
	P_ID NUMBER,
	P_GOAL NUMBER(3) constraint REC_GOAL_NN not null,
	P_ASSIST NUMBER(3) constraint REC_ASSIST_NN not null,
	P_POINT NUMBER(3) constraint REC_POINT_NN not null,
	L_NAME VARCHAR2(30),
	constraint REC_PK primary key(P_ID),
	constraint REC_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);

--구단
create table TEAM(
	P_ID NUMBER,
	T_HOME VARCHAR2(40) constraint TEAM_HOME_NN not null,
	T_NAME VARCHAR2(40) constraint TEAM_NAME_NN not null,
	T_FINANCIAL NUMBER(20) constraint TEAM_FINANCIAL_NN not null,
	T_DATE DATE default SYSDATE,
	T_LOCATION VARCHAR2(20) constraint TEAM_LOCATION_NN not null,
	T_SPONSOR VARCHAR2(30) constraint TEAM_SPONSOR_NN not null,
	T_COACH VARCHAR2(20) constraint TEAM_COACH_NN not null,
	L_NAME VARCHAR2(30),
	constraint TEAM_PK primary key(P_ID),
	constraint TEAM_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);

--매니저
create table MANAGER(
	MNG_CODE NUMBER,
	MNG_NAME VARCHAR2(20) not null,
	P_ID NUMBER not null,
	L_NAME VARCHAR2(30) not null,
	constraint MNG_PK primary key(MNG_CODE),
	constraint MNG_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);
create SEQUENCE MNG_SEQ start with 1 increment by 1 nocache;

--선수스폰서
create table SPONSOR_PLAYER(
	S_CODE NUMBER,
	S_SHOES VARCHAR2(20) not null,
	S_CAR VARCHAR2(20) not null,
	P_ID NUMBER not null,
	L_NAME VARCHAR2(30) not null,
	constraint SOP_PK primary key(S_CODE),
	constraint SOP_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);
create SEQUENCE SOP_SEQ start with 1 increment by 1 nocache;


create table MY_PLAYER(
	P_ID NUMBER constraint MY_PLA_PID_NN not null,
        M_EMAIL VARCHAR2(30) constraint MY_PLA_EMAIL_NN not null,
	L_NAME VARCHAR2(30) constraint MY_PLA_L_NAME_NN not null,
	P_POSITION VARCHAR2(10) constraint MY_PLA_MY_POSITION_NN not null,
	P_NAME VARCHAR2(40) constraint MY_PLA_NAME_NN not null,
	P_MAINFOOT VARCHAR2(10) constraint MY_PLA_MY_MAINFOOT_NN not null,
	P_SAL NUMBER(15) constraint MY_PLA_SAL_NN not null,
	M_NAME VARCHAR2(30) constraint MY_M_NAME_NN not null,
	constraint MY_PLA_PK primary key(M_EMAIL,P_ID),
	constraint MY_PLA_MEM_FK foreign key (M_EMAIL,L_NAME) references MEMBER(M_EMAIL,L_NAME) on delete cascade,
	constraint MY_PLA_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade,
	constraint MY_PLA_CK check (P_POSITION in ('FW', 'MF', 'DF', 'GK')),
	constraint MY_PLA_CK2 check (P_MAINFOOT in ('오른발', '왼발', '양발'))
);



create table WISHILIST(
   P_ID NUMBER constraint WL_PID_NN not null,
   M_EMAIL VARCHAR2(30) constraint WL_EMAIL_NN not null,
   L_NAME VARCHAR2(30) constraint WL_LNAME_NN not null,
   P_POSITION VARCHAR2(10),
   P_NAME VARCHAR2(40) constraint WL_NAME_NN not null,
   P_MAINFOOT VARCHAR2(10),
   P_HEIGHT NUMBER(3) constraint WL_HEIGHT_NN not null,
   P_WEIGHT NUMBER(3) constraint WL_WEIGHT_NN not null,
   P_NATION VARCHAR2(30) constraint WL_NATION_NN not null,
   P_SAL NUMBER(15) constraint WL_SAL_NN not null,
   P_BIRTH DATE constraint WL_BIRTH_NN not null,
   M_NAME VARCHAR2(30) constraint WL_M_NAME_NN not null,
   constraint WL_PK primary key(P_ID, M_EMAIL),
   constraint WL_FK foreign key (P_ID, L_NAME) references PLAYER(P_ID, L_NAME) on delete cascade,
   constraint WL_FK2 foreign key (M_EMAIL, L_NAME) references MEMBER(M_EMAIL, L_NAME) on delete cascade,
   constraint WL_CK check (P_POSITION in ('FW', 'MF', 'DF', 'GK')),
   constraint WL_CK2 check (P_MAINFOOT in ('오른발', '왼발', '양발'))
);



-- 프로시저
-- 잔액 차감 프로시저
create or replace procedure CONTRACT_BUY(b_ID_BUY in PLAYER.P_ID%TYPE, b_MEM_BUY in MEMBER.M_EMAIL%TYPE)
is
   newSAL NUMBER;
   newMONEY NUMBER;
begin
   select P_SAL into newSAL from PLAYER where P_ID = b_ID_BUY;
   select M_MONEY into newMONEY from MEMBER where M_EMAIL = b_MEM_BUY;
   newMONEY :=  newMONEY - newSAL;
   update MEMBER set M_MONEY=newMONEY where M_EMAIL = b_MEM_BUY;
end;
/


-- 구매선수 생성 프로시저
create or replace procedure MY_PLAYER_ADD(b_ID_ADD in PLAYER.P_ID%TYPE, b_MEM_ADD in MEMBER.M_EMAIL%TYPE)
is
--   newM_EMAIL VARCHAR2(30);
--   newP_ID NUMBER;
   newL_NAME VARCHAR2(30);
   newMY_POSITION VARCHAR2(10);
   newMY_NAME VARCHAR2(40);
   newMY_MAINFOOT VARCHAR2(10);
   newMY_SAL NUMBER(15);
   newMY_MNAME VARCHAR2(30);
begin
  -- newM_EMAIL := b_MEM_ADD;
  -- newP_ID := b_ID_ADD;
   select L_NAME into newL_NAME from PLAYER where P_ID = b_ID_ADD;
   select P_POSITION into newMY_POSITION from PLAYER where P_ID = b_ID_ADD;
   select P_NAME into newMY_NAME from PLAYER where P_ID = b_ID_ADD;
   select P_MAINFOOT into newMY_MAINFOOT from PLAYER where P_ID = b_ID_ADD;
   select P_SAL into newMY_SAL from PLAYER where P_ID = b_ID_ADD;
   select M_NAME into newMY_MNAME from MEMBER where M_EMAIL = b_MEM_ADD;

   insert into MY_PLAYER values(b_ID_ADD, b_MEM_ADD, newL_NAME, newMY_POSITION, newMY_NAME, newMY_MAINFOOT, newMY_SAL, newMY_MNAME);
end;
/


-- 잔액 증가 프로시저 (판매할때 수수료 5프로)
create or replace procedure CONTRACT_SELL(b_ID_SELL in PLAYER.P_ID%TYPE, b_MEM_SELL in MEMBER.M_EMAIL%TYPE)
is
   newSAL NUMBER;
   newMONEY NUMBER;
begin
   select P_SAL into newSAL from MY_PLAYER where P_ID = b_ID_SELL and M_EMAIL = b_MEM_SELL;
   select M_MONEY into newMONEY from MEMBER where M_EMAIL = b_MEM_SELL;
   newSAL := newSAL - ((newSAL * 5) / 100);
   newMONEY :=  newMONEY + newSAL;
   update MEMBER set M_MONEY=newMONEY where M_EMAIL = b_MEM_SELL;
end;
/

-- 선수 삭제 프로시저
create or replace procedure MY_PLAYER_DEL(b_ID_DEL in PLAYER.P_ID%TYPE, b_MEM_DEL in MEMBER.M_EMAIL%TYPE)
is

begin
   delete from MY_PLAYER where P_ID=b_ID_DEL and M_EMAIL = b_MEM_DEL;
end;
/



-- 찜한 선수 목록 생성 프로시저
create or replace procedure MY_WL_ADD(b_ID_WL_ADD in PLAYER.P_ID%TYPE, b_MEM_WL_ADD in MEMBER.M_EMAIL%TYPE)
is
   newL_NAME VARCHAR2(30);
   newWL_POSITION VARCHAR2(10);
   newWL_NAME VARCHAR2(40);
   newWL_MAINFOOT VARCHAR2(10);
   newWL_HEIGHT NUMBER(3);
   newWL_WEIGHT NUMBER(3);
   newWL_NATION VARCHAR2(30);
   newMY_SAL NUMBER(15);
   newWL_BIRTH VARCHAR2(10);
   newMY_MNAME VARCHAR2(30);
begin
   select L_NAME into newL_NAME from PLAYER where P_ID = b_ID_WL_ADD;
   select P_POSITION into newWL_POSITION from PLAYER where P_ID = b_ID_WL_ADD;
   select P_NAME into newWL_NAME from PLAYER where P_ID = b_ID_WL_ADD;
   select P_MAINFOOT into newWL_MAINFOOT from PLAYER where P_ID = b_ID_WL_ADD;
   select P_HEIGHT into newWL_HEIGHT from PLAYER where P_ID = b_ID_WL_ADD;
   select P_WEIGHT into newWL_WEIGHT from PLAYER where P_ID = b_ID_WL_ADD;
   select P_NATION into newWL_NATION from PLAYER where P_ID = b_ID_WL_ADD;
   select P_SAL into newMY_SAL from PLAYER where P_ID = b_ID_WL_ADD;
   select P_BIRTH into newWL_BIRTH from PLAYER where P_ID = b_ID_WL_ADD;
   select M_NAME into newMY_MNAME from MEMBER where M_EMAIL = b_MEM_WL_ADD;

   insert into WISHILIST values(b_ID_WL_ADD, b_MEM_WL_ADD, newL_NAME, newWL_POSITION, newWL_NAME, newWL_MAINFOOT, newWL_HEIGHT, newWL_WEIGHT, newWL_NATION, newMY_SAL, newWL_BIRTH, newMY_MNAME);
end;
/


-- 찜한 선수 목록 삭제 프로시저
create or replace procedure MY_WL_DEL(b_ID_WL_DEL in PLAYER.P_ID%TYPE, b_MEM_WL_DEL in MEMBER.M_EMAIL%TYPE)
is
begin
   delete from WISHILIST where P_ID=b_ID_WL_DEL and M_EMAIL = b_MEM_WL_DEL;
end;
/


--트리거

--CONTRACT C_DEAL (0 = 구매, 1 = 판매, 2 = 찜, 3 = 찜취소)
create or replace trigger CONTRACT_TR
after
   insert on CONTRACT for each row
begin
   if :NEW.C_DEAL = 0
      then
	CONTRACT_BUY(:NEW.P_ID, :NEW.M_EMAIL);
	MY_PLAYER_ADD(:NEW.P_ID, :NEW.M_EMAIL);
   end if;
   if :NEW.C_DEAL = 1
      then
	CONTRACT_SELL(:NEW.P_ID, :NEW.M_EMAIL);
        MY_PLAYER_DEL(:NEW.P_ID, :NEW.M_EMAIL);
   end if;
   if :NEW.C_DEAL = 2
      then
	MY_WL_ADD(:NEW.P_ID, :NEW.M_EMAIL);
   end if;
   if :NEW.C_DEAL = 3
      then
	MY_WL_DEL(:NEW.P_ID, :NEW.M_EMAIL);
   end if;
end;
/


-- PLAYER TRIGGER

create or replace trigger PLAYER_POSITION_UPDATE
after
   update of P_POSITION on PLAYER for each row
begin
   update WISHILIST set P_POSITION = :NEW.P_POSITION where P_ID = :NEW.P_ID;
   update MY_PLAYER set P_POSITION = :NEW.P_POSITION where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_NAME_UPDATE
after
   update of P_NAME on PLAYER for each row
begin
   update WISHILIST set P_NAME = :NEW.P_NAME where P_ID = :NEW.P_ID;
   update MY_PLAYER set P_NAME = :NEW.P_NAME where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_MAINFOOT_UPDATE
after
   update of P_MAINFOOT on PLAYER for each row
begin
   update WISHILIST set P_MAINFOOT = :NEW.P_MAINFOOT where P_ID = :NEW.P_ID;
   update MY_PLAYER set P_MAINFOOT = :NEW.P_MAINFOOT where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_SAL_UPDATE
after
   update of P_SAL on PLAYER for each row
begin
   update WISHILIST set P_SAL = :NEW.P_SAL where P_ID = :NEW.P_ID;
   update MY_PLAYER set P_SAL = :NEW.P_SAL where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_HEIGHT_UPDATE
after
   update of P_HEIGHT on PLAYER for each row
begin
   update WISHILIST set P_HEIGHT = :NEW.P_HEIGHT where P_ID = :NEW.P_ID;
end;
/



create or replace trigger PLAYER_WEIGHT_UPDATE
after
   update of P_WEIGHT on PLAYER for each row
begin
   update WISHILIST set P_WEIGHT = :NEW.P_WEIGHT where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_NATION_UPDATE
after
   update of P_NATION on PLAYER for each row
begin
   update WISHILIST set P_NATION = :NEW.P_NATION where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_BIRTH_UPDATE
after
   update of P_BIRTH on PLAYER for each row
begin
   update WISHILIST set P_BIRTH = :NEW.P_BIRTH where P_ID = :NEW.P_ID;
end;
/


-- MEMBER TRIGGER
create or replace trigger MEMBER_MNAME_UPDATE
after
   update of M_NAME on MEMBER for each row
begin
   update WISHILIST set M_NAME = :NEW.M_NAME where M_EMAIL = :NEW.M_EMAIL;
   update MY_PLAYER set M_NAME = :NEW.M_NAME where M_EMAIL = :NEW.M_EMAIL;
end;
/



-- 리그 인서트
insert into LEAGUE values('EPL', '영국');

-- 회원 인서트
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('kiho1212@naver.com','EPL','010-6618-4826','성기호','rlgh27!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('GodByengChel27@naver.com','EPL','010-1485-6642','신병철','sdfe4823!^@#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('HAK36@gmail.com','EPL','010-4358-1845','이제학','HAK485@');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('HAWN32@hanmail.net','EPL','010-3328-7536','이환규','HAWN184895423@#&$');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('qnrhrqjatn@naver.com','EPL','010-4094-6892','박범수','vbn2489156758!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('alsienk@nate.com','EPL','010-4862-1759','김성지','disoek@^');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('aeofjoz184@daum.net','EPL','010-9428-7149','성호균','tjdghrbs52!&#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('wocsowi11@nate.com','EPL','010-9916-4955','이주환','eocks12@');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('wnsidkdh1148@naver.com','EPL','010-4428-7115','신방희','eickso119!!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('dosos!!42@nate.com','EPL','010-4553-9421','마가람','qufdlwhDLE1!@#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('dosiei963@daum.net','EPL','010-4428-7599','허제인','asdfws184#$*');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('sdjeicndiapwo@gmail.com','EPL','010-1785-1184','김수지','tnwl4456!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('QASDZXZ456@gmail.com','EPL','010-4115-9366','김세우','TodNaktdlT8!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('eisn7752@daum.net','EPL','010-4773-1177','박재원','wodnjsdl74*!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('aopps@nate.com','EPL','010-4958-7714','최병원','asdf1548!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('TjlscE866@hanmail.net','EPL','010-1148-6945','성신이','dlRJnshD85$$');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('sjeicn4485@gmail.com','EPL','010-4482-4926','김원','sneidl!@#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('DISJD&*75@nate.com','EPL','010-9233-7442','이기주','AOxshhW698&@!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('sjeicndh1@naver.com','EPL','010-9752-4726','최범지','eicnsh4#!!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('assod09@daum.net','EPL','010-1845-8599','송희','gmlgmldj45^%');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('ehddhd422@gmail.com','EPL','010-7488-6428','이재우','cncdhddy188@@!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('ENddol1**@hanmail.net','EPL','010-5161-7923','박진','WlsdLL1!!!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('tndosl@daum.net','EPL','010-4826-7595','조성인','qpsomi1!@');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('IdCWsa48@gmail.com','EPL','010-7455-1642','추안수','DICSswn4878@#$');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('socbc@hanmail.net','EPL','010-9958-4772','박상제','sddccitkdwp**^');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('aowocnsh1927@daum.net','EPL','010-3128-7995','성배심','tlaqo19!!!^');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('sorkdlwl@nate.com','EPL','010-6882-1321','최배성','qocndajgk488$$@');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('wpcjdh@naver.com','EPL','010-3221-6354','김수희','wnssshe41!@#$');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('cndhss113@daum.net','EPL','010-7422-3396','신성배','tjdqo96!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('cosoekdn@gmail.com','EPL','010-7582-2447','조우진','whdnwls4852@!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('EDC2245@nate.com','EPL','010-1447-9875','박이수','clsoDDD144^#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('SDWw1#@hanmail.net','EPL','010-4288-7119','김환','Ddehncn2!^^');

-- 축구선수 인서트
--맨체스터 시티
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '케빈 더브라위너', '오른발', 181, 70, '벨기에', 1300, '91/06/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '라힘 스털링', '오른발', 170, 69, '영국', 1140, '94/12/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '가브리엘 제수스', '오른발', 175, 73, '브라질', 1190, '94/12/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '리야드 마레즈', '왼발', 179, 62, '알제리', 800, '91/02/21');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '일카이 귄도안', '오른발', 180, 80, '독일', 600, '90/10/24');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '잭 그릴리쉬', '오른발', 182, 78, '영국', 1300, '95/09/10');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '로드리', '오른발', 191, 82, '스페인', 850, '96/06/26');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '베르나르도실바', '왼발', 173, 64, '포르투갈', 900, '94/08/10');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '페르난지뉴', '오른발', 179, 67, '브라질', 800, '85/05/04');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '필 포든', '왼발', 171, 69, '영국', 1100, '00/05/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '카일 워커', '오른발', 183, 83, '영국', 600, '90/05/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '존 스톤스', '오른발', 188, 76, '포르투갈', 800, '94/05/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '네이선 아케', '오른발', 180, 75, '네덜란드', 200, '95/02/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '진첸코', '오른발', 175, 64, '우크라이나', 1500, '96/12/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '라포르트', '오른발', 191, 86, '프랑스', 550, '94/05/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '벤자민 멘디', '왼발', 185, 85, '프랑스', 400, '94/07/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '주앙 칸셀루', '오른발', 182, 74, '포르투갈', 750, '94/05/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '에데르송', '왼발', 188, 86, '브라질', 600, '93/08/17');

--토트넘
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '휴고 요리스', '왼발', 188, 82, '프랑스', 300, '86/12/26');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '세르히오 레길론', '왼발', 178, 68, '스페인', 400, '96/12/16');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '크리스티안 로메로', '왼발', 185, 79, '아르헨티나', 600, '98/04/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '에메르송 로얄', '왼발', 183, 79, '브라질', 500, '99/01/14');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '에릭 다이어', '오른발', 190, 90, '영국', 300, '94/01/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '다빈손 산체스', '오른발', 187, 79, '콜롬비아', 200, '96/06/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '로셀소', '왼발', 177, 68, '아르헨티나', 600, '96/04/09');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '델리 알리', '오른발', 188, 80, '영국', 700, '96/04/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '은돔벨레', '오른발', 179, 76, '프랑스', 900, '96/12/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '호이비에르', '오른발', 185, 84, '덴마크', 600, '95/08/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '베르바인', '왼발', 178, 73, '네덜란드', 300, '97/10/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '손흥민', '양발', 183, 78, '대한민국', 1100, '92/07/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '해리 케인', '양발', 188, 89, '영국', 1300, '93/07/28');

--울버햄튼
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '호세 사', '오른발', 192, 84, '포르투갈', 200, '93/01/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '맥스 킬먼', '왼발', 194, 89, '영국', 300, '97/05/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '코너 코디', '오른발', 186, 80, '영국', 200,  '93/02/25');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '넬손 세메두', '오른발', 177, 69, '포르투갈', 600,  '93/11/16');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '후벵 네베스', '오른발', 180, 80, '포르투갈', 900, '97/03/13');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '주앙 무티뉴', '양발', 170, 61, '포르투갈', 400, '86/09/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '레안더 덴돈커', '오른발', 188, 76, '벨기에', 100, '95/04/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '아다마 트라오레', '오른발', 178, 72, '스페인', 700, '96/01/25');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '라울 히메네즈', '오른발', 190, 76, '멕시코', 900, '91/05/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '황희찬', '오른발', 177, 77, '대한민국', 600, '96/01/26');

--에버튼
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '조던 픽포드', '왼발', 185, 77, '영국', 200, '94/03/07');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '마이클 킨', '오른발', 170, 70, '영국', 400, '93/01/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '뤼카 디뉴', '왼발', 178, 74, '프랑스', 500, '93/07/20');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '예리 미나', '오른발', 195, 94, '콜롬비아', 300, '94/09/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '앤드로스 타운센트', '왼발', 181, 81, '영국', 300, '91/07/16');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '안드레 고메스', '오른발', 188, 84, '포르투갈', 600, '93/07/30');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '압둘라예 두쿠레', '왼발', 184, 76, '프랑스', 500, '93/01/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '더마레이 그레이', '양발', 180, 74, '영국', 300, '96/06/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '알렉스 이워비', '오른발', 180, 75, '나이지리아', 500, '96/05/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '히샬리송', '양발', 179, 75, '브라질', 1000, '97/05/10');

--맨유
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '다비드 데 헤아', '오른발', 192, 82, '스페인', 800, '90/11/07');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '리 그랜트', '오른발', 193, 83, '영국', 300, '83/01/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '딘 헨더슨', '오른발', 188, 85, '영국', 200, '97/03/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '빅토르 린델뢰프', '양발', 187, 80, '스웨덴', 400, '94/07/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '에릭 바이', '오른발', 187, 77, '코트디부아르', 650, '94/04/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '필 존스', '오른발', 185, 86, '영국', 600, '92/02/21');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '해리 매과이어', '오른발', 194, 100, '영국', 1000, '93/03/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '디오고 달롯', '오른발', 184, 78, '포르투갈', 500, '90/03/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '루크 쇼', '왼발', 185, 75, '영국', 800, '95/07/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '알렉스 텔레스', '왼발', 181, 67, '브라질', 350, '92/12/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '에런 완비사카', '오른발', 183, 72, '영국', 700, '97/11/26');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '브랜든 윌리엄스', '오른발', 171, 63, '영국', 250, '00/09/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '악셀 튀앙제브', '오른발', 186, 72, '영국', 100, '97/11/14');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '테덴 멘기', '오른발', 183, 78, '영국', 100, '02/04/30');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '폴 포그바', '양발', 191, 84, '프랑스', 1040, '93/03/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '후안 마타', '왼발', 170, 63, '스페인', 600, '88/04/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '제시 린가드', '오른발', 175, 65, '영국', 300, '92/12/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '안드레아스 퍼레이라', '오른발', 178, 70, '브라질', 700, '96/01/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '아마드 디알로', '양발', 173, 72, '코트디아부르', 650, '02/07/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '프레드', '왼발', 169, 62, '브라질', 900, '93/03/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '브루노 페르난데스', '오른발', 179, 69, '포르투갈', 1300, '94/09/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '파쿤도 펠리스트리', '오른발', 175, 68, '우루과이', 400, '01/12/20');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '네마냐 마티치', '왼발', 194, 83, '세르비아', 600, '88/08/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '도니 반 더 비크', '오른발', 184, 74, '네덜란드', 800, '97/04/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '제임스 가너', '오른발', 182, 80, '영국', 200, '01/03/13');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '스콧 맥토미니', '오른발', 193, 90, '스코틀랜드', 700, '96/12/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '앙토니 마르시알', '오른발', 181, 76, '프랑스', 700, '95/12/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '마커스 래시퍼드', '오른발', 180, 70, '영국', 1200, '97/10/31');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '메이슨 그린우드', '양발', 181, 70, '영국', 1000, '01/10/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '에딘손 카바니', '오른발', 184, 71, '우루과이', 400, '87/02/14');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '타히트 총', '왼발', 185, 75, '네덜란드', 100, '99/12/04');

--리버풀
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '알리송 베케르', '오른발', 191, 91, '브라질', 1000, '92/10/02');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '아드리안', '오른발', 190, 77, '스페인', 250, '87/01/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '로리스 카리우스', '오른발', 189, 90, '독일', 200, '93/06/22');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '퀴빈 켈레허', '오른발', 188, 71, '아일랜드', 200, '98/11/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '마르셀로 피탈루가', '오른발', 191, 85, '독일', 300, '02/12/20');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '버질 판 데이크', '오른발', 193, 92, '네덜란드', 1400, '91/07/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '이브라히마 코나테', '오른발', 194, 95, '프랑스', 300, '99/05/25');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '즈 고메즈', '오른발', 188, 77, '영국', 800, '97/05/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '코스타스 치미카스', '왼발', 178, 70, '그리스', 100, '96/05/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '앤디 로버트슨', '왼발', 178, 72, '스코틀랜드', 1000, '94/03/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '조엘 마티프', '오른발', 195, 90, '독일', 800, '91/08/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '나다니엘 필립스', '오른발', 190, 84, '영국', 500, '97/03/21');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '트렌트 알렉산더아널드', '오른발', 175, 69, '영국', 1300, '98/10/07');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '네코 윌리엄스', '오른발', 183, 72, '웨일스', 500, '01/04/13');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '파비뉴', '오른발', 188, 78, '브라질', 800, '93/10/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '티아고 알칸타라', '오른발', 174, 70, '이탈리아', 700, '91/04/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '제임스 밀너', '오른발', 177, 80, '영국', 800, '86/01/04');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '나비 케이타', '오른발', 172, 64, '기니', 600, '95/02/10');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '조던 헨더슨', '오른발', 182, 80, '영국', 600, '90/06/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '앨랙스 옥슬레이드 체임벌린', '오른발', 180, 70, '영국', 500, '93/08/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '커티스 존스', '오른발', 185, 75, '영국', 400, '01/01/30');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '호베르투 피루미누', '오른발', 181, 76, '브라질', 800, '91/10/02');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '사디오 마네', '오른발', 175, 69, '세네갈', 1200, '92/04/10');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '모하메드 살라', '오른발', 175, 73, '이집트', 1550, '92/06/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '미나미노 타쿠미', '오른발', 174, 67, '일본', 600, '95/01/16');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '디오구 조타', '오른발', 178, 70, '포르투갈', 700, '96/12/04');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '디보크 오리기', '오른발', 185, 75, '벨기에', 400, '95/04/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '하비 엘리엇', '양발', 170, 67, '영국', 500, '03/04/04');

--첼시
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '에두아르 멘디', '오른발', 197, 93, '프랑스', 1000, '92/03/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '케파 아리자발라가', '오른발', 186, 90, '스페인', 800, '94/10/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '안토니오 뤼디거', '오른발', 190, 85, '독일', 1000, '93/03/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '마르코스 알론소', '왼발', 188, 81, '독일', 700, '90/12/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '티아고 실바', '오른발', 181, 82, '브라질', 600, '84/09/22');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '벤칠 웰', '왼발', 180, 78, '영국', 700, '96/12/21');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '리스 제임스', '오른발', 179, 91, '영국', 600, '99/12/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '조르지뉴', '오른발', 180, 68, '브라질', 700, '91/12/20');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '은골로 캉테', '오른발', 168, 72, '프랑스', 1300, '91/03/29');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '마테오코바 치치', '오른발', 176, 82, '오스트리아', 900, '94/05/06');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '로멜로 루카쿠', '양발', 191, 103, '벨기에', 1000, '93/05/13');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '티모 베르너', '오른발', 180, 75, '독일', 900, '96/03/06');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '지예흐', '왼발', 180, 70, '네덜란드', 1000, '93/03/19');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '하베르츠', '왼발', 190, 83, '독일', 1200, '99/06/11');

--아스널
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '레노', '오른발', 190, 83, '독일', 500, '92/03/04');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '가브리엘', '오른발', 185, 72, '브라질', 600, '90/11/26');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '토미야스', '오른발', 188, 78, '일본', 500, '98/11/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '베예린', '오른발', 178, 74, '스페인', 600, '95/03/19');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '사카', '왼발', 178, 73, '영국', 700, '01/09/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '외데 가르드', '왼발', 176, 68, '노르웨이', 300, '98/12/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '자카', '왼발', 186, 80, '스위스', 500, '92/09/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '귀엥두지', '오른발', 184, 80, '프랑스', 400, '99/04/14');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '라카제트', '오른발', 176, 77, '프랑스', 700, '91/05/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '아우바 메양', '오른발', 187, 80, '프랑스', 800, '89/06/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '페페', '오른발', 188, 81, '브라질', 500, '83/02/26');

insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '호날두', '오른발', 187, 83, '포르투갈', 1500, '85/02/05');

-- 스폰서 인서트
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', '벤츠', 30, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '아디다스', '벤츠', 52, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', '아우디', 31, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '스베누', 'BMW', 4, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '스베누', '아우디', 1, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '아디다스', '벤츠', 88, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', '벤츠', 95, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', 'BMW', 83, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '스베누', '벤츠', 28, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '아디다스', 'BMW', 49, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', '벤츠', 26, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '스베누', '폭스바겐', 11, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '아디다스', '벤츠', 2, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', '벤츠', 66, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', 'BMW', 105, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', '벤츠', 119, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '스베누', '현대자동차', 106, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', '벤츠', 124, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '아디다스', '현대자동차', 134, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '나이키', '벤츠', 121, 'EPL');

-- 수상내역 인서트
--호날두
insert into AWARD values('2017발롱도르',136,'EPL');
insert into AWARD values('2017FIFA올해의선수상',136,'EPL');
insert into AWARD values('16-17UEFA올해의선수',136,'EPL');
insert into AWARD values('14-15유러피언골든슈',136,'EPL');
 --손흥민
insert into AWARD values('2020푸스카스상',30,'EPL');
--살라
insert into AWARD values('2018푸스카스상',106,'EPL');
--알리송
insert into AWARD values('2019',83,'EPL');
--조르지뉴
insert into AWARD values('20-21UEFA올해의선수',118,'EPL');
--반데이크
insert into AWARD values('18-19UEFA올해의선수',88,'EPL');

-- 선수전적 인서트
--맨시티 토트넘 울버햄튼 에버튼  맨유 리버풀 첼시 아스널
--선수코드,골,어시,공격포인트,리그
--해리케인
insert into RECORD values(31,23,14,37,'EPL'); 
--모하메드살라
insert into RECORD values(106,22,5,27,'EPL');
--브루노페르난데스
insert into RECORD values(72,18,12,30,'EPL');
--손흥민
insert into RECORD values(30,17,10,27,'EPL');
--일카이귄도안
insert into RECORD values(5,13,2,15,'EPL');
--라카제트
insert into RECORD values(133,13,1,14,'EPL');
--사디오 마네
insert into RECORD values(105,11,8,19,'EPL');
--에딘손카바니
insert into RECORD values(81,10,3,13,'EPL');
--니콜라페페
insert into RECORD values(135,10,1,11,'EPL');
--아우바메양
insert into RECORD values(134,10,3,13,'EPL');
--라힘스털링
insert into RECORD values(2,10,7,17,'EPL');
--디오고조타
insert into RECORD values(108,9,0,9,'EPL');
--리야드마레즈
insert into RECORD values(4,9,6,15,'EPL');
--필포든
insert into RECORD values(10,9,5,14,'EPL');
--가브리엘제수스
insert into RECORD values(3,9,4,13,'EPL');
--피르미누
insert into RECORD values(104,9,7,16,'EPL');
--조르지뉴
insert into RECORD values(118,7,2,9,'EPL');
--그린우드
insert into RECORD values(80,7,2,9,'EPL');
--히샬리송
insert into RECORD values(51,7,3,10,'EPL');
--데브라위너
insert into RECORD values(1,6,12,18,'EPL');
--잭그릴리쉬
insert into RECORD values(6,6,10,16,'EPL');
--티모베르너
insert into RECORD values(122,6,8,14,'EPL');
--사카
insert into RECORD values(129,5,3,8,'EPL');
--후벤네베스
insert into RECORD values(36,5,1,6,'EPL');
--라울히메네즈
insert into RECORD values(40,4,0,4,'EPL');
--마르시알
insert into RECORD values(78,4,3,7,'EPL');
--존 스톤스
insert into RECORD values(12,4,0,4,'EPL');
--하베르츠
insert into RECORD values(124,4,3,7,'EPL');
--맥토미니
insert into RECORD values(77,4,1,5,'EPL');
--폴 포그바
insert into RECORD values(66,3,3,6,'EPL');
--벤 칠웰
insert into RECORD values(116,3,5,8,'EPL');

-- 매니저 인서트
insert into MANAGER values(MNG_SEQ.nextval, '제임스', 136,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '클락', 19,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '폴워커', 1,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '빈디젤', 119,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '스타뎀', 115,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '브라이언', 121,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '맥스', 105,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '루크홉스', 106,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '윌리엄', 66,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '테즈', 58,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '해리', 52,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '엠마왓슨', 41,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '루퍼트', 51,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '위즐리', 39,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '다니엘', 31,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '도미닉', 30,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '토레토', 2,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '데카드', 6,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '드웨인존슨', 11,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '레티', 26,'EPL');

-- 구단 인서트
insert into TEAM values(1,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(2,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(3,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(4,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(5,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(6,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(7,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(8,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(9,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(10,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(11,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(12,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(13,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(14,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(15,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(16,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(17,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');
insert into TEAM values(18,'에티하드스타디움','맨체스터시티',80000,'1894/01/01','맨체스터','푸마','과르디올라','EPL');


insert into TEAM values(52,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(53,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(54,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(55,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(56,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(57,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(58,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(59,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(60,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(61,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(62,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(63,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(64,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(65,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(66,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(67,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(68,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(69,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(70,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(71,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(72,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(73,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(74,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(75,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(76,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(77,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(78,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(79,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(80,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(81,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');
insert into TEAM values(82,'올드트래포드','맨체스터유나이티드',50000,'1878/01/01','맨체스터','아디다스','솔샤르','EPL');

insert into TEAM values(19,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(20,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(21,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(22,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(23,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(24,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(25,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(26,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(27,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(28,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(29,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(30,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');
insert into TEAM values(31,'토트넘홋스퍼스타디움','토트넘',40000,'1882/01/01','런던','나이키','콘테','EPL');

insert into TEAM values(111,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(112,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(113,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(114,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(115,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(116,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(117,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(118,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(119,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(120,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(121,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(122,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(123,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');
insert into TEAM values(124,'스탬퍼드브리지','첼시',50000,'1905/01/01','런던','아디다스','투헬','EPL');

insert into TEAM values(83,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(84,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(85,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(86,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(87,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(88,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(89,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(90,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(91,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(92,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(93,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(94,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(95,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(96,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(97,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(98,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(99,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(100,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(101,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(102,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(103,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(104,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(105,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(106,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(107,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(108,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(109,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');
insert into TEAM values(110,'안필드','리버풀',40000,'1892/01/01','리버풀','나이키','클롭','EPL');

insert into TEAM values(125,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(126,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(127,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(128,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(129,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(130,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(131,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(132,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(133,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(134,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');
insert into TEAM values(135,'에미레이트스타디움','아스널',30000,'1886/01/01','런던','아디다스','아르테타','EPL');

-- 거래내역 인서트
-- 구매 인서트
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 1, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 2, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 11, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 33, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 23, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 56, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 78, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 91, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 14, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'kiho1212@naver.com', 25, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 111, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 101, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 56, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 57, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 45, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 70, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 23, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 25, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'GodByengChel27@naver.com', 27, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 28, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 29, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 36, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 39, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 90, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 60, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 76, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAK36@gmail.com', 23, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 10, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 33, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 36, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 38, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 41, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 47, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 92, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 86, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 75, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 56, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'HAWN32@hanmail.net', 59, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 43, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 42, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 57, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 77, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 66, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 45, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 36, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 87, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 90, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 11, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'qnrhrqjatn@naver.com', 3, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'alsienk@nate.com', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'alsienk@nate.com', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'alsienk@nate.com', 34, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'alsienk@nate.com', 38, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'alsienk@nate.com', 99, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'alsienk@nate.com', 101, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aeofjoz184@daum.net', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aeofjoz184@daum.net', 77, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aeofjoz184@daum.net', 99, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aeofjoz184@daum.net', 82, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aeofjoz184@daum.net', 88, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aeofjoz184@daum.net', 75, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wocsowi11@nate.com', 10, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wocsowi11@nate.com', 8, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wocsowi11@nate.com', 6, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wocsowi11@nate.com', 5, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wocsowi11@nate.com', 55, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wocsowi11@nate.com', 44, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wnsidkdh1148@naver.com', 43, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wnsidkdh1148@naver.com', 47, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wnsidkdh1148@naver.com', 4, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wnsidkdh1148@naver.com', 34, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wnsidkdh1148@naver.com', 67, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wnsidkdh1148@naver.com', 66, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosos!!42@nate.com', 64, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosos!!42@nate.com', 54, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosos!!42@nate.com', 76, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosos!!42@nate.com', 74, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosos!!42@nate.com', 32, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosos!!42@nate.com', 30, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosiei963@daum.net', 91, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosiei963@daum.net', 93, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosiei963@daum.net', 54, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosiei963@daum.net', 72, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosiei963@daum.net', 75, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'dosiei963@daum.net', 30, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sdjeicndiapwo@gmail.com', 20, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sdjeicndiapwo@gmail.com', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sdjeicndiapwo@gmail.com', 40, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sdjeicndiapwo@gmail.com', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sdjeicndiapwo@gmail.com', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sdjeicndiapwo@gmail.com', 14, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'QASDZXZ456@gmail.com', 16, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'QASDZXZ456@gmail.com', 14, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'QASDZXZ456@gmail.com', 28, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'QASDZXZ456@gmail.com', 25, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'QASDZXZ456@gmail.com', 45, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'QASDZXZ456@gmail.com', 67, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'eisn7752@daum.net', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'eisn7752@daum.net', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'eisn7752@daum.net', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'eisn7752@daum.net', 36, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'eisn7752@daum.net', 47, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'eisn7752@daum.net', 56, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aopps@nate.com', 78, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aopps@nate.com', 79, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aopps@nate.com', 65, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aopps@nate.com', 54, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aopps@nate.com', 43, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aopps@nate.com', 37, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'TjlscE866@hanmail.net', 32, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'TjlscE866@hanmail.net', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'TjlscE866@hanmail.net', 78, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'TjlscE866@hanmail.net', 65, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'TjlscE866@hanmail.net', 46, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'TjlscE866@hanmail.net', 90, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicn4485@gmail.com', 101, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicn4485@gmail.com', 121, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicn4485@gmail.com', 14, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicn4485@gmail.com', 61, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicn4485@gmail.com', 48, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicn4485@gmail.com', 89, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'DISJD&*75@nate.com', 102, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'DISJD&*75@nate.com', 106, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'DISJD&*75@nate.com', 117, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'DISJD&*75@nate.com', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'DISJD&*75@nate.com', 41, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'DISJD&*75@nate.com', 61, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicndh1@naver.com', 109, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicndh1@naver.com', 129, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicndh1@naver.com', 135, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicndh1@naver.com', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicndh1@naver.com', 20, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sjeicndh1@naver.com', 11, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'assod09@daum.net', 70, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'assod09@daum.net', 80, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'assod09@daum.net', 54, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'assod09@daum.net', 37, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'assod09@daum.net', 108, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'assod09@daum.net', 115, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ehddhd422@gmail.com', 123, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ehddhd422@gmail.com', 135, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ehddhd422@gmail.com', 44, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ehddhd422@gmail.com', 37, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ehddhd422@gmail.com', 20, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ehddhd422@gmail.com', 10, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ENddol1**@hanmail.net', 111, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ENddol1**@hanmail.net', 106, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ENddol1**@hanmail.net', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ENddol1**@hanmail.net', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ENddol1**@hanmail.net', 69, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'ENddol1**@hanmail.net', 50, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'tndosl@daum.net', 70, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'tndosl@daum.net', 90, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'tndosl@daum.net', 36, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'tndosl@daum.net', 87, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'tndosl@daum.net', 72, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'tndosl@daum.net', 49, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'IdCWsa48@gmail.com', 75, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'IdCWsa48@gmail.com', 38, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'IdCWsa48@gmail.com', 68, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'IdCWsa48@gmail.com', 24, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'IdCWsa48@gmail.com', 102, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'IdCWsa48@gmail.com', 125, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'socbc@hanmail.net', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'socbc@hanmail.net', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'socbc@hanmail.net', 78, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'socbc@hanmail.net', 49, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'socbc@hanmail.net', 50, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'socbc@hanmail.net', 40, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aowocnsh1927@daum.net', 20, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aowocnsh1927@daum.net', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aowocnsh1927@daum.net', 46, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aowocnsh1927@daum.net', 27, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aowocnsh1927@daum.net', 18, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'aowocnsh1927@daum.net', 28, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sorkdlwl@nate.com', 43, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sorkdlwl@nate.com', 23, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sorkdlwl@nate.com', 34, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sorkdlwl@nate.com', 38, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sorkdlwl@nate.com', 57, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'sorkdlwl@nate.com', 21, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wpcjdh@naver.com', 50, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wpcjdh@naver.com', 26, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wpcjdh@naver.com', 46, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wpcjdh@naver.com', 83, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wpcjdh@naver.com', 28, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'wpcjdh@naver.com', 48, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cndhss113@daum.net', 55, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cndhss113@daum.net', 40, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cndhss113@daum.net', 104, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cndhss113@daum.net', 125, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cndhss113@daum.net', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cndhss113@daum.net', 31, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cosoekdn@gmail.com', 41, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cosoekdn@gmail.com', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cosoekdn@gmail.com', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cosoekdn@gmail.com', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cosoekdn@gmail.com', 16, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'cosoekdn@gmail.com', 27, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'EDC2245@nate.com', 18, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'EDC2245@nate.com', 27, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'EDC2245@nate.com', 68, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'EDC2245@nate.com', 54, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'EDC2245@nate.com', 28, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'EDC2245@nate.com', 47, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'SDWw1#@hanmail.net', 77, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'SDWw1#@hanmail.net', 7, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'SDWw1#@hanmail.net', 17, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'SDWw1#@hanmail.net', 97, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'SDWw1#@hanmail.net', 37, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 0, 'SDWw1#@hanmail.net', 47, 'EPL');


-- 판매 인서트
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'kiho1212@naver.com', 56, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'kiho1212@naver.com', 78, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'GodByengChel27@naver.com', 101, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'GodByengChel27@naver.com', 45, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'HAK36@gmail.com', 29, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'HAK36@gmail.com', 60, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'HAWN32@hanmail.net', 92, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'HAWN32@hanmail.net', 41, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'qnrhrqjatn@naver.com', 43, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'qnrhrqjatn@naver.com', 42, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'aowocnsh1927@daum.net', 46, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'QASDZXZ456@gmail.com', 28, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'ENddol1**@hanmail.net', 31, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 1, 'DISJD&*75@nate.com', 61, 'EPL');


-- 찜하기 인서트

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 2, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 3, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 4, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 5, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 6, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 14, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 33, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 77, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 99, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'kiho1212@naver.com', 111, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 5, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 6, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 7, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 9, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 111, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 112, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 109, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 62, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 39, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'GodByengChel27@naver.com', 47, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 92, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 38, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 57, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 29, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 121, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 122, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 133, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 93, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAK36@gmail.com', 34, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 105, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 106, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 3, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 8, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 19, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 49, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 57, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 81, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 61, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'HAWN32@hanmail.net', 41, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 82, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 64, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 37, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 83, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 95, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 18, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 6, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 3, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 74, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 20, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'qnrhrqjatn@naver.com', 10, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'alsienk@nate.com', 15, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'alsienk@nate.com', 3, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'alsienk@nate.com', 5, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'alsienk@nate.com', 47, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'alsienk@nate.com', 43, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'alsienk@nate.com', 84, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aeofjoz184@daum.net', 77, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aeofjoz184@daum.net', 62, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aeofjoz184@daum.net', 51, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aeofjoz184@daum.net', 94, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aeofjoz184@daum.net', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aeofjoz184@daum.net', 68, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wocsowi11@nate.com', 72, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wocsowi11@nate.com', 79, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wocsowi11@nate.com', 40, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wocsowi11@nate.com', 52, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wocsowi11@nate.com', 63, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wocsowi11@nate.com', 1, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wnsidkdh1148@naver.com', 2, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wnsidkdh1148@naver.com', 6, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wnsidkdh1148@naver.com', 1, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wnsidkdh1148@naver.com', 11, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wnsidkdh1148@naver.com', 82, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wnsidkdh1148@naver.com', 25, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosos!!42@nate.com', 19, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosos!!42@nate.com', 11, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosos!!42@nate.com', 28, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosos!!42@nate.com', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosos!!42@nate.com', 58, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosos!!42@nate.com', 71, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosiei963@daum.net', 101, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosiei963@daum.net', 127, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosiei963@daum.net', 18, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosiei963@daum.net', 58, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosiei963@daum.net', 15, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'dosiei963@daum.net', 32, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sdjeicndiapwo@gmail.com', 68, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sdjeicndiapwo@gmail.com', 103, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sdjeicndiapwo@gmail.com', 106, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sdjeicndiapwo@gmail.com', 113, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sdjeicndiapwo@gmail.com', 23, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sdjeicndiapwo@gmail.com', 69, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'QASDZXZ456@gmail.com', 104, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'QASDZXZ456@gmail.com', 105, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'QASDZXZ456@gmail.com', 14, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'QASDZXZ456@gmail.com', 12, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'QASDZXZ456@gmail.com', 8, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'QASDZXZ456@gmail.com', 2, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'eisn7752@daum.net', 4, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'eisn7752@daum.net', 9, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'eisn7752@daum.net', 105, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'eisn7752@daum.net', 100, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'eisn7752@daum.net', 97, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'eisn7752@daum.net', 79, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aopps@nate.com', 110, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aopps@nate.com', 17, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aopps@nate.com', 46, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aopps@nate.com', 37, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aopps@nate.com', 86, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aopps@nate.com', 120, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'TjlscE866@hanmail.net', 130, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'TjlscE866@hanmail.net', 42, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'TjlscE866@hanmail.net', 5, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'TjlscE866@hanmail.net', 85, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'TjlscE866@hanmail.net', 46, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'TjlscE866@hanmail.net', 96, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicn4485@gmail.com', 97, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicn4485@gmail.com', 23, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicn4485@gmail.com', 98, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicn4485@gmail.com', 101, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicn4485@gmail.com', 7, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicn4485@gmail.com', 3, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'DISJD&*75@nate.com', 7, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'DISJD&*75@nate.com', 4, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'DISJD&*75@nate.com', 100, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'DISJD&*75@nate.com', 24, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'DISJD&*75@nate.com', 63, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'DISJD&*75@nate.com', 95, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicndh1@naver.com', 1, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicndh1@naver.com', 63, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicndh1@naver.com', 82, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicndh1@naver.com', 47, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicndh1@naver.com', 86, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sjeicndh1@naver.com', 84, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'assod09@daum.net', 105, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'assod09@daum.net', 117, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'assod09@daum.net', 24, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'assod09@daum.net', 41, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'assod09@daum.net', 30, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'assod09@daum.net', 40, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ehddhd422@gmail.com', 136, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ehddhd422@gmail.com', 53, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ehddhd422@gmail.com', 45, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ehddhd422@gmail.com', 76, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ehddhd422@gmail.com', 87, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ehddhd422@gmail.com', 2, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ENddol1**@hanmail.net', 6, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ENddol1**@hanmail.net', 35, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ENddol1**@hanmail.net', 58, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ENddol1**@hanmail.net', 8, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ENddol1**@hanmail.net', 46, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'ENddol1**@hanmail.net', 48, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'tndosl@daum.net', 7, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'tndosl@daum.net', 36, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'tndosl@daum.net', 27, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'tndosl@daum.net', 58, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'tndosl@daum.net', 79, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'tndosl@daum.net', 39, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'IdCWsa48@gmail.com', 4, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'IdCWsa48@gmail.com', 78, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'IdCWsa48@gmail.com', 9, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'IdCWsa48@gmail.com', 57, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'IdCWsa48@gmail.com', 46, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'IdCWsa48@gmail.com', 127, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'socbc@hanmail.net', 135, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'socbc@hanmail.net', 126, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'socbc@hanmail.net', 2, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'socbc@hanmail.net', 7, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'socbc@hanmail.net', 5, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'socbc@hanmail.net', 16, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aowocnsh1927@daum.net', 93, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aowocnsh1927@daum.net', 24, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aowocnsh1927@daum.net', 47, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aowocnsh1927@daum.net', 57, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aowocnsh1927@daum.net', 125, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'aowocnsh1927@daum.net', 68, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sorkdlwl@nate.com', 79, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sorkdlwl@nate.com', 53, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sorkdlwl@nate.com', 16, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sorkdlwl@nate.com', 48, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sorkdlwl@nate.com', 64, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'sorkdlwl@nate.com', 97, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wpcjdh@naver.com', 1, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wpcjdh@naver.com', 8, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wpcjdh@naver.com', 15, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wpcjdh@naver.com', 43, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wpcjdh@naver.com', 101, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'wpcjdh@naver.com', 124, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cndhss113@daum.net', 36, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cndhss113@daum.net', 86, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cndhss113@daum.net', 5, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cndhss113@daum.net', 22, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cndhss113@daum.net', 105, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cndhss113@daum.net', 112, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cosoekdn@gmail.com', 46, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cosoekdn@gmail.com', 68, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cosoekdn@gmail.com', 26, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cosoekdn@gmail.com', 69, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'cosoekdn@gmail.com', 36, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'EDC2245@nate.com', 102, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'EDC2245@nate.com', 133, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'EDC2245@nate.com', 20, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'EDC2245@nate.com', 26, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'EDC2245@nate.com', 110, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'EDC2245@nate.com', 43, 'EPL');


insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'SDWw1#@hanmail.net', 103, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'SDWw1#@hanmail.net', 1, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'SDWw1#@hanmail.net', 47, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'SDWw1#@hanmail.net', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'SDWw1#@hanmail.net', 58, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 2, 'SDWw1#@hanmail.net', 37, 'EPL');



-- 찜 취소 인서트
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'kiho1212@naver.com', 14, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'kiho1212@naver.com', 33, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'kiho1212@naver.com', 99, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'GodByengChel27@naver.com', 47, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'GodByengChel27@naver.com', 39, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'GodByengChel27@naver.com', 7, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'HAK36@gmail.com', 31, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'HAK36@gmail.com', 121, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'HAK36@gmail.com', 93, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'HAWN32@hanmail.net', 19, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'HAWN32@hanmail.net', 57, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'HAWN32@hanmail.net', 49, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'qnrhrqjatn@naver.com', 10, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'qnrhrqjatn@naver.com', 20, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'qnrhrqjatn@naver.com', 74, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'alsienk@nate.com', 47, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'alsienk@nate.com', 3, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'alsienk@nate.com', 84, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'ENddol1**@hanmail.net', 46, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'ENddol1**@hanmail.net', 48, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'aeofjoz184@daum.net', 77, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'aeofjoz184@daum.net', 94, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'sjeicn4485@gmail.com', 101, 'EPL');
insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'sjeicn4485@gmail.com', 7, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'cosoekdn@gmail.com', 46, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'ehddhd422@gmail.com', 76, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'eisn7752@daum.net', 100, 'EPL');

insert into CONTRACT(C_NUMBER, C_DEAL, M_EMAIL, P_ID, L_NAME) values(CONTRACT_SEQ.nextval, 3, 'IdCWsa48@gmail.com', 9, 'EPL');


124   하베르츠