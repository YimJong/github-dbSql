동일한 SQL 문장이란 : 텍스트가 완벽하게 동일한 SQL
1. 대소문자 가림
2. 공백도 동일해야함
3. 조회 결과가 같다고 동일한 SQL이 아님

그렇기 때문에 다음 두개의 SQL 문장은 동일한 문장이 아님;

SELECT * FROM dept;
select * FROM dept;
select   * FROM dept;
select *
FROM dept;

SQL 실행 시 V$SQL 뷰에 데이터가 조회되는지 확인;
SELECT /* sql_test */ *
FROM dept
WHERE deptno = 10;

SELECT /* sql_test */ *
FROM dept
WHERE deptno = 20;

위 두개의 SQL은 검색하고자 하는 부서번호만 다르고 나머지 텍스트는 동일하다.
하지만 부서번호가 다르기 때문에 DBMS 입장에서는 서로 다른 SQL로 인식한다.
→ 다른 SQL 실행 계획을 세운다.
→ 실행 계획을 공유하지 못한다.
※ 해결책
SQL에서 변경되는 부분을 별도로 전송을 하고 실행계획이 세워진 이후에 바인딩 작업을 거쳐
실제 사용자가 원하는 변수 값으로 치환 후 실행
→ 실행 계획을 공유 → 메모리 자원 낭비 방지;

SELECT /* sql_test */ *
FROM dept
WHERE deptno = :deptno;




SQL 커서 (CURSOR)
기존에 사용한 SQL문은 묵시적 커서를 사용.
로직을 제어하기 위한 커허 : 명시적 커서

SELECT 결과 여러건을 TABLE 타입의 변수에 저장할 수 있지만
메모리는 한정적이기 때문에 많은 양의 데이터를 담기에는 제한이 따름.

SQL 커서를 통해 개발자가 직접 FETCH 함으로써 SELECT 결과를 전부 불러오지 않고도 개발이 가능.

커서 선언 방법 :

선언부에서 선언
    CURSOR 커서이름 IS
        제어할 쿼리;
        
실행부(BEGIN)에서 커서 열기
    OPEN 커서이름;

실행부(BEGIN)에서 커서로부터 데이터 FETCH
    FETCH 커서이름 INTO 변수

실행부(BEGIN)에서 커서 닫기
    CLOSE 커서이름;
    
부서 테이블을 활용하여 모든 행에 대해 부서번호와 부서 이름을 CURSOR를 통해 FETCH,
FETCH 된 결과를 확인;

SET SERVEROUTPUT ON;

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    OPEN dept_cursor;
    
    LOOP
    
     FETCH dept_cursor INTO v_deptno, v_dname;
     
     EXIT WHEN dept_cursor%NOTFOUND;
     
     DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);

    END LOOP;

END;
/



CURSOR를 열고 닫는 과정이 다소 거추장스러움.
CURSOR는 일반적으로 LOOP와 함께 사용하는 경우가 많음
→ 명시적 커서를 FOR LOOP에서 사용할 수 있게끔 문법으로 제공;

List<String> userNameList = new ArrayList<>();
userNameList.add("brown");
userNameList.add("cony");
userNameList.add("sally");
와 비슷.

일반 for
for(int i = 0; i < userNameList.size(); i++) {
    String userName = userNameList.get(i);
}

향상된 for
for(String userName : userNameList) {
    userName값 사용...
}

--↑↑↑↑ 자바의 경우 ----------------------------------------------------------------

FOR record_name(한 행의 정보를 담을 변수이름 / 변수를 직접 선언 안함) IN 커서이름 LOOP
    record_name.컬럼명
END LOOP;

DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    FOR rec IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;

END;
/


인자가 있는 명시적 커서
기존 커서 선언방법
    CURSOR 커서이름 IS
        서브쿼리...;
        
인자가 있는 커서 선언방법
    CURSOR 커서이름(인자1 인자1타입 .... ) IS
        서브쿼리
        (커서 선언 시에 작성한 인자를 서브쿼리에서 사용할 수 있다.);
        

DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT deptno, dname
        FROM dept
        WHERE deptno <= p_deptno;             -- 인자 사용 가능
BEGIN
    FOR rec IN dept_cursor(20) LOOP   -- 인자값 입력
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;

END;
/



FOR LOOP에서 커서를 인라인 형태로 작성
FOR 레코드이름 IN 커서이름
→
FOR 레코드이름 IN (서브쿼리);

DECLARE 
BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP  
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/   --  커서선언, 패치선언 X



DECLARE
TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;   -- 타입선언
    v_dt_tab dt_tab;    
   
    v_count NUMBER;
    v_sum NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM dt;
    
    FOR i IN 1..v_dt_tab.count - 1 LOOP
      v_sum := v_sum + (v_dt_tab(i).dt - v_dt_tab(i + 1).dt);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_sum / v_count);
END;
/

---------------------

CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;   -- 인덱스 값을 정수로 할 것이라는 인덱스 타입 선언
                                                                  -- 여기서 자바의 배열 선언과 같은 역할
    v_dt_tab dt_tab;  
    
    v_diff_sum NUMBER := 0;  -- 초기화.
BEGIN
    SELECT * BULK COLLECT INTO v_dt_tab
    FROM dt;
    -- DT 테이블에는 8행이 있는데 1-7번행 까지만 LOOP 시행
    FOR i IN 1..v_dt_tab.COUNT-1 LOOP
        v_diff_sum := v_diff_sum + v_dt_tab(i).dt - v_dt_tab(i+1).dt; 
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_diff_sum / (v_dt_tab.COUNT-1));
    
END;
/

EXEC avgdt;


SELECT A.*, dt - dt2 gap_dt
FROM
(SELECT dt, LEAD(dt) OVER(ORDER BY dt DESC) dt2 
 FROM dt) A;
 
 
 SELECT (MAX(dt) - MIN(dt)) / (COUNT(dt) - 1) result
 FROM dt;

SELECT a.dt, b.dt, a.dt - b.dt gap
FROM
(SELECT ROWNUM rn, dt
 FROM dt) a,
 
(SELECT ROWNUM rn, dt
 FROM dt) b
 WHERE a.rn = b.rn - 1;


