-- 제약 조건 확인 방법
-- 1. tool
-- 2. dictionary view
-- 제약조건 : USER_CONSTRAINTS
-- 제약조건 - 컬럼 : USER_CONS_COLUMNS

-- FK 제약을 생성하기 위해서는 참조하는 테이블 컬럼에 인덱스가 존재해야 한다.

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');

ALTER TABLE emp ADD CONSTRAINTS PK_emp_empno PRIMARY KEY (empno);
ALTER TABLE emp ADD CONSTRAINTS FK_emp_deptno FOREIGN KEY (deptno) REFERENCES dept (deptno);

ALTER TABLE dept ADD CONSTRAINTS PK_dept_dpetno PRIMARY KEY (deptno);

-- 테이블, 컬럼 주석 : DICTIONARY 확인 가능
-- 테이블 주석 : USER_TAB_COMMENTS
-- 컬럼 주석 : UJSER_COL_COMMENTS

-- 주석 생성
-- 테이블주석 : COMMENT ON TABLE 테이블명 IS '주석'
-- 컬럼 주석 : COMMENT ON COLUMN 테이블.컬럼 IS '주석'

-- emp : 직원
-- dept : 부서

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');

COMMENT ON TABLE emp IS '직원';
COMMENT ON TABLE dept IS '부서';

COMMENT ON COLUMN dept.deptno IS '부서번호';
COMMENT ON COLUMN dept.dname IS '부서명';
COMMENT ON COLUMN dept.loc IS '부서위치';

COMMENT ON COLUMN emp.empno IS '직원번호';
COMMENT ON COLUMN emp.ename IS '직원이름';
COMMENT ON COLUMN emp.job IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '매니저 직원번호';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '성과급';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';

SELECT * 
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');

-- comment1
SELECT T.table_name, T.table_type, T.comments tab_comment, C.column_name, C.comments col_comment
FROM USER_COL_COMMENTS C JOIN (SELECT *
                               FROM USER_TAB_COMMENTS) T ON (C.table_name = T.table_name)
WHERE T.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

-- VIEW = QUERY
-- VIEW는 테이블이다 (x)
-- TABLE 처럼 DBMS에 미리 작성한 객체
-- → 작성하지 않고 QUERY에서 바로 작성한 VIEW : IN-LINEVIEW → 인라인 뷰는 이름이 없기 때문에 재활용이 불가

-- 사용목적
-- 1. 보안 목적(특정 컬럼을 제외하고 나머지 결과만 개발자에 제공)
-- 2. INLINE-VIEW를 VIEW로 생성하여 재활용
--   쿼리 길이 단축

-- 생성 방법
-- CREATE [OR REPLACE] VIEW 뷰명칭 [ (column, column2....) ] AS SUBQUERY

-- emp 테이블에서 8개의 컬럼 중 sal, comm 컬럼을 제외한 6개 컬럼을 제공하는 v_emp VIEW 생성.

CREATE OR REPLACE VIEW v_emp AS 
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- 시스템 계정에서 YimJ 계정으로 view 생성 권한 추가
GRANT CREATE VIEW TO YimJ;

-- 기존 인라인 뷰로 작성 시 조회
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);
      
-- VIEW 객체 활용
SELECT *
FROM v_emp;

-- emp 테이블에는 부서명이 없음 → dept 테이블과 조인을 빈번하게 진행
-- 조인된 결과를 view로 생성 해놓으면 코드를 간결하게 작성하는게 가능.

-- dname(부서명), empno(직원번호), ename(직원이름), job(담당업무), hiredate(입사일자);
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- VIEW 활용
SELECT *
FROM v_emp_dept;

-- ※ SMITH 직원 삭제 후 v_emp_dept view 건수 변화를 확인.
DELETE emp
WHERE ename = 'SMITH';
ROLLBACK;

-- VIEW는 한 시점에 고정되어 만드는 것이 아니라 쿼리이다.
-- 논리적인 데이터 정의 집합. 물리적인 데이터가 아니다.
-- VIEW가 참조하는 테이블을 수정하면 VIEW에도 영향을 미친다.

-- SEQUENCE : 시퀀스 - 중복되지 않는 정수값을 리턴해주는 오라클 객체
-- CREATE SEQUENCE 시퀀스_이름
-- [OPTION......]
-- 명명규칙 : SEQ_테이블명;

-- emp 테이블에서 사용한 시퀀스 생성

CREATE SEQUENCE seq_emp;

-- 시퀀스 제공 함수
-- NEXTVAL : 시퀀스에서 다음 값을 가져올 때 사용
-- CURRVAL : NEXTVAL를 사용하고 나서 현재 읽어 들인 값을 재확인. 내가 마지막에 사용한 시퀀스의 값을 확인할 때 사용

SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

SELECT *
FROM emp_test;

ALTER TABLE emp_test ADD (HP VARCHAR2(10));

INSERT INTO emp_test VALUES(seq_emp.NEXTVAL, 'james', 99, '017');

-- ※ 시퀀스 주의점
-- ROLLBACK을 하더라도 NEXTVAL를 통해 얻은 값은 값이 원복되진 않는다.
-- NEXTVAL를 통해 값을 받아오면 그 값을 다시 사용할 수 없다.

-- 인덱스

SELECT ROWID, emp.*
FROM emp;

-- 인덱스가 없을 때 empno 값으로 조회하는 경우
-- emp 테이블에서 pk_emp 제약조건을 삭제하여 empno 컬럼으로 인덱스가 존재하지 않는 환경을 조성

ALTER TABLE emp DROP CONSTRAINT pk_emp_empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp 테이블의 empno 컬럼으로 PK 제약을 생성하고 동일한 SQL을 실행
-- PK : UNIQUE + NOT NULL
--     (UNIQUE 인덱스를 생성해준다)
-- → empno 컬럼으로 unique 인덱스가 생성됨

-- 인덱스로 SQL을 실행하게 되면 인덱스가 없을 때와 어떻게 다른지 차이점을 확인.

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT ROWID, emp.*
FROM emp;

SELECT empno, ROWID
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

-- SELECT 조회컬럼이 테이블 접근에 미치는 영향
-- SELECT * FROM emp WHERE empno = 7782;
-- ↓
-- SELECT empno FROM emp WHERE empno = 7782;

explain plan for
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);    -- 직원번호가 이미 인덱스에 있으므로 테이블을 조회 할 필요가 없다.


-- UNIQUE VS NON-UNIQUE 인덱스의 차이를 확인
-- 1. PK_EMP 삭제
-- 2. empno 컬럼으로 NON-UNIQUE 인덱스 생성
-- 3. 실행계획 확인

ALTER TABLE emp DROP CONSTRAINTS pk_emp;

CREATE INDEX idx_n_emp_01 ON emp (empno);

-- emp 테이블에 job 컬럼을 기준으로 하는 새로운 non-unique 인덱스를 생성
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, ROWID
FROM emp
ORDER BY job = 'MANAGER';

-- 선택가능한 사항
-- 1. emp 테이블을 전체 읽기
-- 2. idx_n_emp_01 인덱스 활용
-- 3. idx_n_emp_02 인덱스 활용

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);