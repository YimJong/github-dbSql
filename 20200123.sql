--WHERE 2

-- emp 테이블에서 입사 날자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전의 사원의 ename, hiredate 데이터를 조회하는 쿼리 작성.
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982-01-01', 'YYYY-MM-DD') and hiredate <= TO_DATE('1983-01-01', 'YYYY-MM-DD'); 

-- where 절에 기술하는 조건에 순서는 조회 결과에 영향을 미치지 않는다.
-- SQL은 집합의 개념을 갖고 있다.
-- 집합의 특징 : 집합에는 순서가 없다.
-- 테이블에는 순서가 보장되지 않음.
-- SELECT 결과가 순서가 다르더라도 값이 동일하면 정답으로 간주.
  --> 해결을 위하여 정렬기능 제공(ORDER BY)

-- IN 연산자
-- 특정 집합에 포함되는지 여부를 확인
-- 부서번호가 10번 혹은(or) 20번에 속하는 직원 조회
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10 or deptno = 20;

SELECT empno, ename, deptno
FROM emp
WHERE deptno in(10, 20);

-- emp테이블에서 사원 이름이 SMITH, JONES인 직원만 조회 (empno, ename, deptno)
SELECT empno, ename, deptno
FROM emp
WHERE ename in('SMITH', 'JONES');

DESC users;

SELECT userid as 아이디, usernm as 이름, alias as 별명
FROM users
WHERE userid in('brown', 'cony', 'sally');

-- 문자열 매칭 연산자 : LIKE, %, _
-- 위에서 연습한 조건은 문자열 일치에 대하여 다룸
-- 이름이 BR로 시작하는 사람만 조회
-- 이름에 R 문자열이 들어가는 사람만 조회

-- 사원 이름이 S로 시작하는 사원 조회
-- % 어떤 문자열(한글자, 글자 없을수도 있고, 여러 문자열이 올 수도 있다.)
SELECT *
FROM emp
WHERE ename LIKE 'S%';

-- 글자수를 제한한 패턴 매칭
-- '_' 정확히 한 문자를 뜻함
-- 직원 이름이 S로 시작하고 이름의 전체 길이가 5글자인 직원
SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- 사원 이름에 S글자가 들어가는 사원 조회
SELECT *
FROM emp
WHERE ename LIKE '%S%';

--member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리 작성.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

-- where5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

-- null 비교 연사 (IS)
SELECT *
FROM emp
WHERE comm IS null;

-- where6
SELECT *
FROM emp
WHERE comm IS NOT null;

-- 사원의 관리자가 7698, 7839 그리고 null이 아닌 직원만 조회
-- NOT IN 연산자에서는 NULL 값을 포함 시키면 안된다.
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839) AND mgr IS NOT NULL;

-- WHERE 7
SELECT *
FROM emp
WHERE job = 'SALESMAN' and hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 8
SELECT *
FROM emp
WHERE deptno <> 10 and hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 9
SELECT *
FROM emp
WHERE deptno not in(10) and hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 10
SELECT *
FROM emp
WHERE deptno in(20, 30) and hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 11
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 12
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

-- WHERE 13
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899;

-- 연산자 우선순위
-- *, / 연산자가 +, - 보다 우선순위가 높다.
-- 우선순위 변경 : ()
-- AND > OR

--emp 테이블에서 사원이름이 SMITH 이거나 사원 이름이 ALLEN 이면서 담당업무가 SALESMAN인 사원 조회
SELECT *
FROM emp
WHERE ename = 'SMITH' OR (ename = 'ALLEN' and JOB = 'SALESMAN');

-- 사원 이름이 SMITH 이거나 ALLEN 이면서 담당 업무가 SALESMAN인 사원 조회
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') AND JOB = 'SALESMAN';

-- WHERE 14
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%' AND hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- 정렬
-- SELSECT *
-- FROM table
-- [WHERE]
-- ORDER BY (컬럼|별칭|컬럼인덱스 [ASC | DESC], ....)

-- emp 테이블의 모든 사원을 ename 컬럼 값을 기준으로 오름차순 정렬한 결과를 조회
SELECT *
FROM emp
ORDER BY ename ASC;

-- emp 테이블의 모든 사원을 ename 컬럼 값을 기준으로 내림차순 정렬한 결과를 조회
SELECT *
FROM emp
ORDER BY ename DESC; -- DECENDING,  DESC emp; -- DESCRIBE 

-- emp 테이블에서 사원 정보를 ename 컬럼으로 내림차순, ename 값이 같을 결우 mgr 컬럼으로 오름차순으로 정렬하는 쿼리 작성.
SELECT *
FROM emp
ORDER BY ename DESC, mgr ASC;

SELECT empno, ename as nm
FROM emp
ORDER BY nm ASC;

-- 별칭으로 정렬
SELECT empno, ename as nm, sal * 12 as year_sal
FROM emp
ORDER BY year_sal ASC;

-- 컬럼 인덱스로 정렬
-- Java는 배열이 0부터 시작함.
SELECT empno, ename as nm, sal * 12 as year_sal -- 차례대로 1, 2, 3 컬럼 인덱스[배열], 1부터 시작함.
FROM emp
ORDER BY 3;

-- ORDER BY 1
SELECT *
FROM dept
ORDER BY dname  ASC;

SELECT *
FROM dept
ORDER BY loc DESC;

-- ORDER BY 2
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm <> 0
ORDER BY comm DESC, empno ASC;

-- ORDER BY3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job ASC, empno DESC;