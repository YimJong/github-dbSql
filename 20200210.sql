-- PRIMARY KEY 제약 조건 생성 시 오라클 DBMS는 해당 컬럼으로 UNIQUE index를 자동으로 생성한다.
-- (*** 정확히는 UNIQUE제약에 의해 UNIQUE 인덱스가 자동으로 생성된다.
--      PRIMARY = UNIQUE + NOT NULL)
-- intdex 해당 컬럼으로 미리 정렬을 해 놓은 객체
-- 정렬이 되어있기 때문에 찾고자 하는 값이 존재하는지 빠르게 알 수가 있다.
-- 만약에 인덱스가 없다면 새로운 데이터를 입력할 때 중복되는 값을 찾기 위해서 최악의 경우 테이블의 모든 데이터를 찾아야 한다.
-- 하지만 인덱스가 있으면 이미 정렬이 되어있기 때문에 해당 값의 존재 유무를 빠르게 알 수가 있다.

-- FOREIGN KEY 제약 조건도 참조하는 테이블에 값이 있는지 확인 하여야 한다.
-- 참조하는 테이블에 값이 있는지 확인 해야한다.
-- 그래서 참조하는 컬럼에 인덱스가 있어야지만 FOREIGN KEY 제약을 생성할 수가 있다.

-- FOREIGN KEY 생성 시 옵션
-- FROEIGN KEY (참조 무결성) : 참조하는 테이블의 컬럼에 존재하는 값만 입력 될 수 있도록 제한
-- (ex : emp테이블에 새로운 데이터를 입력 시 deptno 컬럼에는 dept 테이블에 존재하는 부서번호만 입력 될 수 있다.)

-- FOREIGN KEY가 생성됨에 따라 데이터를 삭제할 때 유의점
-- 어떤 테이블에서 참조하고 있는 데이터를 바로 삭제할 수 없음
-- (ex : EMP.deptno → DEPT.deptno 컬럼을 참조하고 있을 때
--       부서 테이블의 데이터를 삭제할 수가 없음.)

SELECT *
FROM emp_test;

-- emp : 9999, 99
-- dept : 89, 99
-- → 98번 부서를 참조하는 emp 테이블의 데이터는 없음
--   99번 부소를 참조하는 emp 테이블의 데이터는 9999번 brown 사번이 있음.

DELETE dept_test
WHERE deptno = 99;


DELETE dept_test
WHERE deptno = 98;
ROLLBACK;

SELECT *    
FROM emp_test;

SELECT *
FROM dept_test;

-- FOREIGN KEY 옵션
-- 1. ON DELETE CASCADE : 부모가 삭제될 경우(dept) 참조하는 자식 데이터도 같이 삭제한다.(emp)
-- 2. ON DELETE SET NULL : 부모가 삭제될 경우(dept) 참조하는 자식 데이터의 컬럼을 null로 설정.

-- emp_test테이블을 DROP후 옵션을 번갈아가며 생성한 후 삭제 테스트

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) 
            REFERENCES dept_test (deptno) ON DELETE CASCADE
);

INSERT INTO emp_test VALUES (9999, 'brown', 99);
COMMIT;

-- emp 테이블의 deptno 컬럼은 dept 테이블의 deptno 컬럼을 참조 (ON DELETE CASCADE)
-- 옵션에 따라서 부모테이블(dept_test) 삭제 시 참조하고 있는 자식 데이터도 같이 삭제된다.
DELETE dept_test
WHERE deptno = 99;

-- 옵션을 부여하지 않았을 때는 위의 DELETE 쿼리가 에러가 발생.
-- 옵션에 따라서 참조하는 자식테이블의 데이터가 정상적으로 삭제가 되었는지 SELECT 확인.

SELECT *
FROM emp_test;

-- FK ON DELETE SET NULL 옵션 테스트
-- 부모 테이블의 데이터 석제시 (dept_test) 자식테이블에서 참조하는 데이터를 NULL로 업데이트
ROLLBACK;

SELECT *
FROM dept_test;

SELECT *
FROM emp_test;

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) 
            REFERENCES dept_test (deptno) ON DELETE SET NULL
);

INSERT INTO emp_test VALUES (9999, 'brown', 99);
COMMIT;

-- dept_test 테이블의 99번 부서를 삭제하게 되면(부모 테이블을 삭제하면)
-- 99번 부서를 참조하는 emp_test 테이블의 9999번(brown) 데이터의 deptno 컬럼을
-- FK 옵션에 따라 NULL로 변경한다.

DELETE dept_test
WHERE deptno = 99;

-- 부모 테이블의 데이터 삭제 후 자식 테이블의 데이터가 NULL로 변경이 되었는지 확인.

SELECT *
FROM emp_test;

-- CHECK 제약조건 : 컬럼에 들어가는 값의 종류를 제한할 때 사용
-- ex : 급여 컬럼을 숫자로 관리, 급여가 음수가 들어갈 수 있을까?
--      일반적인 경우 급여값은 '급여>0'
-- CHECK 제약을 사용할 경우 급여값이 0보다 큰 값인지 검사 가능.
-- emp테이블의 job컬럼에 들어가는 값을 다음 4가지로 제한 가능
-- 'SAELSMAN', 'PRESIDENT', 'ANALYST', 'MANAGER'

-- 테이블 생성 시 컬럼 기술과 함께 CHECK 제약 생성
-- emp_test 테이블의 sal 컬럼이 0보다 크다는 CHECK 제약조건 생성

INSERT INTO dept_test VALUES (99, 'ddit', '대전');
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    sal NUMBER CHECK (sal > 0),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
    );
    
INSERT INTO emp_test VALUES (9999, 'brown', 99, 1000);
INSERT INTO emp_test VALUES (9998, 'sally', 99, -1000); -- sal 체크조건에 따라 0보다 큰 값만 입력 가능.

-- 새로운 테이블 생성
-- CREATE TABLE 테이블명 (
--  컬럼1.....
-- );

-- CREATE TABLE 테이블명 AS
-- SELECT 결과를 새로운 테이블로 생성

-- emp 테이블을 이용해서 부서번호가 10인 사원들만 해당 데이터로
-- emp_test2 테이블을 생성.

CREATE TABLE emp_test2 AS
SELECT *
FROM emp
WHERE deptno = 10;

-- NOT NULL 제약 조건 이외의 제약 조건은 복사되지 않는다.
-- 개발시
-- 1. 데이터 백업
-- 2. 테스트 개발

-- TABLE 변경
-- 1. 컬럼추가
-- 2. 컬럼 사이즈 변경, 타입 변경
-- 3. 기본값 설정
-- 4. 컬러명을 RENAME
-- 5. 컬럼을 삭제
-- 6. 제약조건 추가/삭제

-- TABLE 변경 1. 컬럼 추가 ( HP VARCHAR2(20) )

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT pk_emp_test PRIMARY KEY (empno),
    CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
);

-- ALTER TABLE 테이블명 ADD (신규컬럼명, 신규컬럼 타입)

ALTER TABLE emp_test ADD (HP VARCHAR2(20));

DESC emp_test;

SELECT *
FROM emp_test;

-- TABLE 변경 2. 컬럼 사이즈 변경, 타입 변경
-- ex: 컬럼 VARCHAR2(20) → VARCHAR2(5)
-- 기본의 데이터가 존재할 경우 정상적으로 실행이 안될 확률이 매우 높음.
-- 일반적으로는 데이터가 존재하지 않는 상태, 즉 테이블을 생성한 직후에 컬럼의 사이즈, 타입이 잘못 된 경우
-- 컬럼 사이즈, 타입을 변경함.

-- 데이터가 입력 된 이후로는 활용도가 매우 떨어짐. (사이즈 늘리는 것만 가능.)

DESC emp_test;

-- HP VARCHAR2(20) → HP VARCHAR2(30)
-- ALTER TABLE 테이블명 MODIFY (기존 컬럼명, 신규 컬럼 타입(사이즈))

ALTER TABLE emp_test MODIFY (HP VARCHAR2(30));

-- 컬럼 타입 변경
-- HP VARCHAR2(30) → HP NUMBER;

ALTER TABLE emp_test MODIFY (HP NUMBER);
DESC emp_test;

-- TABLE 변경 3. 컬럼 기본값 설정
--ALTER TABLE 테이블명 MODIFY (컬럼명 DEFAULT 기본값)

-- HP NUMBER → VARCHAR2(20) DEFAULT '010'
ALTER TABLE emp_test MODIFY (HP VARCHAR2(20) DEFAULT '010');

-- HP 컬럼에는 값을 넣지 않았지만 DEFAULT 설저에 의해 '010' 문자열이 기본값으로 저장된다. DEFAULT설정 이후의 값에만 적용.
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 99);

SELECT *
FROM emp_test;

-- TABLE 변경 4. 변경시 컬럼 변경
-- ALTER TABLE 테이블명 RENAME COLUMN 기존 컬럼명 TO 신규 컬럼명
-- 변경하려고 하는 컬럼이 FK제약, PK제약이 있어도 상관 없음.

-- HP → HP_n

ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;
SELECT *
FROM emp_test;

-- TABLE 변경 5. 컬럼 삭제
-- ALTER TABLE 테이블명 DROP COLUMN 컬러명

-- emp_test 테이블에서 hp_n 컬럼 삭제

SELECT *
FROM emp_test;

ALTER TABLE emp_test DROP COLUMN hp_n;

-- 1. emp_test 테이블을 drop 후 empno, ename, deptno, hp 4개의 컬럼으로 테이블 생성
-- 2. empno, ename, deptno 3가지 컬럼에만 (9999, 'brown', 99) 데이터로 INSERT
-- 3. emp_test 테이블의 hp 컬럼의 기본값을 '010'으로 설정
-- 4. 2번 과정에 입력한 테이블의 hp 컬럼 값이 어떻게 바뀌는지 확인.

-- TABLE 변경 6. 제약조건 추가 / 삭제
-- ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건타입(ex:PRIMARY KEY, FOREIGN KEY) (해당 컬럼);
-- ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명

-- emp_test 테이블 삭제 후 제약 조건 없이 테이블을 생성
-- PRIMARY KEY, FOREIGN KEY 제약을 ALTER TABLE 변경을 통해 생성.
-- 두개의 제약조건 테스트


DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2));
    
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);

-- PRIMARY KEY 테스트
INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 99); -- 첫번째 INSERT 구문에 의해 중복되므로 실패.

-- FOREIGN KEY 테스트
SELECT *
FROM dept_test;

INSERT INTO emp_test VALUES (9998, 'sally', 98); -- dept_test 테이블에 존재하지 않는 부서번호이므로 실패.

-- 제약조건 삭제 : PRIMARY KEY, FOREIGN KEY
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test;

-- 제약조건이 없으므로 empno가 중복된 값이 들어갈 수 있고, dept_test 테이블에 존재하지 않는 deptno 값도 들어갈 수 있다.
INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 99);

-- 존재하지 않는 98번부서로 데이터 입력.
INSERT INTO emp_test VALUES (9998, 'sally', 98);


-- 제약조건 활성화 / 비활성화

-- ALTER TABLE 테이블명 ENABLE | DISABLE CONSTRAINT 제약조건명

-- 1. emp_test 테이블 삭제
-- 2. emp_test 테이블 생성
-- 3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY(dept_test.deptno) 제약조건 생성
-- 4. 두개의 제약조건을 비활성화
-- 5. 비활성화가 되었는지 INSERT를 통해 확인.
-- 6. 제약조건을 위배한 데이터가 들어간 상태에서 제약조건 활성화

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2));
    
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);

ALTER TABLE emp_test DISABLE CONSTRAINT PK_emp_test;
ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test;

INSERT INTO emp_test VALUES (9999, 'brown', 99);
INSERT INTO emp_test VALUES (9999, 'sally', 98);
COMMIT;

SELECT *
FROM emp_test;

-- emp_test테이블에는 empno 컬럼의 값이 9999인 사원이 두명 존재하기 때문에
-- PRIMARY KEY 제약조건을 활성화 할 수가 없다.
-- empno 컬럼의 값이 중복되지 않도록 수정하고 제약조건을 활성화 할 수 있다.
ALTER TABLE emp_test ENABLE CONSTRAINT PK_emp_test;  -- 오류
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test;  -- 오류

-- 중복 데이터 제거
DELETE emp_test
WHERE ename = 'brown';

-- PRIMARY KEY 제약조건 활정화
ALTER TABLE emp_test ENABLE CONSTRAINT PK_emp_test;

-- dept_test 테이블에 존재하지 않는 부서번호 98을 emp_test에서 사용 중.
-- 1. dept_test 테이블에 98번 부서를 등록하거나
-- 2. sally의 부서번호를 99번으로 변경.
-- 3. sally 행을 삭제

UPDATE emp_test SET deptno = 99
WHERE ename = 'sally';

ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test;

