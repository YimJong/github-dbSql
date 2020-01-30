-- EXPLAIN PLAN FOR
SELECT empno, ename,
       CASE WHEN deptno = 10 THEN 'ACCONTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
       END AS dname
FROM emp;

-- SELECT *
-- FROM table(dbms_xplan.display);

SELECT empno, ename, hiredate,
       CASE WHEN (MOD(To_CHAR(hiredate, 'yyyy'),2) = 0) and (MOD(TO_CHAR(SYSDATE, 'yyyy'), 2) = 0) THEN '검강검진 대상자'
            WHEN (MOD(To_CHAR(hiredate, 'yyyy'),2) = 1) and (MOD(TO_CHAR(SYSDATE, 'yyyy'), 1) = 1) THEN '검강검진 대상자'
            ELSE '건강검진 비대상자'
       END AS contact_to_doctor
FROM emp;

SELECT MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2) AS year
FROM dual;

-- GROUP BY 행을 묶을 기준
-- 부서번호가 같은 ROW 끼리 묶는 경우 : GROUP BY deptno
-- 담당업무가 같은 ROW 끼리 묶는 경우 : GROUP BY job
-- MGR가 같고 담당업무가 같은 ROW 끼리 묶는 경우 : GROUP BY mgr, job

-- 그룹함수의 종류
-- SUM : 합계
-- COUNT : 갯수 - NULL 값이 아닌 ROW이 갯수
-- MAX : 최대값
-- MIN : 최소값
-- AVG : 평균

-- 그룹함수의 특징
-- 해당 컬럼에 NULL값을 같는 ROW가 존재할 경우 해당 값은 무시하고 계산한다. (NULL 연산의 결과는 NULL)

-- 부서별 급여 합

-- 그룹함수 주의점
-- GROUP BY 절에 나온 컬럼이외의 다른 컬럼이 SELECT절에 표현되면 에러.
SELECT deptno, ename, SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal, 
       COUNT(sal) as count, SUM(comm)
FROM emp
GROUP BY deptno, ename;

-- GOURP BY 절이 없는 상태에서 그룹함수를 사용한 경우
-- 전체행을 하나의 행으로 묶는다.
SELECT SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal, 
       COUNT(sal) as count, SUM(comm)
FROM emp;

SELECT SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal,
       COUNT(sal),  -- sal 컬럼의 값이 NULL이 아닌 row의 갯수
       COUNT(comm), -- COMM 컬럼의 값이 NULL이 아닌 row의 갯수
       COUNT(*) -- 몇건이 데이터가 있는지 
FROM emp;


SELECT SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal,
       COUNT(sal),  -- sal 컬럼의 값이 NULL이 아닌 row의 갯수
       COUNT(comm), -- COMM 컬럼의 값이 NULL이 아닌 row의 갯수
       COUNT(*) -- 몇건이 데이터가 있는지 
FROM emp
GROUP BY empno;

-- 그룹화와 관련없는 임의의 문자열, 함수, 숫자등은 SELECT절에 나오는 것이 가능.
SELECT 1, SYSDATE, 'ACCOUNTING', SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal,
       COUNT(sal),  -- sal 컬럼의 값이 NULL이 아닌 row의 갯수
       COUNT(comm), -- COMM 컬럼의 값이 NULL이 아닌 row의 갯수
       COUNT(*) -- 몇건이 데이터가 있는지 
FROM emp
GROUP BY empno;

-- SINGLE ROW FUNCTION의 경우 WHERE 절에서 사용하는 것이 가능하나
-- MULTI ROW FUNCTION의 경우 WHERE 절에서 사용하는 것이 불가능 하고
-- HAVING 절에서 조건을 기술하낟.

-- 부서별 급여 합 조회, 단 급여합이 9000이상인 row만 조회
-- deptno, 급여합
SELECT deptno, SUM(sal) as sum_sal
FROM emp
GROUP BY deptno
HAVING sum(sal) > 9000;


-- grp1
SELECT MAX(sal) as max_sal,MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal,
       SUM(sal) as sum_sal, COUNT(sal) as count_sal, COUNT(mgr) as count_mgr,
       COUNT(*) as count_all
FROM emp;


-- grp2
SELECT deptno,
       MAX(sal) as max_sal,MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal,
       SUM(sal) as sum_sal, COUNT(sal) as count_sal, COUNT(mgr) as count_mgr,
       COUNT(*) as count_all
FROM emp
GROUP BY deptno;


-- grp3
SELECT DECODE(deptno, 10, 'ACCOUNTING',
                      20, 'RESEARCH',
                      30, 'SALES') as dname,
       MAX(sal) as max_sal,MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal,
       SUM(sal) as sum_sal, COUNT(sal) as count_sal, COUNT(mgr) as count_mgr,
       COUNT(*) as count_all
FROM emp
GROUP BY deptno
ORDER BY dname ASC;


-- grp4
-- ORACLE 9I 이전까지는 GROUP BY절에 기술한컬럼으로 정렬을 보장
-- ORACLE 10G 이후 부터는 GROUP BY절에 기술한 컬럼으로 정렬을 보장 하지 않는다. (GROUP BY 연산시 속도 UP)
SELECT TO_CHAR(hiredate, 'yyyymm') as hire_yyyymm,
       COUNT(*) as cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm')
ORDER BY TO_CHAR(hiredate, 'yyyymm');


-- grp5
SELECT TO_CHAR(hiredate, 'yyyy') as hire_yyyymm,
       COUNT(*) as cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy');


-- grp6
SELECT COUNT(*) AS cnt
FROM dept;

-- grp7
-- 부서가 뭐가 있는지 : 10, 20, 30 3개의 ROW가 존재
-- 테이블의 ROW 수를 조회 : GROUP BY 없이 COUNT(*)
SELECT COUNT(*) AS cnt
FROM
(SELECT deptno
 FROM emp
 GROUP BY deptno);
 
 
 