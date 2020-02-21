SET SERVEROUTPUT ON;
SELECT *
FROM dept_test;

ROLLBACK;
-- PRO_2 프로시져 + INSERT문

CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept_test.deptno%TYPE, 
                                            p_dname IN dept_test.dname%TYPE, 
                                            p_loc IN dept_test.loc%TYPE) IS
BEGIN
    INSERT INTO dept_test(deptno, dname, loc) VALUES (p_deptno, p_dname, p_loc);
    COMMIT;
END;
/

EXEC registdept_test (55, 'yims academy', 'biraedong');


-- PRO_3 프로시져 + UPDATE문
CREATE OR REPLACE PROCEDURE UPDATEdept_test(p_deptno IN dept_test.deptno%TYPE, 
                                            p_dname IN dept_test.dname%TYPE, 
                                            p_loc IN dept_test.loc%TYPE) IS
BEGIN
    UPDATE dept_test SET dname = p_dname,
                         loc = p_loc
                         WHERE deptno = p_deptno;
    COMMIT;                        
END;
/

EXEC UPDATEdept_test(99, 'it1_m', 'biraedong');


복합 변수 %rowtype : 특정 테이블의 행의 모든 컬럼을 저장할 수 있는 변수
사용 방법 : 변수명 테이블명%ROWTYPE
;

SET SERVEROUTPUT ON;
DECLARE
    v_dept_row dept%ROWTYPE;
BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname || ' ' || v_dept_row.loc);
END;
/


복합 변수 RECORD
개발자가 직접 여러개의 컬럼을 관리할 수 있는 타입을 생성하는 명령
Java를 비유하면 클래스를 선언하는 과정
인스턴스를 만드는 과정은 변수선언
사용 방법 : ;
TYPE 타입이름(개발자가 지정) IS RECORD(
    변수명1 변수타입,
    변수명2 변수타입
    );  -- 자바 클래스 만드는 것과 유사
    
변수명 타입이름;  -- 자바 인스턴스 만드는 것과 유사

DECLARE
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname VARCHAR2(14)
    );
    
    v_dept_row dept_row;
BEGIN
    SELECT deptno, dname INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname);
END;
/


table type 테이블 타입
점 : 스칼라 변수
선 : %ROWTYPE, record type
면 : table type
    어떤 선(%ROWTYPE, RECORD TYPE)을 저장할 수 있는지
    인덱스 타입은 무엇인지;
    
DEPT 테이블의 정보를 담을 수 있는 table type을 선언
기존에 배운 스칼라 타입, rowtype에서는 한 행의 정보를 담을 수 있었지만
table 타입 변수를 이용하면 여러 행의 정보를 담을 수 있다.;
PL/SQL에서는 Java와 다르게 배열에 대한 인덱스가 정수로 고정되어 있지 않고 문자열도 가능하다.
그렇기 때문에 TABLE 타입을 선언할 때는 인덱스에 대한 타입도 같이 명시하여야 한다.
BINARY_INTEGER 타입은 PL/SQL에서만 사용 가능한 타입으로 NUMBER 타입을 이용하여 정수만 사용 가능하게끔 한 NUMBER타입의 서브 타입이다.;


DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;   -- 타입선언
    v_dept_tab dept_tab;      --  변수명(직접 입력) 타입명(위에서 선언)
BEGIN
    SELECT * BULK COLLECT INTO v_dept_tab
    FROM dept;
    -- 기존 스칼라변수, record 타입을 실습 시에는 한 행만 조회 되도록 WHERE절을 통해 제한하였다.
    
    -- 자바에서는 배열[인덱스번호]로 호출
    -- 오라클은 table변수(인덱스번호)로 호출
    
    -- FOR (int i = 0; i < 10; i++); 자바
    -- .count = 자바에서 .length와 같은 기능.
    FOR i IN 1..v_dept_tab.count LOOP
        DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
    END LOOP;
    
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(2).deptno || ' ' || v_dept_tab(2).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(3).deptno || ' ' || v_dept_tab(3).dname);
--    DBMS_OUTPUT.PUT_LINE(v_dept_tab(4).deptno || ' ' || v_dept_tab(4).dname);   
END;
/


조건제어 IF
사용 방법:

IF 조건문 THEN
    실행문;
ELSIF 조건문 THEN
    실행문;
ELSE        -- THEN절 없음
    실행문;
END IF;

-- EX)
DECLARE
    p NUMBER(1) := 2;  -- 변수 선언 및 초기화
BEGIN
    IF p = 1 THEN   -- 자바는 == 써야 함.
        DBMS_OUTPUT.PUT_LINE('1입니다.');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('2입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('알려지지 않았습니다.');
    END IF;
END;
/



CASE 구문
1. 일반 케이스 (Java의 Switch와 유사)
2. 검색 케이스 (if, else if, else와 유사);

<일반 케이스문>
CASE expression
    WHEN value THEN
        실행문;
    WHEN value THEN
        실행문;
    ELSE
        실행문;
END CASE;
<일반 케이스문>;
DECLARE
    p NUMBER(1) := 2;
BEGIN
    CASE p
        WHEN 1 THEN
             DBMS_OUTPUT.PUT_LINE('1입니다.');
        WHEN 2 THEN
             DBMS_OUTPUT.PUT_LINE('2입니다.');
        ELSE
             DBMS_OUTPUT.PUT_LINE('모르는 값입니다.');
    END CASE;
END;
/




<검색 케이스문>;
DECLARE
    p NUMBER(1) := 2;
BEGIN
    CASE
        WHEN p = 1 THEN
             DBMS_OUTPUT.PUT_LINE('1입니다.');
        WHEN p = 2 THEN
             DBMS_OUTPUT.PUT_LINE('2입니다.');
        ELSE
             DBMS_OUTPUT.PUT_LINE('모르는 값입니다.');
    END CASE;
END;
/


<FOR LOOP 문법>
FOR 루프변수/ 인덱스 변수 IN [REVERSE] 시작값..종료값 LOOP
    반복할 로직
END LOOP;

1부터 5까지 FOR LOOP 반복문을 이용하여 숫자 출력;

DECLARE
BEGIN
    FOR i IN 1..5 LOOP
         DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

구구단 출력;
DECLARE
BEGIN
    FOR i IN 2..9 LOOP
     DBMS_OUTPUT.PUT_LINE('==' || i || '단 ==');
        FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i || ' X ' || j || ' = ' || i * j);
        END LOOP;
    END LOOP;
END;
/


while loop 문법;
WHILE 조건 LOOP
    반복 실행할 로직;
END LOOP;

DECLARE
    i NUMBER := 0;
BEGIN
    WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
    END LOOP;
END;

 
LOOP문 문법 → 자바의 while(true)와 비슷
LOOP
    반복 실행할 문자;
    EXIT 조건;
END LOOP;

DECLARE
    i NUMBER := 0;
BEGIN
    LOOP
         DBMS_OUTPUT.PUT_LINE(i);
         EXIT WHEN i > 5;
         i := i + 1;
    END LOOP;
END;
/