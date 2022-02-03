--°è¾à
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