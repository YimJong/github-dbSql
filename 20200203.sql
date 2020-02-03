SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;

SELECT *
FROM daily;

SELECT *
FROM batch;

-- join4
SELECT cid, c.cnm, cy.pid, cy.day, cy.cnt
FROM customer c NATURAL JOIN cycle cy
WHERE c.cnm in ('brown', 'sally');
-- NATURAL JOIN시 조인컬럼에 테이블 별칭이나 이름 붙이지 말 것.

-- join5
SELECT c.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM customer c JOIN cycle cy ON (c.cid = cy.cid)
     JOIN product p ON (cy.pid = p.pid)
WHERE c.cnm in ('brown', 'sally');

SELECT c.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM customer c, cycle cy, product p
WHERE c.cid = cy.cid AND cy.pid = p.pid
AND c.cnm in ('brown', 'sally');
     
-- join6
SELECT c.cid, c.cnm, cy.pid, p.pnm, sum(cy.cnt) AS cnt
FROM customer c JOIN cycle cy ON (c.cid = cy.cid)
     JOIN product p ON (cy.pid = p.pid)
GROUP BY c.cnm, p.pnm, c.cid, cy.pid
ORDER BY c.cid ASC;


SELECT c.cid, c.cnm, cy.pid, p.pnm, sum(cy.cnt) AS cnt
FROM customer c, cycle cy, product p
WHERE c.cid = cy.cid and cy.pid = p.pid
GROUP BY c.cnm, p.pnm, c.cid, cy.pid
ORDER BY c.cid ASC;



-- join7
SELECT p.pid, p.pnm, sum(cy.cnt) AS cnt
FROM cycle cy JOIN product p ON (cy.pid = p.pid)
GROUP BY p.pid, p.pnm
ORDER BY p.pid ASC;

SELECT p.pid, p.pnm, sum(cy.cnt) AS cnt
FROM cycle cy, product p
WHERE cy.pid = p.pid
GROUP BY p.pid, p.pnm
ORDER BY p.pid ASC;


-- OUTER JOIN
-- 두 테이블을 조인할 때 연결 조건을 만족 시키지 못하는 데이터를
-- 기준으로 지정한 테이블의 데이터만이라도 조회 되게끔 하는 조인 방식

-- 연결조건 : e.mgr = m.empno : king의 mgr이 null이기 때문에 조인에 실패한다.
-- EMP테이블의 데이터는 총 14건이지만 아래와 같은 쿼리에서는 결과가 13건이 된다 (1건 조인실패)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- ANSI OUTER
-- 조인에 실패하더라도 조회가 될 테이블을 선정 (매니저 정보가 없어도 사원정보는 나오게끔)

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON( e.mgr = m.empno );

-- RIGHT OUTER로 변경. (테이블의 순서가 중요)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON( e.mgr = m.empno );

-- ORACLE OUTER JOIN
-- 데이터가 없는 쪽의 테이블 컬럼 뒤에 (+)기호를 붙여준다.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

-- ANSI 조인으로 변경
-- 매니저의 부서번호가 10번인 직원만 조회
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON ( e.mgr = m.empno AND m.deptno = 10);

-- JOIN 먼저 한 후 필터링 됨.
-- 일반 조인과 결과가 같음.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON ( e.mgr = m.empno )
WHERE m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno   -- 같은 결과
FROM emp e JOIN emp m ON ( e.mgr = m.empno )
WHERE m.deptno = 10;

-- ORACLE OUTER JOIN
-- 오라클 OUTER JOIN시 기준 테이블의 반대편 테이블의 모든 컬럼에 (+)을붙여야 정상적인 OUTER JOIN으로 동작한다.
-- 하나의 컬럼이라도 (+)를 누락하면 INNER 조인으로 동작한다.

-- 아래 ORACLE OUTER 조인은 INNER 조인으로 동작 : m.deptno 컬럼에 (+)가 붙지 않음.
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno = 10;

-- 정상적인 ORACLE OUTER JOIN
SELECT e.empno, e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno(+) = 10;

-- 사원 - 매니저간 RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

-- FULL OUTER = LEFT OUTER + RIGHT OUTER - 중복
SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

-- OUTER JOIN 1
-- ANSI
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
                                        AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));
-- ORACLE
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');


-- OUTER JOIN 2
-- ANSI
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'YY/MM/DD')) AS buy_date,
       b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));
-- ORACLE
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'YY/MM/DD')) AS buy_date,
       b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id 
AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

-- OUTER JOIN 3
-- ANSI
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'YY/MM/DD')) AS buy_date, b.buy_prod, p.prod_id, p.prod_name, 
       NVL(b.buy_qty, 0)
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));
-- ORACLE
SELECT NVL(b.buy_date, TO_DATE('05/01/25', 'YY/MM/DD')) AS buy_date, b.buy_prod, p.prod_id, p.prod_name, 
       NVL(b.buy_qty, 0)
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id 
AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');


-- OUTER JOIN 4
SELECT p.pid, p.pnm, NVL(cy.cid, 1) AS cid, NVL(cy.day,0) AS day, NVL(cy.cnt, 0) AS cnt
FROM cycle cy RIGHT OUTER JOIN product p ON (cy.pid = p.pid AND cy.cid = 1);


-- OUTER JOIN 5
SELECT p.pid, p.pnm, NVL(cid, 1) AS cid, NVL(c.cnm, 'brown') AS cnm,
       NVL(cy.day, 0) AS day, NVL(cy.cnt, 0) AS day
FROM customer c JOIN cycle cy USING (cid)
     RIGHT OUTER JOIN product p ON (cy.pid = p.pid AND cid = 1)
ORDER BY p.pid DESC;