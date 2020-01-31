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