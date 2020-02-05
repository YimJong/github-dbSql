-- SUB4
-- dept ���̺��� 5���� �����Ͱ� ����
-- emp ���̺��� 14���� ������ �ְ�, ������ �ϳ��� �μ� �ӿ� �ִ�.(deptno)
-- �μ� �� ������ ���� ���� ���� �μ� ������ ��ȸ

-- ������������ �������� ������ �´��� Ȯ���� ������ �ϴ� �������� �ۼ�.

SELECT *
FROM dept;

SELECT deptno
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);
 
-- SUB5
-- 1. 1�� ���� �����ϴ� ��ǰ ��ȸ (pid)
-- 2. pid, pnm ��ȸ �� 1.���� ��ȸ �� ���� �����ؼ� �������� �ʴ� ��ǰ ���� ��ȸ.
SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);
-- SUB6
-- 1. ����ȣ�� 2���� ���� ������ǰ�� ���� ��ȸ
-- 2. ����ȣ�� 1���� ���� ������ǰ ���ǰ� 1.���� ��ȸ�� 2�� ���� ������ǰ�� ���ǿ� �߰��Ͽ� ��ȸ.
SELECT *
FROM cycle
WHERE cid = 1 AND pid IN (SELECT pid
                          FROM cycle
                          WHERE cid = 2);
                          
-- SUB7
SELECT a.cid, customer.cnm, a.pid, product.pnm, a.day, a.cnt
FROM
(SELECT *
 FROM cycle
 WHERE cid = 1 AND pid IN (SELECT pid
                          FROM cycle
                          WHERE cid = 2)) a, customer, product
where a.cid = customer.cid
AND a.pid = product.pid;


-- ũ�ν� ���� �� ������ �ִ� ���?
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN ( SELECT pid
                   FROM cycle
                   WHERE cid = 2)
AND customer.cid = cycle.cid
AND product.pid = cycle.pid;
                                                 
                                              
-- �Ŵ����� �����ϴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- EXSITS ���ǿ� �����ϴ� ���� ���� �ϴ� �� Ȯ���ϴ� ������.
-- �ٸ� �����ڿ� �ٸ��� WHERE ���� �÷��� ������� �ʴ´�.
-- WHERE empno = 7369
-- WHERE EXISTS (SELECT 'X'
--               FROM .......)

-- �Ŵ����� �����ϴ� ������ EXISTS �����ڸ� ���� ��ȸ
-- �Ŵ����� ����
SELECT empno, ename, mgr
FROM emp e  -- �������������� emp�� ��� �ϱ� ������ alias �ο�
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);
              
              
 -- SUB 9
SELECT *
FROM product;
 
SELECT pid
FROM cycle e 
WHERE EXISTS (SELECT 'X'
              FROM cycle 
              WHERE e.cid  = 1);


SELECT p.pid, p.pnm
FROM product p JOIN (SELECT c.pid
                     FROM cycle c
                     WHERE EXISTS (SELECT 'X'
                                   FROM cycle e
                                   WHERE c.cid = 1)) a ON (p.pid = a.pid)
GROUP BY p.pid, p.pnm;


-- ���ȣ?
SELECT *
FROM product
WHERE EXISTS (SELECT 'X'
              FROM cycle
              WHERE cid = 1
              AND cycle.pid = product.pid);


-- SUB10
SELECT *                -- �������� �ʴ� �����͸� ��ȸ.
FROM product
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle
                  WHERE cid = 1
                  AND cycle.pid = product.pid);
                  
-- ���տ���
-- ������ : UNION - �ߺ�����(���հ���) / UNION ALL - �ߺ��� �������� ����(�ӵ� ���)
-- ������ : INTERSECT (���հ���)
-- ������ : MINUS (���հ���)
-- ���տ����� �������
-- �� ������ �÷��� ����, Ÿ���� ��ġ �ؾ� �Ѵ�.

-- ������ �����ʹ� �ѹ��� ��ȸ�ȴ�.
SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698);

              
-- UNION ALL �����ڴ� �ߺ��� ����Ѵ�.              
SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698);


-- INTERSECT (������) : ��, �Ʒ� ���տ��� ���� ���� �ุ ��ȸ
SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698); 
              
              
-- MINUS (������) : �� ���տ��� �Ʒ� ������ �����͸� ������ ������ ����.
SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698); 

-- ������ ��� ������ ������ ���� ���� ������.
-- A UNION B        B UNION A  �� ����
-- A UNION ALL B    B UNION ALL A �� ����
-- A INTERSECT B    B INTERSECT A �� ����
-- A MINUS B        B MINUS A �� �ٸ�

-- ���� ������ ��� �÷� �̸��� ù��° ������ �÷����� ������.
SELECT 'X' fir, 'B' sec
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

-- ����(ORDER BY)�� ���տ��� ���� ������ ���� ������ ���
SELECT deptno, dname, loc
FROM (SELECT deptno, dname, loc
      FROM dept
      WHERE deptno IN (10, 20)
      ORDER BY deptno)

UNION

SELECT *
FROM dept
WHERE deptno IN (30, 40);


-- �ܹ��� ���� ���� ����

SELECT *
FROM fastfood;

-- �õ�, �ñ���, ��������
SELECT a.sido, a.sigungu, round(a.ct/b.ct, 1) as burger
FROM 
    (SELECT sido, sigungu, count(*) ct
     FROM fastfood
     WHERE gb IN ('KFC', '�Ƶ�����', '����ŷ')
     GROUP BY sido, sigungu) a,
    (SELECT sido, sigungu, count(*) ct
     FROM fastfood
     WHERE gb = '�Ե�����'
     GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY burger DESC;

