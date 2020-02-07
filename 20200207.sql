-- TURNCATE 테스트
-- REDO 로그를 생성하지 않기 때문에 삭제 시 데이터 복구가 불가하다.
-- DML(SELECT, INSERT, UPDATE, DELETE)이 아니라 DDL로 분류(ROLLBACK이 불가)

-- 테스트 시나리오
-- emp테이블 복사를 하여 emp_copy라는 이름으로 테이블 생성
-- emp_copy 테이블을 대상으로 TURNCATE TABLE emp_copy 실행

-- emp_copy 테이블에 데이터가 존재하는지 (정상적으로 삭제가 되었는지) 확인.

-- emp_copy 테이블 복사

-- CREATE → DDL(ROLLBACK이 안된다)
CREATE TABLE EMP_COPY AS
SELECT *
FROM emp;

SELECT *
FROM emp_copy;

TRUNCATE TABLE emp_copy;
ROLLBACK;
-- TURNCATE TABLE 명령어는 DDL이기 때문에 ROLLBACK이 불가하다.
-- ROLLBACK 후 SELECT를 해보면 데이터가 복구 되지 않은 것을 알 수 있다.

-- FOR UPDATE
SELECT *
FROM dept
WHERE deptno = 10
FOR UPDATE ;
-- 저 데이터에 락을 걸어 놓은 것과 같음.
-- 부서번호 10번에 대한 데이터에 UPDATE, DELETE 불가능
-- 후행 트랜잭션에서 신규 데이터 생성은 가능함.

-- LV3 SERIALIZABLE READ
-- SET TRANSACTION isolation LEVEL SERIALIZABLE;

SELECT *    -- 데이터 4건
FROM dept;

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');  -- 데이터가 5건이 됨.

-- 다른 후행 트랜잭션에서 신규 데이터를 커밋 했음.

SELECT *
FROM dept; -- 데이터 5건 그대로임. (후행 프랜잭션의 데이터가 안됬음.)
-- SNAPSHOT TOO OLD

-- DDL : Data Definition Language - 데이터 정의어
-- 객체를 생성, 수정, 삭제시 사용
-- ROLLBACK 불가!

-- 테이블 생성
-- CREATE TABLE [스키마명]테이블명(
--    컬럼명, 컬럼타입 [DEFAULT 기본값],
--    컬럼명, 컬럼타입 [DEFAULT 기본값], .....
--   );

-- 스키마 : 접속계정  ex) YimJ.

CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE DEFAULT SYSDATE     -- 현재날짜가 기본 값
);

SELECT *
FROM ranger;

INSERT INTO ranger(ranger_no, ranger_nm) VALUES (1, 'brown');
COMMIT;

-- 테이블 삭제 (DROP)
-- DROP TABLE 테이블명

DROP TABLE ranger;

SELECT *
FROM ranger;

-- DDL은 롤백 불가..
ROLLBACK;
-- 조회 시 table or view does not exist 오류
-- 데이터 또한 당연히 삭제
-- 관련 객체도 같이 삭제 (제약조건, 인덱스)
-- 운영서버에서는 당연히 조심할 것.

-- Data type
-- VARCHAR2(Size) : 가변길이 문자열, SIZE : 1 ~ 4000Byte (char 타입 사용 지양)
--                  한글 1글자 3 byte, 입력되는 값이 컬럼 사이즈보다 작아도 남은 공간을 공백으로 채우지 않는다.

-- CHAR(Size) : 고정길이 문자열, ex) CHAR(10)을 설정하고 5Byte만 입력 했을 경우 나머지 5Byte는 공백으로 채워짐.

-- NUMBER(p, s) : p = 전체자리수(38), s = 소수점 자리수
-- INTEGER → NUMBER(38, 0)
-- renger_no NUMBER → NUMBER(38, 0)

-- DATE : 일자와 시간 정보를 저장. ( DATE타입으로 관리하는 곳이 있고 VARCHAR2로 관리하는 곳이 있음. )
-- 차이점 ex) DATE - 7Byte
--           VARCHAR2 - '20200207' - 8Byte
-- 위 두개의 타입은 하나의 데이터당 1Byte의 사이즈가 차이가 난다. 데이터 양이 증가하면 무시할 수 없는 사이즈로, 설계시 타입에 대한 고려가 필요.

--  LOB(Large Object) - 최대 4GB
--  CLOB - Character Large Object
--       - VARCHAR2로 담을 수 없는 사이즈의 문자열 (4000Byte 초과 문자열)
--       - ex) 웹 에디터에서 생성된 html 코드      
--  BLOB - Byte Large Object
--       - 파일을 데이터베이스의 테이블에서 관리할 때
--       - 일반적으로 게시글 첨부파일을 테이블에 직접 관리하지 않고 보통 첨부파일을 디스크의 특정 공간에 저장하고, 해당 '경로'만 문자열로 간리.
--       - 만약 파일이 매우 중요한 경우 ex)고객 정보사용 동의서 → [파일]을 테이블에 저장


-- 제약 조건 : 데이터가 무결성을 지키도록 위한 설정
-- 1. UNIQUE 제약 조건
--    해당 컬럼의 값이 다른 행의 데이터와 중복되지 않도록 제약
--    ex) 사번이 같은 사원이 있을 수가 없다.

-- 2. NOT NULL 제약 조건 (CHECK 제약조건)
--    해당 컬럼에 값이 반드시 존재
--    ex) 사번 컴럼이 NULL인 사원은 존재할 수가 없다.
--    ex) 회원가입 시 필수 입력사항 (github - 이메일, 이름)
 
-- 3. PRIMARY KEY 제약 조건
--    UNIQUE + NOT NULL : 중복 불가 및 NULL 불가능
--    ex) 사번
--    PRIMARY KEY 제약 조건을 생성할 경우 해당 컬럼으로 UNIQUE INDEX가 생성된다.

-- 4. FOREIGN KEY 제약 조건 (참조 무결성)
--    해당 컬럼이 참조하는 다른 테이블에 값이 존재하는 행이 있어야 한다.
--    ex) emp 테이블의 deptno컬럼이 dept테이블의 deptno컬럼을 참조(관계)
--        emp 테이블의 deptno컬럼에는 dept 테이블에 존재하지 않는 부서번호가 입력 될 수 없다.
--        만약 dept 테이블의 부서번호가 10, 20, 30, 40번만 존재 할 경우
--        emp 테이블에 새로운 행을 추가 하면서 부서번호 값을 99번으로 등록 할 경우
--        행 추가가 실패한다.

-- 5. CHECK 제약 조건 (값을 체크)
--    NOT NULL 제약 조건도 CHECK 제약에 포함
--    emp 테이블의 job 컬럼에 들어올 수 있는 값을 'SALESMAN', 'PRESIDENT', 'CLERK'

-- 제약조건 생성 방법
-- 1. 테이블을 생성하면서 컬럼에 기술
-- 2. 테이블을 생성하면서 컬럼 기술 이후에 별도에 제약조건을 기술
-- 3. 테이블 생성과 별도로 추가적으로 제약조건을 추가

-- CREATE TABLE 테이블명 (
-- 1.   컬럼1 컬럼타입 [제약조건],
--      컬럼2 컬럼타입 [제약조건],....

-- [2. TABLE_CONSTRAINT]
-- 3. ALTER TABLE emp.....

-- PRIMARY KEY 제약조건을 컬럼 레벨로 생성(1번 방법)
-- 1. dept 테이블을 참고하여 dept_test 테이블을 PRIMARY KEY 제약조건과 함께 생성
-- 단 이 방식은 테이블의 KEY 컬럼이 복합 컬럼은 불가, 단일 컬럼일 때만 가능.
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test (deptno) VALUES (99); -- 정상적으로 실행됨.
INSERT INTO dept_test (deptno) VALUES (99); -- unique constraint (YimJ.제약조건명) violated 오류, 
                                            -- 바로 위의 쿼리를 통해 같은 값의 데이터가 이미 저장됨.

-- 참고사항
INSERT INTO dept (deptno) VALUES (99);
INSERT INTO dept (deptno) VALUES (99); -- 두 가지 다 삽입됨. 우리가 원래 사용하던 dept테이블에는 UNIQUE 제약 조건이나
                                       -- PRIMARY 제약 조건이 없음을 뜻 함.
ROLLBACK;

-- 제약 조건 확인방법
-- 1. TOOL을 통한 확인
--    확인하고자 하는 테이블 선택.

-- 2. DICTIONARY를 통해 확인 (USER_TABLES)

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'DEPT_TEST';

SELECT *                                    -- 제약조건 이름을 가져와서 조회해야 함.
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'SYS_C007085';


-- 3. 모델링 (ex: eXerd)으로 확인

-- 제약조건 명을 기술하지 않을 경우 오라클에서 제약조건이름을 임의로 부여 (ex) SYS_C007086
-- 가독성이 떨어지기 때문에 명명 규칙을 지정하고 생성하는게 개발, 운영 관리에 유리.
-- ex) PRIMARY KEY 제약조건 : PK_테이블명
--     FOREIGN KEY 제약조건 : FK_대상테이블명_참조테이블명

DROP TABLE dept_test;

-- 컬럼 레벨의 제약조건을 생성하면서 제약조건 이름을 부여
-- CONSTRAINT 제약조건명 제약조건타입(PRIMARY KEY)
-- 오류 발생시 어떤 제약조건 때문인지 알기 쉽다.
CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

-- 2. 테이블 생성 시 컬럼 기술 이후 별도의 제약조건 기술
DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
);

-- NOT NULL 제약조건 생성하기
-- 1. 컬럼에 기술하기
--    단 컬럼에 기술하면서 제약조건에 이름을 부여하는 건 불가능.

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

-- NOT NULL 제약조건 확인
INSERT INTO dept_test (deptno, dname) VALUES (99, NULL);  -- cannot insert NULL into 값 오류

-- 2. 테이블 생성 시 컬럼 기술 이후에 제약 조건 추가.
DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT NM_dept_test_dname CHECK (deptno IS NOT NULL)
);



-- UNIQUE 제약 : 해당 컬럼에 중복되는 값이 들어오는 것을 방지, 단 NULL은 입력 가능하다.
-- PRIMARY KEY = UNIQUE + NOT NULL

-- 1. 테이블 생성 시 컬럼 레벨 UNIQUE 제약조건
--    dname 컬럼에 UNIQUE 제약조건

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

-- dept_test 테이블의 dname 컬럼에 설정된 unique 제약조건을 확인
INSERT INTO dept_test VALUES (98, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon'); -- 중복 오류


-- 2. 테이블 생성시 컬럼에 제약조건 기술, 제약조건 이름 부여
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) CONSTRAINT UK_dept_test_dname UNIQUE,
    loc VARCHAR2(13)
);

-- dept_test 테이블의 dname 컬럼에 설정된 unique 제약조건을 확인
INSERT INTO dept_test VALUES (98, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon'); -- 중복 오류

-- 3. 테이블 생성 시 컬럼 기술 이후 제약조건 생성 - 복합 커럼(deptno - dname) (unique)
DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT UK_dept_test_deptno_dname UNIQUE (deptno, dname)
);

-- 복합 컬럼에 대한 UNIQUE 제약 확인 (deptno, dname)
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit', 'daejeon'); -- 여기까지는 삽입이 됨.
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon'); -- 오류

-- FOREIGN KEY 제약조건
-- 참조하는 테이블의 컬럼에 존재하는 값만 대상 테이블의 컬럼에 입력할 수 있도록 설정
-- ex) emp테이블에 deptno 컬럼 값을 입력할 때, dept 테이블의 deptno 컬럼에 존재하는 부서번호만 입력할 수 있도록 설정
--     존재하지 않는 부서번호를 emp 테이블에서 사용하지 못하게끔 방지.

-- 1. dept_test 테이블 생성
-- 2. emp_test 테이블 생성
--     emp_test 테이블 생성 시 deptno 컬럼으로 dept.deptno 컬럼을 참조하도록 FK 설정.

DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
);
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno),
    
    CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno)
);

-- 데이터 입력순서
-- 지금상황(dept_test, emp_test 테이블을 방금 생성 - 데이터가 존재하지 않을 때)에서 emp_test 테이블에 데이터를 입력하는게 가능한가??
INSERT INTO emp_test VALUES (9999, 'brown', NULL); -- FK이 설정된 컬럼에 NULL은 허용
INSERT INTO emp_test VALUES (9999, 'sally', 10); -- 10번 부서가 dept_test 테이블에 존재하지 않아서 에러..
                                                 -- parent key not found
                                                 
-- dept_test 테이블에 데이터를 준비
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon'); 
INSERT INTO emp_test VALUES (9988, 'sally', 99); -- 정상 실행
INSERT INTO emp_test VALUES (9988, 'sally', 10); -- 10번 부서가 존재 하지 않으므로 에러

-- 테이블 생성 시 컬럼 기술 이후 FOREIGN KEY 제약조건 생성
DROP TABLE emp_test;
DROP TABLE dept_test;
CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
);
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES  dept_test (deptno)
);
INSERT INTO emp_test VALUES (9999, 'brown', 10); -- dept_test 테이블에 10번 부서가 존재하지 않아 에러.
INSERT INTO emp_test VALUES (9999, 'brown', 99); -- 정상 실행 