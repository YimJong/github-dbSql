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
       CASE WHEN (MOD(To_CHAR(hiredate, 'yyyy'),2) = 0) and (MOD(TO_CHAR(SYSDATE, 'yyyy'), 2) = 0) THEN '�˰����� �����'
            WHEN (MOD(To_CHAR(hiredate, 'yyyy'),2) = 1) and (MOD(TO_CHAR(SYSDATE, 'yyyy'), 1) = 1) THEN '�˰����� �����'
            ELSE '�ǰ����� ������'
       END AS contact_to_doctor
FROM emp;

SELECT MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2) AS year
FROM dual;

-- GROUP BY ���� ���� ����
-- �μ���ȣ�� ���� ROW ���� ���� ��� : GROUP BY deptno
-- �������� ���� ROW ���� ���� ��� : GROUP BY job
-- MGR�� ���� �������� ���� ROW ���� ���� ��� : GROUP BY mgr, job

-- �׷��Լ��� ����
-- SUM : �հ�
-- COUNT : ���� - NULL ���� �ƴ� ROW�� ����
-- MAX : �ִ밪
-- MIN : �ּҰ�
-- AVG : ���

-- �׷��Լ��� Ư¡
-- �ش� �÷��� NULL���� ���� ROW�� ������ ��� �ش� ���� �����ϰ� ����Ѵ�. (NULL ������ ����� NULL)

-- �μ��� �޿� ��

-- �׷��Լ� ������
-- GROUP BY ���� ���� �÷��̿��� �ٸ� �÷��� SELECT���� ǥ���Ǹ� ����.
SELECT deptno, ename, SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal, 
       COUNT(sal) as count, SUM(comm)
FROM emp
GROUP BY deptno, ename;

-- GOURP BY ���� ���� ���¿��� �׷��Լ��� ����� ���
-- ��ü���� �ϳ��� ������ ���´�.
SELECT SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal, 
       COUNT(sal) as count, SUM(comm)
FROM emp;

SELECT SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal,
       COUNT(sal),  -- sal �÷��� ���� NULL�� �ƴ� row�� ����
       COUNT(comm), -- COMM �÷��� ���� NULL�� �ƴ� row�� ����
       COUNT(*) -- ����� �����Ͱ� �ִ��� 
FROM emp;


SELECT SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal,
       COUNT(sal),  -- sal �÷��� ���� NULL�� �ƴ� row�� ����
       COUNT(comm), -- COMM �÷��� ���� NULL�� �ƴ� row�� ����
       COUNT(*) -- ����� �����Ͱ� �ִ��� 
FROM emp
GROUP BY empno;

-- �׷�ȭ�� ���þ��� ������ ���ڿ�, �Լ�, ���ڵ��� SELECT���� ������ ���� ����.
SELECT 1, SYSDATE, 'ACCOUNTING', SUM(sal) as sum_sal, MAX(sal) as max_sal, MIN(sal) as min_sal, ROUND(AVG(sal), 2) as avg_sal,
       COUNT(sal),  -- sal �÷��� ���� NULL�� �ƴ� row�� ����
       COUNT(comm), -- COMM �÷��� ���� NULL�� �ƴ� row�� ����
       COUNT(*) -- ����� �����Ͱ� �ִ��� 
FROM emp
GROUP BY empno;

-- SINGLE ROW FUNCTION�� ��� WHERE ������ ����ϴ� ���� �����ϳ�
-- MULTI ROW FUNCTION�� ��� WHERE ������ ����ϴ� ���� �Ұ��� �ϰ�
-- HAVING ������ ������ ����ϳ�.

-- �μ��� �޿� �� ��ȸ, �� �޿����� 9000�̻��� row�� ��ȸ
-- deptno, �޿���
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
-- ORACLE 9I ���������� GROUP BY���� ������÷����� ������ ����
-- ORACLE 10G ���� ���ʹ� GROUP BY���� ����� �÷����� ������ ���� ���� �ʴ´�. (GROUP BY ����� �ӵ� UP)
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
-- �μ��� ���� �ִ��� : 10, 20, 30 3���� ROW�� ����
-- ���̺��� ROW ���� ��ȸ : GROUP BY ���� COUNT(*)
SELECT COUNT(*) AS cnt
FROM
(SELECT deptno
 FROM emp
 GROUP BY deptno);
 
 
 