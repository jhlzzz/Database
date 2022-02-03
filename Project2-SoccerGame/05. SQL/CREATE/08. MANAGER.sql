--¸Å´ÏÀú
create table MANAGER(
	MNG_CODE NUMBER,
	MNG_NAME VARCHAR2(20) not null,
	P_ID NUMBER not null,
	L_NAME VARCHAR2(30) not null,
	constraint MNG_PK primary key(MNG_CODE),
	constraint MNG_FK foreign key (P_ID,L_NAME) references PLAYER(P_ID,L_NAME) on delete cascade
);