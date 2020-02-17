:dt �� 202002;

SELECT DECODE(d, 1, IW+1, IW) IW,   -- �Ͽ����� �� �� ������ ���ؼ� �Ͽ����� ��� IW�� 1 ����.
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:dt, 'YYYYMM') + (LEVEL - 1) dt,    
            TO_CHAR(TO_DATE(:dt, 'YYYYMM') + (LEVEL - 1), 'D') d,
            TO_CHAR(TO_DATE(:dt, 'YYYYMM') + (LEVEL - 1), ' IW') IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, IW+1, IW)
ORDER BY IW;

���� : �������� 1��, ������ ��¥ : �ش� ���� ������ ����.;
SELECT TO_DATE('202002', 'YYYYMM') + (LEVEL - 1)
FROM dual
CONNECT BY LEVEL <= 29;

���� : �������� : �ش� ���� 1���ڰ� ���� ���� �Ͽ���
      ������ ��¥ : �ش� ���� ������ ���ڰ� ���� ���������.;
SELECT TO_DATE('20200126', 'YYYYMMDD') + (LEVEL - 1)
FROM dual
CONNECT BY LEVEL <= 35;


-- �ش� ���� 1���ڰ� ���� �Ͽ��� ���ϱ�
-- �ش� ���� ������ ���ڰ� ���� ���� ����� ���ϱ�

SELECT
    TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 ) st,
    LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7 - TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
    LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7 - TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                - (TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;


SELECT TO_DATE(:dt, 'yyyymm'),
       (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 )    
FROM dual;


SELECT DECODE(d, 1, IW+1, IW) IW,   -- �Ͽ����� �� �� ������ ���ؼ� �Ͽ����� ��� IW�� 1 ����.
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 ) + (LEVEL - 1) dt,
            TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 ) + (LEVEL - 1), 'D') d,
            TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D') - 1 ) + (LEVEL - 1), ' IW') IW
    FROM dual
    CONNECT BY LEVEL <=  LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7 - TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                - (TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') - 1))
GROUP BY DECODE(d, 1, IW+1, IW)
ORDER BY IW;


SELECT *
FROM sales;

SELECT dt
FROM sales;

SELECT EXTRACT(MONTH FROM dt)            
FROM sales;


SELECT SUM(DECODE(EXTRACT(MONTH FROM dt), 1, sales)) AS JAN,
       SUM(DECODE(EXTRACT(MONTH FROM dt), 2, sales)) AS FEB,
       NVL(SUM(DECODE(EXTRACT(MONTH FROM dt), 3, sales)),0) AS MAR,
       SUM(DECODE(EXTRACT(MONTH FROM dt), 4, sales)) AS APR,
       SUM(DECODE(EXTRACT(MONTH FROM dt), 5, sales)) AS MAY,
       SUM(DECODE(EXTRACT(MONTH FROM dt), 6, sales)) AS JUN
FROM sales; 



-- �ٸ� ��� (NVL)�� ���� �������� ���ִ°��� ������ ����. SUM ������ NVL�� �ϸ� �� �࿡ NVL�� �õ��ϰ� SUM�� ��.
-- SUM�� �� �Ŀ� NVL�� �ϸ� SUM ���� �ѹ��� �ϸ� ��.
SELECT NVL(SUM(JAN), 0) JAN, NVL(SUM(FEB), 0) FEB, 
       NVL(SUM(MAR), 0) MAR, NVL(SUM(APR), 0) APR, 
       NVL(SUM(MAY), 0) MAY, NVL(SUM(JUN), 0) JUN
FROM
(SELECT DECODE(TO_CHAR(dt, 'MM'), '01', SUM(sales)) JAN,
        DECODE(TO_CHAR(dt, 'MM'), '02', SUM(sales)) FEB,
        DECODE(TO_CHAR(dt, 'MM'), '03', SUM(sales)) MAR,
        DECODE(TO_CHAR(dt, 'MM'), '04', SUM(sales)) APR,
        DECODE(TO_CHAR(dt, 'MM'), '05', SUM(sales)) MAY,
        DECODE(TO_CHAR(dt, 'MM'), '06', SUM(sales)) JUN
FROM sales
GROUP BY TO_CHAR(dt, 'MM') );

SELECT *
FROM dept_h;

-- ����Ŭ ������ ���� ����
SELECT ...
FROM ...
WHERE
START WITH ���� : � ���� ���������� ������
CONNECT BY ��� ���� �����ϴ� ����
            FRIOR : �̹� ���� ��
            "   " : ������ ���� ��;

����� : �������� �ڽ� ���� ���� (�� �� �Ʒ�);

XXȸ��(�ֻ��� ����) ���� '����'�Ͽ� ���� �μ��� �������� ���� ���� �ۼ�;

SELECT dept_h.*, LEVEL, lpad(' ', (LEVEL - 1) * 4, ' ') || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;  
-- START WITH deptnm = 'XXȸ��'  �� ��� ����
-- START WITH P_DEPTCD IS NULL   �� ��� ����




-- ��� ���� ���� ���� ((PRIOR)XXȸ�� - 3���� ��(�����κ�, ������ȹ��, �����ý��ۺ�))
PRIOR XXȸ��.deptcd = �����κ�.p_deptcd
PRIOR �����κ�.deptcd = ��������.p_deptcd
-- PRIOR ��������.deptcd = .p_deptcd : �� �̻� ������ �ȵ�.

PRIOR XXȸ��.deptcd = ������ȹ��.p_deptcd
PRIOR ������ȹ��.deptcd = ��ȹ��.p_deptcd
PRIOR ��ȹ��.deptcd = ��ȹ��Ʈ.p_deptcd
-- PRIOR ��ȹ��Ʈ.deprcd = ... : �� �̻� ������ �ȵ�.

PRIOR XXȸ��.deptcd = �����ý��ۺ�.p_deptcd (����1��, ����2��)
PRIOR �����ý��ۺ�.deptcd = ����1��.p.deptcd
-- PRIOR ����1��.p.deptcd = .... : ����.. ����ȵ�.
-- PRIOR ����2��.p.deptcd = .... : ����.. ����ȵ�.



SELECT dept_h.*, LEVEL, lpad(' ', (LEVEL - 1) * 4, ' ') || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY p_deptcd = PRIOR deptcd AND PRIOR ...; -- ����. PRIOR ����, AND���� ��� ����. 


