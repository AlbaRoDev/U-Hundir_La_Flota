Hundir la flota - Cómo ejecutar (Linux / WSL)

Requisitos:
 - Bash (recomendado Bash >= 4)
 - Terminal Linux o WSL

Ejecutar:
 - Con bash:
   bash "/rutaalarchivo/Hundirlaflota.sh"

 - Haciendo ejecutable:
   chmod +x /ruta/al/archivo/Hundirlaflota.sh
   /rutaalarchivo/Hundirlaflota.sh

Notas:

 - Para rendirte en el juego escribe: rendirse, r o salir cuando el prompt lo acepte.

SOLUCIÓN A ERROR "syntax error near unexpected token":

 Este error ocurre cuando los archivos tienen finales de línea de Windows (CRLF)
 en lugar de Unix (LF). Para solucionarlo:

 Opción 1 (recomendado):
   sed -i 's/\r$//' *.sh

 Opción 2 (si tienes dos2unix instalado):
   dos2unix *.sh

 Opción 3 (automático):
   bash .fix-line-endings.sh

 Este problema puede ocurrir si tu git está configurado con core.autocrlf=true
 Para evitarlo en el futuro:
   git config --global core.autocrlf input

Ejemplo:
bash "Usuario/Desktop/Juegos/HundirlaflotaMejorado.sh"
