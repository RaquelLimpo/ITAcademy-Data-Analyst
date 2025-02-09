#                                    #                                      ********Nivell 1********
# **Exercici 1**
#La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit.
#La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules 
#("transaction" i "company"). 
#Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
#Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(20) PRIMARY KEY,
	iban VARCHAR(50) NOT NULL,
	pan VARCHAR(50) NOT NULL,
	pin VARCHAR(4) NOT NULL,
	cvv INT NOT NULL,
	expiring_date VARCHAR(20) NOT NULL
    );
    
CREATE INDEX credit_card_id_idx
	ON transaction(credit_card_id);
    
ALTER TABLE transaction
	ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card (id);
    
#Afegim dades manualment i les comprovem 
SELECT * FROM transactions.credit_card;

# **Exercici2**
#El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999.
# Recorda mostrar que el canvi es va realitzar
UPDATE credit_card
SET iban= 'R323456312213576817699999'
WHERE id = 'CcU-2938';

#Per verificar que s’ha realitzat el canvi
SELECT id, iban
FROM credit_card
WHERE id = 'CcU-2938';

# **Exercici 3**
#En la taula "transaction" ingressa un nou usuari
INSERT INTO credit_card(
id,
iban,
pan,
pin,
cvv,
expiring_date
)
VALUES ('CcU-9999','0','0','0','0','0');

SELECT * 
FROM credit_card 
WHERE id = 'CcU-9999';

INSERT INTO company (id) 
VALUES ('b-9999');

SELECT * 
FROM company 
WHERE id = 'b-9999';

INSERT INTO transaction (
    id, 
    credit_card_id, 
    company_id, 
    user_id, 
    lat, 
    longitude, 
    amount, 
    declined
) 
VALUES (
    '108B1D1D-5B23-A76C-55EF-C568E49A99DD', 
    'CcU-9999', 
    'b-9999', 
    '9999', 
    829.999, 
    -117.999, 
    111.11, 
    0
);

SELECT * 
FROM transaction 
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';


# **Exercici 4**
#Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. 
#Recorda mostrar el canvi realitzat.
ALTER TABLE credit_card DROP COLUMN pan;

#                                      ********Nivell 2********

# **Exercici 1**
#Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.
DELETE FROM transactions.transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

# **Exercici 2**
#La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
#S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
#Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
#Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
#Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW transactions.VistaMarketing AS
SELECT
    c.company_name AS Nom_Companyia,
    c.phone AS Telefon_Contacte,
    c.country AS Pais_Residencia,
    ROUND(AVG(t.amount),2) AS Mitjana_Compra
FROM
    transactions.company AS c
JOIN
    transactions.transaction AS t
ON
    c.id = t.company_id
GROUP BY
 Nom_Companyia, Telefon_Contacte, Pais_Residencia
ORDER BY
    Mitjana_Compra DESC;

# **Exercici 3**
#Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"
SELECT *
FROM transactions.VistaMarketing
WHERE Pais_Residencia = 'Germany';

#                                      ********Nivell 3********

# **Exercici 1**
#Modifiquem les taules perque coincideixin amb la imatge.
#Crear taula user

CREATE INDEX idx_user_id ON transaction(user_id);

CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)    
    );
#introduïm dades manualment i comprovem la taula 
SELECT * FROM transactions.user;   
ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES user (id);
SET foreign_key_checks = 1; 

#user: canviar nom a data_user, canvia email a personal_email
ALTER TABLE user RENAME  to data_user;
ALTER TABLE data_user RENAME COLUMN email to personal_email;

#company: esborrar columna website
ALTER TABLE company DROP COLUMN website;

#credit_card: afegir columna fecha_actual DATE
ALTER TABLE  credit_card ADD COLUMN fecha_actual DATE;

# **Exercici 2**
CREATE VIEW transactions.InformeTecnico AS
SELECT 
t.id AS ID_Transaccio,
u.name AS Nom_Usuari,
u.surname AS Cognom_Usuari,
cc.iban AS IBAN_Targeta,
c.company_name AS Nom_Companyia
FROM 
transactions.transaction AS t
JOIN 
transactions.data_user AS u ON t.user_id = u.id
JOIN 
transactions.credit_card AS cc ON t.credit_card_id = cc.id
JOIN 
transactions.company AS c ON t.company_id = c.id
ORDER BY 
ID_Transaccio DESC;