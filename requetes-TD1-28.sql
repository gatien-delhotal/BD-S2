--R28
SELECT nomEmploye, prenomEmploye, NVL(nomCamping, 'Pas affecté à un camping')
FROM Employes
LEFT JOIN Campings;