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