-- SYNONYM : ���Ǿ�
-- 1. ��ü ��Ī�� �ο�
-- �� �̸��� �����ϰ� ǥ��

-- YimJ ����ڰ� �ڽ��� ���̺� emp���̺��� ����ؼ� ���� v_emp view
-- hr ����ڰ� ����� �� �ְ� �� ������ �ο�

-- v_emp : �ΰ��� ���� sal, comm�� ������ view

-- hr ����� v_emp�� ����ϱ� ���� ������ ���� �ۼ�

SELECT *
FROM YimJ.v_emp; -- ��Ű���� ����Ͽ� � ������� ������ �ۼ��ؾ� ��

-- hr �������� synonym YimJ.v_emp �� v_emp
-- v_emp == YimJ.v_emp

SELECT *
FROM v_emp; -- �ٸ� �������� ������ ���� ���� ���� �� synonym�� ������ �� �� ����.

-- 1. YimJ �������� v_emp�� hr �������� ��ȸ�� �� �ֵ��� ��ȸ���� �ο�
-- ��ȸ ���� �ο� ���
GRANT SELECT ON v_emp TO hr;

-- 2. hr ���� v.emp ��ȸ�ϴ°� ���� (���� 1������ �޾ұ� ������)
-- ���� �ش� ��ü�� �����ڸ� ��� : YimJ.v_emp
-- ������ ������ �����ϰ� YimJ.v_emp �� v_emp ����ϰ� ���� ��Ȳ

-- synontym ������� (hr ��������..)
-- CREATE SYNONYM ���Ǿ��̸� FOR �� ��ü��;

-- SYNONYM ����
-- DROP SYNONYM ���Ǿ� �̸�;


-- data dictionary : ����ڰ� �������� �ʰ�, dbms�� ��ü������ �����ϴ� �ý��� ������ ���� view
-- data dictionary ���ξ�
-- 1. USER : �ش�  ����ڰ� ������ ��ü
-- 2. ALL : �ش� ����ڰ� ������ ��ü + �ٸ� ����ڷ� ���� ������ �ο����� ��ü
-- 3. DBA : ��� ������� ��ü

-- V$ Ư�� VIEW


SELECT *
FROM USER_TABLES;  -- 'USER' = ���ξ�

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES;

-- DICTIONARY ���� Ȯ�� : SYS.DICTIONARY;

SELECT *
FROM DICTIONARY;

SELECT *
FROM USER_OBJECTS;

-- ��ǥ���� DICTIONARY
-- OBJECTS : ��ü ���� ��ȸ(���̺�, �ε���, VIEW, SYNONYM...)
-- TABLES : ���̺� ������ ��ȸ
-- TAB_COLUMNS : ���̺��� �÷� ���� ��ȸ
-- INDEXES : �ε��� ���� ��ȸ
-- IND_COLUMNS : �ε��� ���� �÷� ��ȸ
-- CONSTRAINTS : ���� ���� ��ȸ
-- CONS_COLUMN : �������� ���� �÷� ���� ��ȸ
-- TAB_COMMENTS : ���̺� �ּ�
-- COL_COMMENTS : ���̺��� �÷� �ּ�

-- emp, dept ���̺��� �ε����� �ε��� �÷� ���� ��ȸ
-- user_indexes, user_ind_columns join
-- ���̺��, �ε�����, �÷���, �÷� ����
-- emp  ind_n_emp_04 ename
-- emp  ind_n_emp_04 job
SELECT *
FROM user_indexes;

SELECT *
FROM user_ind_columns;

SELECT idx.table_name, idx.table_name, col.column_name, col.column_position
FROM user_indexes idx, user_ind_columns col
WHERE idx.index_name = col.index_name;

SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;

DROP TABLE dept_test2;
CREATE TABLE dept_test2(
    deptno VARCHAR2(2),
    dname VARCHAR2(10),
    loc VARCHAR2(20)
    );
    
INSERT INTO dept_test2 VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept_test2 VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dept_test2 VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept_test2 VALUES (40, 'OPERATIONS', 'BOSTON');
COMMIT;

DELETE dept_test2
WHERE deptno = 40;

SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;


    
-- ������ ���� ���� ���̺� ���� �Է��ϴ� multiple insert;
INSERT ALL
    INTO dept_test
    INTO dept_test2;
    
-- ���̺� �Է��� �÷��� �����Ͽ� multiple insert;
ROLLBACK;
INSERT ALL
    INTO dept_test (deptno, loc) VALUES (deptno, loc)
    INTO dept_test2
SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT', '����' FROM dual;


-- ���̺� �Է��� �����͸� ���ǿ� ���� multiple insert;
 CASE
     WHEN ���� ��� THEN
 END;


ROLLBACK;
INSERT ALL
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES (deptno, loc)
        INTO dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT', '����' FROM dual;

SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;


-- ������ �����ϴ� ù��° insert�� �����ϴ� multiple insert

ROLLBACK;
INSERT FIRST -- ������ �����ϴ� ù��° WHEN���� ����.
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES (deptno, loc)
    WHEN deptno >= 97 THEN
        INTO dept_test2
    ELSE
        INTO dept_test2   
SELECT 98 deptno, '���' dname, '�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT', '����' FROM dual;

-- ����Ŭ ��ü : ���̺� �������� ������ ��Ƽ������ ����
-- ���̺� �̸��� �����ϳ� ���� ������ ���� ����Ŭ ���������� ������ �и��� ������ �����͸� ����.
-- ex: dept_test �� dept_test_20200201



-- MERGE ����
-- ���̺� �����͸� �Է�/���� �Ϸ��� ��
-- 1. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �����ϸ� �� ������Ʈ
-- 2. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �������� ������ �� INSERT

--1. SELECT ����
--2-1. SELECT ���� ����� 0 ROW�̸� INSERT
--2-2. SELECT ���� ����� 1 ROW�̸� UPDATE

--MERGE ������ ����ϰ� �Ǹ� SELECT�� ���� �ʾƵ� �ڵ����� ������ ������ ���� INSERT �Ǵ� UPDATE�� �����Ѵ�.
--2���� SELECT ���� ��ȸ�� �ѹ����� ���δ�.

--MERGE INTO ���̺��[alias]
--USING (TABLE | VIEW | IN-LINE-VIEW)
--ON (���� ����)
--WHEN MATCHED THEN -- ���� �������ǿ� �����ϴ� ���� �ִٸ�
--    UPDATE SET col1 = �÷���, col2 = �÷���....
--WHEN NOT MATCHED THEN
--    INSERT (�÷�1, �÷�2....) VALUES (�÷���1, �÷���2....);

SELECT *
FROM emp_test;

DELETE emp_test;
TRUNCATE TABLE emp_test; -- LOG�� ������ ����. ������ �ȵ�. �׽�Ʈ������ �̿�.

emp���̺��� emp_test���̺�� �����͸� ����(7369 - SMITH);

SELECT *
FROM emp_test;

ALTER TABLE emp_test DROP CONSTRAINTS PK_EMP_TEST;

INSERT INTO emp_test
SELECT empno, ename, deptno, '010'
FROM emp
WHERE empno = 7369;

UPDATE emp_test SET ename = 'brown'
WHERE empno = 7369;

COMMIT;

emp���̺��� ��� ������ emp_test���̺�� ����
emp���̺��� ���������� emp_test���� �������� ������ insert
emp���̺��� �����ϰ� emp_test���� �����ϸ� ename, deptno�� ������Ʈ

emp���̺� �����ϴ� 14���� ������ �� emp_test���� �����ϴ� 7369�� ������ 13���� �����Ͱ�
emp_test ���̺� �űԷ� �Է��� �ǰ�
emp_test�� �����ϴ� 7369�� �����ʹ� ename(brown)�� emp���̺� �����ϴ� �̸��� SMITH�� ����.;

MERGE INTO emp_test a
USING emp b
ON (a.empno = b.empno)
WHEN MATCHED THEN
    UPDATE set a.ename = b.ename, 
               a.deptno = b.deptno
WHEN NOT MATCHED THEN
    INSERT (empno, ename, deptno) VALUES (b.empno, b.ename, b.deptno);
    
    
�ش� ���̺� �����Ͱ� ������ INSERT, ������ UPDATE
emp_test���̺� ����� 9999���� ����� ������ ���Ӱ� INSERT
������ UPDATE
INSERT INTO dept_test VALUES (9999, 'brown', 10, '010')
UPDATE dept_test SET ename = 'brown'
                     deptno = 10
                     hp = '010'
WHERE empno = 9999;

MERGE INTO emp_test
USING dual
ON (empno = 9999)
WHEN MATCHED THEN
    UPDATE SET ename = ename || '_u',
               deptno = 10,
               hp = '010'
WHEN NOT MATCHED THEN
    INSERT VALUES (9999, 'brown', 10, '010');
    
SELECT *
FROM emp_test;

ALTER TABLE emp_test MODIFY (hp default '010');


-- �μ��� �հ�, ��ü �հ踦 ������ ���� ���ϸ�??

SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno

UNION ALL

SELECT NULL, SUM(sal) sal
FROM emp
ORDER BY deptno;



SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);
ORDER BY deptno;


--REPORT GROUP FUNCTION
--ROLLUP
--CUBE
--GROUPING

ROLLUP
����� : GROUP BY ROLLUP (�÷�1, �÷�2.....)
SUBGROUP�� �ڵ������� ����
SUBGROUP�� �����ϴ� ��Ģ : ROLLUP�� ����� �÷��� �����ʿ��� ���� �ϳ��� �����ϸ鼭 SUB GROUP�� ����.

EX : GROUP BY ROLLUP (deptno)
��
ù��° sub group : GROUP BY deptno
�ι�° sub group : GROUP BY NULL �� ��ü ���� ���.

GROUP_AD1�� GROUP BY ROLLUP ���� ����Ͽ� �ۼ�.;
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno);

SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

GROUP BY job, deptno : ������, �μ��� �޿���
GROUP BY job : �������� �޿���
GROUP BY : ��ü �޿���;


SELECT GROUPING(job) job, GROUPING(deptno) deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);



SELECT CASE WHEN GROUPING(job) = 1 THEN '�Ѱ�' 
       ELSE job END AS job,
       deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


SELECT DECODE(GROUPING(job), 1, '�Ѱ�', job) as job,
       deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);  


SELECT CASE WHEN GROUPING(job) = 1 THEN '��' ELSE job END as job,
       CASE WHEN GROUPING(TO_CHAR(deptno)) = 1 THEN 
                        CASE WHEN GROUPING(job) = 1 THEN '��' ELSE '�Ұ�' END
       ELSE TO_CHAR(deptno) END as deptno,
       SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, TO_CHAR(deptno));





