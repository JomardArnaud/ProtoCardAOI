# ✅ Proto into Haikyuu Todo :fire:

## *Bugs*
- [ ] *Bug visuel : la balle apparaît brièvement dans le bloc pendant 1 frame avant suppression*
- [ ] *Bug visuel : Si la sourris ne bouge pas le cursor disparait (qunad un controller est connecter voir la fonction pour gamepadActive)*

## Vrac
- [ ] Implementation du system de pioche, chaque carte jouée le joueur pioche 1, limit de carte 7 ou 8 ?  
- [ ] Implementation d'un system de pause ? 
- [ ] Refaire le systme de card ability et du parsing
- [ ] Finir SkillShot (prendre en compte les arguements pour le radius et le dmg)
- [ ] Card weapon au lieu de tiré des balles casteront les effets lié à la carte weapon, genre pour faire un SMG (FireRate: 0.25, FireEffect: SkillShot(40, 5)) 
- [ ] Chaque card weapon à une carte shell associé, qui à chaque balle tirée à un pourcentage de spawn 
- [ ] Card Type Bullet
- [ ] Short range weapon (need to return the right stick to a deadzone)
- [ ] Medium range weapon (fire attack automactly in direction of right when it aren't in deadzone)
- [ ] Implementation weapon pour le Player (R3 pour switch entre les weapon)
- [ ] Implementation des cartes de buff (input X et drop B probalment)
- [ ] Implementation des digs de cartes (met la Main card du type à la fin de la main)
- [ ] Implementation des types de cartes (Dash, Attack, Buff)
- [ ] Implementation des familles de cartes qui peuvent être de n'import quel type (Module: ajout sur l'arme ou intéraction avec les ajouts, Curse: ne peut pas être drop et prend la place du mainSlot de leur type quand elle arrive en main, etc)
- [ ] Déctection des main cartes principales, celles qui sont les premières en de chaque type en partant de la gauche
- [ ] Implémenter l'assistance de visée (Aim Assist)
- [ ] Card Buff - gear | Laser Vectoriel |= Ray cast en short range qui s'attache au cursor et suit la trajectoire du right stick
- [ ] First boss arena
### Boss
- [ ] Boss round qui se déplacement en ligne droite et bounce contre les murs, se stop lance une carte et refais une droite, etc 
- [ ] Boss behaviour (Curse Attack: lance un project rect auto guidé contre le joueur esquivable qu'avec un dash une carte Attack - Curse qui se duplique 2 fois en Dash - Curse et Buff- Curse,  )
- [ ] Boss event/scripting
- [ ] UI énergie jauge et compteur
- [ ] UI Weapon
- [ ] UI mainCardSlot
- [ ] Implementation du system de deck, commence avec 6 cartes random en main (mais la 1st carte est de type Dash,la 2nd Attack et la 3rd Buff)
- [ ] Implementation code de l'énergie (S'augmente quand un dégat est faite grâce à une arme, qui rempli une jauge, quand la jauge est à 100% ajoute 1 d'énergie. Peut aussi s'obtenir avec des effets de cards') comment cost pour les cartes
- [ ] Card Attack, Hanabi 3 = Discard all orther Attack card, for each card discard, draw 1 & 
### Counters
- [ ] Implémentation des Counters
### Archetype
- [ ] Implementation archetype bumper(X, Y) , Pose un bumper de radius Y à l'endroit du cursor de shoot, ajoute X * distance milieu_bumper/milieu entity(plus l'entité est proche plus la vélocity est ajoutée)
### Card idea
- [ ] Card Dash - mine | Dash's mine
- [ ] Hud pour les stats du joueur
- [ ] Card - Attack | Rainbow Road 3 Quand une card attack se resolve et que Raindow Road est en main, ajoute tout les keyword du resolve de la card attack jouée
## Done
~~- [X] Ajout du gameplay clavier souris~~
