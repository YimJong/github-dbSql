-- 1�� ����
SELECT * 
FROM lprod;

-- 2�� ����
SELECT buyer_id, buyer_name
FROM buyer;

-- 3�� ����
SELECT *
FROM cart;

-- 4�� ����
SELECT mem_id, mem_pass, mem_name
FROM member;

-- users ���̺� ��ȸ
SELECT *
FROM users;

-- ���̺� � �÷��� �ִ��� Ȯ���ϴ� ���
-- 1. SELECT *
-- 2. TOOL�� ��� (�����-TABLE)
-- 3. DESC ���̺�� (DESC-DESCRIBE)

DESC users;

SELECT *
FROM users;

-- users ���̺��� userid, usernm, reg_dt �÷��� ��ȸ�ϴ� sql�� �ۼ��ϼ���.
-- ��¥ ���� (reg_dt �÷��� date������ ���� �� �ִ� Ÿ��)
-- SQL ��¥ �÷� + (���ϱ� ����)
-- �������� ��Ģ������ �ƴ� �͵�
-- SQL���� ���ǵ� ��¥ ���� : ��¥ + ���� = ��¥���� ������ ���ڷ� ����Ͽ� ���Ѵ�.
-- null : ���� �𸣴� ����
-- null�� ���� ���� ����� �׻� null

SELECT userid as u_id, usernm, reg_dt, reg_dt + 5 as reg_dt_after_5day
FROM users;

--1�� ����
SELECT prod_id as id, prod_name as name
FROM prod;

--2�� ����
SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;

--3�� ����
SELECT buyer_id as ���̾���̵�, buyer_name as �̸�
FROM buyer;

--���ڿ� ����
-- �ڹ� ���� ���ڿ� ���� : + ("Hello" + "world!")
-- SQL������ : || ('Hello' || 'world')
-- SQL������ : concat('Hello', 'world')

--userid, usernm �÷��� ����, ��Ī id_name
SELECT concat(userid, usernm) as id_name
FROM users;

-- SQL������ ������ ����(�÷��� ����� ����), PL/SQL������ ���� ������ ����
-- SQL���� ���ڿ� ����� ��Ŭ �����̼����� ǥ��
-- "Hello, World" --> 'Hello, World'

-- ���ڿ� ����� Į������ ����
-- user id : brown
-- user id : cony
SELECT 'user id : ' || userid 
FROM users;

SELECT 'user id : ' || userid as userid
From users;

SELECT 'SELECT * FROM ' || table_name|| ';' as QUERY
FROM user_tables;

SELECT concat('SELECT * FOROM ', table_name)||';' as QUERY
FROM user_tables;

SELECT concat(concat('SELECT * FROM ', table_name),';') as QUERY
FROM user_tables;

-- if( a == 5 ) (a�� ���� 5���� ��)
-- SQL������ ������ ������ ����.
-- SQL '=' : equal 

-- Where �� : ���̺��� �����͸� ��ȸ�� �� ���ǿ� �´� �ุ ��ȸ
-- ex : userid �÷��� ���� brown�� �ุ ��ȸ
-- brown, 'brown' ����
-- �÷�, ���ڿ� ���
SELECT *
FROM users
WHERE userid = 'brown'; 

--userid�� brown�� �ƴ� �ุ ��ȸ
SELECT *
FROM users
WHERE userid <> 'brown';

-- emp ���̺� �����ϴ� �÷��� Ȯ�� �غ�����
DESC emp;  --���� �������� ������� ���̺�
SELECT *
FROM emp;

-- emp ���̺��� ename �÷� ���� JONES�� �ุ ��ȸ
-- SQL KEY WORD�� ��ҹ��ڸ� ������ ������ �÷��� ���̳�, ���ڿ� ����� ��ҹ��ڸ� ����.
-- 'JONES','Jones'�� ���� �ٸ� ���
SELECT *
FROM emp
WHERE ename = 'JONES';

-- emp���̺��� deptno(�μ���ȣ)�� 30���� ũ�ų� ���� ����鸸 ��ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

-- ���ڿ� : '���ڿ�'
-- ���� : 50
-- ��¥ : �Լ��� ���ڿ��� �����Ͽ� ǥ��. ���ڿ��� �̿��Ͽ� ǥ�� ����(�������� ����.
--       �������� ��¥ ǥ����
--       �ѱ� : YYYY-MM-DD
--       �̱� : MM-DD-YYYY


SELECT *
FROM emp
WHERE hiredate = '80/12/17';
-- TO_DATE : ���ڿ��� date Ÿ������ �����ϴ� �Լ�
-- TO_DATE(��¥���� ���ڿ�, ù��° ������ ����)

SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217','YYYYMMDD');

-- ��������
-- sal �÷��� ���� 1000���� 2000 ������ ���
SELECT *
FROM emp
WHERE sal >= 1000 and sal <= 2000;

-- ���������ڸ� �ε�ȣ ��ſ� BETWEEN AND �����ڷ� ��ü
SELECT *
FROM emp
WHERE sal between 1000 and 2000;


--���� 1
SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE('19820101', 'YYYYMMDD') and TO_DATE('19830101', 'YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate between '1982-01-01' and '1983-01-01';