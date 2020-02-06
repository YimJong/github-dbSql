-- SUB1
SELECT count(*)
FROM emp
WHERE sal > (SELECT avg(sal)
             FROM emp);
             
-- SUB3  (서브쿼리의 연산 결과가 둘 이상이면 '=' 사용 불가 - in 중첩 사용)
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));


-- SUB4   
SELECT * 
FROM dept
WHERE deptno NOT IN( SELECT deptno
                     FROM emp );
                     
-- SUB5
SELECT *
FROM product
WHERE NOT EXISTS ( SELECT 'X'
                   FROM cycle
                   WHERE cid = 1
                   AND cycle.pid = product.pid);

-- SUB6
SELECT cid, pid, day, cnt
FROM cycle
WHERE cid = 2 AND pid IN (SELECT pid
                          FROM cycle
                          WHERE cid = 1);

SELECT c.cid, c.pid, c.day, c.cnt
FROM cycle c
WHERE cid = 1 AND pid IN (SELECT pid
                          FROM cycle
                          WHERE cid = 2);                  
                   
-- SUB7

SELECT c.cid, p.pid, p.pnm, c.day, c.cnt
FROM cycle c JOIN product p ON (c.pid = p.pid)
WHERE c.cid = 2 AND EXISTS ( SELECT 'X'
                             FROM cycle cy
                             WHERE cy.cid = 1 AND c.pid = cy.pid );
                             
SELECT c.cid, p.pid, p.pnm, c.day, c.cnt
FROM cycle c JOIN product p ON (c.pid = p.pid)
WHERE c.cid = 1 AND EXISTS ( SELECT 'X'
                             FROM cycle cy
                             WHERE cy.cid = 2 AND c.pid = cy.pid );  
                             
-- SUB9
SELECT p.pid, p.pnm
FROM product p JOIN (SELECT c.pid
                     FROM cycle c
                     WHERE EXISTS( SELECT 'X'
                                   FROM cycle
                                   WHERE c.cid = 1)) a 
ON(a.pid = p.pid);

-- SUB10
SELECT p.pid, p.pnm
FROM product p
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle
                  WHERE cid = 1 AND p.pid = cycle.pid);



-- 분자 (KFC, 버거킹, 맥도날드)
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '대전광역시' AND gb in ('KFC', '버커킹', '맥도날드')
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '대전광역시' AND gb = '롯데리아'
GROUP BY sido, sigungu;

------- 
SELECT sido, sigungu, ROUND((kfc + burgerking + mac) / lot, 2) AS burgerindex
FROM 
   (SELECT sido, sigungu,
    NVL(SUM(DECODE(gb, 'KFC', 1)), 0) kfc, NVL(SUM(DECODE(gb, '버거킹', 1)), 0) burgerking,
    NVL(SUM(DECODE(gb, '맥도날드', 1)), 0) mac, NVL(SUM(DECODE(gb, '롯데리아', 1)), 1) lot -- 0으로 나누면 오류이므로 롯데리아는 1로 디코드
    
FROM fastfood
WHERE gb IN('KFC', '버거킹', '맥도날드', '롯데리아')
GROUP BY sido, sigungu)
ORDER BY burgerindex DESC;


-- 텍스 테이블에서 개인별 소득 조회
SELECT sido, sigungu, ROUND(sal / people) AS pri_sal
FROM TAX
ORDER BY pri_sal DESC;




-- 햄버거지수 시도, 햄버거지수 시군구, 햄버거지수, 세금 시도, 세금 시군구, 개인별 근로소득액
-- ANSI 
SELECT tax_index.sido, tax_index.sigungu, tax_index.pri_sal,
       burger_index.sido, burger_index.sigungu, burger_index.burger
FROM
    (SELECT ROWNUM rn, t.*
     FROM (SELECT sido, sigungu, ROUND(sal / people) AS pri_sal
           FROM TAX
           ORDER BY pri_sal DESC) t) tax_index 
           
     JOIN     
          
     (SELECT ROWNUM rn, c.*
      FROM
         (SELECT a.sido, a.sigungu, round(a.ct/b.ct, 1) as burger
          FROM 
             (SELECT sido, sigungu, count(*) ct
              FROM fastfood
              WHERE gb IN ('KFC', '맥도날드', '버거킹')
              GROUP BY sido, sigungu) a,
         
             (SELECT sido, sigungu, count(*) ct
              FROM fastfood
              WHERE gb = '롯데리아'
              GROUP BY sido, sigungu) b
      WHERE a.sido = b.sido
      AND a.sigungu = b.sigungu
      ORDER BY burger DESC) c) burger_index ON (tax_index.rn = burger_index.rn); 
      
---------------------------------------------------------------------------------------
-- Oracle Join
SELECT tax_index.sido, tax_index.sigungu, tax_index.pri_sal,
       burger_index.sido, burger_index.sigungu, burger_index.burger
FROM
    (SELECT ROWNUM rn, t.*
     FROM (SELECT sido, sigungu, ROUND(sal / people) AS pri_sal
           FROM TAX
           ORDER BY pri_sal DESC) t) tax_index , 
   
     (SELECT ROWNUM rn, c.*
      FROM
         (SELECT a.sido, a.sigungu, round(a.ct/b.ct, 1) as burger
          FROM 
             (SELECT sido, sigungu, count(*) ct
              FROM fastfood
              WHERE gb IN ('KFC', '맥도날드', '버거킹')
              GROUP BY sido, sigungu) a,
         
             (SELECT sido, sigungu, count(*) ct
              FROM fastfood
              WHERE gb = '롯데리아'
              GROUP BY sido, sigungu) b
      WHERE a.sido = b.sido
      AND a.sigungu = b.sigungu
      ORDER BY burger DESC) c) burger_index
WHERE tax_index.rn = burger_index.rn;
     
    
-- DML

-- empno 컬럼은 NOT NULL 제약 조건이 있다. - INSERT시 반드시 값이 존재해야 정상적으로 입력된다.
-- empno 컬럼을 제외한 나머지 컬럼은 NULLABLE이다. (NULL 값이 저장될 수 있다.)
INSERT INTO emp (empno, ename, job)
VALUES ( 9999, 'brown', NULL);
ROLLBACK;

SELECT *
FROM emp;

-- NOT NULL 제약으로 인해 데이터 생성 불가능.
INSERT INTO emp (ename, job)
VALUES ( 'sally', 'SALESMAN' );

-- 문자열 : '문자열' → 자바 "문자열"
-- 숫자 : 10
-- 날짜 : TO_DATE('20200206', 'YYYYMMDD')

-- emp 테이블의 hiredate 컬럼은 date 타입.
-- emp 테이블의 8개의 컬럼에 값을 입력.
DESC emp;

INSERT INTO emp VALUES ( 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99);
ROLLBACK;

-- 여러건의 데이터를 한번에 INSERT : 
-- INSERT INTO 테이블명 (컬럼명1, 컬럼명2,...)
-- SELECT ...
-- FROM ;
INSERT INTO emp 
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL, 99 
FROM dual
    UNION ALL
SELECT 9999, 'brown', 'CLERK', NULL, TO_DATE('20200205', 'YYYYMMDD'), 1100, NULL, 99
FROM dual;

-- UPDATE 쿼리
-- UPDATE 테이블명 SET 컬럼명1 = 갱신할 컬럼 값1, 컬럼명2 = 갱신할 컬럼 값2,......
-- WHERE 행 제한 조건
-- 업데이트 쿼리 작성시 WHERE 절이 존재하지 않으면 해당 테이블의 모든 행을 대상으로 업데이트가 일어난다.
-- UPDATE, DELETE 절에 WHERE 절이 없으면 의도한게 맞는지 다시한번 확인 해 보아야 한다.
-- WHERE 절이 있다고 하더라도 해당 조건으로 해당 테이블을 SELECT 하는 쿼리를 작성하여 실행하면 UPDATE 대상 행을 조회 할 수 있으므로
-- 확인 하고 실행하는 것도 사고 발생 방지에 도움이 된다.

-- 99번 부서번호를 갖는 부서 정보가 DEPT테이블에 있는 상황
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept;

-- 99번 부서번호를 갖는 부서의 dname 컬럼의 값을 '대덕IT', loc컬럼의 값을 '영민빌딩'으로 업데이트;
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;
ROLLBACK;

-- 업데이트 하려는 대상이 나옴. 확인해 볼 것.
SELECT *
FROM dept
WHERE deptno = 99;

-- 실수로 WHERE절을 기술하지 않았을 경우
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩';
-- WHERE deptno = 99;


-- SMITH, WARD이 속한 부서에 소속된 직원 정보
SELECT  *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD')); -- 서브 쿼리 사용시 스미스가 다른 부서를 가도 사용이 가능.
                 
-- UPDATE시에도 서브 쿼리 사용이 가능
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
-- 9999번 사원 deptno, job 정보를 SMITH 사원이 속한 부서정보, 담당업무로 업데이트
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;

ROLLBACK;

-- DML(DELETE) : 특정 행을 삭제
-- DELETE [FROM] 테이블명 WHERE 행 제한 조건
SELECT *
FROM dept;

DELETE dept          -- 부서번호가 99번인 '행' 삭제
WHERE deptno = 99;
COMMIT;

-- SUBQUERY를 통해서 특정 행을 제한하는 조건을 갖는 DELETE
-- 매니저가 7698 사번인 직원을 삭제 하는 쿼리를 작성

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);

SELECT *
FROM emp;
                
ROLLBACK;