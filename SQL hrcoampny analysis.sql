
-- 2. Parodykite visus darbuotojus: vardus ir pavardes
SELECT FirstName,LastName FROM employees;

-- 3. Filtruokite pagal skyrius: gaukite darbuotojų sąrašą, kurie dirba HR skyriuje.

SELECT FirstName, LastName , DepartmentName
FROM employees AS e
INNER JOIN
departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'HR';

-- 4. Surikiuokite darbuotojus: gaukite darbuotojų sąrašą, surikiuotą pagal jų įdarbinimo
-- datą didėjimo tvarka.

SELECT * 
FROM employees
ORDER BY HireDate;

-- 5. Suskaičiuokite darbuotojus: raskite kiek iš viso įmonėje dirba darbuotojų.

SELECT COUNT(*) 
FROM employees;

-- 6. Sujunkite darbuotojus su skyriais: išveskite bendrą darbuotojų sąrašą, šalia
-- kiekvieno darbuotojo nurodant skyrių kuriame dirba.

SELECT FirstName, LastName , DepartmentName
FROM employees AS e
INNER JOIN
departments d ON e.DepartmentID = d.DepartmentID;

-- 7. Apskaičiuokite vidutinį atlyginimą: suraskite koks yra vidutinis atlyginimas
-- įmonėje tarp visų darbuotojų.

SELECT AVG(SalaryStartDate) AS avg_salary
FROM salaries;

-- 8. Išfiltruokite ir suskaičiuokite: raskite kiek darbuotojų dirba IT skyriuje.

SELECT COUNT(EmployeeID) AS IT_darbuotoju
FROM employees AS e
INNER JOIN
departments d ON e.DepartmentID = d.DepartmentID
WHERE DepartmentName = 'IT';

-- 9. Išrinkite unikalias reikšmes: gaukite unikalių siūlomų darbo pozicijų sąrašą iš
-- jobpositions lentelės.

SELECT DISTINCT(PositionTitle) AS darbo_pozicijos
FROM jobpositions;

-- 10. Išrinkite pagal datos rėžį: gaukite darbuotojus, kurie buvo nusamdyti tarp 2020-02-
-- 01 ir 2020-11-01.

SELECT * 
FROM employees
WHERE HireDate BETWEEN '2020-02-01' AND '2020-11-01';

-- 11. Darbuotojų amžius: gaukite kiekvieno darbuotojo amžių pagal tai kada jie yra gimę.

SELECT
FirstName,
LastName, 
YEAR(CURDATE())- YEAR(DateOfBirth) AS amzius
FROM employees
ORDER BY amzius;

-- 12. Darbuotojų el. pašto adresų sąrašas: gaukite visų darbuotojų el. pašto adresų sąrašą
-- abėcėline tvarka.

SELECT FirstName, LastName, email
FROM employees
ORDER BY email;

-- 13. Darbuotojų skaičius pagal skyrių: suraskite kiek kiekviename skyriuje dirba
-- darbuotojų.
SELECT 
DepartmentName AS skyrius,
COUNT(EmployeeID) AS darbuotoju_skaicius
FROM employees AS e
INNER JOIN
departments d ON e.DepartmentID = d.DepartmentID
GROUP BY DepartmentName;

-- 14. Darbštus darbuotojas: išrinkite visus darbuotojus, kurie turi daugiau nei 3 įgūdžius
-- (skills).

SELECT 
    e.employeeid,
    e.firstname,
    e.lastname,
    COUNT(es.skillid) AS igudziai
FROM 
    employees e
JOIN 
    employeeskills es ON e.employeeid = es.employeeid
GROUP BY 
      e.employeeid,
    e.firstname,
    e.lastname
HAVING 
    COUNT(es.skillid) > 3;


-- 15. Vidutinė papildomos naudos kaina: apskaičiuokite vidutines papildomų naudų
-- išmokų (benefits lentelė) išlaidas darbuotojams.

SELECT 
    AVG(b.cost) AS average_benefit_cost
FROM 
    employeebenefits eb
JOIN 
    benefits b ON eb.benefitid = b.benefitid;


-- 16. Jaunausias ir vyriausias darbuotojai: suraskite jaunausią ir vyriausią darbuotoją
-- įmonėje.

-- Rasti vyriausią darbuotoją-- 
SELECT 
    firstname, 
    lastname, 
    ROUND(DATEDIFF(CURDATE(),DateOfBirth)/365) AS amzius
FROM 
    employees
GROUP BY firstname, lastname,amzius
ORDER BY amzius DESC
LIMIT 1;

-- Rasti jauniausią darbuotoją
SELECT 
    firstname, 
    lastname, 
    ROUND(DATEDIFF(CURDATE(),DateOfBirth)/365) AS amzius
FROM 
    employees
GROUP BY firstname, lastname,amzius
ORDER BY amzius
LIMIT 1;

-- Bendrai vienoje lentelėje.  
SELECT 
    MIN(emp.firstname)AS jauniausias_vardas, 
    MIN(emp.lastname) AS jauniausias_pavarde, 
    MIN(ROUND(DATEDIFF(CURDATE(), emp.DateOfBirth) / 365)) AS jauniausias_amzius,
    MAX(emp2.firstname) AS vyriausias_vardas, 
    MAX(emp2.lastname) AS vyriausias_pavarde, 
    MAX(ROUND(DATEDIFF(CURDATE(), emp2.DateOfBirth) / 365)) AS vyriausias_amzius
FROM 
    employees emp
CROSS JOIN 
    employees emp2
WHERE 
    emp.DateOfBirth = (SELECT MIN(DateOfBirth) FROM employees)
    OR emp2.DateOfBirth = (SELECT MAX(DateOfBirth) FROM employees);

-- 17. Skyrius su daugiausiai darbuotojų: suraskite kuriame skyriuje dirba daugiausiai
-- darbuotojų.

SELECT 
	COUNT(e.EmployeeID) AS darbuotoju_skaicius,
	d.DepartmentName
FROM employees e
JOIN 
	departments d ON e.DepartmentID=d.DepartmentID
GROUP BY DepartmentName
ORDER BY darbuotoju_skaicius DESC;

-- Antras variantas 17 atsakymas 
SELECT * 
FROM (SELECT 
         DepartmentID, 
         COUNT(*) AS darbuotoju_skaicius
     FROM 
         employees e
     GROUP BY 
         departmentid
     ORDER BY 
         darbuotoju_skaicius DESC) AS employees 
JOIN 
	departments d ON employees.DepartmentID=d.DepartmentID
ORDER BY darbuotoju_skaicius;


-- 18. Tekstinė paieška: suraskite visus darbuotojus su žodžiu “excellent” jų darbo
-- atsiliepime (performancereviews lentelė).

SELECT 
    e.employeeid,
    e.firstname,
    e.lastname,
    ReviewText
FROM 
    employees e
JOIN 
    performancereviews p ON e.employeeid = p.employeeid
    WHERE p.ReviewText LIKE '%excellent%'; 

-- 19. Darbuotojų telefono numeriai: išveskite visų darbuotojų ID su jų telefono
-- numeriais.
SELECT EmployeeID,
	FirstName,
    LastName,
    Phone
FROM employees;

-- 20. Darbuotojų samdymo mėnesis: suraskite kurį mėnesį buvo nusamdyta daugiausiai
-- darbuotojų.

SELECT COUNT(*) AS daugiausiai_darbuotoju_nusamdyta,
	MONTH(HireDate) AS menuo
FROM employees
GROUP BY menuo
ORDER by daugiausiai_darbuotoju_nusamdyta DESC
LIMIT 1;


-- 21. Darbuotojų įgūdžiai: išveskite visus darbuotojus, kurie turi įgūdį “Communication”.

SELECT e.firstname, 
	e.lastname, 
	s.skillname
FROM employees e
JOIN 
	employeeskills es ON e.employeeid = es.employeeid
JOIN 
	skills s ON es.skillid = s.skillid
WHERE s.skillname = 'Communication';


-- 22. Sub-užklausos: suraskite kuris darbuotojas įmonėje uždirba daugiausiai ir išveskite


SELECT *
FROM employees e
JOIN 
	salaries s ON e.employeeid = s.employeeid
WHERE SalaryAmount LIKE (
SELECT SalaryAmount
FROM salaries
ORDER BY SalaryAmount DESC
LIMIT 1);


-- 23. Grupavimas ir agregacija: apskaičiuokite visas įmonės išmokų (benefits lentelė)
-- išlaidas.

SELECT SUM(b.cost) AS total_benefits
FROM employeebenefits eb
JOIN benefits b ON eb.benefitid = b.BenefitID;

-- 24. Įrašų atnaujinimas: atnaujinkite telefono numerį darbuotojo, kurio id yra 1.

UPDATE employees
SET Phone = '866666666'
WHERE employeeid = 1;


-- 25. Atostogų užklausos: išveskite sąrašą atostogų prašymų (leaverequests), kurie laukia
-- patvirtinimo.

SELECT *
FROM leaverequests
WHERE Status = 'Pending';

-- 26. Darbo atsiliepimas: išveskite darbuotojus, kurie darbo atsiliepime yra gavę 5 balus.
SELECT e.firstname, 
	e.lastname, 
	p.reviewtext,
    p.rating
FROM employees e
JOIN 
	performancereviews p ON e.employeeid = p.employeeid
WHERE p.rating = '5';

-- 27. Papildomų naudų registracijos: išveskite visus darbuotojus, kurie yra užsiregistravę
-- į “Health Insurance” papildomą naudą (benefits lentelė).

SELECT e.firstname, 
	e.lastname, 
	b.benefitname
FROM employees e
JOIN 
	employeebenefits eb ON e.employeeid = eb.employeeid
JOIN 
	benefits b ON eb.benefitid = b.BenefitID
WHERE b.benefitname = 'Health Insurance';


-- 28. Atlyginimų pakėlimas: parodykite kaip atrodytų atlyginimai darbuotojų, dirbančių
-- “Finance” skyriuje, jeigu jų atlyginimus pakeltume 10 %.

SELECT e.firstname, 
	e.lastname, 
    d.departmentname,
    s.salaryamount AS dabartinis_atlyginimas, 
	(s.salaryamount * 1.10) AS padidintas_atlyginimas,
    s.SalaryEndDate
FROM employees e
JOIN salaries s ON e.employeeid = s.employeeid
JOIN departments d ON e.DepartmentID = e.DepartmentID
WHERE d.departmentname = 'Finance';


-- 29. Efektyviausi darbuotojai: raskite 5 darbuotojus, kurie turi didžiausią darbo
-- vertinimo (performance lentelė) reitingą.

SELECT e.firstname, 
	e.lastname, 
	p.reviewtext,
    p.rating
FROM employees e
JOIN 
	performancereviews p ON e.employeeid = p.employeeid
WHERE p.rating = '5'
LIMIT 5;

-- 30. Atostogų užklausų istorija: gaukite visą atostogų užklausų istoriją (leaverequests
-- lentelė) darbuotojo, kurio id yra 1.

SELECT *
FROM leaverequests
WHERE EmployeeID = '1';

-- 31. Atlyginimų diapozono analizė: nustatykite atlyginimo diapazoną (minimalų ir
-- maksimalų) kiekvienai darbo pozicijai.

SELECT departmentName AS darbo_pozicijos, 
	MIN(SalaryAmount) AS minmalus_atlyginimas, 
	MAX(SalaryAmount) AS maximalus_atlyginimas
FROM employees e
JOIN salaries s ON e.employeeid = s.employeeid
JOIN departments d ON e.DepartmentID = e.DepartmentID
GROUP BY departmentName;

-- 32. Darbo atsiliepimo istorija: gaukite visą istoriją apie darbo atsiliepimus
-- (performancereviews lentelė), darbuotojo, kurio id yra 2.

SELECT *
FROM performancereviews
WHERE EmployeeID='2';

-- 33. Papildomos naudos kaina vienam darbuotojui: apskaičiuokite bendras papildomų
-- naudų išmokų išlaidas vienam darbuotojui (benefits lentelė).

SELECT 
	eb.EmployeeID,
    sum(b.cost) AS bendra_nauda_darbuotojui
FROM 
    employeebenefits eb
JOIN 
    benefits b ON eb.benefitid = b.benefitid
GROUP BY eb.EmployeeID
ORDER BY bendra_nauda_darbuotojui DESC;
    
-- 34. Geriausi įgūdžiai pagal skyrių: išvardykite dažniausiai pasitaikančius įgūdžius
-- kiekviename skyriuje.

SELECT s.SkillName, 
	d.DepartmentName,
    COUNT(SkillName) AS pasikartojantys_igudziai
FROM employees e
JOIN 
	employeeskills es ON e.employeeid = es.employeeid
JOIN 
	skills s ON es.skillid = s.skillid
JOIN
	departments d ON e.departmentID = d.DepartmentID
GROUP BY d.DepartmentName,s.SkillName;


-- 35. Atlyginimo augimas: apskaičiuokite procentinį atlyginimo padidėjimą kiekvienam
-- darbuotojui, lyginant su praėjusiais metais.

-- Suskaičiuoju 2023 metų atlyginimą 
SELECT EmployeeID, SalaryAmount , SalaryEndDate
FROM salaries
WHERE YEAR(SalaryEndDate) LIKE '2023';

-- Suskaičiuoju 2022 metų atlyginimą 

SELECT EmployeeID, SalaryAmount , SalaryEndDate
FROM salaries
WHERE YEAR(SalaryEndDate) LIKE '2022';

-- Atlyginimo augimas procentaliai 
SELECT e.firstname, 
	e.lastname, 
	 ROUND(((dabaratlyginimas.salaryamount - buvesatlyginimas.salaryamount) / buvesatlyginimas.salaryamount) * 100, 2) AS atlyginimo_augimas_procentais
FROM ( SELECT *
FROM salaries
WHERE YEAR(SalaryEndDate) LIKE '2023') AS dabaratlyginimas
JOIN (SELECT *
FROM salaries
WHERE YEAR(SalaryEndDate) LIKE '2022') AS buvesatlyginimas ON dabaratlyginimas.employeeid = buvesatlyginimas.employeeid
JOIN employees e ON e.EmployeeID = dabaratlyginimas.EmployeeID AND e.EmployeeID = buvesatlyginimas.EmployeeID
ORDER BY atlyginimo_augimas_procentais DESC;


-- 36. Darbuotojų išlaikymas: raskite darbuotojus, kurie įmonėje dirba daugiau nei 5 metai
-- ir kuriems per tą laiką nebuvo pakeltas atlyginimas.

-- Skaičiavimas kiek metų dirba
SELECT firstname,
	lastname,
    ROUND(DATEDIFF(CURDATE(),HireDate)/365) AS kiek_metu_dirba
FROM employees;

-- Skaičiavimas darbuotojų išlaikymo.
SELECT e.firstname, 
	e.lastname,
    ROUND((dabaratlyginimas.salaryamount - buvesatlyginimas.salaryamount),2) AS atlyginimo_pokytis,
    ROUND(DATEDIFF(CURDATE(),HireDate)/365) AS kiek_metu_dirba
FROM ( SELECT *
FROM salaries
WHERE YEAR(SalaryEndDate) LIKE '2023') AS dabaratlyginimas
JOIN (SELECT *
FROM salaries
WHERE YEAR(SalaryEndDate) LIKE '2022') AS buvesatlyginimas ON dabaratlyginimas.employeeid = buvesatlyginimas.employeeid
JOIN employees e ON e.EmployeeID = dabaratlyginimas.EmployeeID AND e.EmployeeID = buvesatlyginimas.EmployeeID
HAVING atlyginimo_pokytis >0 AND kiek_metu_dirba >=5
ORDER BY atlyginimo_pokytis DESC;
    

-- 37. Darbuotojų atlyginimų analizė: suraskite kiekvieno darbuotojo atlygį (atlyginimas
-- (salaries lentelė) + išmokos už papildomas naudas (benefits lentelė)) ir surikiuokite
-- darbuotojus pagal bendrą atlyginimą mažėjimo tvarka.


-- Skaičiuoju naudų sumą
SELECT eb.employeeID,
SUM(b.cost) AS naudu_suma
FROM benefits b
JOIN employeebenefits eb ON eb.BenefitID = b.BenefitID 
GROUP BY eb.EmployeeID
ORDER BY eb.EmployeeID;

-- Skaičiuoju 2023 metų atlyginimus

SELECT e.firstname,
	e.lastname,
    s.salaryamount
FROM employees e
JOIN 
	salaries s ON e.employeeid = s.employeeid
WHERE YEAR(SalaryEndDate) = '2023';

--  Sudedu į bendrą kodą suskaičiuoti galutinį užduoties rezultatą

SELECT 
    e.employeeid,
    e.firstname AS vardas,
    e.lastname AS pavarde,
    s.salaryamount AS 2023_metu_atlyginimas,
    COALESCE(naudos.naudu_suma, 0) AS papildomos_naudos,
    (s.salaryamount + COALESCE(naudos.naudu_suma, 0)) AS bendras_atlyginimas
FROM 
    employees e
JOIN 
    salaries s 
    ON e.employeeid = s.employeeid
    AND YEAR(s.salaryenddate) = 2023
LEFT JOIN 
    (SELECT eb.employeeid, 
            SUM(b.cost) AS naudu_suma
     FROM benefits b
     JOIN employeebenefits eb 
         ON eb.benefitid = b.benefitid
     GROUP BY eb.employeeid) AS naudos
ON e.employeeid = naudos.employeeid
ORDER BY 
    bendras_atlyginimas DESC;


-- 38. Darbuotojų darbo atsiliepimų tendencijos: išveskite kiekvieno darbuotojo vardą ir
-- pavardę, nurodant ar jo darbo atsiliepimas (performancereviews lentelė) pagerėjo ar
-- sumažėjo.

-- Išvedam reitingus pagal datas
SELECT 
	e.employeeid,
    e.firstname AS vardas,
    e.lastname AS pavarde,
    pr.rating,
    pr.ReviewDate
FROM employees e
JOIN 
	performancereviews pr ON pr.employeeid = e.employeeid;
    
-- Sukuriam atsiliepimų tendencijas pagal reitingo pokytį.
    
     SELECT 
        e.employeeid, 
        e.firstname AS vardas, 
        e.lastname AS pavarde, 
        pr1.ReviewDate AS pirmas_atsiliepimas_data, 
        pr1.Rating AS pirmas_atsiliepimas, 
        pr2.ReviewDate AS paskutinis_atsiliepimas_data, 
        pr2.Rating AS paskutinis_atsiliepimas,
        CASE 
            WHEN pr2.Rating > pr1.Rating THEN 'Pagerėjo'
            WHEN pr2.Rating < pr1.Rating THEN 'Sumažėjo'
            ELSE 'Nesikeitė'
        END AS tendencija
    FROM 
        employees e
    JOIN 
        performancereviews pr1 ON e.employeeid = pr1.employeeid
    JOIN 
        performancereviews pr2 ON e.employeeid = pr2.employeeid
    WHERE 
        pr1.ReviewDate = (SELECT MIN(ReviewDate) FROM performancereviews WHERE employeeid = e.employeeid)
        AND pr2.ReviewDate = (SELECT MAX(ReviewDate) FROM performancereviews WHERE employeeid = e.employeeid);
