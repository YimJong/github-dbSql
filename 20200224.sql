������ SQL �����̶� : �ؽ�Ʈ�� �Ϻ��ϰ� ������ SQL
1. ��ҹ��� ����
2. ���鵵 �����ؾ���
3. ��ȸ ����� ���ٰ� ������ SQL�� �ƴ�

�׷��� ������ ���� �ΰ��� SQL ������ ������ ������ �ƴ�;

SELECT * FROM dept;
select * FROM dept;
select   * FROM dept;
select *
FROM dept;

SQL ���� �� V$SQL �信 �����Ͱ� ��ȸ�Ǵ��� Ȯ��;
SELECT /* sql_test */ *
FROM dept
WHERE deptno = 10;

SELECT /* sql_test */ *
FROM dept
WHERE deptno = 20;

�� �ΰ��� SQL�� �˻��ϰ��� �ϴ� �μ���ȣ�� �ٸ��� ������ �ؽ�Ʈ�� �����ϴ�.
������ �μ���ȣ�� �ٸ��� ������ DBMS ���忡���� ���� �ٸ� SQL�� �ν��Ѵ�.
�� �ٸ� SQL ���� ��ȹ�� �����.
�� ���� ��ȹ�� �������� ���Ѵ�.
�� �ذ�å
SQL���� ����Ǵ� �κ��� ������ ������ �ϰ� �����ȹ�� ������ ���Ŀ� ���ε� �۾��� ����
���� ����ڰ� ���ϴ� ���� ������ ġȯ �� ����
�� ���� ��ȹ�� ���� �� �޸� �ڿ� ���� ����;

SELECT /* sql_test */ *
FROM dept
WHERE deptno = :deptno;




SQL Ŀ�� (CURSOR)
������ ����� SQL���� ������ Ŀ���� ���.
������ �����ϱ� ���� Ŀ�� : ����� Ŀ��

SELECT ��� �������� TABLE Ÿ���� ������ ������ �� ������
�޸𸮴� �������̱� ������ ���� ���� �����͸� ��⿡�� ������ ����.

SQL Ŀ���� ���� �����ڰ� ���� FETCH �����ν� SELECT ����� ���� �ҷ����� �ʰ� ������ ����.

Ŀ�� ���� ��� :

����ο��� ����
    CURSOR Ŀ���̸� IS
        ������ ����;
        
�����(BEGIN)���� Ŀ�� ����
    OPEN Ŀ���̸�;

�����(BEGIN)���� Ŀ���κ��� ������ FETCH
    FETCH Ŀ���̸� INTO ����

�����(BEGIN)���� Ŀ�� �ݱ�
    CLOSE Ŀ���̸�;
    
�μ� ���̺��� Ȱ���Ͽ� ��� �࿡ ���� �μ���ȣ�� �μ� �̸��� CURSOR�� ���� FETCH,
FETCH �� ����� Ȯ��;

SET SERVEROUTPUT ON;

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    OPEN dept_cursor;
    
    LOOP
    
     FETCH dept_cursor INTO v_deptno, v_dname;
     
     EXIT WHEN dept_cursor%NOTFOUND;
     
     DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);

    END LOOP;

END;
/



CURSOR�� ���� �ݴ� ������ �ټ� �����彺����.
CURSOR�� �Ϲ������� LOOP�� �Բ� ����ϴ� ��찡 ����
�� ����� Ŀ���� FOR LOOP���� ����� �� �ְԲ� �������� ����;

List<String> userNameList = new ArrayList<>();
userNameList.add("brown");
userNameList.add("cony");
userNameList.add("sally");
�� ���.

�Ϲ� for
for(int i = 0; i < userNameList.size(); i++) {
    String userName = userNameList.get(i);
}

���� for
for(String userName : userNameList) {
    userName�� ���...
}

--����� �ڹ��� ��� ----------------------------------------------------------------

FOR record_name(�� ���� ������ ���� �����̸� / ������ ���� ���� ����) IN Ŀ���̸� LOOP
    record_name.�÷���
END LOOP;

DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    FOR rec IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;

END;
/


���ڰ� �ִ� ����� Ŀ��
���� Ŀ�� ������
    CURSOR Ŀ���̸� IS
        ��������...;
        
���ڰ� �ִ� Ŀ�� ������
    CURSOR Ŀ���̸�(����1 ����1Ÿ�� .... ) IS
        ��������
        (Ŀ�� ���� �ÿ� �ۼ��� ���ڸ� ������������ ����� �� �ִ�.);
        

DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT deptno, dname
        FROM dept
        WHERE deptno <= p_deptno;             -- ���� ��� ����
BEGIN
    FOR rec IN dept_cursor(20) LOOP   -- ���ڰ� �Է�
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;

END;
/



FOR LOOP���� Ŀ���� �ζ��� ���·� �ۼ�
FOR ���ڵ��̸� IN Ŀ���̸�
��
FOR ���ڵ��̸� IN (��������);

DECLARE 
BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP  
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/   --  Ŀ������, ��ġ���� X



DECLARE
TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;   -- Ÿ�Լ���
    v_dt_tab dt_tab;    
   
    v_count NUMBER;
    v_sum NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM dt;
    
    FOR i IN 1..v_dt_tab.count - 1 LOOP
      v_sum := v_sum + (v_dt_tab(i).dt - v_dt_tab(i + 1).dt);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_sum / v_count);
END;
/

---------------------

CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;   -- �ε��� ���� ������ �� ���̶�� �ε��� Ÿ�� ����
                                                                  -- ���⼭ �ڹ��� �迭 ����� ���� ����
    v_dt_tab dt_tab;  
    
    v_diff_sum NUMBER := 0;  -- �ʱ�ȭ.
BEGIN
    SELECT * BULK COLLECT INTO v_dt_tab
    FROM dt;
    -- DT ���̺��� 8���� �ִµ� 1-7���� ������ LOOP ����
    FOR i IN 1..v_dt_tab.COUNT-1 LOOP
        v_diff_sum := v_diff_sum + v_dt_tab(i).dt - v_dt_tab(i+1).dt; 
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_diff_sum / (v_dt_tab.COUNT-1));
    
END;
/

EXEC avgdt;


SELECT A.*, dt - dt2 gap_dt
FROM
(SELECT dt, LEAD(dt) OVER(ORDER BY dt DESC) dt2 
 FROM dt) A;
 
 
 SELECT (MAX(dt) - MIN(dt)) / (COUNT(dt) - 1) result
 FROM dt;

SELECT a.dt, b.dt, a.dt - b.dt gap
FROM
(SELECT ROWNUM rn, dt
 FROM dt) a,
 
(SELECT ROWNUM rn, dt
 FROM dt) b
 WHERE a.rn = b.rn - 1;


