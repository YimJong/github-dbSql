SET SERVEROUTPUT ON;
SELECT *
FROM dept_test;

ROLLBACK;
-- PRO_2 ���ν��� + INSERT��

CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept_test.deptno%TYPE, 
                                            p_dname IN dept_test.dname%TYPE, 
                                            p_loc IN dept_test.loc%TYPE) IS
BEGIN
    INSERT INTO dept_test(deptno, dname, loc) VALUES (p_deptno, p_dname, p_loc);
    COMMIT;
END;
/

EXEC registdept_test (55, 'yims academy', 'biraedong');


-- PRO_3 ���ν��� + UPDATE��
CREATE OR REPLACE PROCEDURE UPDATEdept_test(p_deptno IN dept_test.deptno%TYPE, 
                                            p_dname IN dept_test.dname%TYPE, 
                                            p_loc IN dept_test.loc%TYPE) IS
BEGIN
    UPDATE dept_test SET dname = p_dname,
                         loc = p_loc
                         WHERE deptno = p_deptno;
    COMMIT;                        
END;
/

EXEC UPDATEdept_test(99, 'it1_m', 'biraedong');


���� ���� %rowtype : Ư�� ���̺��� ���� ��� �÷��� ������ �� �ִ� ����
��� ��� : ������ ���̺��%ROWTYPE
;

SET SERVEROUTPUT ON;
DECLARE
    v_dept_row dept%ROWTYPE;
BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname || ' ' || v_dept_row.loc);
END;
/


���� ���� RECORD
�����ڰ� ���� �������� �÷��� ������ �� �ִ� Ÿ���� �����ϴ� ���
Java�� �����ϸ� Ŭ������ �����ϴ� ����
�ν��Ͻ��� ����� ������ ��������
��� ��� : ;
TYPE Ÿ���̸�(�����ڰ� ����) IS RECORD(
    ������1 ����Ÿ��,
    ������2 ����Ÿ��
    );  -- �ڹ� Ŭ���� ����� �Ͱ� ����
    
������ Ÿ���̸�;  -- �ڹ� �ν��Ͻ� ����� �Ͱ� ����

DECLARE
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname VARCHAR2(14)
    );
    
    v_dept_row dept_row;
BEGIN
    SELECT deptno, dname INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname);
END;
/


table type ���̺� Ÿ��
�� : ��Į�� ����
�� : %ROWTYPE, record type
�� : table type
    � ��(%ROWTYPE, RECORD TYPE)�� ������ �� �ִ���
    �ε��� Ÿ���� ��������;
    
DEPT ���̺��� ������ ���� �� �ִ� table type�� ����
������ ��� ��Į�� Ÿ��, rowtype������ �� ���� ������ ���� �� �־�����
table Ÿ�� ������ �̿��ϸ� ���� ���� ������ ���� �� �ִ�.;
PL/SQL������ Java�� �ٸ��� �迭�� ���� �ε����� ������ �����Ǿ� ���� �ʰ� ���ڿ��� �����ϴ�.
�׷��� ������ TABLE Ÿ���� ������ ���� �ε����� ���� Ÿ�Ե� ���� ����Ͽ��� �Ѵ�.
BINARY_INTEGER Ÿ���� PL/SQL������ ��� ������ Ÿ������ NUMBER Ÿ���� �̿��Ͽ� ������ ��� �����ϰԲ� �� NUMBERŸ���� ���� Ÿ���̴�.;


DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;   -- Ÿ�Լ���
    v_dept_tab dept_tab;      --  ������(���� �Է�) Ÿ�Ը�(������ ����)
BEGIN
    SELECT * BULK COLLECT INTO v_dept_tab
    FROM dept;
    -- ���� ��Į�󺯼�, record Ÿ���� �ǽ� �ÿ��� �� �ุ ��ȸ �ǵ��� WHERE���� ���� �����Ͽ���.
    
    -- �ڹٿ����� �迭[�ε�����ȣ]�� ȣ��
    -- ����Ŭ�� table����(�ε�����ȣ)�� ȣ��
    
    -- FOR (int i = 0; i < 10; i++); �ڹ�
    -- .count = �ڹٿ��� .length�� ���� ���.
    FOR i IN 1..v_dept_tab.count LOOP
        DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
    END LOOP;
    
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(2).deptno || ' ' || v_dept_tab(2).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(3).deptno || ' ' || v_dept_tab(3).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(4).deptno || ' ' || v_dept_tab(4).dname);   
END;
/


�������� IF
��� ���:

IF ���ǹ� THEN
    ���๮;
ELSIF ���ǹ� THEN
    ���๮;
ELSE        -- THEN�� ����
    ���๮;
END IF;

-- EX)
DECLARE
    p NUMBER(1) := 2;  -- ���� ���� �� �ʱ�ȭ
BEGIN
    IF p = 1 THEN   -- �ڹٴ� == ��� ��.
        DBMS_OUTPUT.PUT_LINE('1�Դϴ�.');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('2�Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�˷����� �ʾҽ��ϴ�.');
    END IF;
END;
/



CASE ����
1. �Ϲ� ���̽� (Java�� Switch�� ����)
2. �˻� ���̽� (if, else if, else�� ����);

<�Ϲ� ���̽���>
CASE expression
    WHEN value THEN
        ���๮;
    WHEN value THEN
        ���๮;
    ELSE
        ���๮;
END CASE;
<�Ϲ� ���̽���>;
DECLARE
    p NUMBER(1) := 2;
BEGIN
    CASE p
        WHEN 1 THEN
             DBMS_OUTPUT.PUT_LINE('1�Դϴ�.');
        WHEN 2 THEN
             DBMS_OUTPUT.PUT_LINE('2�Դϴ�.');
        ELSE
             DBMS_OUTPUT.PUT_LINE('�𸣴� ���Դϴ�.');
    END CASE;
END;
/




<�˻� ���̽���>;
DECLARE
    p NUMBER(1) := 2;
BEGIN
    CASE
        WHEN p = 1 THEN
             DBMS_OUTPUT.PUT_LINE('1�Դϴ�.');
        WHEN p = 2 THEN
             DBMS_OUTPUT.PUT_LINE('2�Դϴ�.');
        ELSE
             DBMS_OUTPUT.PUT_LINE('�𸣴� ���Դϴ�.');
    END CASE;
END;
/


<FOR LOOP ����>
FOR ��������/ �ε��� ���� IN [REVERSE] ���۰�..���ᰪ LOOP
    �ݺ��� ����
END LOOP;

1���� 5���� FOR LOOP �ݺ����� �̿��Ͽ� ���� ���;

DECLARE
BEGIN
    FOR i IN 1..5 LOOP
         DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

������ ���;
DECLARE
BEGIN
    FOR i IN 2..9 LOOP
     DBMS_OUTPUT.PUT_LINE('==' || i || '�� ==');
        FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i || ' X ' || j || ' = ' || i * j);
        END LOOP;
    END LOOP;
END;
/


while loop ����;
WHILE ���� LOOP
    �ݺ� ������ ����;
END LOOP;

DECLARE
    i NUMBER := 0;
BEGIN
    WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
    END LOOP;
END;

 
LOOP�� ���� �� �ڹ��� while(true)�� ���
LOOP
    �ݺ� ������ ����;
    EXIT ����;
END LOOP;

DECLARE
    i NUMBER := 0;
BEGIN
    LOOP
         DBMS_OUTPUT.PUT_LINE(i);
         EXIT WHEN i > 5;
         i := i + 1;
    END LOOP;
END;
/