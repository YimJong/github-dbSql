-- ���� ���� Ȯ�� ���
-- 1. tool
-- 2. dictionary view
-- �������� : USER_CONSTRAINTS
-- �������� - �÷� : USER_CONS_COLUMNS

-- FK ������ �����ϱ� ���ؼ��� �����ϴ� ���̺� �÷��� �ε����� �����ؾ� �Ѵ�.

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');

ALTER TABLE emp ADD CONSTRAINTS PK_emp_empno PRIMARY KEY (empno);
ALTER TABLE emp ADD CONSTRAINTS FK_emp_deptno FOREIGN KEY (deptno) REFERENCES dept (deptno);

ALTER TABLE dept ADD CONSTRAINTS PK_dept_dpetno PRIMARY KEY (deptno);

-- ���̺�, �÷� �ּ� : DICTIONARY Ȯ�� ����
-- ���̺� �ּ� : USER_TAB_COMMENTS
-- �÷� �ּ� : UJSER_COL_COMMENTS

-- �ּ� ����
-- ���̺��ּ� : COMMENT ON TABLE ���̺�� IS '�ּ�'
-- �÷� �ּ� : COMMENT ON COLUMN ���̺�.�÷� IS '�ּ�'

-- emp : ����
-- dept : �μ�

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');

COMMENT ON TABLE emp IS '����';
COMMENT ON TABLE dept IS '�μ�';

COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ';

COMMENT ON COLUMN emp.empno IS '������ȣ';
COMMENT ON COLUMN emp.ename IS '�����̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '�Ŵ��� ������ȣ';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '������';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

SELECT * 
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');

-- comment1
SELECT T.table_name, T.table_type, T.comments tab_comment, C.column_name, C.comments col_comment
FROM USER_COL_COMMENTS C JOIN (SELECT *
                               FROM USER_TAB_COMMENTS) T ON (C.table_name = T.table_name)
WHERE T.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

-- VIEW = QUERY
-- VIEW�� ���̺��̴� (x)
-- TABLE ó�� DBMS�� �̸� �ۼ��� ��ü
-- �� �ۼ����� �ʰ� QUERY���� �ٷ� �ۼ��� VIEW : IN-LINEVIEW �� �ζ��� ��� �̸��� ���� ������ ��Ȱ���� �Ұ�

-- ������
-- 1. ���� ����(Ư�� �÷��� �����ϰ� ������ ����� �����ڿ� ����)
-- 2. INLINE-VIEW�� VIEW�� �����Ͽ� ��Ȱ��
--   ���� ���� ����

-- ���� ���
-- CREATE [OR REPLACE] VIEW ���Ī [ (column, column2....) ] AS SUBQUERY

-- emp ���̺��� 8���� �÷� �� sal, comm �÷��� ������ 6�� �÷��� �����ϴ� v_emp VIEW ����.

CREATE OR REPLACE VIEW v_emp AS 
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- �ý��� �������� YimJ �������� view ���� ���� �߰�
GRANT CREATE VIEW TO YimJ;

-- ���� �ζ��� ��� �ۼ� �� ��ȸ
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);
      
-- VIEW ��ü Ȱ��
SELECT *
FROM v_emp;

-- emp ���̺��� �μ����� ���� �� dept ���̺�� ������ ����ϰ� ����
-- ���ε� ����� view�� ���� �س����� �ڵ带 �����ϰ� �ۼ��ϴ°� ����.

-- dname(�μ���), empno(������ȣ), ename(�����̸�), job(������), hiredate(�Ի�����);
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- VIEW Ȱ��
SELECT *
FROM v_emp_dept;

-- �� SMITH ���� ���� �� v_emp_dept view �Ǽ� ��ȭ�� Ȯ��.
DELETE emp
WHERE ename = 'SMITH';
ROLLBACK;

-- VIEW�� �� ������ �����Ǿ� ����� ���� �ƴ϶� �����̴�.
-- ������ ������ ���� ����. �������� �����Ͱ� �ƴϴ�.
-- VIEW�� �����ϴ� ���̺��� �����ϸ� VIEW���� ������ ��ģ��.

-- SEQUENCE : ������ - �ߺ����� �ʴ� �������� �������ִ� ����Ŭ ��ü
-- CREATE SEQUENCE ������_�̸�
-- [OPTION......]
-- ����Ģ : SEQ_���̺��;

-- emp ���̺��� ����� ������ ����

CREATE SEQUENCE seq_emp;

-- ������ ���� �Լ�
-- NEXTVAL : ���������� ���� ���� ������ �� ���
-- CURRVAL : NEXTVAL�� ����ϰ� ���� ���� �о� ���� ���� ��Ȯ��. ���� �������� ����� �������� ���� Ȯ���� �� ���

SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

SELECT *
FROM emp_test;

ALTER TABLE emp_test ADD (HP VARCHAR2(10));

INSERT INTO emp_test VALUES(seq_emp.NEXTVAL, 'james', 99, '017');

-- �� ������ ������
-- ROLLBACK�� �ϴ��� NEXTVAL�� ���� ���� ���� ���� �������� �ʴ´�.
-- NEXTVAL�� ���� ���� �޾ƿ��� �� ���� �ٽ� ����� �� ����.

-- �ε���

SELECT ROWID, emp.*
FROM emp;

-- �ε����� ���� �� empno ������ ��ȸ�ϴ� ���
-- emp ���̺��� pk_emp ���������� �����Ͽ� empno �÷����� �ε����� �������� �ʴ� ȯ���� ����

ALTER TABLE emp DROP CONSTRAINT pk_emp_empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp ���̺��� empno �÷����� PK ������ �����ϰ� ������ SQL�� ����
-- PK : UNIQUE + NOT NULL
--     (UNIQUE �ε����� �������ش�)
-- �� empno �÷����� unique �ε����� ������

-- �ε����� SQL�� �����ϰ� �Ǹ� �ε����� ���� ���� ��� �ٸ��� �������� Ȯ��.

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT ROWID, emp.*
FROM emp;

SELECT empno, ROWID
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

-- SELECT ��ȸ�÷��� ���̺� ���ٿ� ��ġ�� ����
-- SELECT * FROM emp WHERE empno = 7782;
-- ��
-- SELECT empno FROM emp WHERE empno = 7782;

explain plan for
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);    -- ������ȣ�� �̹� �ε����� �����Ƿ� ���̺��� ��ȸ �� �ʿ䰡 ����.


-- UNIQUE VS NON-UNIQUE �ε����� ���̸� Ȯ��
-- 1. PK_EMP ����
-- 2. empno �÷����� NON-UNIQUE �ε��� ����
-- 3. �����ȹ Ȯ��

ALTER TABLE emp DROP CONSTRAINTS pk_emp;

CREATE INDEX idx_n_emp_01 ON emp (empno);

-- emp ���̺� job �÷��� �������� �ϴ� ���ο� non-unique �ε����� ����
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, ROWID
FROM emp
ORDER BY job = 'MANAGER';

-- ���ð����� ����
-- 1. emp ���̺��� ��ü �б�
-- 2. idx_n_emp_01 �ε��� Ȱ��
-- 3. idx_n_emp_02 �ε��� Ȱ��

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);