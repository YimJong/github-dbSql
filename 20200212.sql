EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM table(dbms_xplan.display);

CREATE INDEX idx_n_emp_03 ON emp (job, ename);
SELECT job, ename, ROWID
FROM emp
ORDER BY ename, job;


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM table(dbms_xplan.display);

--1. table full
--2. indx1 : empno
--3. indx2 : job
--4. indx3 : job + ename
--5. indx4 : ename + job

-- ※ 3번째 인덱스랑 다른 점은 컬럼의 구성 순서가 다름
-- 선두 컬럼부터 조회?

CREATE INDEX idx_n_emp_04 ON emp (ename, job);

-- 위 인덱스 모양
SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

-- 결과차이를 보기 위해 3번째 인덱스 잠시 삭제

DROP INDEX idx_n_emp_03;
DROP INDEX idx_n_emp_04;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM table(dbms_xplan.display);

-- 조인 된 쿼리에 인덱스 사용 시...

-- emp - table full, pk_emp(empno)
-- dept - table full, pk_dept(deptno)

-- 가능한 예상 실행 옵션
-- (emp - table full, dept - table full)
-- (emp - table full, dept - pk_dept)
-- (emp - pk_emp, dept - table full)
-- (emp - pk_emp, dept - pk_dpet)

-- 1. 순서
-- 순서의 개념이 포함 되므로 emp - dept , dept - emp 순서의 2가지 경우의 수.

-- ORACLE - 실시간 응답 : OLTP (ON LINE TRANSACTION PROCESSING)
--         전체 처리시간 : OLAP (ON LINE ANALYSIS PROCESSING) - 복잡한 쿼리의 실행계획을 세우는데 30M ~ 1H 소요될 수 있음.

-- 2. 2개 테이블 조인
-- 각각의 테이블에 인덱스가 5개씩 있다면
-- 한 테이블에 접근 전략 : 6개
-- 6 * 6 * 2 : 72 (한 테이블전략 * 한 테이블 전략 * 순서)

-- emp 부터 읽을 지 dept 부터 읽을 지?
EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM table(dbms_xplan.display);


-- idx 1
CREATE TABLE dept2 AS   -- CTAS 제약조건 복사가 NOT NULL만 된다
SELECT *                -- 백업이나 테스트용으로만 쓰임.
FROM dept              
WHERE 1 = 1;

SELECT *
FROM dept2;

ALTER TABLE dept2 ADD CONSTRAINTS PK_dept2_deptno PRIMARY KEY (deptno);
ALTER TABLE dept2 DROP CONSTRAINTS PK_dept2_deptno;

CREATE UNIQUE INDEX idx_u_dept2_01 ON dept2 (deptno);
DROP INDEX idx_u_dept2_01;

CREATE INDEX idx_n_dept2_01 ON dept2 (dname);
DROP INDEX idx_n_dept2_01;
CREATE INDEX idx_n_dept2_02 ON dept2 (deptno, dname);
DROP INDEX idx_n_dept2_02;

-- idx3
-- NO1 
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = :empno;

SELECT *
FROM table(dbms_xplan.display);

CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
DROP INDEX idx_u_emp_01; 

SELECT empno, ROWID
FROM emp;

SELECT empno
FROM emp;

-- NO2
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename = :ename;

CREATE INDEX idx_n_emp_02 ON emp (ename);
DROP INDEX idx_n_emp_02;


-- NO3
EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.empno LIKE :empno || '%';

ALTER TABLE dept DROP CONSTRAINTS PK_DEPT_DPETNO;

SELECT *
FROM table(dbms_xplan.display);

CREATE INDEX idx_n_emp_dept_01 ON emp (deptno, empno);
DROP INDEX idx_n_emp_dept_01;

--NO4
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000
AND deptno = :deptno;

SELECT *
FROM table(dbms_xplan.display);

SELECT sal
FROM emp;

CREATE INDEX idx_n_emp_03 ON emp(deptno, sal);
DROP INDEX idx_n_emp_03;

-- NO5
SELECT B.*
FROM emp A, emp B
WHERE A.mgr = B.empno
AND A.deptno = :deptno;


-- << access pattern >>
-- 1. empno(=) → 3번에 합병
-- 2. ename(=)
-- 3. deptno(=), empno(LIKE 직원번호%)
-- 4. deptno(=), sal (BETWEEN)
-- 5. deptno(=) / mgr 동반하면 유리
--    empno(=) → 필요 없음
-- 6. deptno, hiredate가 인덱스에 존재하면 유리
EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE EMPNO = :EMPNO;

SELECT *
FROM table(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM DEPT
WHERE DEPTNO = :DEPTNO;

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE SAL BETWEEN :ST_SAL AND :ED_SAL
AND DEPTNO = :DEPTNO;

SELECT *
FROM table(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND EMP.DEPTNO = :DEPTNO
AND EMP.DEPTNO LIKE :DEPTNO || '%';

SELECT *
FROM table(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND EMP.DEPTNO = :DEPTNO
AND DEPT.LOC = :LOC;

SELECT LOC
FROM DEPT;

CREATE INDEX idx_n_emp_02 ON emp (empno);
CREATE INDEX idx_n_emp_01 ON emp (deptno, sal);
DROP INDEX idx_n_emp_01;
CREATE INDEX idx_n_dept_01 ON dept (loc);
DROP INDEX idx_n_dept_01;












