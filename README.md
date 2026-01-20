# Projet d'Autoscaling AWS

## Description

Projet d'implémentation d'une solution d'autoscaling sur AWS Cloud. Le système ajuste dynamiquement le nombre d'instances en fonction de la charge utilisateur, garantissant ainsi la disponibilité et l'optimisation des coûts. (Scaling sollicité par des métriques CloudWatch + dashboard monitoring)

## Architecture

Le projet utilise les services AWS suivants :

- **EC2 Auto Scaling** : Gestion automatique du nombre d'instances
- **Application Load Balancer** : Distribution du trafic entre les instances
- **CloudWatch** : Surveillance et déclenchement des alarmes
- **VPC** : Réseau virtuel privé avec sous-réseaux publics et privés
- **AMI personnalisées** : Images préconfigurées avec l'application

## Structure du projet

```
.
├── app/
│   ├── src/
│   │   ├── app.py
│   │   └── templates/
│   ├── requirements.txt
│   ├── app.service
│   └── nginx.conf
│
├── terraform/
│   ├── modules/
│   │   ├── networking/
│   │   ├── loadbalancer/
│   │   ├── autoscaling/
│   │   └── monitoring/         # CloudWatch
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── packer/                     # Construction d'AMI
│   ├── app-ami.pkr.hcl
│   ├── variables.pkr.hcl
│   └── scripts/
│       └── install-app.sh
│
├── monitoring/
│   ├── prometheus/
│   │   └── prometheus.yml
│   ├── grafana/
│   │   └── dashboards/
│   └── setup-monitoring.sh
│
└── load-testing/
    └── scenarios/
        ├── baseline.json
        ├── scale-up.json
        └── scale-down.json
```

## Installation

### 1. Configuration des variables

Créez un fichier `terraform/terraform.tfvars` basé sur l'exemple fourni :

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

Éditez ce fichier avec vos paramètres spécifiques.

### 2. Construction de l'AMI

Construisez l'image AMI contenant l'application préconfigurée :

```bash
cd packer
packer init .
packer build -var-file="terraform.auto.pkrvars.hcl" app-ami.pkr.hcl
```

Notez l'ID de l'AMI générée pour l'utiliser avec Terraform.

### 3. Déploiement de l'infrastructure

Déployez l'infrastructure AWS avec Terraform :

```bash
cd ../terraform
terraform init
terraform plan
terraform apply
```

L'application sera accessible via l'URL du Load Balancer affichée dans les outputs.

## Fonctionnalités de l'application

L'application Flask expose plusieurs endpoints :

- **`/`** : Page d'accueil affichant les métadonnées de l'instance

- **`/health`** : Endpoint status pour le Load Balancer

- **`/cpu-intensive`** : Endpoint test de charge (pas à la huteur d'un véritable outil)

- **`/metrics`** : Métriques au format Prometheus

## Surveillance et monitoring

### Prometheus et Grafana

Pour déployer la stack de monitoring :

```bash
cd monitoring
./setup-monitoring.sh
```

Accédez ensuite à :
- Prometheus : `http://<monitoring-instance>:9090`
- Grafana : `http://<monitoring-instance>:3000`

### CloudWatch

Les alarmes CloudWatch sont configurées pour surveiller :
- Utilisation CPU moyenne
- Nombre de requêtes par cible
- Latence des réponses

## Tests de charge

Les scénarios de test permettent voir le comportement de l'autoscaling :

1. **baseline** : Charge normale = référence
2. **scale-up** : Augmentation progressive de la charge pour déclencher la création d'instances
3. **scale-down** : Diminution de la charge pour déclencher la suppression d'instances

Solution: Locust, pour tester ces scénarios

## Paramètres d'autoscaling

Les paramètres par défaut peuvent être ajustés dans `terraform/modules/autoscaling/variables.tf` :

- **Nombre minimum d'instances** : 2
- **Nombre maximum d'instances** : 10
- **Capacité désirée** : 2
- **Seuil CPU pour scale-up** : 70%
- **Seuil CPU pour scale-down** : 30%

## Nettoyage

Pour supprimer toutes les ressources créées :

```bash
cd terraform
terraform destroy
```

N'oubliez pas de supprimer manuellement l'AMI créée avec Packer dans la console AWS.

## Sécurité

- Les instances sont déployées dans des sous-réseaux privés
- Seul le Load Balancer est exposé publiquement
- Les groupes de sécurité limitent l'accès aux ports nécessaires

## Améliorations ??

- Implémentation du SSL/TLS sur le Load Balancer
- Mise en cache avec ElastiCache
- Métriques applicatives personnalisées

## Auteur

Développé par :
- BESOMBES Aurélien - Étudiant en Master Infra/Cloud
- TEHAHE Haunui - Étudiant en Master Infra/Cloud
- FERRARI Enzo - Étudiant en Master Infra/Cloud
