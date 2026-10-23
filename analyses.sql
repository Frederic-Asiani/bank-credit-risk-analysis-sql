-- 1. Portefeuille et ratio NPL (proxy pédagogique: retard >=90 jours).
SELECT COUNT(*) AS nombre_prets,ROUND(SUM(encours_usd),2) AS exposition_totale_usd,
 ROUND(SUM(CASE WHEN jours_retard>=90 THEN encours_usd ELSE 0 END),2) AS exposition_npl_usd,
 ROUND(100.0*SUM(CASE WHEN jours_retard>=90 THEN encours_usd ELSE 0 END)/NULLIF(SUM(encours_usd),0),2) AS ratio_npl_pct
FROM prets;

-- 2. Distribution des retards.
WITH tranches AS (
 SELECT encours_usd,CASE WHEN jours_retard=0 THEN '00.A jour'
 WHEN jours_retard<=30 THEN '01.1-30 jours'
 WHEN jours_retard<=60 THEN '02.31-60 jours'
 WHEN jours_retard<=89 THEN '03.61-89 jours' ELSE '04.90+ jours' END AS tranche
 FROM prets)
SELECT tranche,COUNT(*) AS prets,ROUND(SUM(encours_usd),2) AS exposition_usd
FROM tranches GROUP BY tranche ORDER BY tranche;

-- 3. Analyse de cohorte (vintage) selon le trimestre de l'octroi.
SELECT substr(date_octroi,1,4)||'-T'||((CAST(substr(date_octroi,6,2) AS INTEGER)+2)/3) AS trimestre_octroi,
 COUNT(*) AS nb_prets,ROUND(SUM(encours_usd),2) AS encours_usd,
 ROUND(100.0*SUM(CASE WHEN jours_retard>=90 THEN encours_usd ELSE 0 END)/NULLIF(SUM(encours_usd),0),2) AS ratio_npl_pct
FROM prets GROUP BY 1 ORDER BY 1;

-- 4. Exposition au risque par produit.
SELECT produit,COUNT(*) AS nb_prets,ROUND(SUM(encours_usd),2) AS encours_usd,
 ROUND(AVG(probabilite_defaut)*100,2) AS pd_moyenne_pct,
 ROUND(SUM(probabilite_defaut*taux_perte*encours_usd),2) AS perte_attendue_simplifiee_usd
FROM prets GROUP BY produit ORDER BY encours_usd DESC;

-- 5. Stress test démonstratif (+30% PD, plafonnée à 100%, LGD inchangée).
SELECT ROUND(SUM(probabilite_defaut*taux_perte*encours_usd),2) AS ecl_base_usd,
 ROUND(SUM(MIN(probabilite_defaut*1.3,1.0)*taux_perte*encours_usd),2) AS ecl_stress_usd,
 ROUND(SUM((MIN(probabilite_defaut*1.3,1.0)-probabilite_defaut)*taux_perte*encours_usd),2) AS variation_usd
FROM prets;

-- 6. Qualité des montants : remboursements totaux <= prêts initiaux.
SELECT COUNT(*) AS prets_verifies,
 SUM(CASE WHEN montant_regle>montant_initial_usd THEN 1 ELSE 0 END) AS anomalies
FROM (SELECT p.pret_id,p.montant_initial_usd,COALESCE(SUM(r.montant_usd),0) AS montant_regle
 FROM prets p LEFT JOIN remboursements r ON r.pret_id=p.pret_id GROUP BY p.pret_id);
