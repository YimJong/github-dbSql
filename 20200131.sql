SELECT userid, usernm, alias, reg_dt, 
       CASE WHEN MOD(TO_CHAR(reg_dt, 'YYYY'), 2) = 0 AND MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = 0 THEN '건강 검진 대상자'
            WHEN MOD(TO_CHAR(reg_dt, 'YYYY'), 2) = 1 AND MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = 1 THEN '건강 검진 대상자'
            ELSE '건강 검진 비대상자'
       END AS contact_to_doctor
FROM (SELECT userid, usernm, alias, NVL(reg_dt, TO_DATE(SYSDATE, 'YYYY/MM/DD')) AS reg_dt
      FROM users);

SELECT ename, deptno
FROM emp;

SELECT *
FROM dept;

-- JOIN 두 테이블을 연결하는 작업
-- JOIN 문법
--  1. ANSI 문법
--  2. ORACLE 문법

-- Natural Join
-- 두 테이블 간 컬럼명이 같을 때 해당 컬럼으로 연결(조인)
-- emp, dept 테이블에는 deptno라는 이름이 동일한 컬럼이 존재.
-- 타입도 동일해야 함.
SELECT *
FROM emp NATURAL JOIN dept;

-- Natural Join에 사용된 조인 컬럼(deptno)는 한정자 사용 불가능.
SELECT emp.empno, emp.ename, dept.dname, deptno
FROM emp NATURAL JOIN dept;

-- 테이블에 대한 별칭도 사용가능
SELECT e.empno, e.ename, d.dname, deptno
FROM emp e NATURAL JOIN dept d;


-- ORACLE JOIN
-- FROM 절에 조인할 테이블 목록을 , 로 구분하여 나열한다.
-- 조인할 테이블의 연결 조건을 WHERE절에 기술한다.
-- emp, dept 테이블에 존재하는 deptno 컬럼이 (같을 때) 조인

SELECT emp.ename, dept.dname -- ANSI랑 반대, 조인에 사용된 컬럼에 한정자를 표시 해 주어야 함.
FROM emp, dept -- 조인할 테이블 나열
WHERE emp.deptno = dept.deptno; -- 조인 조건 ex)만약 !=를 이용하면 값이 서로 다를 때 조인.

-- 오라클 조인의 테이블 별칭
SELECT e.empno, e.ename, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI : join with using
-- 조인 deptno 하려는 두개의 테이블에 이름이 같은 컬럼이 두개이지만 하나의 컬럼으로만 조인을 하고자 할 때
-- 조인하려는 기준 컬럼을 기술.
-- emp, dept 테이블의 공통 컬럼 : deptno
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

-- JOIN WITH USING 을 ORACLE로 표현하면?
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ANSI : JOIN WITH ON
-- 조인 하려고하는 테이블의 컬럼의 이름이 서로 다를 때
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- JOIN WITH ON  --> ORACLE
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELF JOIN : 같은 테이블 간의 조인 ex)관리자 번호도 emp 테이블에 있고 관리자 번호와 연결되는 사원 번호 및 정보도 emp 테이블에 있음.
-- ex) emp 테이블에서 관리되는 사원의 관리자 사번을 이용하여 관리자 이름을 조회할 때
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

-- ORACLE 문법
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

---------------------------------------------------- equal 조인

-- equal 조인 : =
-- non-equal 조인 : !=, >, <, BETWEEN AND

-- 사원의 급여 정보와 급여 등급 테이블을 이용하여 해당 사원의 급여 등급을 구해보자.
SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;

SELECT emp.ename, emp.sal, salgrade.grade                           -- non-squal 조인에 해당
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

SELECT emp.ename, emp.sal, salgrade.grade
FROM emp JOIN salgrade ON (emp.sal BETWEEN salgrade.losal AND salgrade.hisal);


-- join 0
-- ANSI
SELECT e.empno, e.ename, deptno, d.dname
FROM emp e NATURAL JOIN dept d
ORDER BY deptno ASC;

-- ORACLE
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno ASC;

SELECT e.empno, e.ename, deptno, d.dname
FROM emp e JOIN dept d USING(deptno)
ORDER BY deptno ASC;

SELECT e.empno, e.ename, d.deptno, d.dname  -- 한정자 안쓰면 컬럼이 모호하다고 오류 뜸.
FROM emp e JOIN dept d ON(e.deptno = d.deptno)
ORDER BY deptno ASC;

-- join 0_1
-- ANSI
SELECT e.empno, e.ename, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE deptno in(10, 30);

-- ORACLE
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno and e.deptno in(10, 30);

-- join 0_2
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE SAL > 2500
ORDER BY d.dname ASC;

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno and e.sal > 2500
ORDER BY d.dname ASC;

-- join 0_3
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE SAL > 2500 AND e.empno > 7600
ORDER BY d.dname ASC;

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno and e.sal > 2500 AND e.empno > 7600
ORDER BY d.dname ASC;


-- join 0_4
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e NATURAL JOIN dept d
WHERE SAL > 2500 AND e.empno > 7600 AND d.dname = 'RESEARCH';

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno 
AND e.sal > 2500 
AND e.empno > 7600 
AND d.dname = 'RESEARCH'
ORDER BY d.dname ASC;

-- PROD : prod_lgu
-- LPROD : lprod_gu
SELECT *
FROM prod;

SELECT *
FROM lprod;

-- join 1
-- SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
-- FROM prod p NATURAL JOIN lprod l;

SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p JOIN lprod l ON(l.lprod_gu = p.prod_lgu);

SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE l.lprod_gu = p.prod_lgu;

-- join 2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE prod_buyer = buyer_id;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod JOIN buyer ON(prod_buyer = buyer_id);

-- join3
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE mem_id = cart_member and cart_prod = prod_id;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON(mem_id = cart_member)
            JOIN prod ON(cart_prod = prod_id);