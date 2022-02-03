--내 찜 목록
create table WISHILIST(
   P_ID NUMBER constraint WL_PID_NN not null,
   M_EMAIL VARCHAR2(30) constraint WL_EMAIL_NN not null,
   L_NAME VARCHAR2(30) constraint WL_LNAME_NN not null,
   P_POSITION VARCHAR2(10),
   P_NAME VARCHAR2(40) constraint WL_NAME_NN not null,
   P_MAINFOOT VARCHAR2(10),
   P_HEIGHT NUMBER(3) constraint WL_HEIGHT_NN not null,
   P_WEIGHT NUMBER(3) constraint WL_WEIGHT_NN not null,
   P_NATION VARCHAR2(30) constraint WL_NATION_NN not null,
   P_SAL NUMBER(15) constraint WL_SAL_NN not null,
   P_BIRTH DATE constraint WL_BIRTH_NN not null,
   M_NAME VARCHAR2(30) constraint WL_M_NAME_NN not null,
   constraint WL_PK primary key(P_ID, M_EMAIL),
   constraint WL_FK foreign key (P_ID, L_NAME) references PLAYER(P_ID, L_NAME) on delete cascade,
   constraint WL_FK2 foreign key (M_EMAIL, L_NAME) references MEMBER(M_EMAIL, L_NAME) on delete cascade,
   constraint WL_CK check (P_POSITION in ('FW', 'MF', 'DF', 'GK')),
   constraint WL_CK2 check (P_MAINFOOT in ('오른발', '왼발', '양발'))
);