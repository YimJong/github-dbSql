--WHERE 2

-- emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate �����͸� ��ȸ�ϴ� ���� �ۼ�.
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982-01-01', 'YYYY-MM-DD') and hiredate <= TO_DATE('1983-01-01', 'YYYY-MM-DD'); 

-- where ���� ����ϴ� ���ǿ� ������ ��ȸ ����� ������ ��ġ�� �ʴ´�.
-- SQL�� ������ ������ ���� �ִ�.
-- ������ Ư¡ : ���տ��� ������ ����.
-- ���̺��� ������ ������� ����.
-- SELECT ����� ������ �ٸ����� ���� �����ϸ� �������� ����.
  --> �ذ��� ���Ͽ� ���ı�� ����(ORDER BY)

-- IN ������
-- Ư�� ���տ� ���ԵǴ��� ���θ� Ȯ��
-- �μ���ȣ�� 10�� Ȥ��(or) 20���� ���ϴ� ���� ��ȸ
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10 or deptno = 20;

SELECT empno, ename, deptno
FROM emp
WHERE deptno in(10, 20);

-- emp���̺��� ��� �̸��� SMITH, JONES�� ������ ��ȸ (empno, ename, deptno)
SELECT empno, ename, deptno
FROM emp
WHERE ename in('SMITH', 'JONES');

DESC users;

SELECT userid as ���̵�, usernm as �̸�, alias as ����
FROM users
WHERE userid in('brown', 'cony', 'sally');

-- ���ڿ� ��Ī ������ : LIKE, %, _
-- ������ ������ ������ ���ڿ� ��ġ�� ���Ͽ� �ٷ�
-- �̸��� BR�� �����ϴ� ����� ��ȸ
-- �̸��� R ���ڿ��� ���� ����� ��ȸ

-- ��� �̸��� S�� �����ϴ� ��� ��ȸ
-- % � ���ڿ�(�ѱ���, ���� �������� �ְ�, ���� ���ڿ��� �� ���� �ִ�.)
SELECT *
FROM emp
WHERE ename LIKE 'S%';

-- ���ڼ��� ������ ���� ��Ī
-- '_' ��Ȯ�� �� ���ڸ� ����
-- ���� �̸��� S�� �����ϰ� �̸��� ��ü ���̰� 5������ ����
SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- ��� �̸��� S���ڰ� ���� ��� ��ȸ
SELECT *
FROM emp
WHERE ename LIKE '%S%';

--member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ�ϴ� ���� �ۼ�.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

-- where5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

-- null �� ���� (IS)
SELECT *
FROM emp
WHERE comm IS null;

-- where6
SELECT *
FROM emp
WHERE comm IS NOT null;

-- ����� �����ڰ� 7698, 7839 �׸��� null�� �ƴ� ������ ��ȸ
-- NOT IN �����ڿ����� NULL ���� ���� ��Ű�� �ȵȴ�.
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839) AND mgr IS NOT NULL;

-- WHERE 7
SELECT *
FROM emp
WHERE job = 'SALESMAN' and hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 8
SELECT *
FROM emp
WHERE deptno <> 10 and hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 9
SELECT *
FROM emp
WHERE deptno not in(10) and hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 10
SELECT *
FROM emp
WHERE deptno in(20, 30) and hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 11
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- WHERE 12
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

-- WHERE 13
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899;

-- ������ �켱����
-- *, / �����ڰ� +, - ���� �켱������ ����.
-- �켱���� ���� : ()
-- AND > OR

--emp ���̺��� ����̸��� SMITH �̰ų� ��� �̸��� ALLEN �̸鼭 �������� SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE ename = 'SMITH' OR (ename = 'ALLEN' and JOB = 'SALESMAN');

-- ��� �̸��� SMITH �̰ų� ALLEN �̸鼭 ��� ������ SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') AND JOB = 'SALESMAN';

-- WHERE 14
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%' AND hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-- ����
-- SELSECT *
-- FROM table
-- [WHERE]
-- ORDER BY (�÷�|��Ī|�÷��ε��� [ASC | DESC], ....)

-- emp ���̺��� ��� ����� ename �÷� ���� �������� �������� ������ ����� ��ȸ
SELECT *
FROM emp
ORDER BY ename ASC;

-- emp ���̺��� ��� ����� ename �÷� ���� �������� �������� ������ ����� ��ȸ
SELECT *
FROM emp
ORDER BY ename DESC; -- DECENDING,  DESC emp; -- DESCRIBE 

-- emp ���̺��� ��� ������ ename �÷����� ��������, ename ���� ���� ��� mgr �÷����� ������������ �����ϴ� ���� �ۼ�.
SELECT *
FROM emp
ORDER BY ename DESC, mgr ASC;

SELECT empno, ename as nm
FROM emp
ORDER BY nm ASC;

-- ��Ī���� ����
SELECT empno, ename as nm, sal * 12 as year_sal
FROM emp
ORDER BY year_sal ASC;

-- �÷� �ε����� ����
-- Java�� �迭�� 0���� ������.
SELECT empno, ename as nm, sal * 12 as year_sal -- ���ʴ�� 1, 2, 3 �÷� �ε���[�迭], 1���� ������.
FROM emp
ORDER BY 3;

-- ORDER BY 1
SELECT *
FROM dept
ORDER BY dname  ASC;

SELECT *
FROM dept
ORDER BY loc DESC;

-- ORDER BY 2
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm <> 0
ORDER BY comm DESC, empno ASC;

-- ORDER BY3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job ASC, empno DESC;