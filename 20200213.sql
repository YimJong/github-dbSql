-- SYNONYM : 동의어
-- 1. 객체 별칭을 부여
-- → 이름을 간단하게 표현

-- YimJ 사용자가 자신의 테이블 emp테이블을 사용해서 만든 v_emp view
-- hr 사용자가 사용할 수 있게 끔 권한을 부여

-- v_emp : 민감한 정보 sal, comm을 제외한 view

-- hr 사용자 v_emp를 사용하기 위해 다음과 같이 작성

SELECT *
FROM YimJ.v_emp; -- 스키마를 사용하여 어떤 사용자의 것인지 작성해야 함

-- hr 계정에서 synonym YimJ.v_emp → v_emp
-- v_emp == YimJ.v_emp

SELECT *
FROM v_emp; -- 다른 계정에서 나한테 없는 것이 왔을 때 synonym을 생각해 볼 수 있음.

-- 1. YimJ 계정에서 v_emp를 hr 계정에서 조회할 수 있도록 조회권한 부여
-- 조회 권한 부여 방법
GRANT SELECT ON v_emp TO hr;

-- 2. hr 계정 v.emp 조회하는게 가능 (권한 1번에서 받았기 때문에)
-- 사용시 해당 객체의 소유자를 명시 : YimJ.v_emp
-- 귀찮기 때문에 간단하게 YimJ.v_emp → v_emp 사용하고 싶은 상황

-- synontym 생성방법 (hr 계정에서..)
-- CREATE SYNONYM 동의어이름 FOR 원 객체명;

-- SYNONYM 삭제
-- DROP SYNONYM 동의어 이름;


-- data dictionary : 사용자가 관리하지 않고, dbms가 자체적으로 관리하는 시스템 정보를 담은 view
-- data dictionary 접두어
-- 1. USER : 해당  사용자가 소유한 객체
-- 2. ALL : 해당 사용자가 소유한 객체 + 다른 사용자로 부터 권한을 부여받은 객체
-- 3. DBA : 모든 사용자의 객체

-- V$ 특수 VIEW


SELECT *
FROM USER_TABLES;  -- 'USER' = 접두어

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES;

-- DICTIONARY 종류 확인 : SYS.DICTIONARY;

SELECT *
FROM DICTIONARY;

SELECT *
FROM USER_OBJECTS;

-- 대표적인 DICTIONARY
-- OBJECTS : 객체 정보 조회(테이블, 인덱스, VIEW, SYNONYM...)
-- TABLES : 테이블 정보만 조회
-- TAB_COLUMNS : 테이블의 컬럼 정보 조회
-- INDEXES : 인덱스 정보 조회
-- IND_COLUMNS : 인덱스 구성 컬럼 조회
-- CONSTRAINTS : 제약 조건 조회
-- CONS_COLUMN : 제약조건 구성 컬럼 정보 조회
-- TAB_COMMENTS : 테이블 주석
-- COL_COMMENTS : 테이블의 컬럼 주석

-- emp, dept 테이블의 인덱스와 인덱스 컬럼 정보 조회
-- user_indexes, user_ind_columns join
-- 테이블명, 인덱스명, 컬럼명, 컬럼 순서
-- emp  ind_n_emp_04 ename
-- emp  ind_n_emp_04 job
SELECT *
FROM user_indexes;

SELECT *
FROM user_ind_columns;

SELECT idx.table_name, idx.table_name, col.column_name, col.column_position
FROM user_indexes idx, user_ind_columns col
WHERE idx.index_name = col.index_name;

SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;

DROP TABLE dept_test2;
CREATE TABLE dept_test2(
    deptno VARCHAR2(2),
    dname VARCHAR2(10),
    loc VARCHAR2(20)
    );
    
INSERT INTO dept_test2 VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept_test2 VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dept_test2 VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept_test2 VALUES (40, 'OPERATIONS', 'BOSTON');
COMMIT;

DELETE dept_test2
WHERE deptno = 40;

SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;


    
-- 동일한 값을 여러 테이블에 동시 입력하는 multiple insert;
INSERT ALL
    INTO dept_test
    INTO dept_test2;
    
-- 테이블에 입력한 컬럼을 지정하여 multiple insert;
ROLLBACK;
INSERT ALL
    INTO dept_test (deptno, loc) VALUES (deptno, loc)
    INTO dept_test2
SELECT 98 deptno, '대덕' dname, '중앙로' loc FROM dual UNION ALL
SELECT 97,'IT', '영민' FROM dual;


-- 테이블에 입력할 데이터를 조건에 따라 multiple insert;
 CASE
     WHEN 조건 기술 THEN
 END;


ROLLBACK;
INSERT ALL
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES (deptno, loc)
        INTO dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno, '대덕' dname, '중앙로' loc FROM dual UNION ALL
SELECT 97,'IT', '영민' FROM dual;

SELECT *
FROM dept_test;

SELECT *
FROM dept_test2;


-- 조건을 만족하는 첫번째 insert만 실행하는 multiple insert

ROLLBACK;
INSERT FIRST -- 조건을 만족하는 첫번째 WHEN에만 적용.
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES (deptno, loc)
    WHEN deptno >= 97 THEN
        INTO dept_test2
    ELSE
        INTO dept_test2   
SELECT 98 deptno, '대덕' dname, '중앙로' loc FROM dual UNION ALL
SELECT 97,'IT', '영민' FROM dual;

-- 오라클 객체 : 테이블에 여러개의 구역을 파티션으로 구분
-- 테이블 이름은 동일하나 값의 종류에 따라 오라클 내부적으로 별도의 분리된 영역에 데이터를 저장.
-- ex: dept_test → dept_test_20200201



-- MERGE 통합
-- 테이블에 데이터를 입력/갱신 하려고 함
-- 1. 내가 입력하려고 하는 데이터가 존재하면 → 업데이트
-- 2. 내가 입력하려고 하는 데이터가 존재하지 않으면 → INSERT

--1. SELECT 실행
--2-1. SELECT 실행 결과가 0 ROW이면 INSERT
--2-2. SELECT 실행 결과가 1 ROW이면 UPDATE

--MERGE 구문을 사용하게 되면 SELECT를 하지 않아도 자동으로 데이터 유무에 따라 INSERT 또는 UPDATE를 실행한다.
--2번의 SELECT 쿼리 조회를 한번으로 줄인다.

--MERGE INTO 테이블명[alias]
--USING (TABLE | VIEW | IN-LINE-VIEW)
--ON (조인 조건)
--WHEN MATCHED THEN -- 만약 조인조건에 만족하는 값이 있다면
--    UPDATE SET col1 = 컬럼값, col2 = 컬럼값....
--WHEN NOT MATCHED THEN
--    INSERT (컬럼1, 컬럼2....) VALUES (컬럼값1, 컬럼값2....);

SELECT *
FROM emp_test;

DELETE emp_test;
TRUNCATE TABLE emp_test; -- LOG를 남기지 않음. 복구가 안됨. 테스트용으로 이용.

emp테이블에서 emp_test테이블로 데이터를 복사(7369 - SMITH);

SELECT *
FROM emp_test;

ALTER TABLE emp_test DROP CONSTRAINTS PK_EMP_TEST;

INSERT INTO emp_test
SELECT empno, ename, deptno, '010'
FROM emp
WHERE empno = 7369;

UPDATE emp_test SET ename = 'brown'
WHERE empno = 7369;

COMMIT;

emp테이블의 모든 직원을 emp_test테이블로 통합
emp테이블에는 존재하지만 emp_test에는 존재하지 않으면 insert
emp테이블에는 존재하고 emp_test에도 존재하면 ename, deptno를 업데이트

emp테이블에 존재하는 14건의 데이터 중 emp_test에도 존재하는 7369를 제외한 13건의 데이터가
emp_test 테이블에 신규로 입력이 되고
emp_test에 존재하는 7369번 데이터는 ename(brown)이 emp테이블에 존재하는 이름인 SMITH로 갱신.;

MERGE INTO emp_test a
USING emp b
ON (a.empno = b.empno)
WHEN MATCHED THEN
    UPDATE set a.ename = b.ename, 
               a.deptno = b.deptno
WHEN NOT MATCHED THEN
    INSERT (empno, ename, deptno) VALUES (b.empno, b.ename, b.deptno);
    
    
해당 테이블에 데이터가 있으면 INSERT, 없으면 UPDATE
emp_test테이블에 사번이 9999번인 사람이 없으면 새롭게 INSERT
있으면 UPDATE
INSERT INTO dept_test VALUES (9999, 'brown', 10, '010')
UPDATE dept_test SET ename = 'brown'
                     deptno = 10
                     hp = '010'
WHERE empno = 9999;

MERGE INTO emp_test
USING dual
ON (empno = 9999)
WHEN MATCHED THEN
    UPDATE SET ename = ename || '_u',
               deptno = 10,
               hp = '010'
WHEN NOT MATCHED THEN
    INSERT VALUES (9999, 'brown', 10, '010');
    
SELECT *
FROM emp_test;

ALTER TABLE emp_test MODIFY (hp default '010');


-- 부서별 합계, 전체 합계를 다음과 같이 구하면??

SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno

UNION ALL

SELECT NULL, SUM(sal) sal
FROM emp
ORDER BY deptno;



SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);
ORDER BY deptno;


--REPORT GROUP FUNCTION
--ROLLUP
--CUBE
--GROUPING

ROLLUP
사용방법 : GROUP BY ROLLUP (컬럼1, 컬럼2.....)
SUBGROUP을 자동적으로 생성
SUBGROUP을 생성하는 규칙 : ROLLUP에 기술한 컬럼을 오른쪽에서 부터 하나씩 제거하면서 SUB GROUP을 생성.

EX : GROUP BY ROLLUP (deptno)
→
첫번째 sub group : GROUP BY deptno
두번째 sub group : GROUP BY NULL → 전체 행을 대상.

GROUP_AD1을 GROUP BY ROLLUP 절을 사용하여 작성.;
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno);

SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

GROUP BY job, deptno : 담당업무, 부서별 급여합
GROUP BY job : 담당업무별 급여합
GROUP BY : 전체 급여합;


SELECT GROUPING(job) job, GROUPING(deptno) deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);



SELECT CASE WHEN GROUPING(job) = 1 THEN '총계' 
       ELSE job END AS job,
       deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


SELECT DECODE(GROUPING(job), 1, '총계', job) as job,
       deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);  


SELECT CASE WHEN GROUPING(job) = 1 THEN '총' ELSE job END as job,
       CASE WHEN GROUPING(TO_CHAR(deptno)) = 1 THEN 
                        CASE WHEN GROUPING(job) = 1 THEN '계' ELSE '소계' END
       ELSE TO_CHAR(deptno) END as deptno,
       SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, TO_CHAR(deptno));





