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