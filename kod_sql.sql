-- vytvoření tabulky (ve Snowflake) z natažených tabulek z Kebooly

CREATE TABLE "Pocasi1" AS
SELECT * FROM "Teplota-minimalni" 
UNION ALL
SELECT * FROM "Teplota-maximalni" 
UNION ALL
SELECT * FROM "Teplota-prumerna" 
UNION ALL
SELECT * FROM "Srazky" 
UNION ALL
SELECT * FROM "Vitr" 
UNION ALL
SELECT * FROM "Vlhkost"
UNION ALL
SELECT * FROM "snih"
UNION ALL
SELECT * FROM "Slunecni_svit";


--Úprava spojené tabulky před natažením do Tableau

CREATE OR REPLACE TABLE "projekt_pocasi" AS
SELECT TO_DECIMAL(NULLIF(p."Hodnota", ''), '999.999', 10, 1) AS "Hodnota", p."prvek", p."stanice_ID", p."Rok", p."Mesic", p."Den", 
TO_DATE(CONCAT(p."Rok", '-', p."Mesic", '-', p."Den")) AS "Datum",
c."Jmeno_stanice", c."Okres", c."Obdobi", c."Kraj", c."Zemepisna_delka", c."Zemepisna_sirka", c."Nadmorska_vyska",
    CASE 
        WHEN p."prvek" = 'Teplota maximalni' AND "Hodnota" >= 30.0 THEN 'tropicky den'
        WHEN p."prvek" = 'Teplota maximalni' AND "Hodnota" >= 25.0 THEN 'letni den'
        WHEN p."prvek" = 'Teplota minimalni' AND "Hodnota" <= -10.0 THEN 'arkticky den'
        WHEN p."prvek" = 'Teplota minimalni' AND "Hodnota" <= 0.0 THEN 'mrazovy den'      
        ELSE 'bezny den'
    END AS "meteorologicke_typy"
FROM "pocasi1" AS p
JOIN "ciselnik-stanice_final" AS c ON p."stanice_ID" = c."stanice_ID"
WHERE "Hodnota" != '';
