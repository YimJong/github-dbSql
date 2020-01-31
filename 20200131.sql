SELECT userid, usernm, alias, reg_dt, 
       CASE WHEN MOD(TO_CHAR(reg_dt, 'YYYY'), 2) = 0 AND MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = 0 THEN '�ǰ� ���� �����'
            WHEN MOD(TO_CHAR(reg_dt, 'YYYY'), 2) = 1 AND MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = 1 THEN '�ǰ� ���� �����'
            ELSE '�ǰ� ���� ������'
       END AS contact_to_doctor
FROM (SELECT userid, usernm, alias, NVL(reg_dt, TO_DATE(SYSDATE, 'YYYY/MM/DD')) AS reg_dt
      FROM users);

SELECT ename, deptno
FROM emp;

SELECT *
FROM dept;

-- JOIN �� ���̺��� �����ϴ� �۾�
-- JOIN ����
--  1. ANSI ����
--  2. ORACLE ����

-- Natural Join
-- �� ���̺� �� �÷����� ���� �� �ش� �÷����� ����(����)
-- emp, dept ���̺��� deptno��� �̸��� ������ �÷��� ����.
-- Ÿ�Ե� �����ؾ� ��.
SELECT *
FROM emp NATURAL JOIN dept;

-- Natural Join�� ���� ���� �÷�(deptno)�� ������ ��� �Ұ���.
SELECT emp.empno, emp.ename, dept.dname, deptno
FROM emp NATURAL JOIN dept;

-- ���̺� ���� ��Ī�� ��밡��
SELECT e.empno, e.ename, d.dname, deptno
FROM emp e NATURAL JOIN dept d;


-- ORACLE JOIN
-- FROM ���� ������ ���̺� ����� , �� �����Ͽ� �����Ѵ�.
-- ������ ���̺��� ���� ������ WHERE���� ����Ѵ�.
-- emp, dept ���̺� �����ϴ� deptno �÷��� (���� ��) ����

SELECT emp.ename, dept.dname -- ANSI�� �ݴ�, ���ο� ���� �÷��� �����ڸ� ǥ�� �� �־�� ��.
FROM emp, dept -- ������ ���̺� ����
WHERE emp.deptno = dept.deptno; -- ���� ���� ex)���� !=�� �̿��ϸ� ���� ���� �ٸ� �� ����.

-- ����Ŭ ������ ���̺� ��Ī
SELECT e.empno, e.ename, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI : join with using
-- ���� deptno �Ϸ��� �ΰ��� ���̺� �̸��� ���� �÷��� �ΰ������� �ϳ��� �÷����θ� ������ �ϰ��� �� ��
-- �����Ϸ��� ���� �÷��� ���.
-- emp, dept ���̺��� ���� �÷� : deptno
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

-- JOIN WITH USING �� ORACLE�� ǥ���ϸ�?
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ANSI : JOIN WITH ON
-- ���� �Ϸ����ϴ� ���̺��� �÷��� �̸��� ���� �ٸ� ��
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- JOIN WITH ON  --> ORACLE
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELF JOIN : ���� ���̺� ���� ���� ex)������ ��ȣ�� emp ���̺� �ְ� ������ ��ȣ�� ����Ǵ� ��� ��ȣ �� ������ emp ���̺� ����.
-- ex) emp ���̺��� �����Ǵ� ����� ������ ����� �̿��Ͽ� ������ �̸��� ��ȸ�� ��
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

-- ORACLE ����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

---------------------------------------------------- equal ����

-- equal ���� : =
-- non-equal ���� : !=, >, <, BETWEEN AND

-- ����� �޿� ������ �޿� ��� ���̺��� �̿��Ͽ� �ش� ����� �޿� ����� ���غ���.
SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;

SELECT emp.ename, emp.sal, salgrade.grade                           -- non-squal ���ο� �ش�
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

SELECT e.empno, e.ename, d.deptno, d.dname  -- ������ �Ⱦ��� �÷��� ��ȣ�ϴٰ� ���� ��.
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