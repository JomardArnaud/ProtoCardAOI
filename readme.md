# ✅ Dev Notes / Checkboxes

## 🎯 Aim Assist
- [ ] Implémenter l'assistance de visée (Aim Assist)  
  → Basée sur le vecteur directionnel du **right stick**

---

## 🆕 Nouvelle carte : Attack
- [ ] Ajouter un laser vectoriel  
  → S'attache au **curseur**  
  → Suit la trajectoire du **right stick du joueur**

---

## 🆕 Nouvelle carte : Attack/Movement
- [ ] Définir les effets et comportements  
  → *(À compléter)*

---

## 💥 Projectiles / Collisions
- [x] Faire que les `BasicProjectile` soient supprimés (`queue_free()`) en cas de collision avec un mur  
  → ✅ Implémenté  
  → ⚠️ *Bug visuel : la balle apparaît brièvement dans le bloc pendant 1 frame avant suppression*

- [x] Utiliser `class_name` pour les `Block`  
  → Permet de connecter proprement les signaux de collision