--����̶�� ���� ���� �޷����� ���ܿ���
--���� ��ý�Ʈ��!! ���౸��..

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

--����
create table LEAGUE(
	L_NAME VARCHAR2(30) constraint LEA_NAME_NN not null,
	L_NATION VARCHAR2(30) constraint LEA_NATION_NN not null,
	constraint LG_PK primary key(L_NAME)
);


--ȸ��
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


--����
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
	constraint PLA_CK2 check (P_MAINFOOT in ('������', '�޹�', '���'))
);

create SEQUENCE PLAYER_SEQ start with 1 increment by 1 nocache;

--���
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


--���󳻿�
create table AWARD(
	P_AWARD VARCHAR2(30),
	P_ID NUMBER constraint AWA_PID_NN not null,
	L_NAME VARCHAR2(30) constraint AWA_LNAME_NN not null,
	constraint AWA_PK primary key(P_AWARD),
	constraint AWA_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);

--��������
create table RECORD(
	P_ID NUMBER,
	P_GOAL NUMBER(3) constraint REC_GOAL_NN not null,
	P_ASSIST NUMBER(3) constraint REC_ASSIST_NN not null,
	P_POINT NUMBER(3) constraint REC_POINT_NN not null,
	L_NAME VARCHAR2(30),
	constraint REC_PK primary key(P_ID),
	constraint REC_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);

--����
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

--�Ŵ���
create table MANAGER(
	MNG_CODE NUMBER,
	MNG_NAME VARCHAR2(20) not null,
	P_ID NUMBER not null,
	L_NAME VARCHAR2(30) not null,
	constraint MNG_PK primary key(MNG_CODE),
	constraint MNG_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);
create SEQUENCE MNG_SEQ start with 1 increment by 1 nocache;

--����������
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
	constraint MY_PLA_CK2 check (P_MAINFOOT in ('������', '�޹�', '���'))
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
   constraint WL_CK2 check (P_MAINFOOT in ('������', '�޹�', '���'))
);



-- ���ν���
-- �ܾ� ���� ���ν���
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


-- ���ż��� ���� ���ν���
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


-- �ܾ� ���� ���ν��� (�Ǹ��Ҷ� ������ 5����)
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

-- ���� ���� ���ν���
create or replace procedure MY_PLAYER_DEL(b_ID_DEL in PLAYER.P_ID%TYPE, b_MEM_DEL in MEMBER.M_EMAIL%TYPE)
is

begin
   delete from MY_PLAYER where P_ID=b_ID_DEL and M_EMAIL = b_MEM_DEL;
end;
/



-- ���� ���� ��� ���� ���ν���
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


-- ���� ���� ��� ���� ���ν���
create or replace procedure MY_WL_DEL(b_ID_WL_DEL in PLAYER.P_ID%TYPE, b_MEM_WL_DEL in MEMBER.M_EMAIL%TYPE)
is
begin
   delete from WISHILIST where P_ID=b_ID_WL_DEL and M_EMAIL = b_MEM_WL_DEL;
end;
/


--Ʈ����

--CONTRACT C_DEAL (0 = ����, 1 = �Ǹ�, 2 = ��, 3 = �����)
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



-- ���� �μ�Ʈ
insert into LEAGUE values('EPL', '����');

-- ȸ�� �μ�Ʈ
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('kiho1212@naver.com','EPL','010-6618-4826','����ȣ','rlgh27!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('GodByengChel27@naver.com','EPL','010-1485-6642','�ź�ö','sdfe4823!^@#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('HAK36@gmail.com','EPL','010-4358-1845','������','HAK485@');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('HAWN32@hanmail.net','EPL','010-3328-7536','��ȯ��','HAWN184895423@#&$');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('qnrhrqjatn@naver.com','EPL','010-4094-6892','�ڹ���','vbn2489156758!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('alsienk@nate.com','EPL','010-4862-1759','�輺��','disoek@^');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('aeofjoz184@daum.net','EPL','010-9428-7149','��ȣ��','tjdghrbs52!&#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('wocsowi11@nate.com','EPL','010-9916-4955','����ȯ','eocks12@');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('wnsidkdh1148@naver.com','EPL','010-4428-7115','�Ź���','eickso119!!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('dosos!!42@nate.com','EPL','010-4553-9421','������','qufdlwhDLE1!@#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('dosiei963@daum.net','EPL','010-4428-7599','������','asdfws184#$*');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('sdjeicndiapwo@gmail.com','EPL','010-1785-1184','�����','tnwl4456!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('QASDZXZ456@gmail.com','EPL','010-4115-9366','�輼��','TodNaktdlT8!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('eisn7752@daum.net','EPL','010-4773-1177','�����','wodnjsdl74*!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('aopps@nate.com','EPL','010-4958-7714','�ֺ���','asdf1548!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('TjlscE866@hanmail.net','EPL','010-1148-6945','������','dlRJnshD85$$');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('sjeicn4485@gmail.com','EPL','010-4482-4926','���','sneidl!@#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('DISJD&*75@nate.com','EPL','010-9233-7442','�̱���','AOxshhW698&@!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('sjeicndh1@naver.com','EPL','010-9752-4726','�ֹ���','eicnsh4#!!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('assod09@daum.net','EPL','010-1845-8599','����','gmlgmldj45^%');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('ehddhd422@gmail.com','EPL','010-7488-6428','�����','cncdhddy188@@!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('ENddol1**@hanmail.net','EPL','010-5161-7923','����','WlsdLL1!!!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('tndosl@daum.net','EPL','010-4826-7595','������','qpsomi1!@');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('IdCWsa48@gmail.com','EPL','010-7455-1642','�߾ȼ�','DICSswn4878@#$');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('socbc@hanmail.net','EPL','010-9958-4772','�ڻ���','sddccitkdwp**^');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('aowocnsh1927@daum.net','EPL','010-3128-7995','�����','tlaqo19!!!^');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('sorkdlwl@nate.com','EPL','010-6882-1321','�ֹ輺','qocndajgk488$$@');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('wpcjdh@naver.com','EPL','010-3221-6354','�����','wnssshe41!@#$');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('cndhss113@daum.net','EPL','010-7422-3396','�ż���','tjdqo96!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('cosoekdn@gmail.com','EPL','010-7582-2447','������','whdnwls4852@!');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('EDC2245@nate.com','EPL','010-1447-9875','���̼�','clsoDDD144^#');
insert into MEMBER(M_EMAIL,L_NAME,M_PHONE,M_NAME,M_PW) values('SDWw1#@hanmail.net','EPL','010-4288-7119','��ȯ','Ddehncn2!^^');

-- �౸���� �μ�Ʈ
--��ü���� ��Ƽ
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ɺ� ���������', '������', 181, 70, '���⿡', 1300, '91/06/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '���� ���и�', '������', 170, 69, '����', 1140, '94/12/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '���긮�� ������', '������', 175, 73, '�����', 1190, '94/12/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '���ߵ� ������', '�޹�', 179, 62, '������', 800, '91/02/21');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '��ī�� �ϵ���', '������', 180, 80, '����', 600, '90/10/24');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�� �׸�����', '������', 182, 78, '����', 1300, '95/09/10');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ε帮', '������', 191, 82, '������', 850, '96/06/26');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�����������ǹ�', '�޹�', 173, 64, '��������', 900, '94/08/10');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�丣������', '������', 179, 67, '�����', 800, '85/05/04');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�� ����', '�޹�', 171, 69, '����', 1100, '00/05/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', 'ī�� ��Ŀ', '������', 183, 83, '����', 600, '90/05/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�� ���潺', '������', 188, 76, '��������', 800, '94/05/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���̼� ����', '������', 180, 75, '�״�����', 200, '95/02/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '��þ��', '������', 175, 64, '��ũ���̳�', 1500, '96/12/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '������Ʈ', '������', 191, 86, '������', 550, '94/05/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���ڹ� ���', '�޹�', 185, 85, '������', 400, '94/07/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�־� ĭ����', '������', 182, 74, '��������', 750, '94/05/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '��������', '�޹�', 188, 86, '�����', 600, '93/08/17');

--��Ʈ��
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '�ް� �丮��', '�޹�', 188, 82, '������', 300, '86/12/26');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�������� �����', '�޹�', 178, 68, '������', 400, '96/12/16');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', 'ũ����Ƽ�� �θ޷�', '�޹�', 185, 79, '�Ƹ���Ƽ��', 600, '98/04/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���޸��� �ξ�', '�޹�', 183, 79, '�����', 500, '99/01/14');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���� ���̾�', '������', 190, 90, '����', 300, '94/01/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�ٺ�� ��ü��', '������', 187, 79, '�ݷҺ��', 200, '96/06/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�μ���', '�޹�', 177, 68, '�Ƹ���Ƽ��', 600, '96/04/09');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���� �˸�', '������', 188, 80, '����', 700, '96/04/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '��������', '������', 179, 76, '������', 900, '96/12/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', 'ȣ�̺񿡸�', '������', 185, 84, '����ũ', 600, '95/08/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '��������', '�޹�', 178, 73, '�״�����', 300, '97/10/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�����', '���', 183, 78, '���ѹα�', 1100, '92/07/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�ظ� ����', '���', 188, 89, '����', 1300, '93/07/28');

--�����ư
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', 'ȣ�� ��', '������', 192, 84, '��������', 200, '93/01/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�ƽ� ų��', '�޹�', 194, 89, '����', 300, '97/05/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�ڳ� �ڵ�', '������', 186, 80, '����', 200,  '93/02/25');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�ڼ� ���޵�', '������', 177, 69, '��������', 600,  '93/11/16');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ĺ� �׺���', '������', 180, 80, '��������', 900, '97/03/13');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�־� ��Ƽ��', '���', 170, 61, '��������', 400, '86/09/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���ȴ� ����Ŀ', '������', 188, 76, '���⿡', 100, '95/04/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�ƴٸ� Ʈ�����', '������', 178, 72, '������', 700, '96/01/25');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '��� ���޳���', '������', 190, 76, '�߽���', 900, '91/05/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', 'Ȳ����', '������', 177, 77, '���ѹα�', 600, '96/01/26');

--����ư
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '���� ������', '�޹�', 185, 77, '����', 200, '94/03/07');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '����Ŭ Ų', '������', 170, 70, '����', 400, '93/01/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '��ī ��', '�޹�', 178, 74, '������', 500, '93/07/20');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���� �̳�', '������', 195, 94, '�ݷҺ��', 300, '94/09/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ص�ν� Ÿ�Ʈ', '�޹�', 181, 81, '����', 300, '91/07/16');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ȵ巹 ��޽�', '������', 188, 84, '��������', 600, '93/07/30');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�еѶ� ����', '�޹�', 184, 76, '������', 500, '93/01/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�������� �׷���', '���', 180, 74, '����', 300, '96/06/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�˷��� �̿���', '������', 180, 75, '����������', 500, '96/05/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '��������', '���', 179, 75, '�����', 1000, '97/05/10');

--����
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '�ٺ�� �� ���', '������', 192, 82, '������', 800, '90/11/07');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '�� �׷�Ʈ', '������', 193, 83, '����', 300, '83/01/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '�� �����', '������', 188, 85, '����', 200, '97/03/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���丣 ��������', '���', 187, 80, '������', 400, '94/07/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���� ����', '������', 187, 77, '��Ʈ��ξƸ�', 650, '94/04/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�� ����', '������', 185, 86, '����', 600, '92/02/21');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�ظ� �Ű��̾�', '������', 194, 100, '����', 1000, '93/03/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '����� �޷�', '������', 184, 78, '��������', 500, '90/03/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '��ũ ��', '�޹�', 185, 75, '����', 800, '95/07/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�˷��� �ڷ���', '�޹�', 181, 67, '�����', 350, '92/12/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���� �Ϻ��ī', '������', 183, 72, '����', 700, '97/11/26');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�귣�� ��������', '������', 171, 63, '����', 250, '00/09/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�Ǽ� Ƣ������', '������', 186, 72, '����', 100, '97/11/14');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�׵� ���', '������', 183, 78, '����', 100, '02/04/30');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�� ���׹�', '���', 191, 84, '������', 1040, '93/03/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ľ� ��Ÿ', '�޹�', 170, 63, '������', 600, '88/04/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���� ������', '������', 175, 65, '����', 300, '92/12/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ȵ巹�ƽ� �۷��̶�', '������', 178, 70, '�����', 700, '96/01/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�Ƹ��� ��˷�', '���', 173, 72, '��Ʈ��ƺθ�', 650, '02/07/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '������', '�޹�', 169, 62, '�����', 900, '93/03/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���� �丣������', '������', 179, 69, '��������', 1300, '94/09/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���ﵵ �縮��Ʈ��', '������', 175, 68, '������', 400, '01/12/20');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�׸��� ��Ƽġ', '�޹�', 194, 83, '�������', 600, '88/08/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���� �� �� ��ũ', '������', 184, 74, '�״�����', 800, '97/04/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���ӽ� ����', '������', 182, 80, '����', 200, '01/03/13');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���� ����̴�', '������', 193, 90, '����Ʋ����', 700, '96/12/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '����� �����þ�', '������', 181, 76, '������', 700, '95/12/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '��Ŀ�� �����۵�', '������', 180, 70, '����', 1200, '97/10/31');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '���̽� �׸����', '���', 181, 70, '����', 1000, '01/10/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '����� ī�ٴ�', '������', 184, 71, '������', 400, '87/02/14');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', 'Ÿ��Ʈ ��', '�޹�', 185, 75, '�״�����', 100, '99/12/04');

--����Ǯ
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '�˸��� ���ɸ�', '������', 191, 91, '�����', 1000, '92/10/02');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '�Ƶ帮��', '������', 190, 77, '������', 250, '87/01/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '�θ��� ī���콺', '������', 189, 90, '����', 200, '93/06/22');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '���� �̷���', '������', 188, 71, '���Ϸ���', 200, '98/11/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '�������� ��Ż�簡', '������', 191, 85, '����', 300, '02/12/20');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���� �� ����ũ', '������', 193, 92, '�״�����', 1400, '91/07/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�̺������ �ڳ���', '������', 194, 95, '������', 300, '99/05/25');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�� �����', '������', 188, 77, '����', 800, '97/05/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�ڽ�Ÿ�� ġ��ī��', '�޹�', 178, 70, '�׸���', 100, '96/05/12');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�ص� �ι�Ʈ��', '�޹�', 178, 72, '����Ʋ����', 1000, '94/03/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���� ��Ƽ��', '������', 195, 90, '����', 800, '91/08/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���ٴϿ� �ʸ���', '������', 190, 84, '����', 500, '97/03/21');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', 'Ʈ��Ʈ �˷�����Ƴε�', '������', 175, 69, '����', 1300, '98/10/07');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���� ��������', '������', 183, 72, '���Ͻ�', 500, '01/04/13');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ĺ�', '������', 188, 78, '�����', 800, '93/10/23');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', 'Ƽ�ư� ��ĭŸ��', '������', 174, 70, '��Ż����', 700, '91/04/11');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���ӽ� �г�', '������', 177, 80, '����', 800, '86/01/04');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���� ����Ÿ', '������', 172, 64, '���', 600, '95/02/10');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���� �����', '������', 182, 80, '����', 600, '90/06/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ٷ��� �������̵� ü�ӹ���', '������', 180, 70, '����', 500, '93/08/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', 'ĿƼ�� ����', '������', 185, 75, '����', 400, '01/01/30');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', 'ȣ������ �Ƿ�̴�', '������', 181, 76, '�����', 800, '91/10/02');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '���� ����', '������', 175, 69, '���װ�', 1200, '92/04/10');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '���ϸ޵� ���', '������', 175, 73, '����Ʈ', 1550, '92/06/15');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�̳��̳� Ÿ���', '������', 174, 67, '�Ϻ�', 600, '95/01/16');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '����� ��Ÿ', '������', 178, 70, '��������', 700, '96/12/04');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '��ũ ������', '������', 185, 75, '���⿡', 400, '95/04/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�Ϻ� ������', '���', 170, 67, '����', 500, '03/04/04');

--ÿ��
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '���ξƸ� ���', '������', 197, 93, '������', 1000, '92/03/01');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '���� �Ƹ��ڹ߶�', '������', 186, 90, '������', 800, '94/10/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '����Ͽ� ����', '������', 190, 85, '����', 1000, '93/03/03');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '�����ڽ� �˷м�', '�޹�', 188, 81, '����', 700, '90/12/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', 'Ƽ�ư� �ǹ�', '������', 181, 82, '�����', 600, '84/09/22');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '��ĥ ��', '�޹�', 180, 78, '����', 700, '96/12/21');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���� ���ӽ�', '������', 179, 91, '����', 600, '99/12/08');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '��������', '������', 180, 68, '�����', 700, '91/12/20');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '����� Ĳ��', '������', 168, 72, '������', 1300, '91/03/29');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '���׿��ڹ� ġġ', '������', 176, 82, '����Ʈ����', 900, '94/05/06');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�θ�� ��ī��', '���', 191, 103, '���⿡', 1000, '93/05/13');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', 'Ƽ�� ������', '������', 180, 75, '����', 900, '96/03/06');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '������', '�޹�', 180, 70, '�״�����', 1000, '93/03/19');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�Ϻ�����', '�޹�', 190, 83, '����', 1200, '99/06/11');

--�ƽ���
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'GK', '����', '������', 190, 83, '����', 500, '92/03/04');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '���긮��', '������', 185, 72, '�����', 600, '90/11/26');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '��߽̾�', '������', 188, 78, '�Ϻ�', 500, '98/11/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'DF', '������', '������', 178, 74, '������', 600, '95/03/19');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '��ī', '�޹�', 178, 73, '����', 700, '01/09/05');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�ܵ� ������', '�޹�', 176, 68, '�븣����', 300, '98/12/17');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '��ī', '�޹�', 186, 80, '������', 500, '92/09/27');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'MF', '�Ϳ�����', '������', 184, 80, '������', 400, '99/04/14');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '��ī��Ʈ', '������', 176, 77, '������', 700, '91/05/28');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '�ƿ�� �޾�', '������', 187, 80, '������', 800, '89/06/18');
insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', '����', '������', 188, 81, '�����', 500, '83/02/26');

insert into PLAYER values(PLAYER_SEQ.nextval, 'EPL', 'FW', 'ȣ����', '������', 187, 83, '��������', 1500, '85/02/05');

-- ������ �μ�Ʈ
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', '����', 30, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '�Ƶ�ٽ�', '����', 52, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', '�ƿ��', 31, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '������', 'BMW', 4, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '������', '�ƿ��', 1, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '�Ƶ�ٽ�', '����', 88, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', '����', 95, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', 'BMW', 83, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '������', '����', 28, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '�Ƶ�ٽ�', 'BMW', 49, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', '����', 26, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '������', '�����ٰ�', 11, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '�Ƶ�ٽ�', '����', 2, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', '����', 66, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', 'BMW', 105, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', '����', 119, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '������', '�����ڵ���', 106, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', '����', 124, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '�Ƶ�ٽ�', '�����ڵ���', 134, 'EPL');
insert into SPONSOR_PLAYER values(SOP_SEQ.nextval, '����Ű', '����', 121, 'EPL');

-- ���󳻿� �μ�Ʈ
--ȣ����
insert into AWARD values('2017�߷յ���',136,'EPL');
insert into AWARD values('2017FIFA�����Ǽ�����',136,'EPL');
insert into AWARD values('16-17UEFA�����Ǽ���',136,'EPL');
insert into AWARD values('14-15�����Ǿ��罴',136,'EPL');
 --�����
insert into AWARD values('2020Ǫ��ī����',30,'EPL');
--���
insert into AWARD values('2018Ǫ��ī����',106,'EPL');
--�˸���
insert into AWARD values('2019',83,'EPL');
--��������
insert into AWARD values('20-21UEFA�����Ǽ���',118,'EPL');
--�ݵ���ũ
insert into AWARD values('18-19UEFA�����Ǽ���',88,'EPL');

-- �������� �μ�Ʈ
--�ǽ�Ƽ ��Ʈ�� �����ư ����ư  ���� ����Ǯ ÿ�� �ƽ���
--�����ڵ�,��,���,��������Ʈ,����
--�ظ�����
insert into RECORD values(31,23,14,37,'EPL'); 
--���ϸ޵���
insert into RECORD values(106,22,5,27,'EPL');
--�����丣������
insert into RECORD values(72,18,12,30,'EPL');
--�����
insert into RECORD values(30,17,10,27,'EPL');
--��ī�̱ϵ���
insert into RECORD values(5,13,2,15,'EPL');
--��ī��Ʈ
insert into RECORD values(133,13,1,14,'EPL');
--���� ����
insert into RECORD values(105,11,8,19,'EPL');
--�����ī�ٴ�
insert into RECORD values(81,10,3,13,'EPL');
--���ݶ�����
insert into RECORD values(135,10,1,11,'EPL');
--�ƿ�ٸ޾�
insert into RECORD values(134,10,3,13,'EPL');
--�������и�
insert into RECORD values(2,10,7,17,'EPL');
--�������Ÿ
insert into RECORD values(108,9,0,9,'EPL');
--���ߵ帶����
insert into RECORD values(4,9,6,15,'EPL');
--������
insert into RECORD values(10,9,5,14,'EPL');
--���긮��������
insert into RECORD values(3,9,4,13,'EPL');
--�Ǹ��̴�
insert into RECORD values(104,9,7,16,'EPL');
--��������
insert into RECORD values(118,7,2,9,'EPL');
--�׸����
insert into RECORD values(80,7,2,9,'EPL');
--��������
insert into RECORD values(51,7,3,10,'EPL');
--���������
insert into RECORD values(1,6,12,18,'EPL');
--��׸�����
insert into RECORD values(6,6,10,16,'EPL');
--Ƽ�𺣸���
insert into RECORD values(122,6,8,14,'EPL');
--��ī
insert into RECORD values(129,5,3,8,'EPL');
--�ĺ��׺���
insert into RECORD values(36,5,1,6,'EPL');
--������޳���
insert into RECORD values(40,4,0,4,'EPL');
--�����þ�
insert into RECORD values(78,4,3,7,'EPL');
--�� ���潺
insert into RECORD values(12,4,0,4,'EPL');
--�Ϻ�����
insert into RECORD values(124,4,3,7,'EPL');
--����̴�
insert into RECORD values(77,4,1,5,'EPL');
--�� ���׹�
insert into RECORD values(66,3,3,6,'EPL');
--�� ĥ��
insert into RECORD values(116,3,5,8,'EPL');

-- �Ŵ��� �μ�Ʈ
insert into MANAGER values(MNG_SEQ.nextval, '���ӽ�', 136,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, 'Ŭ��', 19,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '����Ŀ', 1,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '�����', 119,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '��Ÿ��', 115,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '����̾�', 121,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '�ƽ�', 105,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '��ũȩ��', 106,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '������', 66,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '����', 58,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '�ظ�', 52,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '�����ӽ�', 41,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '����Ʈ', 51,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '����', 39,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '�ٴϿ�', 31,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '���̴�', 30,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '�䷹��', 2,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '��ī��', 6,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '���������', 11,'EPL');
insert into MANAGER values(MNG_SEQ.nextval, '��Ƽ', 26,'EPL');

-- ���� �μ�Ʈ
insert into TEAM values(1,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(2,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(3,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(4,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(5,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(6,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(7,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(8,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(9,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(10,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(11,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(12,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(13,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(14,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(15,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(16,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(17,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');
insert into TEAM values(18,'��Ƽ�ϵ彺Ÿ���','��ü���ͽ�Ƽ',80000,'1894/01/01','��ü����','Ǫ��','������ö�','EPL');


insert into TEAM values(52,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(53,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(54,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(55,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(56,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(57,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(58,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(59,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(60,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(61,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(62,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(63,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(64,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(65,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(66,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(67,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(68,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(69,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(70,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(71,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(72,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(73,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(74,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(75,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(76,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(77,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(78,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(79,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(80,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(81,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');
insert into TEAM values(82,'�õ�Ʈ������','��ü����������Ƽ��',50000,'1878/01/01','��ü����','�Ƶ�ٽ�','�ֻ���','EPL');

insert into TEAM values(19,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(20,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(21,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(22,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(23,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(24,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(25,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(26,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(27,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(28,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(29,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(30,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');
insert into TEAM values(31,'��Ʈ��Ȫ���۽�Ÿ���','��Ʈ��',40000,'1882/01/01','����','����Ű','����','EPL');

insert into TEAM values(111,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(112,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(113,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(114,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(115,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(116,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(117,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(118,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(119,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(120,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(121,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(122,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(123,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');
insert into TEAM values(124,'�����۵�긮��','ÿ��',50000,'1905/01/01','����','�Ƶ�ٽ�','����','EPL');

insert into TEAM values(83,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(84,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(85,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(86,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(87,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(88,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(89,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(90,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(91,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(92,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(93,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(94,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(95,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(96,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(97,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(98,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(99,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(100,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(101,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(102,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(103,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(104,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(105,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(106,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(107,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(108,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(109,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');
insert into TEAM values(110,'���ʵ�','����Ǯ',40000,'1892/01/01','����Ǯ','����Ű','Ŭ��','EPL');

insert into TEAM values(125,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(126,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(127,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(128,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(129,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(130,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(131,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(132,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(133,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(134,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');
insert into TEAM values(135,'���̷���Ʈ��Ÿ���','�ƽ���',30000,'1886/01/01','����','�Ƶ�ٽ�','�Ƹ���Ÿ','EPL');

-- �ŷ����� �μ�Ʈ
-- ���� �μ�Ʈ
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


-- �Ǹ� �μ�Ʈ
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


-- ���ϱ� �μ�Ʈ

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



-- �� ��� �μ�Ʈ
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


124   �Ϻ�����