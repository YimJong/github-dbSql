-- SUB4
-- dept 테이블에는 5건의 데이터가 존재
-- emp 테이블에는 14명의 직원이 있고, 직원은 하나의 부서 속에 있다.(deptno)
-- 부서 중 직원이 속해 있지 않은 부서 정보를 조회

-- 서브쿼리에서 데이터의 조건이 맞는지 확인자 역할을 하는 서브쿼리 작성.

SELECT *
FROM dept;

SELECT deptno
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);
 
-- SUB5
-- 1. 1번 고객이 애음하는 제품 조회 (pid)
-- 2. pid, pnm 조회 시 1.에서 조회 한 것을 제외해서 애음하지 않는 제품 정보 조회.
SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);
-- SUB6
-- 1. 고객번호가 2번인 고객의 애음제품을 먼저 조회
-- 2. 고객번호가 1번인 고객의 애음제품 조건과 1.에서 조회한 2번 고객의 애음제품을 조건에 추가하여 조회.
SELECT *
FROM cycle
WHERE cid = 1 AND pid IN (SELECT pid
                          FROM cycle
                          WHERE cid = 2);
                          
-- SUB7
SELECT a.cid, customer.cnm, a.pid, product.pnm, a.day, a.cnt
FROM
(SELECT *
 FROM cycle
 WHERE cid = 1 AND pid IN (SELECT pid
                          FROM cycle
                          WHERE cid = 2)) a, customer, product
where a.cid = customer.cid
AND a.pid = product.pid;


-- 크로스 조인 후 조건을 주는 방법?
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN ( SELECT pid
                   FROM cycle
                   WHERE cid = 2)
AND customer.cid = cycle.cid
AND product.pid = cycle.pid;
                                                 
                                              
-- 매니저가 존재하는 직원을 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- EXSITS 조건에 만족하는 행이 존재 하는 지 확인하는 연산자.
-- 다른 연산자와 다르게 WHERE 절에 컬럼을 기술하지 않는다.
-- WHERE empno = 7369
-- WHERE EXISTS (SELECT 'X'
--               FROM .......)

-- 매니저가 존재하는 직원을 EXISTS 연산자를 통해 조회
-- 매니저도 직원
SELECT empno, ename, mgr
FROM emp e  -- 서브쿼리에서도 emp를 써야 하기 때문에 alias 부여
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);
              
              
 -- SUB 9
SELECT *
FROM product;
 
SELECT pid
FROM cycle e 
WHERE EXISTS (SELECT 'X'
              FROM cycle 
              WHERE e.cid  = 1);


SELECT p.pid, p.pnm
FROM product p JOIN (SELECT c.pid
                     FROM cycle c
                     WHERE EXISTS (SELECT 'X'
                                   FROM cycle e
                                   WHERE c.cid = 1)) a ON (p.pid = a.pid)
GROUP BY p.pid, p.pnm;


-- 비상호?
SELECT *
FROM product
WHERE EXISTS (SELECT 'X'
              FROM cycle
              WHERE cid = 1
              AND cycle.pid = product.pid);


-- SUB10
SELECT *                -- 존재하지 않는 데이터만 조회.
FROM product
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle
                  WHERE cid = 1
                  AND cycle.pid = product.pid);
                  
-- 집합연산
-- 합집합 : UNION - 중복제거(집합개념) / UNION ALL - 중복을 제거하지 않음(속도 향상)
-- 교집합 : INTERSECT (집합개념)
-- 차집합 : MINUS (집합개념)
-- 집합연산의 공통사항
-- 두 집합의 컬럼의 개수, 타입이 일치 해야 한다.

-- 동일한 데이터는 한번만 조회된다.
SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698);

              
-- UNION ALL 연산자는 중복을 허용한다.              
SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698);


-- INTERSECT (교집합) : 위, 아래 집합에서 값이 같은 행만 조회
SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698); 
              
              
-- MINUS (차집합) : 위 집합에서 아래 집합의 데이터를 제거한 나머지 집합.
SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno in (7566, 7698); 

-- 집합의 기술 순서가 영향이 가는 집합 연산자.
-- A UNION B        B UNION A  → 같음
-- A UNION ALL B    B UNION ALL A → 같음
-- A INTERSECT B    B INTERSECT A → 같음
-- A MINUS B        B MINUS A → 다름

-- 집합 연산의 결과 컬럼 이름은 첫번째 집합의 컬럼명을 따른다.
SELECT 'X' fir, 'B' sec
FROM dual

UNION

SELECT 'Y', 'A'
FROM dual;

-- 정렬(ORDER BY)는 집합연산 가장 마지막 집합 다음에 기술
SELECT deptno, dname, loc
FROM (SELECT deptno, dname, loc
      FROM dept
      WHERE deptno IN (10, 20)
      ORDER BY deptno)

UNION

SELECT *
FROM dept
WHERE deptno IN (30, 40);


-- 햄버거 도시 발전 지수

SELECT *
FROM fastfood;

-- 시도, 시군구, 버거지수
SELECT a.sido, a.sigungu, round(a.ct/b.ct, 1) as burger
FROM 
    (SELECT sido, sigungu, count(*) ct
     FROM fastfood
     WHERE gb IN ('KFC', '맥도날드', '버거킹')
     GROUP BY sido, sigungu) a,
    (SELECT sido, sigungu, count(*) ct
     FROM fastfood
     WHERE gb = '롯데리아'
     GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY burger DESC;

