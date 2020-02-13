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

-- �� 3��° �ε����� �ٸ� ���� �÷��� ���� ������ �ٸ�
-- ���� �÷����� ��ȸ?

CREATE INDEX idx_n_emp_04 ON emp (ename, job);

-- �� �ε��� ���
SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

-- ������̸� ���� ���� 3��° �ε��� ��� ����

DROP INDEX idx_n_emp_03;
DROP INDEX idx_n_emp_04;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM table(dbms_xplan.display);

-- ���� �� ������ �ε��� ��� ��...

-- emp - table full, pk_emp(empno)
-- dept - table full, pk_dept(deptno)

-- ������ ���� ���� �ɼ�
-- (emp - table full, dept - table full)
-- (emp - table full, dept - pk_dept)
-- (emp - pk_emp, dept - table full)
-- (emp - pk_emp, dept - pk_dpet)

-- 1. ����
-- ������ ������ ���� �ǹǷ� emp - dept , dept - emp ������ 2���� ����� ��.

-- ORACLE - �ǽð� ���� : OLTP (ON LINE TRANSACTION PROCESSING)
--         ��ü ó���ð� : OLAP (ON LINE ANALYSIS PROCESSING) - ������ ������ �����ȹ�� ����µ� 30M ~ 1H �ҿ�� �� ����.

-- 2. 2�� ���̺� ����
-- ������ ���̺� �ε����� 5���� �ִٸ�
-- �� ���̺� ���� ���� : 6��
-- 6 * 6 * 2 : 72 (�� ���̺����� * �� ���̺� ���� * ����)

-- emp ���� ���� �� dept ���� ���� ��?
EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM table(dbms_xplan.display);


-- idx 1
CREATE TABLE dept2 AS   -- CTAS �������� ���簡 NOT NULL�� �ȴ�
SELECT *                -- ����̳� �׽�Ʈ�����θ� ����.
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
-- 1. empno(=) �� 3���� �պ�
-- 2. ename(=)
-- 3. deptno(=), empno(LIKE ������ȣ%)
-- 4. deptno(=), sal (BETWEEN)
-- 5. deptno(=) / mgr �����ϸ� ����
--    empno(=) �� �ʿ� ����
-- 6. deptno, hiredate�� �ε����� �����ϸ� ����
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












