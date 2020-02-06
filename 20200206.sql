-- SUB1
SELECT count(*)
FROM emp
WHERE sal > (SELECT avg(sal)
             FROM emp);
             
-- SUB3  (���������� ���� ����� �� �̻��̸� '=' ��� �Ұ� - in ��ø ���)
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));


-- SUB4   
SELECT * 
FROM dept
WHERE deptno NOT IN( SELECT deptno
                     FROM emp );
                     
-- SUB5
SELECT *
FROM product
WHERE NOT EXISTS ( SELECT 'X'
                   FROM cycle
                   WHERE cid = 1
                   AND cycle.pid = product.pid);

-- SUB6
SELECT cid, pid, day, cnt
FROM cycle
WHERE cid = 2 AND pid IN (SELECT pid
                          FROM cycle
                          WHERE cid = 1);

SELECT c.cid, c.pid, c.day, c.cnt
FROM cycle c
WHERE cid = 1 AND pid IN (SELECT pid
                          FROM cycle
                          WHERE cid = 2);                  
                   
-- SUB7

SELECT c.cid, p.pid, p.pnm, c.day, c.cnt
FROM cycle c JOIN product p ON (c.pid = p.pid)
WHERE c.cid = 2 AND EXISTS ( SELECT 'X'
                             FROM cycle cy
                             WHERE cy.cid = 1 AND c.pid = cy.pid );
                             
SELECT c.cid, p.pid, p.pnm, c.day, c.cnt
FROM cycle c JOIN product p ON (c.pid = p.pid)
WHERE c.cid = 1 AND EXISTS ( SELECT 'X'
                             FROM cycle cy
                             WHERE cy.cid = 2 AND c.pid = cy.pid );  
                             
-- SUB9
SELECT p.pid, p.pnm
FROM product p JOIN (SELECT c.pid
                     FROM cycle c
                     WHERE EXISTS( SELECT 'X'
                                   FROM cycle
                                   WHERE c.cid = 1)) a 
ON(a.pid = p.pid);

-- SUB10
SELECT p.pid, p.pnm
FROM product p
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle
                  WHERE cid = 1 AND p.pid = cycle.pid);



-- ���� (KFC, ����ŷ, �Ƶ�����)
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '����������' AND gb in ('KFC', '��Ŀŷ', '�Ƶ�����')
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '����������' AND gb = '�Ե�����'
GROUP BY sido, sigungu;

------- 
SELECT sido, sigungu, ROUND((kfc + burgerking + mac) / lot, 2) AS burgerindex
FROM 
   (SELECT sido, sigungu,
    NVL(SUM(DECODE(gb, 'KFC', 1)), 0) kfc, NVL(SUM(DECODE(gb, '����ŷ', 1)), 0) burgerking,
    NVL(SUM(DECODE(gb, '�Ƶ�����', 1)), 0) mac, NVL(SUM(DECODE(gb, '�Ե�����', 1)), 1) lot -- 0���� ������ �����̹Ƿ� �Ե����ƴ� 1�� ���ڵ�
    
FROM fastfood
WHERE gb IN('KFC', '����ŷ', '�Ƶ�����', '�Ե�����')
GROUP BY sido, sigungu)
ORDER BY burgerindex DESC;


-- �ؽ� ���̺��� ���κ� �ҵ� ��ȸ
SELECT sido, sigungu, ROUND(sal / people) AS pri_sal
FROM TAX
ORDER BY pri_sal DESC;




-- �ܹ������� �õ�, �ܹ������� �ñ���, �ܹ�������, ���� �õ�, ���� �ñ���, ���κ� �ٷμҵ��
-- ANSI 
SELECT tax_index.sido, tax_index.sigungu, tax_index.pri_sal,
       burger_index.sido, burger_index.sigungu, burger_index.burger
FROM
    (SELECT ROWNUM rn, t.*
     FROM (SELECT sido, sigungu, ROUND(sal / people) AS pri_sal
           FROM TAX
           ORDER BY pri_sal DESC) t) tax_index 
           
     JOIN     
          
     (SELECT ROWNUM rn, c.*
      FROM
         (SELECT a.sido, a.sigungu, round(a.ct/b.ct, 1) as burger
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
      ORDER BY burger DESC) c) burger_index ON (tax_index.rn = burger_index.rn); 
      
---------------------------------------------------------------------------------------
-- Oracle Join
SELECT tax_index.sido, tax_index.sigungu, tax_index.pri_sal,
       burger_index.sido, burger_index.sigungu, burger_index.burger
FROM
    (SELECT ROWNUM rn, t.*
     FROM (SELECT sido, sigungu, ROUND(sal / people) AS pri_sal
           FROM TAX
           ORDER BY pri_sal DESC) t) tax_index , 
   
     (SELECT ROWNUM rn, c.*
      FROM
         (SELECT a.sido, a.sigungu, round(a.ct/b.ct, 1) as burger
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
      ORDER BY burger DESC) c) burger_index
WHERE tax_index.rn = burger_index.rn;
     
    
-- DML

-- empno �÷��� NOT NULL ���� ������ �ִ�. - INSERT�� �ݵ�� ���� �����ؾ� ���������� �Էµȴ�.
-- empno �÷��� ������ ������ �÷��� NULLABLE�̴�. (NULL ���� ����� �� �ִ�.)
INSERT INTO emp (empno, ename, job)
VALUES ( 9999, 'brown', NULL);
ROLLBACK;

SELECT *
FROM emp;

-- NOT NULL �������� ���� ������ ���� �Ұ���.
INSERT INTO emp (ename, job)
VALUES ( 'sally', 'SALESMAN' );

-- ���ڿ� : '���ڿ�' �� �ڹ� "���ڿ�"
-- ���� : 10
-- ��¥ : TO_DATE('20200206', 'YYYYMMDD')

-- emp ���̺��� hiredate �÷��� date Ÿ��.
-- emp ���̺��� 8���� �÷��� ���� �Է�.
DESC emp;

INSERT INTO emp VALUES ( 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99);
ROLLBACK;

-- �������� �����͸� �ѹ��� INSERT : 
-- INSERT INTO ���̺�� (�÷���1, �÷���2,...)
-- SELECT ...
-- FROM ;
INSERT INTO emp 
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99 
FROM dual
    UNION ALL
SELECT 9999, 'brown', 'CLERK', NULL, TO_DATE('20200205', 'YYYYMMDD'), 1100, NULL, 99
FROM dual;

-- UPDATE ����
-- UPDATE ���̺�� SET �÷���1 = ������ �÷� ��1, �÷���2 = ������ �÷� ��2,......
-- WHERE �� ���� ����
-- ������Ʈ ���� �ۼ��� WHERE ���� �������� ������ �ش� ���̺��� ��� ���� ������� ������Ʈ�� �Ͼ��.
-- UPDATE, DELETE ���� WHERE ���� ������ �ǵ��Ѱ� �´��� �ٽ��ѹ� Ȯ�� �� ���ƾ� �Ѵ�.
-- WHERE ���� �ִٰ� �ϴ��� �ش� �������� �ش� ���̺��� SELECT �ϴ� ������ �ۼ��Ͽ� �����ϸ� UPDATE ��� ���� ��ȸ �� �� �����Ƿ�
-- Ȯ�� �ϰ� �����ϴ� �͵� ��� �߻� ������ ������ �ȴ�.

-- 99�� �μ���ȣ�� ���� �μ� ������ DEPT���̺� �ִ� ��Ȳ
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept;

-- 99�� �μ���ȣ�� ���� �μ��� dname �÷��� ���� '���IT', loc�÷��� ���� '���κ���'���� ������Ʈ;
UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;
ROLLBACK;

-- ������Ʈ �Ϸ��� ����� ����. Ȯ���� �� ��.
SELECT *
FROM dept
WHERE deptno = 99;

-- �Ǽ��� WHERE���� ������� �ʾ��� ���
UPDATE dept SET dname = '���IT', loc = '���κ���';
-- WHERE deptno = 99;


-- SMITH, WARD�� ���� �μ��� �Ҽӵ� ���� ����
SELECT  *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD')); -- ���� ���� ���� ���̽��� �ٸ� �μ��� ���� ����� ����.
                 
-- UPDATE�ÿ��� ���� ���� ����� ����
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
-- 9999�� ��� deptno, job ������ SMITH ����� ���� �μ�����, �������� ������Ʈ
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;

ROLLBACK;

-- DML(DELETE) : Ư�� ���� ����
-- DELETE [FROM] ���̺�� WHERE �� ���� ����
SELECT *
FROM dept;

DELETE dept          -- �μ���ȣ�� 99���� '��' ����
WHERE deptno = 99;
COMMIT;

-- SUBQUERY�� ���ؼ� Ư�� ���� �����ϴ� ������ ���� DELETE
-- �Ŵ����� 7698 ����� ������ ���� �ϴ� ������ �ۼ�

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);

SELECT *
FROM emp;
                
ROLLBACK;