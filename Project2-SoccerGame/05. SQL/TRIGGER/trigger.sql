-- 트리거


--CONTRACT C_DEAL (0 = 구매, 1 = 판매, 2 = 찜, 3 = 찜취소)
create or replace trigger CONTRACT_TR
after
   insert on CONTRACT for each row
begin
   if :NEW.C_DEAL = 0
      then
	CONTRACT_BUY(:NEW.P_ID, :NEW.M_EMAIL);
	MY_PLAYER_ADD(:NEW.P_ID, :NEW.M_EMAIL);
   end if;
   if :NEW.C_DEAL = 1
      then
	CONTRACT_SELL(:NEW.P_ID, :NEW.M_EMAIL);
        MY_PLAYER_DEL(:NEW.P_ID, :NEW.M_EMAIL);
   end if;
   if :NEW.C_DEAL = 2
      then
	MY_WL_ADD(:NEW.P_ID, :NEW.M_EMAIL);
   end if;
   if :NEW.C_DEAL = 3
      then
	MY_WL_DEL(:NEW.P_ID, :NEW.M_EMAIL);
   end if;
end;
/


-- PLAYER TRIGGER

create or replace trigger PLAYER_POSITION_UPDATE
after
   update of P_POSITION on PLAYER for each row
begin
   update WISHILIST set P_POSITION = :NEW.P_POSITION where P_ID = :NEW.P_ID;
   update MY_PLAYER set P_POSITION = :NEW.P_POSITION where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_NAME_UPDATE
after
   update of P_NAME on PLAYER for each row
begin
   update WISHILIST set P_NAME = :NEW.P_NAME where P_ID = :NEW.P_ID;
   update MY_PLAYER set P_NAME = :NEW.P_NAME where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_MAINFOOT_UPDATE
after
   update of P_MAINFOOT on PLAYER for each row
begin
   update WISHILIST set P_MAINFOOT = :NEW.P_MAINFOOT where P_ID = :NEW.P_ID;
   update MY_PLAYER set P_MAINFOOT = :NEW.P_MAINFOOT where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_SAL_UPDATE
after
   update of P_SAL on PLAYER for each row
begin
   update WISHILIST set P_SAL = :NEW.P_SAL where P_ID = :NEW.P_ID;
   update MY_PLAYER set P_SAL = :NEW.P_SAL where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_HEIGHT_UPDATE
after
   update of P_HEIGHT on PLAYER for each row
begin
   update WISHILIST set P_HEIGHT = :NEW.P_HEIGHT where P_ID = :NEW.P_ID;
end;
/



create or replace trigger PLAYER_WEIGHT_UPDATE
after
   update of P_WEIGHT on PLAYER for each row
begin
   update WISHILIST set P_WEIGHT = :NEW.P_WEIGHT where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_NATION_UPDATE
after
   update of P_NATION on PLAYER for each row
begin
   update WISHILIST set P_NATION = :NEW.P_NATION where P_ID = :NEW.P_ID;
end;
/


create or replace trigger PLAYER_BIRTH_UPDATE
after
   update of P_BIRTH on PLAYER for each row
begin
   update WISHILIST set P_BIRTH = :NEW.P_BIRTH where P_ID = :NEW.P_ID;
end;
/


-- MEMBER TRIGGER
create or replace trigger MEMBER_MNAME_UPDATE
after
   update of M_NAME on MEMBER for each row
begin
   update WISHILIST set M_NAME = :NEW.M_NAME where M_EMAIL = :NEW.M_EMAIL;
   update MY_PLAYER set M_NAME = :NEW.M_NAME where M_EMAIL = :NEW.M_EMAIL;
end;
/
