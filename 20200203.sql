SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;

SELECT *
FROM daily;

SELECT *
FROM batch;

-- join4
SELECT cid, c.cnm, cy.pid, cy.day, cy.cnt
FROM customer c NATURAL JOIN cycle cy
WHERE c.cnm in ('brown', 'sally');
-- NATURAL JOIN�� �����÷��� ���̺� ��Ī�̳� �̸� ������ �� ��.

-- join5
SELECT c.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM customer c JOIN cycle cy ON (c.cid = cy.cid)
     JOIN product p ON (cy.pid = p.pid)
WHERE c.cnm in ('brown', 'sally');

SELECT c.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM customer c, cycle cy, product p
WHERE c.cid = cy.cid AND cy.pid = p.pid
AND c.cnm in ('brown', 'sally');
     
-- join6
SELECT c.cid, c.cnm, cy.pid, p.pnm, sum(cy.cnt) AS cnt
FROM customer c JOIN cycle cy ON (c.cid = cy.cid)
     JOIN product p ON (cy.pid = p.pid)
GROUP BY c.cnm, p.pnm, c.cid, cy.pid
ORDER BY c.cid ASC;


SELECT c.cid, c.cnm, cy.pid, p.pnm, sum(cy.cnt) AS cnt
FROM customer c, cycle cy, product p
WHERE c.cid = cy.cid and cy.pid = p.pid
GROUP BY c.cnm, p.pnm, c.cid, cy.pid
ORDER BY c.cid ASC;



-- join7
SELECT p.pid, p.pnm, sum(cy.cnt) AS cnt
FROM cycle cy JOIN product p ON (cy.pid = p.pid)
GROUP BY p.pid, p.pnm
ORDER BY p.pid ASC;

SELECT p.pid, p.pnm, sum(cy.cnt) AS cnt
FROM cycle cy, product p
WHERE cy.pid = p.pid
GROUP BY p.pid, p.pnm
ORDER BY p.pid ASC;


-- OUTER JOIN
-- �� ���̺��� ������ �� ���� ������ ���� ��Ű�� ���ϴ� �����͸�
-- �������� ������ ���̺��� �����͸��̶� ��ȸ �ǰԲ� �ϴ� ���� ���

-- �������� : e.mgr = m.empno : king�� mgr�� null�̱� ������ ���ο� �����Ѵ�.
-- EMP���̺��� �����ʹ� �� 14�������� �Ʒ��� ���� ���������� ����� 13���� �ȴ� (1�� ���ν���)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- ANSI OUTER
-- ���ο� �����ϴ��� ��ȸ�� �� ���̺��� ���� (�Ŵ��� ������ ��� ��������� �����Բ�)

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON( e.mgr = m.empno );

-- RIGHT OUTER�� ����. (���̺��� ������ �߿�)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON( e.mgr = m.empno );

-- ORACLE OUTER JOIN
-- �����Ͱ� ���� ���� ���̺� �÷� �ڿ� (+)��ȣ�� �ٿ��ش�.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

-- ANSI �������� ����
-- �Ŵ����� �μ���ȣ�� 10���� ������ ��ȸ
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON ( e.mgr = m.empno AND m.deptno = 10);

-- JOIN ���� �� �� ���͸� ��.
-- �Ϲ� ���ΰ� ����� ����.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON ( e.mgr = m.empno )
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno   -- ���� ���
FROM emp e JOIN emp m ON ( e.mgr = m.empno )
WHERE m.deptno = 10;

-- ORACLE OUTER JOIN
-- ����Ŭ OUTER JOIN�� ���� ���̺��� �ݴ��� ���̺��� ��� �÷��� (+)���ٿ��� �������� OUTER JOIN���� �����Ѵ�.
-- �ϳ��� �÷��̶� (+)�� �����ϸ� INNER �������� �����Ѵ�.

-- �Ʒ� ORACLE OUTER ������ INNER �������� ���� : m.deptno �÷��� (+)�� ���� ����.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno = 10;

-- �������� ORACLE OUTER JOIN
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno(+) = 10;

-- ��� - �Ŵ����� RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

-- FULL OUTER = LEFT OUTER + RIGHT OUTER - �ߺ�
SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

-- OUTER JOIN 1
-- ANSI
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
                                        AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));
-- ORACLE
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');


-- OUTER JOIN 2
-- ANSI
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'YY/MM/DD')) AS buy_date,
       b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));
-- ORACLE
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'YY/MM/DD')) AS buy_date,
       b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id 
AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

-- OUTER JOIN 3
-- ANSI
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'YY/MM/DD')) AS buy_date, b.buy_prod, p.prod_id, p.prod_name, 
       NVL(b.buy_qty, 0)
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));
-- ORACLE
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'YY/MM/DD')) AS buy_date, b.buy_prod, p.prod_id, p.prod_name, 
       NVL(b.buy_qty, 0)
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id 
AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');


-- OUTER JOIN 4
SELECT p.pid, p.pnm, NVL(cy.cid, 1) AS cid, NVL(cy.day,0) AS day, NVL(cy.cnt, 0) AS cnt
FROM cycle cy RIGHT OUTER JOIN product p ON (cy.pid = p.pid AND cy.cid = 1);


-- OUTER JOIN 5
SELECT p.pid, p.pnm, NVL(cid, 1) AS cid, NVL(c.cnm, 'brown') AS cnm,
       NVL(cy.day, 0) AS day, NVL(cy.cnt, 0) AS day
FROM customer c JOIN cycle cy USING (cid)
     RIGHT OUTER JOIN product p ON (cy.pid = p.pid AND cid = 1)
ORDER BY p.pid DESC;