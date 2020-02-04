-- CROSS JOIN → 카티션 프로덕트 (Cartesian product)
-- 조인하는 두 테이블의 연결 조건이 누락되는 경우 가능한 모든 조합에 대해 연결(조인)이 시도
-- dept(4건), emp(14건)의 CROSS JOIN의 결과는 4*14 = 56건

-- dept 테이블과 emp 테이블을 조인을 하기 위해 FROM 절에 두개의 테이블을 기술
-- WHERE절에 두 테이블의 연결 조건을 누락
-- 모든 경우의 수 출력

-- 테이블 간 적용하는 경우보다 데이터 복제를 위해 사용.

SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp;

-- crossjoin 1
SELECT customer.cid, customer.cnm, product.pid, product.pnm
FROM customer, product;


-- SUBQUERY : 쿼리 안에 다른 쿼리가 들어가 있는 경우
-- SUBQUERY가 사용된 위치에 따라 3가지로 분류 
-- SELECT 절 : SCALAR SUBQUERY : 하나의 행, 하나의 컬럼만 리턴해야 에러가 발생하지 않음.
-- FROM 절 : INLINE-VIEW
-- WHERE 절 : SUBQUERY 

-- 구하고자 하는 것
-- SMITH가 속한 부서에 속하는 직원들의 정보를 조회

-- 1.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

-- 2.
SELECT *
FROM emp
WHERE deptno = 20;

-- SUBQUERY를 이용하면 두개의 쿼리를 동시에 하나의 SQL로 실행이 가능.
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
-- SUB1 : 평균 급여보다 높은 급여를 받는 직원의 수
-- 1. 평균 급여 구하기
-- 2. 구한 평균 급여보다 높은 급여를 받는 사람
SELECT count(*)
FROM emp
WHERE sal >(SELECT avg(sal)
            FROM emp);
            
-- SUB2
SELECT *
FROM emp
WHERE sal >(SELECT avg(sal)
            FROM emp);

-- 다중행 연산자
-- IN : 서브쿼리의 여러행 중 일치하는 값이 존재 할 때
-- ANY (활용도는 다소 떨어짐) : 서브쿼리의 여러행 중 한 행이라도 조건을 만족할 때
-- ALL (활용도는 다소 떨어짐) : 서브쿼리의 여러행 중 모든 행에 대해 조건을 만족할 때

-- SUB3
-- SMITH 와 WARD 직원이 속하는 부서의 모든 직원 정보를 조회.
-- 서브쿼리의 결과가 여러행일때는 '=' 연산자 사용 불가능.
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename in ('SMITH', 'WARD'));
                 
-- SMITH, WARD 사원의 급여보다 급여가 작은 직원을 조회.
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename in ('SMITH', 'WARD'));
                
-- SMITH, WARD보다 급여가 큰 직원의 정보     
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename in ('SMITH', 'WARD'));

-- IN, NOT IN의 NULL과 관련된 유의 사항

-- 직원의 관리자 사번이 7902 이거나 NULL
-- IN 연산자는 OR 연산자로 치환가능
-- NULL 비교는 '=' 연산자가 아니라 IS NULL로 비교 해야지하지만 IN 연산자는 '='로 계산한다.
SELECT *
FROM emp
WHERE mgr = 7902 OR mgr IS NULL;

-- NOT IN 연산자 안에 NULL이 있으면 데이터가 나오지 않음. NULL의 연산값은 항상 NULL이기 때문.
-- 전체가 NULL인 것처럼 연산함.
SELECT *
FROM emp
WHERE empno NOT IN (7902, NULL);

SELECT *
FROM emp
WHERE empno != 7902
AND empno IS NOT NULL;

-- multi column subquery (pairwise)
-- 순서쌍의 결과를 동시에 만족 시킬때
-- (7698, 30) (7839, 10)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));

SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

-- non-pairwise는 순서쌍을 동시에 만족시키지 않는 형태로 작성
-- mgr 값이 7698이거나 7839 이면서
-- deptno가 10이거나 30번인 직원
-- mgr, deptno
-- (7698, 10), (7698, 30)
-- (7839, 10), (7839, 10);
SELECT *
FROM emp
WHERE mgr IN ( SELECT mgr
               FROM emp
               WHERE empno IN (7499, 7782))
AND deptno IN ( SELECT denpno
                FROM emp
                WHERE empno IN (7499, 7782));
                
-- 스칼라 서브쿼리 : SELECT 절에 기술, 1개의 ROW, 1개의 COL을 조회하는 쿼리
-- 스칼라 서브쿼리는 MAIN 쿼리의 컬럼을 사용하는게 가능하다.

SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;

SELECT empno, ename, deptno,
       (SELECT dname FROM dept WHERE deptno = emp.deptno) AS dname
FROM emp;

-- INLINE VIEW : FROM절에 기술되는 서브쿼리;

-- MAIN 쿼리의 컬럼을 SUBQUERY에서 사용 하는지 유무에 따른 분류
-- 사용 할 경우 : correlated subquery (상호 연관 쿼리), 서브쿼리만 단독으로 실행하는게 불가능.
--              실행 순서가 정해져 있다. (main → sub)
-- 사용 안 할 경우 : non-correlated subquery(비상호 연관 서브쿼리), 서브쿼리만 단독으로 실행 가능.
--              실행 순서가 정해져 있지 않다. (main → sub, sub → main)

-- 모든 직원의 급여 평균보다 급여가 높은 사람을 조회
SELECT *
FROM emp
WHERE sal > (SELECT avg(sal)
             FROM emp);             
             
-- 직원이 속한 부서의 급여 평균보다 급여가 높은 사람을 조회
SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
             FROM emp s
             WHERE s.deptno = m.deptno);
             
-- 위의 문제를 조인을 이용해서 풀어보자
-- 1. 조인 테이블 선정
--  emp, 부서별 급여 평균(inline view)
SELECT emp.ename, emp.sal, emp.deptno, dept_sal.*
FROM emp, (SELECT deptno, round(avg(sal)) avg_sal
           FROM emp
           GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;

-- SUB4
-- 데이터 추가
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
ROLLBACK; -- 트랜잭션 취소, 커밋을 한번 했으면 다시 돌아가지 않음.
COMMIT; -- 데이터를 추가, 변경, 삭제 시 필요. 트랜잭션 확정

SELECT *
FROM dept;

SELECT deptno, dname, loc
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);