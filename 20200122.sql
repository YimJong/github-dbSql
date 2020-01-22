-- 1번 문제
SELECT * 
FROM lprod;

-- 2번 문제
SELECT buyer_id, buyer_name
FROM buyer;

-- 3번 문제
SELECT *
FROM cart;

-- 4번 문제
SELECT mem_id, mem_pass, mem_name
FROM member;

-- users 테이블 조회
SELECT *
FROM users;

-- 테이블에 어떤 컬럼이 있는지 확인하는 방법
-- 1. SELECT *
-- 2. TOOL의 기능 (사용자-TABLE)
-- 3. DESC 테이블명 (DESC-DESCRIBE)

DESC users;

SELECT *
FROM users;

-- users 테이블에서 userid, usernm, reg_dt 컬럼만 조회하는 sql을 작성하세요.
-- 날짜 연산 (reg_dt 컬럼은 date정보를 담을 수 있는 타입)
-- SQL 날짜 컬럼 + (더하기 연산)
-- 수학적인 사칙연산이 아닌 것들
-- SQL에서 정의된 날짜 연산 : 날짜 + 정수 = 날짜에서 정수를 일자로 취급하여 더한다.
-- null : 값을 모르는 상태
-- null에 대한 연산 결과는 항상 null

SELECT userid as u_id, usernm, reg_dt, reg_dt + 5 as reg_dt_after_5day
FROM users;

--1번 문제
SELECT prod_id as id, prod_name as name
FROM prod;

--2번 문제
SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;

--3번 문제
SELECT buyer_id as 바이어아이디, buyer_name as 이름
FROM buyer;

--문자열 결합
-- 자바 언어에서 문자열 결합 : + ("Hello" + "world!")
-- SQL에서는 : || ('Hello' || 'world')
-- SQL에서는 : concat('Hello', 'world')

--userid, usernm 컬럼을 결합, 별칭 id_name
SELECT concat(userid, usernm) as id_name
FROM users;

-- SQL에서의 변수는 없음(컬럼이 비슷한 역할), PL/SQL에서는 변수 개념이 존재
-- SQL에서 문자열 상수는 싱클 쿼테이션으로 표현
-- "Hello, World" --> 'Hello, World'

-- 문자열 상수와 칼럼간의 결합
-- user id : brown
-- user id : cony
SELECT 'user id : ' || userid 
FROM users;

SELECT 'user id : ' || userid as userid
From users;

SELECT 'SELECT * FROM ' || table_name|| ';' as QUERY
FROM user_tables;

SELECT concat('SELECT * FOROM ', table_name)||';' as QUERY
FROM user_tables;

SELECT concat(concat('SELECT * FROM ', table_name),';') as QUERY
FROM user_tables;

-- if( a == 5 ) (a의 값이 5인지 비교)
-- SQL에서는 대입의 개념이 없음.
-- SQL '=' : equal 

-- Where 절 : 테이블에서 데이터를 조회할 때 조건에 맞는 행만 조회
-- ex : userid 컬럼의 값이 brown인 행만 조회
-- brown, 'brown' 구분
-- 컬럼, 문자열 상수
SELECT *
FROM users
WHERE userid = 'brown'; 

--userid가 brown이 아닌 행만 조회
SELECT *
FROM users
WHERE userid <> 'brown';

-- emp 테이블에 존재하는 컬럼을 확인 해보세요
DESC emp;  --교육 목적으로 만들어진 테이블
SELECT *
FROM emp;

-- emp 테이블에서 ename 컬럼 값이 JONES인 행만 조회
-- SQL KEY WORD는 대소문자를 가리지 않지만 컬럼의 값이나, 문자열 상수는 대소문자를 가림.
-- 'JONES','Jones'는 값이 다른 상수
SELECT *
FROM emp
WHERE ename = 'JONES';

-- emp테이블에서 deptno(부서번호)가 30보다 크거나 같은 사원들만 조회
SELECT *
FROM emp
WHERE deptno >= 30;

-- 문자열 : '문자열'
-- 숫자 : 50
-- 날짜 : 함수와 문자열을 결합하여 표현. 문자열만 이용하여 표현 가능(권장하지 않음.
--       국가별로 날짜 표기방법
--       한국 : YYYY-MM-DD
--       미국 : MM-DD-YYYY


SELECT *
FROM emp
WHERE hiredate = '80/12/17';
-- TO_DATE : 문자열을 date 타입으로 변경하는 함수
-- TO_DATE(날짜형식 문자열, 첫번째 인자의 형식)

SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217','YYYYMMDD');

-- 범위연산
-- sal 컬럼의 값이 1000에서 2000 사이인 사람
SELECT *
FROM emp
WHERE sal >= 1000 and sal <= 2000;

-- 범위연산자를 부등호 대신에 BETWEEN AND 연산자로 대체
SELECT *
FROM emp
WHERE sal between 1000 and 2000;


--문제 1
SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE('19820101', 'YYYYMMDD') and TO_DATE('19830101', 'YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate between '1982-01-01' and '1983-01-01';