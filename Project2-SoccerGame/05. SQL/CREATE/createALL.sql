--우승이라는 골을 향해 달려가는 구단에게
--맞춤 어시스트를!! ㈜축구인..

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

--내 선수 목록
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

--내 찜 목록
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