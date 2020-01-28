SELECT *
FROM emp
WHERE deptno in(10, 30) and sal > 1500
ORDER BY ename DESC;

-- ROWNUM : ���ȣ�� ��Ÿ���� �÷�(����¡ ó��, ���� ���� SQL���� ���)
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno in(10, 30) and sal > 1500;

-- ROWNUM�� WHERE�������� ��� ����.
-- �����ϴ°�? = ('ROWNUM = 1', 'ROWNUM <= 2'�� �ǰ�,  =>  ROWNUM <= N
--              'ROWNUM = 2', 'ROWNUM >= 2'�� �ȵ�)  =>  ROWNUM >= N
-- ROWNUM�� �̹� ���� �����Ϳ��ٰ� ������ �ο�
-- **������1 : ���� ���� ������ ����(ROWNUM�� �ο����� ���� ��)�� ��ȸ�� ���� ����.
-- **������2 : ORDER BY ���� SELECT �� ���Ŀ� ���� - ROWNUM ���� ��������.
-- ����¡ ó���� ���
-- ���̺� �ִ� ��� ���� ��ȸ�ϴ� ���� �ƴ϶� �츮�� ���ϴ� �������� �ش��ϴ� �� �����͸� ��ȸ�� �Ѵ�.
-- ����¡ ó�� �� ������� : 1������ �� �Ǽ�, ���� ����(ex : �߰���� ��� �ð�)
-- ep���̺� �� row �Ǽ� : 14
-- ������ �� 5���� �����͸� ��ȸ
-- 1 page : 1~5
-- 2 page : 6~10
-- 3 page : 11~15
SELECT ROWNUM as rn, empno, ename
FROM emp
WHERE ROWNUM <= 7
ORDER BY ename;
-- ���ĵ� ����� ROWNUM�� �ο��ϱ� ���ؼ��� IN-LINE VIEW�� ����Ѵ�.
-- ���� ���� : 1. ����  2. ROWNUM �ο�

-- SELECT *�� ����� ��� �ٸ� EXPRESSION�� ǥ�� �ϱ� ���ؼ� ���̺��.* ���̺��Ī.* ���� ǥ���ؾ� �Ѵ�.
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;

-- page size : 5, ���� ���� : ename
-- 1 page : 1~5
SELECT *
FROM
 (SELECT ROWNUM as rn, a.*
  FROM
    (SELECT empno, ename
     FROM emp
     ORDER BY ename) a )
WHERE rn BETWEEN 1 AND 5;
-- ROWNUM�� rn���� ��Ī�� �ְ� ���μ� ���̺�� ����߱� ������ 'ROWNUM = 2' ���� ��� ����.

-- 2 page : 6~10
SELECT *
FROM
 (SELECT ROWNUM as rn, a.*
  FROM
    (SELECT empno, ename
     FROM emp
     ORDER BY ename) a )
WHERE rn BETWEEN 6 AND 10;

-- 3 page : 11~15
SELECT *
FROM
 (SELECT ROWNUM as rn, a.*
  FROM
    (SELECT empno, ename
     FROM emp
     ORDER BY ename) a )
WHERE rn BETWEEN 11 AND 15;

-- n page : ((n-1)*pagesize) + 1  ~  n * pagesize

-- ROWNUM 1
SELECT *
FROM
 (SELECT ROWNUM AS rn, e.*
  FROM emp e)
WHERE rn BETWEEN 1 AND 10;

-- ROWNUM 2
SELECT *
FROM
 (SELECT ROWNUM AS rn, e.*
  FROM emp e)
WHERE rn BETWEEN 11 AND 20;

-- ROWNUM 3
SELECT *
FROM
(SELECT ROWNUM AS rn, a.*
 FROM
  (SELECT empno, ename
   FROM emp
   ORDER BY ename ASC) a )
WHERE rn BETWEEN 11 AND 15;

-- Java�� ������ ���� ���. (���ε� ����)
SELECT *
FROM
(SELECT ROWNUM AS rn, a.*
 FROM
  (SELECT empno, ename
   FROM emp
   ORDER BY ename ASC) a )
WHERE rn BETWEEN (:page - 1) * :pageSize + 1 AND :page * :pageSize;



   
-- DUAL ���̺� : �����Ϳ� ���� ����, �Լ��� �׽�Ʈ �غ� �������� ���.
-- ���ڿ� ��ҹ��� : LOWER, UPPER, INITCAP
SELECT LOWER('Hello, world!') AS LOWER, UPPER('Hello, world!') AS UPPER, INITCAP('Hello, world!') AS INITCAP
FROM dual;

-- ����� emp���̺��� �Ǽ� ��ŭ ����. (Single Row Function �̹Ƿ�)
SELECT LOWER(ename) AS LOWER, UPPER(ename) AS UPPER, INITCAP(ename) AS INITCAP
FROM emp;

-- �Լ��� WHERE�������� ��� �����ϴ�.
-- ��� �̸��� SMITH�� ����� ��ȸ
SELECT *
FROM emp
WHERE ename = UPPER(:ename);

-- �̷� ������ SQL���� ���� �ؾ���.(���̺��� �÷��� �������� �� ��.)
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;

SELECT CONCAT('Hello', ', World') as CONCAT,
       SUBSTR('Hello, World', 1, 5) as SUBSTR,
       LENGTH('Hello, World') as LENGTH,
       INSTR('Hello, World', 'o') as INSTR,
       INSTR('Hello, World', 'o', 6) as INSTR2,
       LPAD('Hello, World', 15, '*') as LPAD,
       RPAD('Hello, World', 15, '*') as RPAD,
       REPLACE('Hello, World', 'H', 'T') as REPLACE,
       TRIM('   Hello, World   ') as TRIM,  -- ������ ����
       TRIM('d' FROM '  Hello, World') as TRIM2  -- ������ �ƴ� �ҹ��� d ����(���� x)
FROM dual;

-- ���� ���� �Լ�
-- ROUND : �ݿø� (10.6�� �Ҽ��� ù��° �ڸ����� �ݿø� �� 11)
-- TRUNC : ����(����) (10.6�� �Ҽ��� ù��° �ڸ����� �ݿø� �� 10)
-- ROUND, TRUNC : ���° �ڸ����� �ݿø� / ����
-- MOD : ������ (���� �ƴ϶� ������ ������ �� ������ ��) ( 13 / 5 �� �� : 2, ������ : 3)

-- ROUND(��� ����, ���� ��� �ڸ�)
SELECT ROUND(105.54, 1) as ROUND, -- �ݿø� ����� �Ҽ��� ù��° �ڸ����� �������� ��. �� �ι�° �ڸ����� �ݿø���.
       ROUND(105.55, 1) as ROUND2,
       ROUND(105.55, 0) as ROUND3,  -- �ݿø� ����� �����θ� �� �Ҽ��� ù��° �ڸ����� �ݿø�.
       ROUND(105.55, -1) as ROUND4, -- �ݿø� ����� ���� �ڸ����� �� ���� �ڸ����� �ݿø�.
       ROUND(105.55) as ROUND6 -- ���� ��� �ڸ� �⺻�� : 0
FROM dual;

-- TRUNC(��� ����, ���� ��� �ڸ�)
SELECT TRUNC(105.54, 1) as TRUNC, -- ������ ����� �Ҽ��� ù��° �ڸ����� �������� �� �ι�° �ڸ����� ����.
       TRUNC(105.55, 1) as TRUNC2,
       TRUNC(105.55, 0) as TRUNC3, -- ������ ����� ������(���� �ڸ�)���� �������� �� �Ҽ��� ù��° �ڸ����� ����.
       TRUNC(105.55, -1) as TRUNC4, -- ������ ����� 10�� �ڸ� ���� �������� �� ���� �ڸ����� ����.
       TRUNC(105.55) as TRUNC5 -- ���� ��� �ڸ� �⺻�� : 0
FROM dual;

-- EMP���̺��� ����� �޿�(sal)�� 1000���� ������ ���� ��
SELECT ename, sal, TRUNC(sal/1000, 0) AS portion, MOD(sal, 1000) AS remainder -- MOD�� ����� divisor���� �׻� �۴�.
FROM emp;

DESC emp;

-- �⵵ 2�ڸ�/�� 2�ڸ�/���� 2�ڸ�  (���� - ȯ�� ���� - �����ͺ��̽� - NLS - ����)
SELECT ename, hiredate
FROM emp;

-- SYSDATE : ���� ����Ŭ ������ �ú��ʰ� ���Ե� ��¥ ������ �����ϴ� Ư�� �Լ�.
-- �Լ���(����, ����2)
-- date + ���� : ���� ����
-- 1 = �Ϸ�
-- 1�ð� = 1/24

-- ���� ǥ�� : ����
-- ���� ǥ�� : �̱� �����̼� + ���ڿ� + �̱� �����̼� �� '���ڿ�'
-- ��¥ ǥ�� : TO_DATE('���ڿ� ��¥ ��', '���ڿ� ��¥ ���� ǥ�� ����')
--           �� TO_DATE('2020-01-28', 'YYYY-MM-DD')
SELECT (SYSDATE + 1/24)
FROM dual;

--fn1
SELECT TO_DATE('2019-12-31', 'YYYY,MM,DD') AS question1,
       TO_DATE('2019-12-31', 'YYYY,MM,DD') -5 AS question2,
       SYSDATE AS question3,
       SYSDATE - 3 AS question4
FROM dual;