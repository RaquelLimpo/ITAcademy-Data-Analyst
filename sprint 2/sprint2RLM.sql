#Nivell 1 Exercici 2-a: Llistat dels països que estan fent compres.
SELECT DISTINCT country FROM transactions.company
INNER JOIN transactions.transaction
ON company.id = transaction.company_id
;
#Nivell 1 Exercici 2- b: Des de quants països es realitzen les compres.
SELECT COUNT(DISTINCT country) FROM transactions.company
INNER JOIN transactions.transaction
ON company.id = transaction.company_id
;
#Nivell 1 Exercici 2-c: Identifica la companyia amb la mitjana més gran de vendes.
SELECT round(AVG(amount),2) , company_name FROM transactions.transaction
INNER JOIN transactions.company
ON company.id = transaction.company_id
WHERE declined = 0
GROUP BY company_name
order by AVG(amount) Desc
LIMIT 1
;

#Nivell 1 Exercici 3-a: Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT company_name, country, amount, declined 
FROM  transactions.company, transactions.transaction
WHERE company_id IN
(SELECT company_id FROM transactions.company WHERE country LIKE 'Germany')
;

#Nivell 1 Exercici 3-b: Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT company_name, country 
FROM transactions.company 
WHERE id IN (
SELECT company_id 
FROM transactions.transaction 
WHERE amount > (
SELECT AVG(amount) 
FROM transactions.transaction))
;

#Nivell 1 Exercici 3-c: Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT * 
FROM transactions.company 
WHERE id NOT IN (
SELECT company_id 
FROM transactions.transaction)
;

#Nivell 2-1: Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes.
# Mostra la data de cada transacció juntament amb el total de les vendes.
SELECT DATE(timestamp) AS transaction_date, SUM(amount) AS total_sales
FROM transactions.transaction
GROUP BY transaction_date
ORDER BY total_sales DESC
LIMIT 5
;

#Nivell 2-2 Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà
SELECT company.country, AVG(transaction.amount) AS average_sales
FROM transactions.transaction
JOIN transactions.company ON transaction.company_id = company.id
GROUP BY company.country
ORDER BY average_sales DESC
;

#Nivell 2-3 En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
#Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

#2-3a: Mostra el llistat aplicant JOIN i subconsultes.
SELECT transaction.id, company_name, country, timestamp, amount
FROM transactions.transaction
JOIN transactions.company ON transaction.company_id = company.id
WHERE company.country = (
SELECT country
FROM transactions.company
WHERE company_name = 'Non Institute'
);

#2-3b: Mostra el llistat aplicant solament subconsultes.
SELECT *
FROM transactions.transaction
WHERE company_id IN (
	SELECT id
	FROM transactions.company
	WHERE country = (
		SELECT country
		FROM transactions.company
		WHERE company_name = 'Non Institute')
);
#Nivell 3-1: Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros
# i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. 
#Ordena els resultats de major a menor quantitat.
SELECT company_name, phone, country, timestamp, amount
FROM transactions.transaction
JOIN transactions.company ON transaction.company_id = company.id
WHERE transaction.amount BETWEEN 100 AND 200
AND DATE(timestamp) IN ('2021-04-29', '2021-07-20', '2022-03-13')
ORDER BY amount DESC
;

#Nivell 3-2 Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
#per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
#però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
SELECT company.company_name, 
company.country,
COUNT(transaction.id) AS transaction_count,
	CASE 
	WHEN COUNT(transaction.id) > 4 THEN 'Más de 4 transacciones'
	ELSE '4 o menos transacciones'
	END AS transaction_classification
FROM transactions.company
LEFT JOIN transactions.transaction ON company.id = transaction.company_id
GROUP BY company.company_name, company.country
ORDER BY transaction_count DESC;
