
/*a*/
SELECT DISTINCT filiale.filialleiter
FROM filiale
    INNER JOIN artikel ON filiale.fid=artikel.fid
    INNER JOIN lieferant ON artikel.lid=lieferant.lid
WHERE lieferant.name='Druckwerk Trallala';
/*a*/

/*b*/
SELECT DISTINCT kunde.kid
FROM kunde
    INNER JOIN kauft ON kunde.kid = kauft.kid
    INNER JOIN artikel ON kauft.aid = artikel.aid
    INNER JOIN lieferant ON artikel.lid=lieferant.lid
WHERE lieferant.land != 'Schweiz';
/*b*/

/*c*/
SELECT DISTINCT kunde.kid
FROM kunde
    INNER JOIN kauft ON kunde.kid = kauft.kid
    INNER JOIN artikel ON kauft.aid = artikel.aid
    INNER JOIN artikeltyp ON artikel.typid = artikeltyp.typid
    INNER JOIN bietetan ON artikeltyp.typid = bietetan.typid
    INNER JOIN lieferant ON bietetan.lid = lieferant.lid
WHERE lieferant.land = 'Schweiz';
/*c*/

/*d*/
SELECT artikeltyp.bezeichnung, count(artikeltyp.typid)
FROM artikeltyp
    INNER JOIN artikel ON artikeltyp.typid = artikel.typid
WHERE artikel.fid IS NULL
GROUP BY artikeltyp.typid;
/*d*/

/*e*/
SELECT kunde.kid, sum(artikeltyp.preis)
FROM kunde
    INNER JOIN kauft ON kunde.kid = kauft.kid
    INNER JOIN artikel ON kauft.aid = artikel.aid
    INNER JOIN artikeltyp ON artikel.typid = artikeltyp.typid
GROUP BY kunde.kid
ORDER BY kunde.kid;
/*e*/

/*f*/
SELECT artikeltyp.bezeichnung, lieferant.name
FROM artikeltyp
    INNER JOIN bietetan ON artikeltyp.typid = bietetan.typid
    INNER JOIN lieferant ON lieferant.lid = bietetan.lid
    INNER JOIN
    (
SELECT artikeltyp.typid, min(bietetan.angebotspreis) AS minp
    FROM artikeltyp
        INNER JOIN bietetan ON artikeltyp.typid = bietetan.typid
        INNER JOIN lieferant ON lieferant.lid = bietetan.lid
    WHERE artikeltyp.typid IN (
SELECT g.typid
    FROM (
SELECT artikel.typid, count(artikel.typid) AS numb
        FROM artikel
        WHERE artikel.aid NOT IN (
            SELECT kauft.aid
            FROM kauft
        ) AND artikel.fid IS NOT NULL
        GROUP BY artikel.typid) AS g
    WHERE numb < 400
)
    GROUP BY artikeltyp.typid
) AS h ON h.minp = bietetan.angebotspreis AND h.typid = artikeltyp.typid;
/*f*/


