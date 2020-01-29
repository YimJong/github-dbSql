-- DATE : TO_DATE ���ڿ� �� ��¥(DATE)
--        TO_CHAR ��¥ �� ���ڿ�(��¥ ���� ����)
-- JAVA������ ��¥ ������ ��ҹ��ڸ� ������. ( MM / mm �� �� / �� )
-- �Ͽ��� 1, ������ 2 ..... ����� 7
-- ���� IW : ISOǥ��. �ش����� ������� �������� ������ ����.
--          2019/12/31 ȭ���� �� 2020/01/02 ����� : ������ ������� �� ���� ����

SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE, 'D'),
       TO_CHAR(SYSDATE, 'IW'),
       TO_CHAR(TO_DATE('2019-12-31', 'YYYY/MM/DD'), 'IW')
FROM dual;

-- emp ���̺��� hiredate(�Ի�����) Į���� ����� ��:��:��
SELECT ename, hiredate,
       TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') AS hiredate2,
       TO_CHAR(hiredate + 1, 'YYYY/MM/DD HH24:MI:SS') AS hiredate_plusdate,
       TO_CHAR(hiredate + 1/24, 'YYYY/MM/DD HH24:MI:SS') AS hiredate_plushour,
       TO_CHAR(hiredate + (1/24/60)*30, 'YYYY/MM/DD HH24:MI:SS') AS hiredate_plus30min
FROM emp;

--fn2

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS dt_dash,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS') AS dt_dash_with_time,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') AS dt_dd_mm_yyyy
FROM dual;

SELECT hiredate
FROM emp;

-- MONTHS_BETWEEN(DATE, DATE)
-- ���ڷ� ���� �� ��¥ ������ ���� ���� ����
SELECT ename, hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate),
       MONTHS_BETWEEN(TO_DATE('2020-01-17', 'YYYY-MM-DD'), hiredate)
FROM emp
WHERE ename = 'SMITH';

--ADD_MONTHS(DATE, ���� - ������ ���� ��)
SELECT ADD_MONTHS(SYSDATE, 5),
       ADD_MONTHS(SYSDATE, -5)
FROM dual;

--NEXT_DAY(DATE, �ְ�����), ex) NEXT_DAY(SYSDATE, 5) �� SYSDATE���� ó�� �����ϴ� �ְ����� 5(�����)�� �ش��ϴ� ����
--                            SYSDATE 2020/01/29(��) ���� ó�� �����ϴ� 5(��)���� �� 2020/01/30(��)
SELECT NEXT_DAY(SYSDATE, 5)
FROM dual;

--LAST_DAY(DATE) DATE�� ���� ���� ������ ���ڸ� ����.
SELECT LAST_DAY(SYSDATE)
FROM dual;

-- LAST_DAY�� ���� ���ڷ� ���� date�� ���� ���� ������ ���ڸ� ���� �� �ִµ�
-- date�� ù��° ���ڴ� ��� ���ұ�?
SELECT ADD_MONTHS((LAST_DAY(SYSDATE) + 1), -1) AS FIRSTDAY_OF_MONTH,
       TO_DATE('01', 'DD')
FROM dual;

-- hiredate ���� �̿��Ͽ� �ش���� ù��° ���ڸ� ǥ��
SELECT ename, hiredate, ADD_MONTHS((LAST_DAY(hiredate) + 1), -1) AS FIRSTDAY_OF_MONTH
FROM emp;

-- empno�� numberŸ�� , ���ڴ� ���ڿ�
-- Ÿ���� ���� �ʱ� ������ ������ ����ȯ�� �Ͼ.
-- ���̺� �÷��� Ÿ�Կ� �°� �ùٸ� ���� ���� �ִ°� �߿�.
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM emp
WHERE empno = 7369;

-- hiredate�� ��� DATE Ÿ��, ���ڴ� ���ڿ��� �־����� ������ ������ ����ȯ�� �߻�.
-- ��¥ ���ڿ� ���� ��¥ Ÿ������ ��������� ����ϴ� ���� ����.
SELECT *
FROM emp
WHERE hiredate = TO_DATE('1980/12/17', 'YYYY/MM/DD');

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM table(dbms_xplan.display);

-- ���ڸ� ���ڿ��� �����ϴ� ��� : ����
-- õ���� ������
-- �ѱ� : 1,000.50
-- ���� : 1.000,50

-- emp sal �÷�(NUMBER Ÿ��)�� ������
-- 9 : ����
-- 0 : ���� �ڸ� ����(0���� ǥ��)
-- L : ��ȭ����
SELECT ename,
sal, TO_CHAR(sal, 'L0,999')
FROM emp;


-- NULL�� ���� ����� �׻� NULL
-- emp ���̺��� sal �÷����� null �����Ͱ� �������� ����. (14���� �����Ϳ� ���Ͽ�)
-- emp ���̺��� comm �÷����� null �����Ͱ� ����. (14���� �����Ϳ� ���Ͽ�)
-- sal + com �� comm�� NULL�� �࿡ ���ؼ��� ��� NULL�� ���´�.
-- �䱸������ comm�� NULL�̸� sal �ķ��� ���� ��ȸ
-- �䱸������ ���� ��Ű�� ���Ѵ� �� SW������ [����]

-- NVL(Ÿ��, ��ü��)
-- Ÿ���� ���� NULL�̸� ��ü���� ��ȯ�ϰ�
-- Ÿ���� ���� NULL�� �ƴϸ� Ÿ�� ���� ��ȯ
-- if(Ÿ�� == null)
--      return ��ü��;
-- else
--      return Ÿ��;
SELECT ename, sal, comm, NVL(comm, 0), sal + NVL(comm, 0)
FROM emp;

-- NVL2(expr1, expr2, expr3)
-- if(expr1 != null)
--     return expr2;
-- else
--     return expr3
SELECT ename, sal, comm, NVL2(comm, 100000, 0)
FROM emp;

-- NULLIF(expr1, expr2)
-- if (expr1 == expr2)
--      return null;
-- else 
--      return expr1
SELECT ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

-- ��������
-- COALESCE �����߿� ����ó������ �����ϴ� NULL�� �ƴ� ���ڸ� ��ȯ.
-- COALESCE(expr1, expr2....)
-- if(expr1 != null)
--    return expr1
-- else
--    return COALESCE(expr2, expr3....);

--  COALESCE(comm, sal) : comm�� null�� �ƴϸ� comm
--                        comm�� null�̸� sal (��, sal �÷��� ���� NULL�� �ƴҶ�)
SELECT ename, sal, comm, COALESCE(comm, sal)
FROM emp;

-- fn4
SELECT empno, ename, mgr,
       NVL(mgr, 9999),
       NVL2(mgr, mgr, 9999),
       COALESCE(mgr, 9999)
FROM emp;

-- fn5
SELECT userid, usernm, reg_dt, n_reg_dt
FROM
    (SELECT ROWNUM AS rn, userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) AS n_reg_dt
     FROM users)
WHERE rn >= 2;

SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) AS n_reg_dt
FROM users
WHERE userid != 'brown';

-- CONDITION : ������
-- CASE : Java�� if -else if - else
-- CASE
--      WHEN ���� THEN ���ϰ�1
--      WHEN ����2 THEN ���ϰ�2
--      ELSE �⺻��
-- END

-- emp���̺��� job�ķ��� ���� SALESMAN : SAL * 1.05 ����
--                          MANAGER : SAR * 1.1 ����
--                          PRESIDENT : SAR * 1.2 ����
--                          �� ���� ������� SAR ����
SELECT ename, job, sal, 
       CASE
          WHEN job = 'SALESMAN' THEN sal * 1.05
          WHEN job = 'MANAGER' THEN sal * 1.1
          WHEN job = 'PRESIDENT' THEN sal * 1.20
          ELSE sal
       END AS salary_up
FROM emp;

-- DECODE �Լ� : CASE���� ����
-- (�ٸ��� CASE �� : WHEN ���� ���Ǻ񱳰� �����Ӵ�.
--        DECODE �Լ� : �ϳ��� ���� ���Ͽ� = �񱳸� ���)
-- DECODE �Լ� : ��������(������ ������ ��Ȳ�� ���� �þ ���� ����)
-- DECODE(col | expr, ù��° ���ڿ� ���� ��, ù��° ���ڿ� �ι�° ���ڰ� ���� ��� ��ȯ ��,
--                    ù��° ���ڿ� ���� ��2, ù��° ���ڿ� �׹�° ���ڰ� ���� ��� ��ȯ ��, .....
--                    option - else ���������� ��ȯ�� �⺻ ��)
SELECT ename, job, sal,
       DECODE(job, 'SALESMAN', sal * 1.05,
                   'MANAGER', sal * 1.1,
                   'PRESIDENT', sal * 1.2, sal) AS salary_plus
FROM emp;

-- EX1
SELECT ename, job, sal,
       CASE WHEN job = 'SALESMAN' AND sal > 1400 THEN sal * 1.05
            WHEN job = 'SALESMAN' AND sal < 1400 THEN sal * 1.1
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.20
       ELSE sal
       END AS salary_up
FROM emp;

-- EX2
SELECT ename, job, sal,
        
