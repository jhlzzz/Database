
--1. 스폰서가 있는 선수들의 이름, 선수가격, 국적을 출력하시오.
select P_NAME, P_SAL, P_NATION from PLAYER p, SPONSOR_PLAYER s where p.P_ID = s.P_ID;

--2. 영국 국적을 찜한 회원의 회원이름, 잔액, 선수이름을 출력하시오.
select m.M_NAME, m.M_MONEY, w.P_NAME from MEMBER m, WISHILIST w where m.M_EMAIL = w.M_EMAIL 
and w.P_NATION=all(select P_NATION from WISHILIST where P_NATION = '영국');

--3. 키가 180이상인 선수들의 이름과 수상내역을 출력하시오.
select p.P_NAME, a.P_AWARD from PLAYER p, AWARD a where p.P_ID=a.P_ID 
and P_HEIGHT >= 180;

--4. 매니저가 있는 선수들의 이름, 주발, 국적, 리그이름을 출력하시오.
select p.P_NAME, p.P_MAINFOOT, p.P_NATION, p.L_NAME from PLAYER p, MANAGER m where p.P_ID = m.P_ID;

--5. 신병철 계정에 있는 내 선수 목록에 선수이름과 수상명을 출력하시오.
select p.P_NAME, a.P_AWARD from MY_PLAYER p, AWARD a where p.P_ID = a.P_ID
and p.M_EMAIL =any(select M_EMAIL from MY_PLAYER where M_EMAIL = 'GodByengChel27@naver.com');

--6. 모든 회원 중 소유한 선수가격 합계가 가장 높은 회원의 이메일을 출력하시오.
select * from(select M_EMAIL from MY_PLAYER
where M_EMAIL=all(select M_EMAIL from MY_PLAYER 
group by M_EMAIL having sum(P_SAL)>=all(select sum(P_SAL)
from MY_PLAYER group by M_EMAIL)) ) where rownum = 1;

--7. 선수 중 가장 키가 작은 선수의 이름과 키를 출력하시오.
select P_NAME, P_HEIGHT from PLAYER where P_HEIGHT = (select min(P_HEIGHT) from PLAYER);

--8. 선수 중 가장 어린 선수의 이름과 나이를 출력하시오.
select P_NAME, P_BIRTH from PLAYER where P_BIRTH = (select max(P_BIRTH) from PLAYER);

--9. 수상내역이 가장 많은 선수의 이름과 국적을 출력하시오.
select P_NAME, P_NATION from PLAYER p, AWARD a where p.P_ID = a.P_ID 
group by P_NAME, P_NATION having count(P_AWARD) >= (select max(count(P_AWARD)) from AWARD group by P_ID);

--10. 양발을 사용하는 선수 중 국적이 영국인 선수의 포지션과 이름을 출력하시오.
select P_POSITION, P_NAME from PLAYER where P_MAINFOOT = '양발' and P_NATION = '영국';

--11. 재정상태가 가장 높은 구단의 홈구장, 연고지, 감독, 재정상태를 출력하시오.
select t1.T_HOME, t1.T_LOCATION, t1.T_COACH, t1.T_FINANCIAL from TEAM t1, TEAM t2 where  t1.T_FINANCIAL>=(select max(T_FINANCIAL) from TEAM) 
and t1.P_ID=t2.P_ID and t1.P_ID=(select max(P_ID) from TEAM where T_FINANCIAL>=(select max(T_FINANCIAL) from TEAM));

--12. 연고지가 런던인 구단 중 재정상태가 제일 낮은 구단명과 선수 목록을 출력하시오.
select T_NAME, P_NAME from TEAM t, PLAYER p where t.P_ID = p.P_ID 
and T_FINANCIAL = (select min(T_FINANCIAL) from TEAM) and T_LOCATION = '런던';

--13. 포지션이 미드필더 중 공격포인트가 가장 높은 선수의 이름과 공격포인트, 선수가격을 출력하시오.
select * from (select p.p_name, r.P_Point, p.P_SAL from RECORD r , PLAYER p where p.P_position = 'MF' and p.p_id = r.p_id order by r.P_Point desc ) WHERE rownum =1;

--14. 스폰서와 매니저를 모두 갖고있는 선수의 이름를 출력하시오.
select P_NAME from PLAYER p, SPONSOR_PLAYER s, MANAGER m where p.P_ID = s.P_ID and p.P_ID = m.P_ID;

--15. 축구화 스폰서가 나이키인 선수의 이름과 선수 가격을 출력하시오.
select P_NAME, P_SAL from PLAYER p , SPONSOR_PLAYER s where p.P_ID= s.P_ID
and S_SHOES = '나이키';

--16. 맨체스터유나이티드 구단의  평균 선수가격(소수점 두번째 자리까지)을 출력하시오. 
select t_name,round(avg(P_SAL),2) from TEAM t, PLAYER p where p.P_ID = t.P_ID 
group by t_name having t_name='맨체스터유나이티드';
