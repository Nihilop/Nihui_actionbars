# Nihui ActionBars

Un addon complet pour World of Warcraft dédié à la personnalisation des barres d'action.

## Fonctionnalités

### 🎯 Gestion des Masks
- Système de masques personnalisés pour les effets visuels
- Support des masques circulaires, carrés, rectangulaires
- Compatible avec les masques existants de rnxmUI

### ✨ Spell Break/Activation
- Effets visuels personnalisés lors de l'activation de sorts
- Système de glow avec animation multicouches
- Configuration avancée des couleurs et modes de fusion
- Remplacement des effets Blizzard par défaut

### 📝 Placement des Textes
- Personnalisation complète des textes des barres d'action :
  - **Keybinds** : Raccourcis clavier
  - **Noms de macros** : Noms des sorts/macros
  - **Compteurs** : Nombre d'objets empilés
- Configuration individuelle pour chaque type de texte :
  - Police, taille, style
  - Couleur et transparence
  - Ombre et décalage
  - Position et ancrage

## Installation

1. Copiez le dossier `Nihui_ab` dans votre répertoire `Interface/AddOns/`
2. Redémarrez WoW ou tapez `/reload`
3. L'addon se charge automatiquement

## Utilisation

### Commandes slash
- `/nihuiab` ou `/nab` - Ouvre la configuration
- `/nihuiab config` - Ouvre le panneau de configuration
- `/nihuiab reset` - Remet tous les paramètres par défaut

### Interface de configuration
- Accessible via `/nihuiab config`
- Ou dans le menu Interface > AddOns > Nihui ActionBars
- Configuration en temps réel avec aperçu immédiat

## Structure du projet

```
Nihui_ab/
├── Nihui_ab.toc          # Fichier de description de l'addon
├── init.lua              # Initialisation principale
├── config.lua            # Utilitaires de configuration
├── libs/                 # Bibliothèques Ace
├── modules/              # Modules fonctionnels
│   ├── actionbars.lua    # Gestion des barres d'action
│   ├── spellactivation.lua # Effets d'activation de sorts
│   └── textplacement.lua # Placement des textes
├── masks/                # Système de masques
│   ├── masks.lua         # Gestion des masques
│   └── *.tga            # Fichiers de texture des masques
├── gui/                  # Interface graphique
│   └── gui.lua          # Configuration avec AceConfig
└── textures/            # Textures additionnelles
```

## Configuration avancée

### Spell Activation
- **Glow Scale** : Taille de l'effet de lueur (0.5 - 3.0)
- **Couleurs** : Configuration RGB pour chaque couche
- **Modes de fusion** : BLEND, ADD, ALPHAKEY, MOD, DISABLE
- **Masques** : Application de formes personnalisées

### Text Placement
- **Anchoring** : 9 points d'ancrage disponibles
- **Offsets** : Décalage précis en pixels
- **Fonts** : Support des polices personnalisées
- **Shadows** : Ombres configurables

## Compatibilité

- Compatible avec World of Warcraft retail (11.0.2+)
- Fonctionne avec les addons de barres d'action tiers
- Support des bibliothèques Ace pour la configuration

## Dépendances

L'addon inclut toutes les bibliothèques nécessaires :
- LibStub
- AceAddon-3.0
- AceConfig-3.0
- AceGUI-3.0

## Développement

Basé sur le système modulaire de rnxmUI, cet addon utilise :
- Architecture modulaire pour une maintenance facile
- Système d'événements pour la réactivité
- Pool d'objets pour les performances
- Configuration persistante avec SavedVariables

## Auteur

- **nihil** (basé sur rnxmUI par rnxm)
- Version 1.0

## Support

Pour signaler des bugs ou demander des fonctionnalités, utilisez les commandes de debug intégrées ou consultez les logs de WoW.