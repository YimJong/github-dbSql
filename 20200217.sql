:dt → 202002;

SELECT DECODE(d, 1, IW+1, IW) IW,   -- 일요일을 한 행 내리기 위해서 일요일일 경우 IW에 1 더함.
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:dt, 'YYYYMM') + (LEVEL - 1) dt,    
            TO_CHAR(TO_DATE(:dt, 'YYYYMM') + (LEVEL - 1), 'D') d,
            TO_CHAR(TO_DATE(:dt, 'YYYYMM') + (LEVEL - 1), ' IW') IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, IW+1, IW)
ORDER BY IW;

기존 : 시작일자 1일, 마지막 날짜 : 해당 월의 마지막 일자.;
SELECT TO_DATE('202002', 'YYYYMM') + (LEVEL - 1)
FROM dual
CONNECT BY LEVEL <= 29;

변경 : 시작일자 : 해당 월의 1일자가 속한 주의 일요일
      마지막 날짜 : 해당 월의 마지막 일자가 속한 주의토요일.;
SELECT TO_DATE('20200126', 'YYYYMMDD') + (LEVEL - 1)
FROM dual
CONNECT BY LEVEL <= 35;


-- 해당 월의 1일자가 속한 일요일 구하기
-- 해당 월의 마지막 일자가 속한 주의 토요일 구하기

SELECT
    TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 ) st,
    LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7 - TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
    LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7 - TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                - (TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;


SELECT TO_DATE(:dt, 'yyyymm'),
       (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 )    
FROM dual;


SELECT DECODE(d, 1, IW+1, IW) IW,   -- 일요일을 한 행 내리기 위해서 일요일일 경우 IW에 1 더함.
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 ) + (LEVEL - 1) dt,
            TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 ) + (LEVEL - 1), 'D') d,
            TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 ) + (LEVEL - 1), ' IW') IW
    FROM dual
    CONNECT BY LEVEL <=  LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7 - TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                - (TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') - 1))
GROUP BY DECODE(d, 1, IW+1, IW)
ORDER BY IW;


SELECT *
FROM sales;

SELECT dt
FROM sales;

SELECT EXTRACT(MONTH FROM dt)            
FROM sales;


SELECT SUM(DECODE(EXTRACT(MONTH FROM dt), 1, sales)) AS JAN,
       SUM(DECODE(EXTRACT(MONTH FROM dt), 2, sales)) AS FEB,
       NVL(SUM(DECODE(EXTRACT(MONTH FROM dt), 3, sales)),0) AS MAR,
       SUM(DECODE(EXTRACT(MONTH FROM dt), 4, sales)) AS APR,
       SUM(DECODE(EXTRACT(MONTH FROM dt), 5, sales)) AS MAY,
       SUM(DECODE(EXTRACT(MONTH FROM dt), 6, sales)) AS JUN
FROM sales; 



-- 다른 방법 (NVL)을 가장 마지막에 해주는것이 성능이 좋음. SUM 이전에 NVL을 하면 각 행에 NVL을 시도하고 SUM을 함.
-- SUM을 한 후에 NVL을 하면 SUM 값에 한번만 하면 됨.
SELECT NVL(SUM(JAN), 0) JAN, NVL(SUM(FEB), 0) FEB, 
       NVL(SUM(MAR), 0) MAR, NVL(SUM(APR), 0) APR, 
       NVL(SUM(MAY), 0) MAY, NVL(SUM(JUN), 0) JUN
FROM
(SELECT DECODE(TO_CHAR(dt, 'MM'), '01', SUM(sales)) JAN,
        DECODE(TO_CHAR(dt, 'MM'), '02', SUM(sales)) FEB,
        DECODE(TO_CHAR(dt, 'MM'), '03', SUM(sales)) MAR,
        DECODE(TO_CHAR(dt, 'MM'), '04', SUM(sales)) APR,
        DECODE(TO_CHAR(dt, 'MM'), '05', SUM(sales)) MAY,
        DECODE(TO_CHAR(dt, 'MM'), '06', SUM(sales)) JUN
FROM sales
GROUP BY TO_CHAR(dt, 'MM') );

SELECT *
FROM dept_h;

-- 오라클 계층형 쿼리 문법
SELECT ...
FROM ...
WHERE
START WITH 조건 : 어떤 행을 시작점으로 삼을지
CONNECT BY 행과 행을 연결하는 기준
            FRIOR : 이미 읽은 행
            "   " : 앞으로 읽을 행;

하향식 : 상위에서 자식 노드로 연결 (위 → 아래);

XX회사(최상위 조직) 부터 '시작'하여 하위 부서로 내려가는 계층 쿼리 작성;

SELECT dept_h.*, LEVEL, lpad(' ', (LEVEL - 1) * 4, ' ') || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;  
-- START WITH deptnm = 'XX회사'  → 사용 가능
-- START WITH P_DEPTCD IS NULL   → 사용 가능




-- 행과 행의 연결 조건 ((PRIOR)XX회사 - 3가지 부(디자인부, 정보기획부, 정보시스템부))
PRIOR XX회사.deptcd = 디자인부.p_deptcd
PRIOR 디자인부.deptcd = 디자인팀.p_deptcd
-- PRIOR 디자인팀.deptcd = .p_deptcd : 더 이상 연결이 안됨.

PRIOR XX회사.deptcd = 정보기획부.p_deptcd
PRIOR 정보기획부.deptcd = 기획팀.p_deptcd
PRIOR 기획팀.deptcd = 기획파트.p_deptcd
-- PRIOR 기획파트.deprcd = ... : 더 이상 연결이 안됨.

PRIOR XX회사.deptcd = 정보시스템부.p_deptcd (개발1팀, 개발2팀)
PRIOR 정보시스템부.deptcd = 개발1팀.p.deptcd
-- PRIOR 개발1팀.p.deptcd = .... : 없음.. 연결안됨.
-- PRIOR 개발2팀.p.deptcd = .... : 없음.. 연결안됨.



SELECT dept_h.*, LEVEL, lpad(' ', (LEVEL - 1) * 4, ' ') || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY p_deptcd = PRIOR deptcd AND PRIOR ...; -- 가능. PRIOR 순서, AND조건 사용 가능. 


