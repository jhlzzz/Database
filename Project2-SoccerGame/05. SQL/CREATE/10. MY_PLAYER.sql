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