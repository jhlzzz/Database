
--1. �������� �ִ� �������� �̸�, ��������, ������ ����Ͻÿ�.
select P_NAME, P_SAL, P_NATION from PLAYER p, SPONSOR_PLAYER s where p.P_ID = s.P_ID;

--2. ���� ������ ���� ȸ���� ȸ���̸�, �ܾ�, �����̸��� ����Ͻÿ�.
select m.M_NAME, m.M_MONEY, w.P_NAME from MEMBER m, WISHILIST w where m.M_EMAIL = w.M_EMAIL 
and w.P_NATION=all(select P_NATION from WISHILIST where P_NATION = '����');

--3. Ű�� 180�̻��� �������� �̸��� ���󳻿��� ����Ͻÿ�.
select p.P_NAME, a.P_AWARD from PLAYER p, AWARD a where p.P_ID=a.P_ID 
and P_HEIGHT >= 180;

--4. �Ŵ����� �ִ� �������� �̸�, �ֹ�, ����, �����̸��� ����Ͻÿ�.
select p.P_NAME, p.P_MAINFOOT, p.P_NATION, p.L_NAME from PLAYER p, MANAGER m where p.P_ID = m.P_ID;

--5. �ź�ö ������ �ִ� �� ���� ��Ͽ� �����̸��� ������� ����Ͻÿ�.
select p.P_NAME, a.P_AWARD from MY_PLAYER p, AWARD a where p.P_ID = a.P_ID
and p.M_EMAIL =any(select M_EMAIL from MY_PLAYER where M_EMAIL = 'GodByengChel27@naver.com');

--6. ��� ȸ�� �� ������ �������� �հ谡 ���� ���� ȸ���� �̸����� ����Ͻÿ�.
select * from(select M_EMAIL from MY_PLAYER
where M_EMAIL=all(select M_EMAIL from MY_PLAYER 
group by M_EMAIL having sum(P_SAL)>=all(select sum(P_SAL)
from MY_PLAYER group by M_EMAIL)) ) where rownum = 1;

--7. ���� �� ���� Ű�� ���� ������ �̸��� Ű�� ����Ͻÿ�.
select P_NAME, P_HEIGHT from PLAYER where P_HEIGHT = (select min(P_HEIGHT) from PLAYER);

--8. ���� �� ���� � ������ �̸��� ���̸� ����Ͻÿ�.
select P_NAME, P_BIRTH from PLAYER where P_BIRTH = (select max(P_BIRTH) from PLAYER);

--9. ���󳻿��� ���� ���� ������ �̸��� ������ ����Ͻÿ�.
select P_NAME, P_NATION from PLAYER p, AWARD a where p.P_ID = a.P_ID 
group by P_NAME, P_NATION having count(P_AWARD) >= (select max(count(P_AWARD)) from AWARD group by P_ID);

--10. ����� ����ϴ� ���� �� ������ ������ ������ �����ǰ� �̸��� ����Ͻÿ�.
select P_POSITION, P_NAME from PLAYER where P_MAINFOOT = '���' and P_NATION = '����';

--11. �������°� ���� ���� ������ Ȩ����, ������, ����, �������¸� ����Ͻÿ�.
select t1.T_HOME, t1.T_LOCATION, t1.T_COACH, t1.T_FINANCIAL from TEAM t1, TEAM t2 where  t1.T_FINANCIAL>=(select max(T_FINANCIAL) from TEAM) 
and t1.P_ID=t2.P_ID and t1.P_ID=(select max(P_ID) from TEAM where T_FINANCIAL>=(select max(T_FINANCIAL) from TEAM));

--12. �������� ������ ���� �� �������°� ���� ���� ���ܸ�� ���� ����� ����Ͻÿ�.
select T_NAME, P_NAME from TEAM t, PLAYER p where t.P_ID = p.P_ID 
and T_FINANCIAL = (select min(T_FINANCIAL) from TEAM) and T_LOCATION = '����';

--13. �������� �̵��ʴ� �� ��������Ʈ�� ���� ���� ������ �̸��� ��������Ʈ, ���������� ����Ͻÿ�.
select * from (select p.p_name, r.P_Point, p.P_SAL from RECORD r , PLAYER p where p.P_position = 'MF' and p.p_id = r.p_id order by r.P_Point desc ) WHERE rownum =1;

--14. �������� �Ŵ����� ��� �����ִ� ������ �̸��� ����Ͻÿ�.
select P_NAME from PLAYER p, SPONSOR_PLAYER s, MANAGER m where p.P_ID = s.P_ID and p.P_ID = m.P_ID;

--15. �౸ȭ �������� ����Ű�� ������ �̸��� ���� ������ ����Ͻÿ�.
select P_NAME, P_SAL from PLAYER p , SPONSOR_PLAYER s where p.P_ID= s.P_ID
and S_SHOES = '����Ű';

--16. ��ü����������Ƽ�� ������  ��� ��������(�Ҽ��� �ι�° �ڸ�����)�� ����Ͻÿ�. 
select t_name,round(avg(P_SAL),2) from TEAM t, PLAYER p where p.P_ID = t.P_ID 
group by t_name having t_name='��ü����������Ƽ��';
