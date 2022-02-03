--È¸¿ø
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