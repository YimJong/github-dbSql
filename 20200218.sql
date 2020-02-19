상향식 계층 쿼리 (LEAF → ROOT NODE(상위 NODE)
전체 노드를 방문하는게 아니라 자신의 부모노드만 방문 (하향식과 다른점);
시작점 : 디자인팀
연결은 : 상위부서

SELECT *
FROM dept_h;

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL - 1) * 4) || deptnm deptnm
FROM dept_h
START WITH deptnm = '디자인팀'
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
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;


-- 계층형 쿼리의 행 제한 조건 기술 위치에 따른 결과 비교 (PRUNING BRANCH - 가지치기);
--FROM → START WITH, CONNECT BY → WHERE
--1. WHERE : 계층 연결을 하고 나서 행을 제한
--2. CONNECT BY : 계층 연결을 하는 과정에서 행을 제한

--WHERE 절 기술 전 : 총 9개의 행이 조회되는 것 확인
--WHERE 절 (org_cd != '정보기획부') : 정보기획부를 제외한 8개 행 조회;

SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp
FROM no_emp
WHERE org_cd != '정보기획부'
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;



-- CONNECT BY 절에 조건을 기술.
SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd AND org_cd != '정보기획부';


-- CONNECT_BY_ROOT(컬럼) : 해당 컬럼의 최상위 행의 값을 가져옴.
SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- SYS_CONNEFCT_BY_PATH : 해당 행의 컬럼이 거쳐온 컬럼 값을 추천, 구분자로 이어준다.
SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- CONNECT_BY_ISLEAF  : 해당 행이 LEAF 노드인지 (연결된 자식이 없는지) 값을 리턴 ( 1: LEAF,  0 : NO LEAF )
SELECT lpad(' ', (LEVEL - 1) * 4) || org_cd AS org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path,
       CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;


-- h_6
SELECT *
FROM board_test;

DESC board_test;

-- ! 루트가 여러개임.
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

-- 네이버 같은 순서로 게시글 정렬 (UPDATE로 컬럼 추가)
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

-----------------------------------값이 같고 조건이 없을때 정렬 테스트.

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