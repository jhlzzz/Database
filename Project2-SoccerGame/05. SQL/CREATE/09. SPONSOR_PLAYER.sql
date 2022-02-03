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