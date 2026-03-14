# Scop

Creerea unui sistem temportizat de adus modificari site-urilor Jupyter Book 2, usor de folosit de reutilizat.

# Mod de functionare

Modificarile sunt aduse prin modificarea si impingerea modificarilor in repo. Temporizarea este realizata prin fire de executie independente, fiecare avand un sistem propriu de temporizare.

# ToDo
---
Functionalitati de baza:
- [x] Configuratie prin CSV
- [x] Modificare corecta a fisierului .yml
- [ ] Creere log de functionare
- [x] Functionalitati Git
- [ ] Lansare thread-uri si temporizare
- [ ] Rezolvarea erorilor de internet si Git in mod automat
---
Functionalitati QOL:
- [ ] CLI
- [ ] Completarea task-urilor neefectuate pe baza log-ului
- [ ] Inlocuirea executie git din terminal cu GitLib2
- [ ] Rezolvare mai inteligenta a erorilor de internet
- [ ] Comasarea inteligenta a modificarilor pentru eficientizarea functionarii
- [ ] Modularizarea functionalitatii de scheduling pentru a permite refolosirea in alte proiecte

----
De viitor:
- [ ] Parsare avansata a fisierelor .yml
- [ ] Extinderea posibilitatilor de modificare
- [ ] Consola lua si interpretator pentru script-uri mai avansate de modificare a fisierelor
- [ ] Permiterea rularii de script-uri bash scheduled
