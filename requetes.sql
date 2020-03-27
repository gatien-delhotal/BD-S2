--R11

SELECT nomEmploye, prenomEmploye
FROM Employes
WHERE salaireEmploye > 2000;

--R12

SELECT nomCamping
FROM Campings
WHERE nbEtoilesCamping=5 AND villeCamping='Palavas';

--R13

SELECT nomEmploye, prenomEmploye
FROM Employes e JOIN Campings c ON e.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus'
ORDER BY salaireEmploye;

--R14

SELECT nomEmploye, prenomEmploye
FROM Employes
WHERE idEmployeChef IN (
	SELECT idEmploye 
	FROM Employes 
	WHERE nomEmploye = 'Alizan' AND prenomEmploye = 'Gaspard');

--R15

SELECT nomClient, prenomClient
FROM Clients
WHERE idClient IN(
	SELECT idClient
	FROM  Locations
	WHERE '14-07-2017' BETWEEN dateDebut AND dateFin
	AND idBungalow IN (
		SELECT idBungalow
		FROM Bungalows b JOIN Campings c ON c.idCamping = b.idCamping
		WHERE nomCamping = 'Les Flots Bleus'));

--R16

SELECT nomClient, prenomClient
FROM Clients
WHERE idClient IN (
	SELECT DISTINCT idClient
	FROM Locations
	WHERE dateDebut < '31-07-2017'
	AND dateFin > '01-07-2017'
	AND idBungalow IN (
		SELECT idBungalow
		FROM Bungalows b JOIN Campings c ON b.idCamping = c.idCamping
		WHERE nomCamping = 'Les Flots Bleus'));

--R17

SELECT nomClient, prenomClient
FROM Clients
WHERE villeClient IN(
	SELECT DISTINCT villeCamping
	FROM Campings);

--R18

SELECT COUNT(DISTINCT idService) AS nbDeSservices
FROM Proposer p JOIN Bungalows b on p.idBungalow = b.idBungalow
WHERE nomBungalow = 'Le Titanic';

--R19

SELECT MAX(salaireEmploye)
FROM Employes
WHERE idCamping = (
	SELECT idCamping
	FROM Campings
	WHERE nomCamping = 'Les Flots Bleus');

--R20

SELECT COUNT(DISTINCT idCamping)
FROM Locations l JOIN Clients c on l.idClient = c.idClient JOIN Bungalows b on l.idBungalow = b.idBungalow
WHERE nomClient = 'Zeblouse'
AND prenomClient = 'Agathe';

--R21

SELECT nomBungalow
FROM Bungalows
WHERE superficieBungalow = (SELECT MAX(superficieBungalow) FROM Bungalows);

--R22

SELECT nomEmploye, prenomEmploye
FROM Employes
WHERE salaireEmploye =(
	SELECT MIN(salaireEmploye)
	FROM Employes
	WHERE idCamping = (
		SELECT idCamping
		FROM Campings
		WHERE nomCamping = 'Les Flots Bleus'))
AND idCamping = (SELECT idCamping
	FROM Campings
	WHERE nomCamping = 'Les Flots Bleus');

--R23

SELECT nomBungalow
FROM Bungalows
WHERE idBungalow NOT IN(
	SELECT idBungalow
	FROM Proposer);

--R23bis
SELECT nomBungalow
FROM Bungalows
MINUS
SELECT nomBungalow
FROM Bungalows
WHERE idBungalow IN(
	SELECT idBungalow
	FROM Proposer);

--R24

SELECT nomEmploye
FROM Employes
MINUS
SELECT nomEmploye;

--R25

SELECT nomBungalow
FROM Bungalows
WHERE idBungalow NOT IN(
	SELECT idBungalow
	FROM Proposer p 
	JOIN Services s ON p.idService = s.idService
	WHERE nomService = 'Climatisation' 
	OR nomService = 'TV'
	);

--R26

SELECT DISTINCT nomService
FROM Services s JOIN Proposer p ON s.idService = p.idService
JOIN Bungalows b ON p.idBungalow = b.idBungalow
JOIN Campings c ON b.idCamping = c.idCamping
WHERE nomCamping = 'La décharge Monochrome'
INTERSECT
SELECT DISTINCT nomService
FROM Services s JOIN Proposer p ON s.idService = p.idService
JOIN Bungalows b ON p.idBungalow = b.idBungalow
JOIN Campings c ON b.idCamping = c.idCamping
WHERE nomCamping = 'The White Majestic'
--Plus rapide de faire avec les id depuis proposer puis SELECT nomService WHERE idService IN

--R27

--R28

SELECT nomEmploye, prenomEmploye, NVL(nomCamping, 'Pas affecté à un camping')
FROM Employes
LEFT JOIN Campings;

--R30

SELECT nomBungalow
FROM Bungalows
WHERE idBungalow IN(
	SELECT idBungalow
	FROM Bungalows
	MINUS
	SELECT idBungalow
	FROM Locations);

--R30 bis

SELECT nomBungalow
FROM Bungalows
WHERE idBungalow NOT IN(
	SELECT idBungalow
	FROM Locations);

--R30 ter

SELECT nomBungalow
FROM Bungalows b
WHERE NOT EXISTS(
	SELECT idBungalow
	FROM Locations l
	WHERE b.idBungalow = l.idBungalow);

--R31

SELECT nomCamping
FROM Campings c
WHERE NOT EXISTS(
	SELECT idEmploye
	FROM Employes e
	WHERE c.idCamping = e.idCamping);

--R31 bis -> ne retourne aucune ligne

SELECT nomCamping
FROM Campings c
WHERE idCamping NOT IN(
	SELECT idCamping
        FROM Employes);

--R32

SELECT nomService
FROM Services s
WHERE categorieService = 'Loisir'
OR NOT EXISTS(
	SELECT idService
	FROM Proposer p 
	JOIN Bungalows b ON b.idBungalow = p.idBungalow
	JOIN Campings c ON b.idCamping = c.idCamping
	WHERE p.idService = s.idService
	AND nomCamping = 'The White Majestic');

--R33

SELECT nomClient 
FROM Clients c
WHERE villeClient = 'Montpellier'
AND NOT EXISTS(
	SELECT idClient AS pasDeService
	FROM (Locations l JOIN (
		SELECT idBungalow AS b
		FROM Bungalows
		WHERE idBungalow NOT IN(SELECT idBungalow FROM Proposer))
		ON l.idBungalow = b.idBungalow)
	WHERE c.idClient = pasDeService.idClient);

--R5A

SELECT COUNT(*), categorieService
FROM Services
GROUP BY categorieService;

--R5B

SELECT villeClient
FROM Clients
GROUP BY villeClient
HAVING COUNT(*)>=3;

--R50

SELECT COUNT(*), nomClient
FROM Locations l
JOIN Clients c ON c.idClient = l.idClient
GROUP BY nomClient, c.idClient
ORDER BY COUNT(*) DESC;

--R51

SELECT nomCamping, AVG(salaireEmploye)
FROM Employes e
JOIN Campings c ON e.idCamping = c.idCamping
GROUP BY nomCamping;

--R53

SELECT nomCamping
FROM Campings c
JOIN Employes e ON e.idCamping = c.idCamping
GROUP BY c.idCamping, nomCamping
HAVING COUNT(*)  > 3;

--R54 PAS OK DU TOUT

SELECT nomCamping
FROM Campings c
JOIN Bungalows b ON b.idCamping = c.idCamping
GROUP BY nomCamping
HAVING MIN(superficieBungalow) < 65
ORDER BY COUNT(*);

--R55

SELECT nomCamping
FROM Campings c 
JOIN Employes e ON c.idCamping =  e.idCamping
GROUP BY nomCamping
HAVING MIN(salaireEmploye) >= 1000;

--R56

SELECT nomBungalow
FROM Bungalows b
JOIN Proposer s ON b.idBungalow = s.idBungalow
GROUP BY nomBungalow
HAVING COUNT(*) = (SELECT COUNT(*)
	FROM Bungalows b
	JOIN Proposer s ON b.idBungalow = s.idBungalow
	WHERE nomBungalow = 'Le Royal');

--R57

SELECT nomBungalow, COUNT(idService)
FROM Bungalows b
LEFT JOIN Proposer p 
ON b.idBungalow = p.idBungalow
GROUP BY nomBungalow, b.idBungalow
ORDER BY COUNT(idService) DESC;

--R58

SELECT nomBungalow, nomCamping
FROM Bungalows b
JOIN Campings c ON b.idCamping = c.idCamping
WHERE idBungalow IN(
	SELECT idBungalow
	FROM Locations
	GROUP BY idBungalow, dateFin, dateDebut
	HAVING dateFin > '01-06-2017'
	AND dateDebut < '30-06-2017');




--R70

SELECT nomBungalow
FROM Bungalows b 
JOIN Proposer p ON b.idBungalow = p.idBungalow
GROUP BY b.idBungalow, nomBungalow
HAVING COUNT(idService) = (SELECT COUNT(*) FROM Services);

--R70 but cooler

SELECT nomBungalow
FROM Bungalows b
WHERE NOT EXISTS (
	SELECT idService
	FROM Services s
	MINUS
	SELECT idService
	FROM Proposer p
	WHERE p.idBungalow = b.idBungalow);

--R71

SELECT nomBungalow 
FROM Bungalows b
JOIN Proposer p ON b.idBungalow = p.idBungalow
JOIN Services s ON s.idService = p.idService
WHERE categorieService = 'Luxe'
GROUP BY b.idBungalow, nomBungalow
HAVING COUNT(*) = (SELECT COUNT(*)
	FROM Services
	WHERE categorieService = 'Luxe');

--R71 but cooler

SELECT nomBungalow
FROM Bungalows b
WHERE NOT EXISTS (
	SELECT idService
	FROM Services
	WHERE categorieService = 'Luxe'
	MINUS 
	SELECT idService
	FROM Proposer p
	WHERE p.idBungalow = b.idBungalow);


--R81

SELECT c.idClient, nomClient, prenomClient
FROM Clients c
WHERE idClient NOT IN(
	SELECT c.idClient
	FROM Clients c
	JOIN Locations l ON c.idClient = l.idClient
	JOIN Bungalows b ON b.idBungalow = l.idBungalow
	JOIN Campings ca ON ca.idCamping = b.idCamping
	WHERE villeCamping = 'Palavas'
	)
ORDER BY nomClient, prenomClient;

--R82

SELECT nomService
FROM Services s
JOIN Proposer p ON p.idService = s.idService
JOIN Bungalows b ON b.idBungalow = p.idBungalow
JOIN Campings c ON c.idCamping = b.idCamping
WHERE nomCamping = 'Les Flots Bleus'
AND superficieBungalow = (
	SELECT MAX(superficieBungalow)
	FROM Bungalows b 
	JOIN Campings c ON b.idCamping = c.idCamping
	WHERE nomCamping = 'Les Flots Bleus');

--R83 BAH YAPADEWHERE	

SELECT nomBungalow, COUNT(idLocation) AS nbLoc
FROM Bungalows b
LEFT JOIN Locations l ON b.idBungalow = l.idBungalow
AND dateDebut<='30-06-2017'
AND dateFin >= '01-06-2017'
GROUP BY b.idBungalow, nomBungalow
ORDER BY nbLoc DESC;

--R84

SELECT villeCamping
FROM Campings
GROUP BY villeCamping
HAVING COUNT(*)>1


--R85
SELECT nomClient
FROM Clients c
JOIN Locations l ON c.idClient = l.idClient
GROUP BY c.idClient, nomClient
HAVING COUNT(idLocation) = (
	SELECT COUNT(idLocation)
	FROM Clients c
	JOIN Locations l ON c.idClient = l.idClient
	WHERE nomClient = 'Zeblouse'
	GROUP BY c.idClient, nomClient);

--R86

SELECT nomService
FROM Services s
JOIN Proposer p ON s.idService = p.idService
GROUP BY s.idService, nomService
HAVING COUNT(idBungalow) < 5;

--R87

SELECT nomCamping
FROM Campings c
JOIN Employes e ON c.idCamping = e.idCamping
GROUP BY c.idCamping, nomCamping
HAVING COUNT(idEmploye) = (SELECT MAX(COUNT(idEmploye))
	FROM  Employes
	GROUP BY idCamping);

--R88

SELECT nomBungalow
FROM Bungalows b
JOIN Proposer p ON b.idBungalow = p.idBungalow
JOIN Services s ON s.idService = p.idService
GROUP BY b.idBungalow, nomBungalow
HAVING COUNT( DISTINCT categorieService) = (SELECT COUNT(DISTINCT categorieService) FROM Services);

--R89 PAS BON

SELECT nomBungalow
FROM Bungalows b
JOIN Proposer p ON p.idBungalow = b.idBungalow
WHERE idService IN(
	SELECT idService
	FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
	WHERE nomBungalow = 'La Suite Régalienne')
MINUS
SELECT nomBungalow
FROM Bungalows b
JOIN Proposer p ON p.idBungalow = b.idBungalow
WHERE idService IN(
	SELECT idService
	FROM Bungalows b
	JOIN Proposer p ON p.idBungalow = b.idBungalow
	MINUS
	SELECT idService
	FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
		WHERE nomBungalow = 'La Suite Régalienne');
--Ca marche aps non plus...
SELECT nomBungalow
FROM Bungalows b
JOIN Proposer p ON p.idBungalow = b.idBungalow
WHERE NOT EXISTS(
	SELECT idService
	FROM Proposer p 
	JOIN Bungalows b ON b.idBungalow = p.idBungalow
	MINUS
	SELECT idService
	FROM Proposer p 
	JOIN Bungalows b ON b.idBungalow = p.idBungalow
	AND nomBungalow = 'La Suite Régalienne');


--R90

SELECT nomService, COUNT(b.idBungalow) AS nbBungalows
FROM Services s
JOIN Proposer p ON p.idService = s.idService
LEFT JOIN Bungalows b ON p.idBungalow = b.idBungalow
AND b.idBungalow IN(
	SELECT b.idBungalow
	FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
	GROUP BY b.idBungalow
	HAVING COUNT(idService)=1)
GROUP BY s.idService, nomService;

--R91

SELECT nomCamping, nomBungalow
FROM Campings c
JOIN Bungalows b ON b.idCamping = c.idCamping
WHERE idBungalow IN(
	SELECT b.idBungalow
	FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
	GROUP BY b.idCamping, b.idBungalow
	HAVING COUNT(idService) = (SELECT MAX(COUNT(idService))
			FROM Bungalows b
			JOIN Proposer p ON b.idBungalow = p.idBungalow
			GROUP BY b.idCamping));