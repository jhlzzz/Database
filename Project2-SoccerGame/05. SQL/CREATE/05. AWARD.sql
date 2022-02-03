--수상내역
create table AWARD(
	P_AWARD VARCHAR2(30),
	P_ID NUMBER constraint AWA_PID_NN not null,
	L_NAME VARCHAR2(30) constraint AWA_LNAME_NN not null,
	constraint AWA_PK primary key(P_AWARD),
	constraint AWA_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);