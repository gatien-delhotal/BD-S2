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

--R89
SELECT nomBungalow
FROM Bungalows b
JOIN Proposer p ON p.idBungalow = b.idBungalow
WHERE idService IN(
	SELECT idService
	FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow)
AND idService NOT IN(
	SELECT idService
	FROM Bungalows b
	JOIN Proposer p ON p.idBungalow = b.idBungalow
	MINUS
	SELECT idService
	FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow);