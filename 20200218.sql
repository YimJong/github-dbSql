����� ���� ���� (LEAF �� ROOT NODE(���� NODE)
��ü ��带 �湮�ϴ°� �ƴ϶� �ڽ��� �θ��常 �湮 (����İ� �ٸ���);
������ : ��������
������ : �����μ�

SELECT *
FROM dept_h;

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL - 1) * 4) || deptnm deptnm
FROM dept_h
START WITH deptnm = '��������'
CONNECT BY PRIOR p_deptcd = deptcd;

-- h_4

SELECT *
FROM h_sum;

SELECT lpad(' ', (LEVEL - 1) * 4) || s_id AS s_id, value
FROM h_sum
START WITH s_id = 0
CONNECT BY PRIOR s_id = ps_id;


-- h_5

SELECT *
FROM no_emp;

SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;


-- ������ ������ �� ���� ���� ��� ��ġ�� ���� ��� �� (PRUNING BRANCH - ����ġ��);
--FROM �� START WITH, CONNECT BY �� WHERE
--1. WHERE : ���� ������ �ϰ� ���� ���� ����
--2. CONNECT BY : ���� ������ �ϴ� �������� ���� ����

--WHERE �� ��� �� : �� 9���� ���� ��ȸ�Ǵ� �� Ȯ��
--WHERE �� (org_cd != '������ȹ��') : ������ȹ�θ� ������ 8�� �� ��ȸ;

SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp
FROM no_emp
WHERE org_cd != '������ȹ��'
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;



-- CONNECT BY ���� ������ ���.
SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd AND org_cd != '������ȹ��';


-- CONNECT_BY_ROOT(�÷�) : �ش� �÷��� �ֻ��� ���� ���� ������.
SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- SYS_CONNEFCT_BY_PATH : �ش� ���� �÷��� ���Ŀ� �÷� ���� ��õ, �����ڷ� �̾��ش�.
SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- CONNECT_BY_ISLEAF  : �ش� ���� LEAF ������� (����� �ڽ��� ������) ���� ���� ( 1: LEAF,  0 : NO LEAF )
SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path,
       CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;


-- h_6
SELECT *
FROM board_test;

DESC board_test;

-- ! ��Ʈ�� ��������.
SELECT seq, lpad(' ', (LEVEL - 1) * 4) || title AS title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq;

-- h_7
SELECT seq, lpad(' ', (LEVEL - 1) * 4) || title AS title, 
       DECODE(parent_seq, NULL, seq, parent_seq) AS test
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY test DESC;

SELECT seq, lpad(' ', (LEVEL - 1) * 4) || title AS title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

-- ���̹� ���� ������ �Խñ� ���� (UPDATE�� �÷� �߰�)
ALTER TABLE board_test ADD (gn NUMBER);

UPDATE board_test SET gn = 4
WHERE seq IN (4, 5, 6, 7, 8, 10, 11);

UPDATE board_test SET gn = 2
WHERE seq IN (2, 3); 

UPDATE board_test SET gn = 1
WHERE seq IN (1, 9); 

COMMIT;

SELECT gn, seq, lpad(' ', (LEVEL - 1) * 4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;

-----------------------------------���� ���� ������ ������ ���� �׽�Ʈ.

CREATE TABLE ordertest(
    order_test number,
    name_test varchar2(10)
    );

insert into ordertest values (1, 'a');
insert into ordertest values (1, 'b');
insert into ordertest values (2, 'a');
insert into ordertest values (2, 'b');
insert into ordertest values (3, 'a');
insert into ordertest values (1, 'd');
insert into ordertest values (4, 'b');
insert into ordertest values (5, 'a');
insert into ordertest values (1, 'c');
insert into ordertest values (2, 'c');
insert into ordertest values (5, 'b');

select *
from ordertest;

select * from ordertest
order by order_test;

drop table ordertest;


SELECT *
FROM emp
ORDER BY deptno DESC, empno ASC;

SELECT ename
FROM emp
WHERE sal = (select max(sal)
             from emp);
             
----------------------------------------------------------------------             
SELECT *
FROM
    (SELECT ename, sal, deptno, ROWNUM rn             
     FROM emp
     WHERE deptno = 10
     ORDER BY sal DESC)

UNION ALL

SELECT *
FROM
    (SELECT ename, sal, deptno, ROWNUM rn             
     FROM emp
     WHERE deptno = 20
     ORDER BY sal DESC)

UNION ALL

SELECT *
FROM
    (SELECT ename, sal, deptno, ROWNUM rn             
     FROM emp
     WHERE deptno = 30
     ORDER BY sal DESC);

-----------------------------------------------------------------------
select dd.ename, dd.sal, dd.deptno, lv
from
(SELECT ROWNUM rn, ename, sal, deptno
FROM
(SELECT ename, sal, deptno
FROM EMP
order by deptno, sal desc) d)dd ,


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


select *
from emp;