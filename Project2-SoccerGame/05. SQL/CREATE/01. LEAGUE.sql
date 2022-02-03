--¸®±×
create table LEAGUE(
	L_NAME VARCHAR2(30) constraint LEA_NAME_NN not null,
	L_NATION VARCHAR2(30) constraint LEA_NATION_NN not null,
	constraint LG_PK primary key(L_NAME)
);
