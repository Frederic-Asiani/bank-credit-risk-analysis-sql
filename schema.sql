CREATE TABLE emprunteurs (
 emprunteur_id INTEGER PRIMARY KEY, segment TEXT NOT NULL, agence TEXT NOT NULL,
 secteur TEXT NOT NULL);
CREATE TABLE prets (
 pret_id INTEGER PRIMARY KEY,emprunteur_id INTEGER NOT NULL REFERENCES emprunteurs(emprunteur_id),
 date_octroi TEXT NOT NULL, produit TEXT NOT NULL, montant_initial_usd NUMERIC NOT NULL CHECK(montant_initial_usd>0),
 encours_usd NUMERIC NOT NULL CHECK(encours_usd>=0), jours_retard INTEGER NOT NULL CHECK(jours_retard>=0),
 probabilite_defaut NUMERIC NOT NULL CHECK(probabilite_defaut BETWEEN 0 AND 1),
 taux_perte NUMERIC NOT NULL CHECK(taux_perte BETWEEN 0 AND 1));
CREATE TABLE remboursements (
 remboursement_id INTEGER PRIMARY KEY,pret_id INTEGER NOT NULL REFERENCES prets(pret_id),
 date_reglement TEXT NOT NULL, montant_usd NUMERIC NOT NULL CHECK(montant_usd>0));
CREATE INDEX idx_pret_octroi ON prets(date_octroi);
CREATE INDEX idx_pret_retard ON prets(jours_retard);
CREATE INDEX idx_remb_pret ON remboursements(pret_id);
