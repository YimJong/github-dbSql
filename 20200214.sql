--GROUP 03

SELECT deptno, job, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--GROUP 04
SELECT d.dname, e.job, SUM(e.sal + NVL(e.comm, 0)) sal
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
GROUP BY ROLLUP (d.dname, e.job)
ORDER BY d.dname ASC, sal DESC;

SELECT b.dname, a.job, a.sal
FROM
(SELECT deptno, job, SUM(sal) sal
 FROM emp
 GROUP BY ROLLUP (deptno, job) ) a, dept b
WHERE a.deptno = b.deptno(+); 


--GROUP 05
SELECT DECODE(GROUPING(d.dname), 1 , '����', d.dname) as dname,
       e.job, SUM(e.sal + NVL(e.comm, 0)) sal
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
GROUP BY ROLLUP (d.dname, e.job)
ORDER BY dname ASC, sal DESC;


-- GROUPING SETS
-- ������ ������� ���� �׷��� ����ڰ� ���� ����
-- ����� : GROUP BY GROUPING SETS(col1, col2.....)
-- ��
-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2

-- GROUP BY GROUPING STES( (col1, col2), col3, col4)
-- ��
-- GROUP BY col1, col2
-- UNION ALL
-- GROUP BY col3
-- UNION ALL
-- GROUP BY col4;

-- GROUPING SETS�� ��� �÷� ��� ������ ����� ������ ��ġ�� �ʴ´�
-- ROLLUP�� �÷� ��� ������ ��� ������ ��ģ��.

--GROUB BY GROUPING SETS (job, deptno)
--��
--GROUP BY job
--UNION ALL
--GROUP BY deptno;
--
--SELECT job, SUM(sal) sal
--FROM emp
--GROUP BY GROUPING STES (job, job);
--
--job, deptno�� group by �� �����
--mgr�� GROUP BY�� ����� ��ȸ�ϴ� SQP�� GROUPING SETS�� �޿� �� �ۼ�.

SELECT deptno, job, mgr, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS (
                        (job, deptno),
                        (mgr)
                        );

-- CUBE
-- ������ ��� �������� �÷��� ������ SUB GROUP�� �����Ѵ�.
-- �� ����� �÷��� ������ ��Ű��.

-- ex: GROUP BY CUBE(col1, col2);

-- (col1, col2) == GROUP BY col2
-- (null, col2) == GROUP BY ��ü
-- (null, null) == GROUP BY col1
-- (col1, null) == GROUP BY col1, col2

SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY CUBE(job, deptno);

-- ȥ��
SELECT job, deptno, mgr, SUM(sal) sal
FROM emp
GROUP BY job, ROLLUP(deptno), cube(mgr);


-- �������� UPDATE
-- 1. ���� emp_test ���̺� drop
-- 2. emp ���̺��� �̿��ؼ� emp_test ���̺��� ���� (��� �࿡ ���� ctas)
-- 3. emp_test ���̺� dname VARCHAR2(14)�÷� �߰�
-- 4. emp_test.dname �÷��� dept ���̺��� �̿��ؼ� �μ����� ������Ʈ

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

UPDATE emp_test SET dname = (SELECT dname
                             FROM dept
                             WHERE dept.deptno = emp_test.deptno
                             );
                             
-----  sub a1

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

SELECT *
FROM dept_test;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test SET empcnt = (
                               SELECT COUNT(*)
                               FROM emp
                               WHERE emp.deptno = dept_test.deptno
                              );
                              
-- sub a2
-- dept_test.empcnt �÷��� ������� �ʰ� emp ���̺��� �̿��Ͽ� ����.
INSERT INTO dept_test VALUES(99, 'it1', 'daejeon', 0);
INSERT INTO dept_test VALUES(98, 'it2', 'daejeon', 0);
COMMIT;

SELECT *
FROM dept_test;
                              
DELETE dept_test
WHERE 0 = (SELECT COUNT(*) cnt
           FROM emp
           WHERE emp.deptno = dept_test.deptno
          );
       
       
-- sub a3
SELECT *
FROM emp_test;

UPDATE emp_test a SET sal = sal + 200
WHERE sal < (SELECT AVG(sal)
             FROM emp_test b 
             WHERE  a.deptno = b.deptno);
            
            
-- WITH ��
-- �ϳ��� �������� �ݺ��Ǵ� SUBQUERY�� ���� ��
-- �ش� SUBQUERY�� ������ �����Ͽ� ����

-- MAIN������ ����� �� WITH ������ ���� ���� �޸𸮿� �ӽ������� ����.
-- �� MAIN ������ ���� �Ǹ� �޸� ����

-- SUBQUERY �ۼ� �ÿ��� �ش� SUBQUERY�� ����� ��ȸ�ϱ� ���ؼ� I/O�� �ݺ������� �Ͼ����
-- WITH���� ���� �����ϸ� �ѹ��� SUBQUERY�� ������ �� ����� �޸𸮿� ���� �س��� ����
-- ��, �ϳ��� �������� ������ SUBQUERY�� �ݺ������� ������ ���� �߸� �ۼ��� SQL�� Ȯ���� ����.                                         

-- ����
WITH ������� �̸� AS (
    ��������
);

SELECT *
FROM ������� �̸�;

������ �μ��� �޿� ����� ��ȸ�ϴ� ��������� WITH���� ���� ����;

WITH sal_avg_dept AS (
    SELECT deptno, ROUND(AVG(sal), 2) sal
    FROM emp
    GROUP BY deptno
    ),
    dept_empcnt AS (
    SELECT deptno, COUNT(*) empcnt
    FROM emp
    GROUP BY deptno
    )
    
SELECT *
FROM sal_avg_dept a, dept_empcnt b
WHERE a.deptno = b.deptno;

-- WITH���� �̿��� �׽�Ʈ ���̺� �ۼ�.
WITH temp AS (
    SELECT sysdate - 1 FROM dual UNION ALL
    SELECT sysdate - 2 FROM dual UNION ALL
    SELECT sysdate - 3 FROM dual)

SELECT *
FROM temp;

�޷¸����;

-- CONNECT BY LEVEL <[=]  ����
-- �ش� ���̺��� ���� ���� ��ŭ �����ϰ�, ������ ���� �����ϱ� ���ؼ� LEVEL�� �ο�
-- LEVEL�� 1���� ����

SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <= 10;

SELECT dept.*, LEVEL
FROM dept
CONNECT BY LEVEL <= 5;

-- 2020�� 2���� �޷��� ����.
-- :dt = 202002, 202003
-- �޷�
-- �� �� ȭ �� �� �� ��
SELECT TO_DATE('202002', 'YYYYMM') + (LEVEL -1),
       TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'),
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'),
       1, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) su, 
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'),
       2, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) m,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'),
       3, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) tu,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'),
       4, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) w,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'),
       5, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) tr,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'),
       6, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) f,
       DECODE(TO_CHAR(TO_DATE('202002', 'YYYYMM') + (LEVEL -1), 'D'),
       7, TO_DATE('202002', 'YYYYMM') + (LEVEL -1)) sa
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD');

SELECT TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD')
FROM dual;