-- DATE : TO_DATE 문자열 → 날짜(DATE)
--        TO_CHAR 날짜 → 문자열(날짜 포맷 지정)
-- JAVA에서는 날짜 포맷의 대소문자를 가린다. ( MM / mm → 월 / 분 )
-- 일요일 1, 월요일 2 ..... 토요일 7
-- 주차 IW : ISO표준. 해당주의 목요일을 기준으로 주차를 산정.
--          2019/12/31 화요일 → 2020/01/02 목요일 : 때문에 목요일을 한 주의 기준

SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE, 'D'),
       TO_CHAR(SYSDATE, 'IW'),
       TO_CHAR(TO_DATE('2019-12-31', 'YYYY/MM/DD'), 'IW')
FROM dual;

-- emp 테이블의 hiredate(입사일자) 칼럼의 년월일 시:분:초
SELECT ename, hiredate,
       TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') AS hiredate2,
       TO_CHAR(hiredate + 1, 'YYYY/MM/DD HH24:MI:SS') AS hiredate_plusdate,
       TO_CHAR(hiredate + 1/24, 'YYYY/MM/DD HH24:MI:SS') AS hiredate_plushour,
       TO_CHAR(hiredate + (1/24/60)*30, 'YYYY/MM/DD HH24:MI:SS') AS hiredate_plus30min
FROM emp;

--fn2

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS dt_dash,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS') AS dt_dash_with_time,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') AS dt_dd_mm_yyyy
FROM dual;

SELECT hiredate
FROM emp;

-- MONTHS_BETWEEN(DATE, DATE)
-- 인자로 들어온 두 날짜 사이의 개월 수를 리턴
SELECT ename, hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate),
       MONTHS_BETWEEN(TO_DATE('2020-01-17', 'YYYY-MM-DD'), hiredate)
FROM emp
WHERE ename = 'SMITH';

--ADD_MONTHS(DATE, 정수 - 가감할 개월 수)
SELECT ADD_MONTHS(SYSDATE, 5),
       ADD_MONTHS(SYSDATE, -5)
FROM dual;

--NEXT_DAY(DATE, 주간일자), ex) NEXT_DAY(SYSDATE, 5) → SYSDATE이후 처음 등장하는 주간일자 5(목요일)에 해당하는 일자
--                            SYSDATE 2020/01/29(수) 이후 처음 등장하는 5(목)요일 → 2020/01/30(목)
SELECT NEXT_DAY(SYSDATE, 5)
FROM dual;

--LAST_DAY(DATE) DATE가 속한 월의 마지막 일자를 리턴.
SELECT LAST_DAY(SYSDATE)
FROM dual;

-- LAST_DAY를 통해 인자로 들어온 date가 속한 월의 마지막 일자를 구할 수 있는데
-- date의 첫번째 일자는 어떻게 구할까?
SELECT ADD_MONTHS((LAST_DAY(SYSDATE) + 1), -1) AS FIRSTDAY_OF_MONTH,
       TO_DATE('01', 'DD')
FROM dual;

-- hiredate 값을 이용하여 해당원의 첫번째 일자를 표현
SELECT ename, hiredate, ADD_MONTHS((LAST_DAY(hiredate) + 1), -1) AS FIRSTDAY_OF_MONTH
FROM emp;

-- empno는 number타입 , 인자는 문자열
-- 타입이 맞지 않기 때문에 묵시적 형변환이 일어남.
-- 테이블 컬럼의 타입에 맞게 올바른 인자 값을 주는게 중요.
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM emp
WHERE empno = 7369;

-- hiredate의 경우 DATE 타입, 인자는 문자열로 주어졌기 때문에 묵시적 형변환이 발생.
-- 날짜 문자열 보다 날짜 타입으로 명시적으로 기술하는 것이 좋음.
SELECT *
FROM emp
WHERE hiredate = TO_DATE('1980/12/17', 'YYYY/MM/DD');

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM table(dbms_xplan.display);

-- 숫자를 문자열로 변경하는 경우 : 포맷
-- 천단위 구분자
-- 한국 : 1,000.50
-- 독일 : 1.000,50

-- emp sal 컬럼(NUMBER 타입)을 포맷팅
-- 9 : 숫자
-- 0 : 강제 자리 맞춤(0으로 표기)
-- L : 통화단위
SELECT ename,
sal, TO_CHAR(sal, 'L0,999')
FROM emp;


-- NULL에 대한 결과는 항상 NULL
-- emp 테이블의 sal 컬럼에는 null 데이터가 존재하지 않음. (14건의 데이터에 대하여)
-- emp 테이블의 comm 컬럼에는 null 데이터가 존재. (14건의 데이터에 대하여)
-- sal + com → comm인 NULL인 행에 대해서는 결과 NULL로 나온다.
-- 요구사항이 comm이 NULL이면 sal 컴럼의 값만 조회
-- 요구사항이 충족 시키지 못한다 → SW에서는 [결함]

-- NVL(타겟, 대체값)
-- 타겟의 값이 NULL이면 대체값을 반환하고
-- 타겟의 값이 NULL이 아니면 타겟 값을 반환
-- if(타겟 == null)
--      return 대체값;
-- else
--      return 타겟;
SELECT ename, sal, comm, NVL(comm, 0), sal + NVL(comm, 0)
FROM emp;

-- NVL2(expr1, expr2, expr3)
-- if(expr1 != null)
--     return expr2;
-- else
--     return expr3
SELECT ename, sal, comm, NVL2(comm, 100000, 0)
FROM emp;

-- NULLIF(expr1, expr2)
-- if (expr1 == expr2)
--      return null;
-- else 
--      return expr1
SELECT ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

-- 가변인자
-- COALESCE 인자중에 가장처음으로 등장하는 NULL이 아닌 인자를 반환.
-- COALESCE(expr1, expr2....)
-- if(expr1 != null)
--    return expr1
-- else
--    return COALESCE(expr2, expr3....);

--  COALESCE(comm, sal) : comm이 null이 아니면 comm
--                        comm이 null이면 sal (단, sal 컬럼의 값이 NULL이 아닐때)
SELECT ename, sal, comm, COALESCE(comm, sal)
FROM emp;

-- fn4
SELECT empno, ename, mgr,
       NVL(mgr, 9999),
       NVL2(mgr, mgr, 9999),
       COALESCE(mgr, 9999)
FROM emp;

-- fn5
SELECT userid, usernm, reg_dt, n_reg_dt
FROM
    (SELECT ROWNUM AS rn, userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) AS n_reg_dt
     FROM users)
WHERE rn >= 2;

SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) AS n_reg_dt
FROM users
WHERE userid != 'brown';

-- CONDITION : 조건절
-- CASE : Java의 if -else if - else
-- CASE
--      WHEN 조건 THEN 리턴값1
--      WHEN 조건2 THEN 리턴값2
--      ELSE 기본값
-- END

-- emp테이블에서 job컴럼의 값이 SALESMAN : SAL * 1.05 리턴
--                          MANAGER : SAR * 1.1 리턴
--                          PRESIDENT : SAR * 1.2 리턴
--                          그 밖의 사람들은 SAR 리턴
SELECT ename, job, sal, 
       CASE
          WHEN job = 'SALESMAN' THEN sal * 1.05
          WHEN job = 'MANAGER' THEN sal * 1.1
          WHEN job = 'PRESIDENT' THEN sal * 1.20
          ELSE sal
       END AS salary_up
FROM emp;

-- DECODE 함수 : CASE절과 유사
-- (다른점 CASE 절 : WHEN 절에 조건비교가 자유롭다.
--        DECODE 함수 : 하나의 값에 대하여 = 비교만 허용)
-- DECODE 함수 : 가변인자(인자의 개수가 상황에 따라서 늘어날 수가 있음)
-- DECODE(col | expr, 첫번째 인자와 비교할 값, 첫번째 인자와 두번째 인자가 같을 경우 반환 값,
--                    첫번째 인자와 비교할 값2, 첫번째 인자와 네번째 인자가 같을 경우 반환 값, .....
--                    option - else 최종적으로 반환할 기본 값)
SELECT ename, job, sal,
       DECODE(job, 'SALESMAN', sal * 1.05,
                   'MANAGER', sal * 1.1,
                   'PRESIDENT', sal * 1.2, sal) AS salary_plus
FROM emp;

-- EX1
SELECT ename, job, sal,
       CASE WHEN job = 'SALESMAN' AND sal > 1400 THEN sal * 1.05
            WHEN job = 'SALESMAN' AND sal < 1400 THEN sal * 1.1
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.20
       ELSE sal
       END AS salary_up
FROM emp;

-- EX2
SELECT ename, job, sal,
        
