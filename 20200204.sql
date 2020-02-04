-- CROSS JOIN �� īƼ�� ���δ�Ʈ (Cartesian product)
-- �����ϴ� �� ���̺��� ���� ������ �����Ǵ� ��� ������ ��� ���տ� ���� ����(����)�� �õ�
-- dept(4��), emp(14��)�� CROSS JOIN�� ����� 4*14 = 56��

-- dept ���̺�� emp ���̺��� ������ �ϱ� ���� FROM ���� �ΰ��� ���̺��� ���
-- WHERE���� �� ���̺��� ���� ������ ����
-- ��� ����� �� ���

-- ���̺� �� �����ϴ� ��캸�� ������ ������ ���� ���.

SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp;

-- crossjoin 1
SELECT customer.cid, customer.cnm, product.pid, product.pnm
FROM customer, product;


-- SUBQUERY : ���� �ȿ� �ٸ� ������ �� �ִ� ���
-- SUBQUERY�� ���� ��ġ�� ���� 3������ �з� 
-- SELECT �� : SCALAR SUBQUERY : �ϳ��� ��, �ϳ��� �÷��� �����ؾ� ������ �߻����� ����.
-- FROM �� : INLINE-VIEW
-- WHERE �� : SUBQUERY 

-- ���ϰ��� �ϴ� ��
-- SMITH�� ���� �μ��� ���ϴ� �������� ������ ��ȸ

-- 1.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

-- 2.
SELECT *
FROM emp
WHERE deptno = 20;

-- SUBQUERY�� �̿��ϸ� �ΰ��� ������ ���ÿ� �ϳ��� SQL�� ������ ����.
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
-- SUB1 : ��� �޿����� ���� �޿��� �޴� ������ ��
-- 1. ��� �޿� ���ϱ�
-- 2. ���� ��� �޿����� ���� �޿��� �޴� ���
SELECT count(*)
FROM emp
WHERE sal >(SELECT avg(sal)
            FROM emp);
            
-- SUB2
SELECT *
FROM emp
WHERE sal >(SELECT avg(sal)
            FROM emp);

-- ������ ������
-- IN : ���������� ������ �� ��ġ�ϴ� ���� ���� �� ��
-- ANY (Ȱ�뵵�� �ټ� ������) : ���������� ������ �� �� ���̶� ������ ������ ��
-- ALL (Ȱ�뵵�� �ټ� ������) : ���������� ������ �� ��� �࿡ ���� ������ ������ ��

-- SUB3
-- SMITH �� WARD ������ ���ϴ� �μ��� ��� ���� ������ ��ȸ.
-- ���������� ����� �������϶��� '=' ������ ��� �Ұ���.
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename in ('SMITH', 'WARD'));
                 
-- SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ.
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename in ('SMITH', 'WARD'));
                
-- SMITH, WARD���� �޿��� ū ������ ����     
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename in ('SMITH', 'WARD'));

-- IN, NOT IN�� NULL�� ���õ� ���� ����

-- ������ ������ ����� 7902 �̰ų� NULL
-- IN �����ڴ� OR �����ڷ� ġȯ����
-- NULL �񱳴� '=' �����ڰ� �ƴ϶� IS NULL�� �� �ؾ��������� IN �����ڴ� '='�� ����Ѵ�.
SELECT *
FROM emp
WHERE mgr = 7902 OR mgr IS NULL;

-- NOT IN ������ �ȿ� NULL�� ������ �����Ͱ� ������ ����. NULL�� ���갪�� �׻� NULL�̱� ����.
-- ��ü�� NULL�� ��ó�� ������.
SELECT *
FROM emp
WHERE empno NOT IN (7902, NULL);

SELECT *
FROM emp
WHERE empno != 7902
AND empno IS NOT NULL;

-- multi column subquery (pairwise)
-- �������� ����� ���ÿ� ���� ��ų��
-- (7698, 30) (7839, 10)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));

SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

-- non-pairwise�� �������� ���ÿ� ������Ű�� �ʴ� ���·� �ۼ�
-- mgr ���� 7698�̰ų� 7839 �̸鼭
-- deptno�� 10�̰ų� 30���� ����
-- mgr, deptno
-- (7698, 10), (7698, 30)
-- (7839, 10), (7839, 10);
SELECT *
FROM emp
WHERE mgr IN ( SELECT mgr
               FROM emp
               WHERE empno IN (7499, 7782))
AND deptno IN ( SELECT denpno
                FROM emp
                WHERE empno IN (7499, 7782));
                
-- ��Į�� �������� : SELECT ���� ���, 1���� ROW, 1���� COL�� ��ȸ�ϴ� ����
-- ��Į�� ���������� MAIN ������ �÷��� ����ϴ°� �����ϴ�.

SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;

SELECT empno, ename, deptno,
       (SELECT dname FROM dept WHERE deptno = emp.deptno) AS dname
FROM emp;

-- INLINE VIEW : FROM���� ����Ǵ� ��������;

-- MAIN ������ �÷��� SUBQUERY���� ��� �ϴ��� ������ ���� �з�
-- ��� �� ��� : correlated subquery (��ȣ ���� ����), ���������� �ܵ����� �����ϴ°� �Ұ���.
--              ���� ������ ������ �ִ�. (main �� sub)
-- ��� �� �� ��� : non-correlated subquery(���ȣ ���� ��������), ���������� �ܵ����� ���� ����.
--              ���� ������ ������ ���� �ʴ�. (main �� sub, sub �� main)

-- ��� ������ �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp
WHERE sal > (SELECT avg(sal)
             FROM emp);             
             
-- ������ ���� �μ��� �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
             FROM emp s
             WHERE s.deptno = m.deptno);
             
-- ���� ������ ������ �̿��ؼ� Ǯ���
-- 1. ���� ���̺� ����
--  emp, �μ��� �޿� ���(inline view)
SELECT emp.ename, emp.sal, emp.deptno, dept_sal.*
FROM emp, (SELECT deptno, round(avg(sal)) avg_sal
           FROM emp
           GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;

-- SUB4
-- ������ �߰�
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
ROLLBACK; -- Ʈ����� ���, Ŀ���� �ѹ� ������ �ٽ� ���ư��� ����.
COMMIT; -- �����͸� �߰�, ����, ���� �� �ʿ�. Ʈ����� Ȯ��

SELECT *
FROM dept;

SELECT deptno, dname, loc
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);