SELECT *
FROM emp
WHERE deptno in(10, 30) and sal > 1500
ORDER BY ename DESC;

-- ROWNUM : 행번호를 나타내는 컬럼(페이징 처리, 정렬 응용 SQL에서 사용)
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno in(10, 30) and sal > 1500;

-- ROWNUM을 WHERE절에서도 사용 가능.
-- 동작하는가? = ('ROWNUM = 1', 'ROWNUM <= 2'은 되고,  =>  ROWNUM <= N
--              'ROWNUM = 2', 'ROWNUM >= 2'는 안됨)  =>  ROWNUM >= N
-- ROWNUM은 이미 읽은 데이터에다가 순서를 부여
-- **유의점1 : 읽지 않은 상태의 값을(ROWNUM이 부여되지 않은 행)은 조회할 수가 없다.
-- **유의점2 : ORDER BY 절은 SELECT 절 이후에 실행 - ROWNUM 행이 섞여버림.
-- 페이징 처리에 사용
-- 테이블에 있는 모든 행을 조회하는 것이 아니라 우리가 원하는 페이지에 해당하는 행 데이터만 조회를 한다.
-- 페이징 처리 시 고려사항 : 1페이지 당 건수, 정렬 기준(ex : 중고나라는 등록 시간)
-- ep테이블 총 row 건수 : 14
-- 페이지 당 5건의 데이터를 조회
-- 1 page : 1~5
-- 2 page : 6~10
-- 3 page : 11~15
SELECT ROWNUM as rn, empno, ename
FROM emp
WHERE ROWNUM <= 7
ORDER BY ename;
-- 정렬된 결과에 ROWNUM을 부여하기 위해서는 IN-LINE VIEW를 사용한다.
-- 요점 정리 : 1. 정렬  2. ROWNUM 부여

-- SELECT *를 기술할 경우 다른 EXPRESSION을 표기 하기 위해서 테이블명.* 테이블명칭.* 으로 표현해야 한다.
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;

-- page size : 5, 정렬 기준 : ename
-- 1 page : 1~5
SELECT *
FROM
 (SELECT ROWNUM as rn, a.*
  FROM
    (SELECT empno, ename
     FROM emp
     ORDER BY ename) a )
WHERE rn BETWEEN 1 AND 5;
-- ROWNUM을 rn으로 별칭을 주고 감싸서 테이블로 취급했기 때문에 'ROWNUM = 2' 조건 사용 가능.

-- 2 page : 6~10
SELECT *
FROM
 (SELECT ROWNUM as rn, a.*
  FROM
    (SELECT empno, ename
     FROM emp
     ORDER BY ename) a )
WHERE rn BETWEEN 6 AND 10;

-- 3 page : 11~15
SELECT *
FROM
 (SELECT ROWNUM as rn, a.*
  FROM
    (SELECT empno, ename
     FROM emp
     ORDER BY ename) a )
WHERE rn BETWEEN 11 AND 15;

-- n page : ((n-1)*pagesize) + 1  ~  n * pagesize

-- ROWNUM 1
SELECT *
FROM
 (SELECT ROWNUM AS rn, e.*
  FROM emp e)
WHERE rn BETWEEN 1 AND 10;

-- ROWNUM 2
SELECT *
FROM
 (SELECT ROWNUM AS rn, e.*
  FROM emp e)
WHERE rn BETWEEN 11 AND 20;

-- ROWNUM 3
SELECT *
FROM
(SELECT ROWNUM AS rn, a.*
 FROM
  (SELECT empno, ename
   FROM emp
   ORDER BY ename ASC) a )
WHERE rn BETWEEN 11 AND 15;

-- Java와 연동시 변수 사용. (바인딩 변수)
SELECT *
FROM
(SELECT ROWNUM AS rn, a.*
 FROM
  (SELECT empno, ename
   FROM emp
   ORDER BY ename ASC) a )
WHERE rn BETWEEN (:page - 1) * :pageSize + 1 AND :page * :pageSize;



   
-- DUAL 테이블 : 데이터와 관계 없이, 함수를 테스트 해볼 목적으로 사용.
-- 문자열 대소문자 : LOWER, UPPER, INITCAP
SELECT LOWER('Hello, world!') AS LOWER, UPPER('Hello, world!') AS UPPER, INITCAP('Hello, world!') AS INITCAP
FROM dual;

-- 결과가 emp테이블의 건수 만큼 나옴. (Single Row Function 이므로)
SELECT LOWER(ename) AS LOWER, UPPER(ename) AS UPPER, INITCAP(ename) AS INITCAP
FROM emp;

-- 함수는 WHERE절에서도 사용 가능하다.
-- 사원 이름이 SMITH인 사원만 조회
SELECT *
FROM emp
WHERE ename = UPPER(:ename);

-- 이런 형태의 SQL문은 지양 해야함.(테이블쪽 컬럼을 가공하지 말 것.)
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;

SELECT CONCAT('Hello', ', World') as CONCAT,
       SUBSTR('Hello, World', 1, 5) as SUBSTR,
       LENGTH('Hello, World') as LENGTH,
       INSTR('Hello, World', 'o') as INSTR,
       INSTR('Hello, World', 'o', 6) as INSTR2,
       LPAD('Hello, World', 15, '*') as LPAD,
       RPAD('Hello, World', 15, '*') as RPAD,
       REPLACE('Hello, World', 'H', 'T') as REPLACE,
       TRIM('   Hello, World   ') as TRIM,  -- 공백을 제거
       TRIM('d' FROM '  Hello, World') as TRIM2  -- 공백이 아닌 소문자 d 제거(공백 x)
FROM dual;

-- 숫자 관련 함수
-- ROUND : 반올림 (10.6을 소수점 첫번째 자리에서 반올림 → 11)
-- TRUNC : 절삭(버림) (10.6을 소수점 첫번째 자리에서 반올림 → 10)
-- ROUND, TRUNC : 몇번째 자리에서 반올림 / 절삭
-- MOD : 나머지 (몫이 아니라 나누기 연산을 한 나머지 값) ( 13 / 5 → 몫 : 2, 나머지 : 3)

-- ROUND(대상 숫자, 최종 결과 자리)
SELECT ROUND(105.54, 1) as ROUND, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 함. → 두번째 자리에서 반올림함.
       ROUND(105.55, 1) as ROUND2,
       ROUND(105.55, 0) as ROUND3,  -- 반올림 결과가 정수부만 → 소수점 첫번째 자리에서 반올림.
       ROUND(105.55, -1) as ROUND4, -- 반올림 결과가 십의 자리까지 → 일의 자리에서 반올림.
       ROUND(105.55) as ROUND6 -- 최종 결과 자리 기본값 : 0
FROM dual;

-- TRUNC(대상 숫자, 최종 결과 자리)
SELECT TRUNC(105.54, 1) as TRUNC, -- 절삭의 결과가 소수점 첫번째 자리까지 나오도록 → 두번째 자리에서 절삭.
       TRUNC(105.55, 1) as TRUNC2,
       TRUNC(105.55, 0) as TRUNC3, -- 절삭의 결과가 정수부(밑의 자리)까지 나오도록 → 소수점 첫번째 자리에서 절삭.
       TRUNC(105.55, -1) as TRUNC4, -- 절삭의 결과가 10의 자리 까지 나오도록 → 일의 자리에서 절삭.
       TRUNC(105.55) as TRUNC5 -- 최종 결과 자리 기본값 : 0
FROM dual;

-- EMP테이블에서 사원의 급여(sal)을 1000으로 나눴을 때의 몫
SELECT ename, sal, TRUNC(sal/1000, 0) AS portion, MOD(sal, 1000) AS remainder -- MOD의 결과는 divisor보다 항상 작다.
FROM emp;

DESC emp;

-- 년도 2자리/월 2자리/일자 2자리  (도구 - 환경 설정 - 데이터베이스 - NLS - 수정)
SELECT ename, hiredate
FROM emp;

-- SYSDATE : 현재 오라클 서버의 시분초가 포함된 날짜 정보를 리턴하는 특수 함수.
-- 함수명(인자, 인자2)
-- date + 정수 : 일자 연산
-- 1 = 하루
-- 1시간 = 1/24

-- 숫자 표기 : 숫자
-- 문자 표기 : 싱글 쿼테이션 + 문자열 + 싱글 쿼테이션 → '문자열'
-- 날짜 표기 : TO_DATE('문자열 날짜 값', '문자열 날짜 값을 표기 형식')
--           → TO_DATE('2020-01-28', 'YYYY-MM-DD')
SELECT (SYSDATE + 1/24)
FROM dual;

--fn1
SELECT TO_DATE('2019-12-31', 'YYYY,MM,DD') AS question1,
       TO_DATE('2019-12-31', 'YYYY,MM,DD') -5 AS question2,
       SYSDATE AS question3,
       SYSDATE - 3 AS question4
FROM dual;