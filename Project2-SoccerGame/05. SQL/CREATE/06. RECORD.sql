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