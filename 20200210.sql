-- PRIMARY KEY ���� ���� ���� �� ����Ŭ DBMS�� �ش� �÷����� UNIQUE index�� �ڵ����� �����Ѵ�.
-- (*** ��Ȯ���� UNIQUE���࿡ ���� UNIQUE �ε����� �ڵ����� �����ȴ�.
--      PRIMARY = UNIQUE + NOT NULL)
-- intdex �ش� �÷����� �̸� ������ �� ���� ��ü
-- ������ �Ǿ��ֱ� ������ ã���� �ϴ� ���� �����ϴ��� ������ �� ���� �ִ�.
-- ���࿡ �ε����� ���ٸ� ���ο� �����͸� �Է��� �� �ߺ��Ǵ� ���� ã�� ���ؼ� �־��� ��� ���̺��� ��� �����͸� ã�ƾ� �Ѵ�.
-- ������ �ε����� ������ �̹� ������ �Ǿ��ֱ� ������ �ش� ���� ���� ������ ������ �� ���� �ִ�.

-- FOREIGN KEY ���� ���ǵ� �����ϴ� ���̺� ���� �ִ��� Ȯ�� �Ͽ��� �Ѵ�.
-- �����ϴ� ���̺� ���� �ִ��� Ȯ�� �ؾ��Ѵ�.
-- �׷��� �����ϴ� �÷��� �ε����� �־������ FOREIGN KEY ������ ������ ���� �ִ�.

-- FOREIGN KEY ���� �� �ɼ�
-- FROEIGN KEY (���� ���Ἲ) : �����ϴ� ���̺��� �÷��� �����ϴ� ���� �Է� �� �� �ֵ��� ����
-- (ex : emp���̺� ���ο� �����͸� �Է� �� deptno �÷����� dept ���̺� �����ϴ� �μ���ȣ�� �Է� �� �� �ִ�.)

-- FOREIGN KEY�� �����ʿ� ���� �����͸� ������ �� ������
-- � ���̺��� �����ϰ� �ִ� �����͸� �ٷ� ������ �� ����
-- (ex : EMP.deptno �� DEPT.deptno �÷��� �����ϰ� ���� ��
--       �μ� ���̺��� �����͸� ������ ���� ����.)

SELECT *
FROM emp_test;

-- emp : 9999, 99
-- dept : 89, 99
-- �� 98�� �μ��� �����ϴ� emp ���̺��� �����ʹ� ����
--   99�� �μҸ� �����ϴ� emp ���̺��� �����ʹ� 9999�� brown ����� ����.

DELETE dept_test
WHERE deptno = 99;


DELETE dept_test
WHERE deptno = 98;
ROLLBACK;

SELECT *    
FROM emp_test;

SELECT *
FROM dept_test;

-- FOREIGN KEY �ɼ�
-- 1. ON DELETE CASCADE : �θ� ������ ���(dept) �����ϴ� �ڽ� �����͵� ���� �����Ѵ�.(emp)
-- 2. ON DELETE SET NULL : �θ� ������ ���(dept) �����ϴ� �ڽ� �������� �÷��� null�� ����.

-- emp_test���̺��� DROP�� �ɼ��� �����ư��� ������ �� ���� �׽�Ʈ

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) 
            REFERENCES dept_test (deptno) ON DELETE CASCADE
);

INSERT INTO emp_test VALUES (9999, 'brown', 99);
COMMIT;

-- emp ���̺��� deptno �÷��� dept ���̺��� deptno �÷��� ���� (ON DELETE CASCADE)
-- �ɼǿ� ���� �θ����̺�(dept_test) ���� �� �����ϰ� �ִ� �ڽ� �����͵� ���� �����ȴ�.
DELETE dept_test
WHERE deptno = 99;

-- �ɼ��� �ο����� �ʾ��� ���� ���� DELETE ������ ������ �߻�.
-- �ɼǿ� ���� �����ϴ� �ڽ����̺��� �����Ͱ� ���������� ������ �Ǿ����� SELECT Ȯ��.

SELECT *
FROM emp_test;

-- FK ON DELETE SET NULL �ɼ� �׽�Ʈ
-- �θ� ���̺��� ������ ������ (dept_test) �ڽ����̺��� �����ϴ� �����͸� NULL�� ������Ʈ
ROLLBACK;

SELECT *
FROM dept_test;

SELECT *
FROM emp_test;

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) 
            REFERENCES dept_test (deptno) ON DELETE SET NULL
);

INSERT INTO emp_test VALUES (9999, 'brown', 99);
COMMIT;

-- dept_test ���̺��� 99�� �μ��� �����ϰ� �Ǹ�(�θ� ���̺��� �����ϸ�)
-- 99�� �μ��� �����ϴ� emp_test ���̺��� 9999��(brown) �������� deptno �÷���
-- FK �ɼǿ� ���� NULL�� �����Ѵ�.

DELETE dept_test
WHERE deptno = 99;

-- �θ� ���̺��� ������ ���� �� �ڽ� ���̺��� �����Ͱ� NULL�� ������ �Ǿ����� Ȯ��.

SELECT *
FROM emp_test;

-- CHECK �������� : �÷��� ���� ���� ������ ������ �� ���
-- ex : �޿� �÷��� ���ڷ� ����, �޿��� ������ �� �� ������?
--      �Ϲ����� ��� �޿����� '�޿�>0'
-- CHECK ������ ����� ��� �޿����� 0���� ū ������ �˻� ����.
-- emp���̺��� job�÷��� ���� ���� ���� 4������ ���� ����
-- 'SAELSMAN', 'PRESIDENT', 'ANALYST', 'MANAGER'

-- ���̺� ���� �� �÷� ����� �Բ� CHECK ���� ����
-- emp_test ���̺��� sal �÷��� 0���� ũ�ٴ� CHECK �������� ����

INSERT INTO dept_test VALUES (99, 'ddit', '����');
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    sal NUMBER CHECK (sal > 0),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
    );
    
INSERT INTO emp_test VALUES (9999, 'brown', 99, 1000);
INSERT INTO emp_test VALUES (9998, 'sally', 99, -1000); -- sal üũ���ǿ� ���� 0���� ū ���� �Է� ����.

-- ���ο� ���̺� ����
-- CREATE TABLE ���̺�� (
--  �÷�1.....
-- );

-- CREATE TABLE ���̺�� AS
-- SELECT ����� ���ο� ���̺�� ����

-- emp ���̺��� �̿��ؼ� �μ���ȣ�� 10�� ����鸸 �ش� �����ͷ�
-- emp_test2 ���̺��� ����.

CREATE TABLE emp_test2 AS
SELECT *
FROM emp
WHERE deptno = 10;

-- NOT NULL ���� ���� �̿��� ���� ������ ������� �ʴ´�.
-- ���߽�
-- 1. ������ ���
-- 2. �׽�Ʈ ����

-- TABLE ����
-- 1. �÷��߰�
-- 2. �÷� ������ ����, Ÿ�� ����
-- 3. �⺻�� ����
-- 4. �÷����� RENAME
-- 5. �÷��� ����
-- 6. �������� �߰�/����

-- TABLE ���� 1. �÷� �߰� ( HP VARCHAR2(20) )

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT pk_emp_test PRIMARY KEY (empno),
    CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
);

-- ALTER TABLE ���̺�� ADD (�ű��÷���, �ű��÷� Ÿ��)

ALTER TABLE emp_test ADD (HP VARCHAR2(20));

DESC emp_test;

SELECT *
FROM emp_test;

-- TABLE ���� 2. �÷� ������ ����, Ÿ�� ����
-- ex: �÷� VARCHAR2(20) �� VARCHAR2(5)
-- �⺻�� �����Ͱ� ������ ��� ���������� ������ �ȵ� Ȯ���� �ſ� ����.
-- �Ϲ������δ� �����Ͱ� �������� �ʴ� ����, �� ���̺��� ������ ���Ŀ� �÷��� ������, Ÿ���� �߸� �� ���
-- �÷� ������, Ÿ���� ������.

-- �����Ͱ� �Է� �� ���ķδ� Ȱ�뵵�� �ſ� ������. (������ �ø��� �͸� ����.)

DESC emp_test;

-- HP VARCHAR2(20) �� HP VARCHAR2(30)
-- ALTER TABLE ���̺�� MODIFY (���� �÷���, �ű� �÷� Ÿ��(������))

ALTER TABLE emp_test MODIFY (HP VARCHAR2(30));

-- �÷� Ÿ�� ����
-- HP VARCHAR2(30) �� HP NUMBER;

ALTER TABLE emp_test MODIFY (HP NUMBER);
DESC emp_test;

-- TABLE ���� 3. �÷� �⺻�� ����
--ALTER TABLE ���̺�� MODIFY (�÷��� DEFAULT �⺻��)

-- HP NUMBER �� VARCHAR2(20) DEFAULT '010'
ALTER TABLE emp_test MODIFY (HP VARCHAR2(20) DEFAULT '010');

-- HP �÷����� ���� ���� �ʾ����� DEFAULT ������ ���� '010' ���ڿ��� �⺻������ ����ȴ�. DEFAULT���� ������ ������ ����.
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 99);

SELECT *
FROM emp_test;

-- TABLE ���� 4. ����� �÷� ����
-- ALTER TABLE ���̺�� RENAME COLUMN ���� �÷��� TO �ű� �÷���
-- �����Ϸ��� �ϴ� �÷��� FK����, PK������ �־ ��� ����.

-- HP �� HP_n

ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;
SELECT *
FROM emp_test;

-- TABLE ���� 5. �÷� ����
-- ALTER TABLE ���̺�� DROP COLUMN �÷���

-- emp_test ���̺��� hp_n �÷� ����

SELECT *
FROM emp_test;

ALTER TABLE emp_test DROP COLUMN hp_n;

-- 1. emp_test ���̺��� drop �� empno, ename, deptno, hp 4���� �÷����� ���̺� ����
-- 2. empno, ename, deptno 3���� �÷����� (9999, 'brown', 99) �����ͷ� INSERT
-- 3. emp_test ���̺��� hp �÷��� �⺻���� '010'���� ����
-- 4. 2�� ������ �Է��� ���̺��� hp �÷� ���� ��� �ٲ���� Ȯ��.

-- TABLE ���� 6. �������� �߰� / ����
-- ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� ��������Ÿ��(ex:PRIMARY KEY, FOREIGN KEY) (�ش� �÷�);
-- ALTER TABLE ���̺�� DROP CONSTRAINT �������Ǹ�

-- emp_test ���̺� ���� �� ���� ���� ���� ���̺��� ����
-- PRIMARY KEY, FOREIGN KEY ������ ALTER TABLE ������ ���� ����.
-- �ΰ��� �������� �׽�Ʈ


DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2));
    
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);

-- PRIMARY KEY �׽�Ʈ
INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 99); -- ù��° INSERT ������ ���� �ߺ��ǹǷ� ����.

-- FOREIGN KEY �׽�Ʈ
SELECT *
FROM dept_test;

INSERT INTO emp_test VALUES (9998, 'sally', 98); -- dept_test ���̺� �������� �ʴ� �μ���ȣ�̹Ƿ� ����.

-- �������� ���� : PRIMARY KEY, FOREIGN KEY
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test;

-- ���������� �����Ƿ� empno�� �ߺ��� ���� �� �� �ְ�, dept_test ���̺� �������� �ʴ� deptno ���� �� �� �ִ�.
INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 99);

-- �������� �ʴ� 98���μ��� ������ �Է�.
INSERT INTO emp_test VALUES (9998, 'sally', 98);


-- �������� Ȱ��ȭ / ��Ȱ��ȭ

-- ALTER TABLE ���̺�� ENABLE | DISABLE CONSTRAINT �������Ǹ�

-- 1. emp_test ���̺� ����
-- 2. emp_test ���̺� ����
-- 3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY(dept_test.deptno) �������� ����
-- 4. �ΰ��� ���������� ��Ȱ��ȭ
-- 5. ��Ȱ��ȭ�� �Ǿ����� INSERT�� ���� Ȯ��.
-- 6. ���������� ������ �����Ͱ� �� ���¿��� �������� Ȱ��ȭ

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2));
    
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);

ALTER TABLE emp_test DISABLE CONSTRAINT PK_emp_test;
ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test;

INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 98);
COMMIT;

SELECT *
FROM emp_test;

-- emp_test���̺��� empno �÷��� ���� 9999�� ����� �θ� �����ϱ� ������
-- PRIMARY KEY ���������� Ȱ��ȭ �� ���� ����.
-- empno �÷��� ���� �ߺ����� �ʵ��� �����ϰ� ���������� Ȱ��ȭ �� �� �ִ�.
ALTER TABLE emp_test ENABLE CONSTRAINT PK_emp_test;  -- ����
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test;  -- ����

-- �ߺ� ������ ����
DELETE emp_test
WHERE ename = 'brown';

-- PRIMARY KEY �������� Ȱ��ȭ
ALTER TABLE emp_test ENABLE CONSTRAINT PK_emp_test;

-- dept_test ���̺� �������� �ʴ� �μ���ȣ 98�� emp_test���� ��� ��.
-- 1. dept_test ���̺� 98�� �μ��� ����ϰų�
-- 2. sally�� �μ���ȣ�� 99������ ����.
-- 3. sally ���� ����

UPDATE emp_test SET deptno = 99
WHERE ename = 'sally';

ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test;

