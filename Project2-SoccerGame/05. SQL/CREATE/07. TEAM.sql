--±¸´Ü
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