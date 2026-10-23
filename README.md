# Risque de crédit et qualité du portefeuille

**Cas pratique SQL réalisé, exécuté et validé sur SQLite 3 (données entièrement synthétiques).**

Analyse NPL, retards, cohortes, exposition par produit et simulation simplifiée des pertes attendues. PD/LGD sont des hypothèses pédagogiques non validées.

## Fichiers
- `banque_demo.sqlite` : base SQLite préchargée, directement interrogeable.
- `schema.sql` : modèle relationnel avec clés primaires / étrangères / contraintes.
- `analyses.sql` : 6 requêtes d'analyse exécutées.
- `data/` : fichiers CSV reproductibles pour audit et visualisation.
- `resultats_valides.json` : résultats calculés par exécution réelle des requêtes.

## Volumétrie des données
- **emprunteurs** : 180 lignes
- **prets** : 290 lignes
- **remboursements** : 1,462 lignes

## Démarrer
```bash
sqlite3 banque_demo.sqlite < analyses.sql
```
Ou ouvrir `banque_demo.sqlite` dans DB Browser for SQLite, DBeaver ou Python sqlite3.

## Précautions méthodologiques
- Les montants monétaires sont exprimés en **USD fictifs** pour éviter les conversions et risques de change.
- Les noms, clients, transactions, institutions et observations sont fictifs.
- Toute alerte, probabilité, performance, ou métrique s'applique exclusivement aux données simulées.
- Aucune donnée bancaire réelle ni partenariat avec une banque n'est revendiqué.
- Moteur SQL testé : **SQLite 3.46**, requêtes adaptables à MySQL 8 (notamment dates et fonctions).
