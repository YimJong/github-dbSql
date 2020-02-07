-- TURNCATE �׽�Ʈ
-- REDO �α׸� �������� �ʱ� ������ ���� �� ������ ������ �Ұ��ϴ�.
-- DML(SELECT, INSERT, UPDATE, DELETE)�� �ƴ϶� DDL�� �з�(ROLLBACK�� �Ұ�)

-- �׽�Ʈ �ó�����
-- emp���̺� ���縦 �Ͽ� emp_copy��� �̸����� ���̺� ����
-- emp_copy ���̺��� ������� TURNCATE TABLE emp_copy ����

-- emp_copy ���̺� �����Ͱ� �����ϴ��� (���������� ������ �Ǿ�����) Ȯ��.

-- emp_copy ���̺� ����

-- CREATE �� DDL(ROLLBACK�� �ȵȴ�)
CREATE TABLE EMP_COPY AS
SELECT *
FROM emp;

SELECT *
FROM emp_copy;

TRUNCATE TABLE emp_copy;
ROLLBACK;
-- TURNCATE TABLE ��ɾ�� DDL�̱� ������ ROLLBACK�� �Ұ��ϴ�.
-- ROLLBACK �� SELECT�� �غ��� �����Ͱ� ���� ���� ���� ���� �� �� �ִ�.

-- FOR UPDATE
SELECT *
FROM dept
WHERE deptno = 10
FOR UPDATE ;
-- �� �����Ϳ� ���� �ɾ� ���� �Ͱ� ����.
-- �μ���ȣ 10���� ���� �����Ϳ� UPDATE, DELETE �Ұ���
-- ���� Ʈ����ǿ��� �ű� ������ ������ ������.

-- LV3 SERIALIZABLE READ
-- SET TRANSACTION isolation LEVEL SERIALIZABLE;

SELECT *    -- ������ 4��
FROM dept;

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');  -- �����Ͱ� 5���� ��.

-- �ٸ� ���� Ʈ����ǿ��� �ű� �����͸� Ŀ�� ����.

SELECT *
FROM dept; -- ������ 5�� �״����. (���� ��������� �����Ͱ� �ȉ���.)
-- SNAPSHOT TOO OLD

-- DDL : Data Definition Language - ������ ���Ǿ�
-- ��ü�� ����, ����, ������ ���
-- ROLLBACK �Ұ�!

-- ���̺� ����
-- CREATE TABLE [��Ű����]���̺��(
--    �÷���, �÷�Ÿ�� [DEFAULT �⺻��],
--    �÷���, �÷�Ÿ�� [DEFAULT �⺻��], .....
--   );

-- ��Ű�� : ���Ӱ���  ex) YimJ.

CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE DEFAULT SYSDATE     -- ���糯¥�� �⺻ ��
);

SELECT *
FROM ranger;

INSERT INTO ranger(ranger_no, ranger_nm) VALUES (1, 'brown');
COMMIT;

-- ���̺� ���� (DROP)
-- DROP TABLE ���̺��

DROP TABLE ranger;

SELECT *
FROM ranger;

-- DDL�� �ѹ� �Ұ�..
ROLLBACK;
-- ��ȸ �� table or view does not exist ����
-- ������ ���� �翬�� ����
-- ���� ��ü�� ���� ���� (��������, �ε���)
-- ����������� �翬�� ������ ��.

-- Data type
-- VARCHAR2(Size) : �������� ���ڿ�, SIZE : 1 ~ 4000Byte (char Ÿ�� ��� ����)
--                  �ѱ� 1���� 3 byte, �ԷµǴ� ���� �÷� ������� �۾Ƶ� ���� ������ �������� ä���� �ʴ´�.

-- CHAR(Size) : �������� ���ڿ�, ex) CHAR(10)�� �����ϰ� 5Byte�� �Է� ���� ��� ������ 5Byte�� �������� ä����.

-- NUMBER(p, s) : p = ��ü�ڸ���(38), s = �Ҽ��� �ڸ���
-- INTEGER �� NUMBER(38, 0)
-- renger_no NUMBER �� NUMBER(38, 0)

-- DATE : ���ڿ� �ð� ������ ����. ( DATEŸ������ �����ϴ� ���� �ְ� VARCHAR2�� �����ϴ� ���� ����. )
-- ������ ex) DATE - 7Byte
--           VARCHAR2 - '20200207' - 8Byte
-- �� �ΰ��� Ÿ���� �ϳ��� �����ʹ� 1Byte�� ����� ���̰� ����. ������ ���� �����ϸ� ������ �� ���� �������, ����� Ÿ�Կ� ���� ����� �ʿ�.

--  LOB(Large Object) - �ִ� 4GB
--  CLOB - Character Large Object
--       - VARCHAR2�� ���� �� ���� �������� ���ڿ� (4000Byte �ʰ� ���ڿ�)
--       - ex) �� �����Ϳ��� ������ html �ڵ�      
--  BLOB - Byte Large Object
--       - ������ �����ͺ��̽��� ���̺��� ������ ��
--       - �Ϲ������� �Խñ� ÷�������� ���̺� ���� �������� �ʰ� ���� ÷�������� ��ũ�� Ư�� ������ �����ϰ�, �ش� '���'�� ���ڿ��� ����.
--       - ���� ������ �ſ� �߿��� ��� ex)�� ������� ���Ǽ� �� [����]�� ���̺� ����


-- ���� ���� : �����Ͱ� ���Ἲ�� ��Ű���� ���� ����
-- 1. UNIQUE ���� ����
--    �ش� �÷��� ���� �ٸ� ���� �����Ϳ� �ߺ����� �ʵ��� ����
--    ex) ����� ���� ����� ���� ���� ����.

-- 2. NOT NULL ���� ���� (CHECK ��������)
--    �ش� �÷��� ���� �ݵ�� ����
--    ex) ��� �ķ��� NULL�� ����� ������ ���� ����.
--    ex) ȸ������ �� �ʼ� �Է»��� (github - �̸���, �̸�)
 
-- 3. PRIMARY KEY ���� ����
--    UNIQUE + NOT NULL : �ߺ� �Ұ� �� NULL �Ұ���
--    ex) ���
--    PRIMARY KEY ���� ������ ������ ��� �ش� �÷����� UNIQUE INDEX�� �����ȴ�.

-- 4. FOREIGN KEY ���� ���� (���� ���Ἲ)
--    �ش� �÷��� �����ϴ� �ٸ� ���̺� ���� �����ϴ� ���� �־�� �Ѵ�.
--    ex) emp ���̺��� deptno�÷��� dept���̺��� deptno�÷��� ����(����)
--        emp ���̺��� deptno�÷����� dept ���̺� �������� �ʴ� �μ���ȣ�� �Է� �� �� ����.
--        ���� dept ���̺��� �μ���ȣ�� 10, 20, 30, 40���� ���� �� ���
--        emp ���̺� ���ο� ���� �߰� �ϸ鼭 �μ���ȣ ���� 99������ ��� �� ���
--        �� �߰��� �����Ѵ�.

-- 5. CHECK ���� ���� (���� üũ)
--    NOT NULL ���� ���ǵ� CHECK ���࿡ ����
--    emp ���̺��� job �÷��� ���� �� �ִ� ���� 'SALESMAN', 'PRESIDENT', 'CLERK'

-- �������� ���� ���
-- 1. ���̺��� �����ϸ鼭 �÷��� ���
-- 2. ���̺��� �����ϸ鼭 �÷� ��� ���Ŀ� ������ ���������� ���
-- 3. ���̺� ������ ������ �߰������� ���������� �߰�

-- CREATE TABLE ���̺�� (
-- 1.   �÷�1 �÷�Ÿ�� [��������],
--      �÷�2 �÷�Ÿ�� [��������],....

-- [2. TABLE_CONSTRAINT]
-- 3. ALTER TABLE emp.....

-- PRIMARY KEY ���������� �÷� ������ ����(1�� ���)
-- 1. dept ���̺��� �����Ͽ� dept_test ���̺��� PRIMARY KEY �������ǰ� �Բ� ����
-- �� �� ����� ���̺��� KEY �÷��� ���� �÷��� �Ұ�, ���� �÷��� ���� ����.
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test (deptno) VALUES (99); -- ���������� �����.
INSERT INTO dept_test (deptno) VALUES (99); -- unique constraint (YimJ.�������Ǹ�) violated ����, 
                                            -- �ٷ� ���� ������ ���� ���� ���� �����Ͱ� �̹� �����.

-- �������
INSERT INTO dept (deptno) VALUES (99);
INSERT INTO dept (deptno) VALUES (99); -- �� ���� �� ���Ե�. �츮�� ���� ����ϴ� dept���̺��� UNIQUE ���� �����̳�
                                       -- PRIMARY ���� ������ ������ �� ��.
ROLLBACK;

-- ���� ���� Ȯ�ι��
-- 1. TOOL�� ���� Ȯ��
--    Ȯ���ϰ��� �ϴ� ���̺� ����.

-- 2. DICTIONARY�� ���� Ȯ�� (USER_TABLES)

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'DEPT_TEST';

SELECT *                                    -- �������� �̸��� �����ͼ� ��ȸ�ؾ� ��.
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'SYS_C007085';


-- 3. �𵨸� (ex: eXerd)���� Ȯ��

-- �������� ���� ������� ���� ��� ����Ŭ���� ���������̸��� ���Ƿ� �ο� (ex) SYS_C007086
-- �������� �������� ������ ��� ��Ģ�� �����ϰ� �����ϴ°� ����, � ������ ����.
-- ex) PRIMARY KEY �������� : PK_���̺��
--     FOREIGN KEY �������� : FK_������̺��_�������̺��

DROP TABLE dept_test;

-- �÷� ������ ���������� �����ϸ鼭 �������� �̸��� �ο�
-- CONSTRAINT �������Ǹ� ��������Ÿ��(PRIMARY KEY)
-- ���� �߻��� � �������� �������� �˱� ����.
CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

-- 2. ���̺� ���� �� �÷� ��� ���� ������ �������� ���
DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
);

-- NOT NULL �������� �����ϱ�
-- 1. �÷��� ����ϱ�
--    �� �÷��� ����ϸ鼭 �������ǿ� �̸��� �ο��ϴ� �� �Ұ���.

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

-- NOT NULL �������� Ȯ��
INSERT INTO dept_test (deptno, dname) VALUES (99, NULL);  -- cannot insert NULL into �� ����

-- 2. ���̺� ���� �� �÷� ��� ���Ŀ� ���� ���� �߰�.
DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT NM_dept_test_dname CHECK (deptno IS NOT NULL)
);



-- UNIQUE ���� : �ش� �÷��� �ߺ��Ǵ� ���� ������ ���� ����, �� NULL�� �Է� �����ϴ�.
-- PRIMARY KEY = UNIQUE + NOT NULL

-- 1. ���̺� ���� �� �÷� ���� UNIQUE ��������
--    dname �÷��� UNIQUE ��������

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

-- dept_test ���̺��� dname �÷��� ������ unique ���������� Ȯ��
INSERT INTO dept_test VALUES (98, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon'); -- �ߺ� ����


-- 2. ���̺� ������ �÷��� �������� ���, �������� �̸� �ο�
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) CONSTRAINT UK_dept_test_dname UNIQUE,
    loc VARCHAR2(13)
);

-- dept_test ���̺��� dname �÷��� ������ unique ���������� Ȯ��
INSERT INTO dept_test VALUES (98, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon'); -- �ߺ� ����

-- 3. ���̺� ���� �� �÷� ��� ���� �������� ���� - ���� Ŀ��(deptno - dname) (unique)
DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT UK_dept_test_deptno_dname UNIQUE (deptno, dname)
);

-- ���� �÷��� ���� UNIQUE ���� Ȯ�� (deptno, dname)
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit', 'daejeon'); -- ��������� ������ ��.
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon'); -- ����

-- FOREIGN KEY ��������
-- �����ϴ� ���̺��� �÷��� �����ϴ� ���� ��� ���̺��� �÷��� �Է��� �� �ֵ��� ����
-- ex) emp���̺� deptno �÷� ���� �Է��� ��, dept ���̺��� deptno �÷��� �����ϴ� �μ���ȣ�� �Է��� �� �ֵ��� ����
--     �������� �ʴ� �μ���ȣ�� emp ���̺��� ������� ���ϰԲ� ����.

-- 1. dept_test ���̺� ����
-- 2. emp_test ���̺� ����
--     emp_test ���̺� ���� �� deptno �÷����� dept.deptno �÷��� �����ϵ��� FK ����.

DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
);
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno),
    
    CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno)
);

-- ������ �Է¼���
-- ���ݻ�Ȳ(dept_test, emp_test ���̺��� ��� ���� - �����Ͱ� �������� ���� ��)���� emp_test ���̺� �����͸� �Է��ϴ°� �����Ѱ�??
INSERT INTO emp_test VALUES (9999, 'brown', NULL); -- FK�� ������ �÷��� NULL�� ���
INSERT INTO emp_test VALUES (9999, 'sally', 10); -- 10�� �μ��� dept_test ���̺� �������� �ʾƼ� ����..
                                                 -- parent key not found
                                                 
-- dept_test ���̺� �����͸� �غ�
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon'); 
INSERT INTO emp_test VALUES (9988, 'sally', 99); -- ���� ����
INSERT INTO emp_test VALUES (9988, 'sally', 10); -- 10�� �μ��� ���� ���� �����Ƿ� ����

-- ���̺� ���� �� �÷� ��� ���� FOREIGN KEY �������� ����
DROP TABLE emp_test;
DROP TABLE dept_test;
CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
);
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES  dept_test (deptno)
);
INSERT INTO emp_test VALUES (9999, 'brown', 10); -- dept_test ���̺� 10�� �μ��� �������� �ʾ� ����.
INSERT INTO emp_test VALUES (9999, 'brown', 99); -- ���� ���� 