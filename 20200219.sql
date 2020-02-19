SELECT dd.ename, dd.sal, dd.deptno, lv
    FROM
    (SELECT ROWNUM rn, ename, sal, deptno
     FROM
    (SELECT ename, sal, deptno
     FROM EMP
     ORDER BY deptno, sal desc) d)dd ,

    (SELECT ROWNUM rn, lv
     FROM
        (SELECT *
         FROM
            (SELECT LEVEL lv
             FROM dual 
             CONNECT BY LEVEL <= 14) a,
        
            (SELECT deptno, COUNT(*) cnt
             FROM emp
             GROUP BY deptno) b
         WHERE b.cnt >= a.lv
         ORDER BY b.deptno, a.lv) c)c
WHERE c.rn = dd.rn;


-- ���� ������ �м��Լ��� ����ؼ� ǥ���ϸ�?
SELECT ename, sal, deptno, ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;


1. ���� ���� ��� 11��
2. ����¡ ó��(�������� 10���� �Խñ�)
3. 1������ : 1 ~ 10
4. 2������ : 11 ~ 20
5. ���ε庯�� :page, :pageSize ���;

SELECT *
FROM
(SELECT ROWNUM rn, a.*
 FROM
    (SELECT seq, lpad(' ', (LEVEL - 1) * 4) || title AS title, 
           DECODE(parent_seq, NULL, seq, parent_seq) AS test
     FROM board_test
     START WITH PARENT_SEQ IS NULL
     CONNECT BY PRIOR seq = parent_seq
     ORDER SIBLINGS BY test DESC) a )
WHERE rn BETWEEN (:page - 1) * :pageSize + 1 AND :page * :pageSize;


-- �м��Լ� ����
�м��Լ��� ([����]) OVER ([PARTITION BY �÷�] [ORDER BY �÷�] [WINDOWING])
PARTITION BY �÷� : �ش� �÷��� ���� ROW ���� �ϳ��� �׷����� ���´�.
ORDER BY �÷� : PARTITION BY�� ���� ���� �׷� ������ ORDER BY �÷����� ����

ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank;

-- ���� ���� �м��Լ�
RANK() : ���� ���� ���� �� �ߺ� ������ ����, �� ������ �ߺ� ����ŭ ������ ������ ����
         2���� 2���̸� 3���� ���� 4����� �� ������ �����ȴ�.
DENSE_RANK() : ���� ���� ���� �� �ߺ� ������ ����, �� ������ �ߺ� ���� �������� ����
               2���� 2���̴��� �ļ����� 3����� ����
ROW_NUMBER() : ROWNUM�� ����, �ߺ��� ���� ������� ����.

-- �μ���, �޿� ������ 3���� ��ŷ ���� �Լ��� ����;
SELECT ename, sal, deptno,
       RANK() OVER(PARTITION BY deptno ORDER BY sal) sal_rank,
       DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal) sal_dense_rank,
       ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal) sal_row_number
FROM emp;

-- ana 1 : ��� ��ü �޿� ����
-- �м��Լ������� �׷�
SELECT empno, ename, sal, deptno,
       RANK() OVER(ORDER BY sal DESC, empno ASC) sal_rank,
       DENSE_RANK() OVER(ORDER BY sal DESC, empno ASC) sal_dense_rank,
       ROW_NUMBER() OVER(ORDER BY sal DESC, empno ASC) sal_row_number
FROM emp;

-- ana 2
SELECT e.empno, e.ename, e.deptno, a.cnt
FROM emp e,
    (SELECT deptno, count(*) cnt
     FROM emp
     GROUP BY deptno) a
WHERE e.deptno = a.deptno
ORDER BY deptno ASC;

-- ��� ���úм��Լ� (GROUP �Լ����� �����ϴ� �Լ� ������ ����)
SUM(�÷�)
COUNT(*), COUNT(�÷�)
MIN(�÷�)
MAX(�÷�)
AVG(�÷�)

- no_ana2�� �м��Լ��� �̿��Ͽ� �ۼ�
�μ��� ���� ��;
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- ana2
SELECT empno, ename, sal, deptno, ROUND(AVG(sal) OVER(PARTITION BY deptno), 2) avg_sal
FROM emp;

-- ana3
SELECT empno, ename, sal, deptno, ROUND(MAX(sal) OVER(PARTITION BY deptno), 2) avg_sal
FROM emp;

-- ana4
SELECT empno, ename, sal, deptno, ROUND(MIN(sal) OVER(PARTITION BY deptno), 2) avg_sal
FROM emp;

�޿��� �������� �����ϰ�, �޿��� ���� ���� �Ի����ڰ� ���� ����� ���� �켱������ �ǵ��� �����Ͽ� 
�������� ������(LEAD)�� SAL �÷��� ���ϴ� ���� �ۼ�;

SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

-- ana5
SELECT empno, ename, hiredate, sal, LAG(sal) OVER(ORDER BY sal DESC, hiredate ASC) lag_sal
FROM emp;

-- ana6
SELECT empno, ename, hiredate, job, sal, LAG(sal) OVER(PARTITION BY job ORDER BY sal DESC, deptno) lag_sal
FROM emp;

-- no_ana3
SELECT e.empno, e.ename, e.sal, SUM(a.sal) c_sum
FROM emp e, 
    (SELECT ROWNUM rn, sal
     FROM
        (SELECT sal
         FROM emp
         ORDER BY sal)) a
WHERE e.sal >= a.sal
GROUP BY e.empno, e.ename, e.sal
ORDER BY sal, empno;

-- no_ana3�� �м��Լ��� �̿��Ͽ� SQL �ۼ�;

SELECT empno, ename, sal, SUM(sal) OVER(ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumm_sal
FROM emp;

-- ���� ���� �������� ���� �� ����� ���� �� ����� �� 3������ sal �հ� ���ϱ�.
SELECT empno, ename, sal, SUM(sal) OVER(ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;

-- ana7
-- ORDER BY ��� �� WINDOWING ���� ������� ���� ��� ���� WINDOWING�� �⺻ ������ ���� �ȴ�.
-- RANGE UNBOUNDED PRECEDING
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW;
SELECT empno, ename, deptno, sal, SUM(sal) OVER(PARTITION BY deptno ORDER BY sal 
                                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS c_sum
FROM emp;       

-- WINDOWING �� RANGE, ROWS ��
-- RANGE : ������ ���� ����, ���� ���� ������ �÷����� �ڽ��� ������ ���
-- ROWS : �������� ���� ����
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING) row_,
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal RANGE UNBOUNDED PRECEDING) range_,
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal) default_
FROM emp;
-- ������ ���� ���� �� ������ ����. RANGE�� �ߺ����� ������.