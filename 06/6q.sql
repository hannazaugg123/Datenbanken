
SELECT
    Nachname, Vorname
FROM
    Angestellte INNER JOIN HaeltBetreut ON Angestellte.PersonalNr = HaeltBetreut.PersonalNr
    INNER JOIN Vorlesungen ON Vorlesungen.VorlesungsNr = HaeltBetreut.VorlesungsNr
WHERE
    Titel = 'Programmieren'
    AND Typ = 'Assistent';


SELECT DISTINCT
    Titel, ECTS
FROM
    Vorlesungen
WHERE
    Semester = 'fs11';


SELECT DISTINCT
    ECTS, Titel
FROM
    Angestellte, Vorlesungen, HaeltBetreut
WHERE
    Nachname = 'Zauder'
    AND Typ = 'Professor'
    AND Angestellte.PersonalNr = HaeltBetreut.PersonalNr
    AND Vorlesungen.VorlesungsNr = HaeltBetreut.VorlesungsNr;

