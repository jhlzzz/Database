--- 프로시저

-- 잔액 차감 프로시저
create or replace procedure CONTRACT_BUY(b_ID_BUY in PLAYER.P_ID%TYPE, b_MEM_BUY in MEMBER.M_EMAIL%TYPE)
is
   newSAL NUMBER;
   newMONEY NUMBER;
begin
   select P_SAL into newSAL from PLAYER where P_ID = b_ID_BUY;
   select M_MONEY into newMONEY from MEMBER where M_EMAIL = b_MEM_BUY;
   newMONEY :=  newMONEY - newSAL;
   update MEMBER set M_MONEY=newMONEY where M_EMAIL = b_MEM_BUY;
end;
/


-- 구매선수 생성 프로시저
create or replace procedure MY_PLAYER_ADD(b_ID_ADD in PLAYER.P_ID%TYPE, b_MEM_ADD in MEMBER.M_EMAIL%TYPE)
is
--   newM_EMAIL VARCHAR2(30);
--   newP_ID NUMBER;
   newL_NAME VARCHAR2(30);
   newMY_POSITION VARCHAR2(10);
   newMY_NAME VARCHAR2(40);
   newMY_MAINFOOT VARCHAR2(10);
   newMY_SAL NUMBER(15);
   newMY_MNAME VARCHAR2(30);
begin
  -- newM_EMAIL := b_MEM_ADD;
  -- newP_ID := b_ID_ADD;
   select L_NAME into newL_NAME from PLAYER where P_ID = b_ID_ADD;
   select P_POSITION into newMY_POSITION from PLAYER where P_ID = b_ID_ADD;
   select P_NAME into newMY_NAME from PLAYER where P_ID = b_ID_ADD;
   select P_MAINFOOT into newMY_MAINFOOT from PLAYER where P_ID = b_ID_ADD;
   select P_SAL into newMY_SAL from PLAYER where P_ID = b_ID_ADD;
   select M_NAME into newMY_MNAME from MEMBER where M_EMAIL = b_MEM_ADD;

   insert into MY_PLAYER values(b_ID_ADD, b_MEM_ADD, newL_NAME, newMY_POSITION, newMY_NAME, newMY_MAINFOOT, newMY_SAL, newMY_MNAME);
end;
/

--MY_PLAYER_SEQ.nextval
-- nnewcount = newcojunt +r

-- 잔액 증가 프로시저 (판매할때 수수료 5프로)
create or replace procedure CONTRACT_SELL(b_ID_SELL in PLAYER.P_ID%TYPE, b_MEM_SELL in MEMBER.M_EMAIL%TYPE)
is
   newSAL NUMBER;
   newMONEY NUMBER;
begin
   select P_SAL into newSAL from MY_PLAYER where P_ID = b_ID_SELL and M_EMAIL = b_MEM_SELL;
   select M_MONEY into newMONEY from MEMBER where M_EMAIL = b_MEM_SELL;
   newSAL := newSAL - ((newSAL * 5) / 100);
   newMONEY :=  newMONEY + newSAL;
   update MEMBER set M_MONEY=newMONEY where M_EMAIL = b_MEM_SELL;
end;
/

-- 선수 삭제 프로시저
create or replace procedure MY_PLAYER_DEL(b_ID_DEL in PLAYER.P_ID%TYPE, b_MEM_DEL in MEMBER.M_EMAIL%TYPE)
is

begin
   delete from MY_PLAYER where P_ID=b_ID_DEL and M_EMAIL = b_MEM_DEL;
end;
/



-- 찜한 선수 목록 생성 프로시저
create or replace procedure MY_WL_ADD(b_ID_WL_ADD in PLAYER.P_ID%TYPE, b_MEM_WL_ADD in MEMBER.M_EMAIL%TYPE)
is
   newL_NAME VARCHAR2(30);
   newWL_POSITION VARCHAR2(10);
   newWL_NAME VARCHAR2(40);
   newWL_MAINFOOT VARCHAR2(10);
   newWL_HEIGHT NUMBER(3);
   newWL_WEIGHT NUMBER(3);
   newWL_NATION VARCHAR2(30);
   newMY_SAL NUMBER(15);
   newWL_BIRTH VARCHAR2(10);
   newMY_MNAME VARCHAR2(30);
begin
   select L_NAME into newL_NAME from PLAYER where P_ID = b_ID_WL_ADD;
   select P_POSITION into newWL_POSITION from PLAYER where P_ID = b_ID_WL_ADD;
   select P_NAME into newWL_NAME from PLAYER where P_ID = b_ID_WL_ADD;
   select P_MAINFOOT into newWL_MAINFOOT from PLAYER where P_ID = b_ID_WL_ADD;
   select P_HEIGHT into newWL_HEIGHT from PLAYER where P_ID = b_ID_WL_ADD;
   select P_WEIGHT into newWL_WEIGHT from PLAYER where P_ID = b_ID_WL_ADD;
   select P_NATION into newWL_NATION from PLAYER where P_ID = b_ID_WL_ADD;
   select P_SAL into newMY_SAL from PLAYER where P_ID = b_ID_WL_ADD;
   select P_BIRTH into newWL_BIRTH from PLAYER where P_ID = b_ID_WL_ADD;
   select M_NAME into newMY_MNAME from MEMBER where M_EMAIL = b_MEM_WL_ADD;

   insert into WISHILIST values(b_ID_WL_ADD, b_MEM_WL_ADD, newL_NAME, newWL_POSITION, newWL_NAME, newWL_MAINFOOT, newWL_HEIGHT, newWL_WEIGHT, newWL_NATION, newMY_SAL, newWL_BIRTH, newMY_MNAME);
end;
/


-- 찜한 선수 목록 삭제 프로시저
create or replace procedure MY_WL_DEL(b_ID_WL_DEL in PLAYER.P_ID%TYPE, b_MEM_WL_DEL in MEMBER.M_EMAIL%TYPE)
is
begin
   delete from WISHILIST where P_ID=b_ID_WL_DEL and M_EMAIL = b_MEM_WL_DEL;
end;
/
