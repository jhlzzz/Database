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