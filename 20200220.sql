SELECT *
FROM no_emp;

1. leaf node�� �˱� ���� ��������� ���� �� ���ƾ� ��. CONNECT_BY_ISLEAF�� leaf node Ȯ��.;
2. LEVEL : ���� Ž�� �� �׷��� ���� ���� �ʿ��� ��.
3. leaf ������ ���� Ž��, ROWNUM �ο�. (�ζ��� ��), LEVEL, ROWNUM, LEVEL + ROWNUM �÷� ȹ��
4. OVER ���� �׷�ȭ �� WINDOWING���� �׷캰 ������ �� ���ϱ�.
5. �ߺ� �μ� ī��Ʈ�� Ȯ��. COUNT OVER PARTITION ���
6. �������� �ߺ� ī��Ʈ�� ����� �������� ǥ�� (���߿� ��ġ�� ���� ���� ��)
7. ������ ���ϱ�(�ζ��� ��)

SELECT LPAD(' ', (LEVEL - 1) * 4) || org_cd org_cd, total
FROM
    (SELECT org_cd, parent_org_cd, SUM(total) total
     FROM
        (SELECT org_cd, parent_org_cd, no_emp, SUM(no_emp) OVER(PARTITION BY gno ORDER BY rn
                                                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total
         FROM                                                
            (SELECT org_cd, parent_org_cd, lv, ROWNUM rn, lv + ROWNUM gno,
                    no_emp / COUNT(*) OVER (PARTITION BY org_cd) no_emp
             FROM
                (SELECT no_emp.*, LEVEL lv, CONNECT_BY_ISLEAF leaf
                 FROM no_emp
                 START WITH parent_org_cd IS NULL
                 CONNECT BY PRIOR org_cd = parent_org_cd)
             START WITH leaf = 1
             CONNECT BY PRIOR parent_org_cd = org_cd) )
    GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;



DROP TABLE gis_dt;
CREATE TABLE gis_dt AS
SELECT SYSDATE + ROUND(DBMS_RANDOM.value(-30, 30)) dt,
       '����� ����� ������ Ű��� ���� ���� ������ �Դϴ� ����� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴ�' v1
FROM dual
CONNECT BY LEVEL <= 450000;

CREATE INDEX idx_n_gis_dt_01 ON gis_dt (dt, v1);

gia_dt�� dt �÷����� 2020�� 2���� �ش��ϴ� ��¥�� �ߺ����� �ʰ� ���Ѵ� : �ִ� 29���� ��
2020/02/01
2020/02/02
2020/02/03
...
2020/02/29

PL/SQL ��� ����
DECLARE : ����, ��� ���� [��������]
BEGIN : ���� ��� [���� �Ұ�]
EXCEPTION : ����ó�� [���� ����]

PL/SQL ������
�ߺ� �Ǵ� ������ ���� Ư����
���� �����ڰ� �Ϲ����� ���α׷��� ���� �ٸ���.
Java =
PL/SQL :=
;

PL/SQL ��������
Java : Ÿ�� ������ ( ex : String str );
PL/SQL : ������ Ÿ�� ( ex : deptno NUMBER(2) );

PL/SQL �ڵ� ������ ���� ����ϴ� ���� Java�� �����ϰ� �����ݷ��� ����Ѵ�.
Java : String srt;
PL/SQL : deptno NUMBER(2);

PL/SQL ����� ���� ǥ���ϴ� ���ڿ� : /
SQL�� ���� ���ڿ� : ;

Hello World ���;

SET SERVEROUTPUT ON;

DECLARE
    msg VARCHAR2(50);
BEGIN
    msg := 'Hello, World!';
    DBMS_OUTPUT.PUT_LINE(msg);
END;
/


�μ� ���̺��� 10�� �μ��� �μ���ȣ��,�μ��̸��� PL/SQL ������ �����ϰ� ������ ���;

DECLARE
    v_deptno NUMBER(2);         -- ���� ����.
    v_dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept;
    -- WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
END;
/

PL/SQL ���� Ÿ��
�μ� ���̺��� �μ���ȣ, �μ����� ��ȸ�Ͽ� ������ ��� ����;
�μ���ȣ, �μ����� Ÿ���� �μ� ���̺� ���ǰ� �Ǿ�����.

NUMBER, VARCHAR2 Ÿ���� ���� ����ϴ°� �ƴ϶� �ش� ���̺��� �÷��� Ÿ���� �����ϵ���
���� Ÿ���� ���� �� �� �ִ�. = ���� Ÿ��;
ex : v_deptno NUMBER(2) �� dept.deptno%TYPE;


DECLARE
    v_deptno dept.deptno%TYPE;     
    v_dname dept.dname%Type;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
END;
/


���ν��� ��� ����

�͸� ��(�̸��� ���� ��)
 - ������ �Ұ��� �ϴ� (IN-LINE VIEW �� ���)
 
���ν���(�̸��� �ִ� ��)
 - ���� �����ϴ�
 - �̸��� �ִ�.
 - ���ν����� ������ �� �Լ�ó�� ���ڸ� ���� �� �ִ�.

�Լ� (�̸��� �ִ� ��)
 - ���� �����ϴ�
 - �̸��� �ִ�
 - ���ν����� �޸� ���ϰ��� �ִ�.
 
���ν��� ����
CREATE OR REPLACE PROCEDURE ���ν����̸� IS (IN param, OUT param, IN OUT param)
    ����� (DECLARE ���� ������ ����)
    BEGIN
    EXCEPTION (�ɼ�)
END;
/



�μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ��̸��� PL/SQL ������ �����ϰ� DBMS_OUTPUT.PUT_LINE �Լ��� �̿��Ͽ� ȭ�鿡 ����ϴ�
printdept ���ν����� ����
CREATE OR REPLACE PROCEDURE printdept IS
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
END;
/


���ν��� ���� ���;
exec ���ν�����(����...);

exec printdept;

printdept_p ���ڷ� �μ���ȣ�� �޾Ƽ�
�ش� �μ���ȣ�� �ش��ϴ� �μ��̸��� ���������� �ֿܼ� ����ϴ� ���ν��� ����;

CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE) IS 
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc INTO v_dname, v_loc
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_dname || ', ' || v_loc);
END;
/

exec printdept_p (20);
-- PL/SQL���� �˻������ 0���̸� �װ͵� ���ܷ� ����ó�� ��.


-- PRO_1 ���ν��� + ���ι�
CREATE OR REPLACE PROCEDURE printemp(p_empno emp.empno%TYPE) IS
    v_ename emp.ename%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT emp.ename, dept.dname INTO v_ename, v_dname
    FROM emp JOIN dept ON (emp.deptno = dept.deptno)
    WHERE emp.empno = p_empno;

    DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_dname);
END;
/

EXEC printemp (7369);