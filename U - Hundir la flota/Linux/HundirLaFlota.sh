#!/bin/bash
# Hundir la Flota - Versión básica
echo ' Va a iniciar el juego de hundir la flota'
echo 'Este juego está tematizado con ambientación en la 2º Guerra Mundial'
echo 'Jugarás al mando del Acorazado Iowa, y te enfrentarás a la temida flota nipona Yamato'
echo 'Podrás huir del combate en cualquier momento, pero eso será una deshonra para los EEUU'
echo 'A partir de ahora eres el Almirante Adler'
echo 'Buena suerte mi general'
echo '------------'
while true; do
echo
read -p '¿Mi general, está seguro de que quiere seguir en la batalla?' sn
# Normalizar entrada removiendo acentos
sn_lower="${sn,,}"
sn_norm="${sn_lower//í/i}"
sn_norm="${sn_norm//á/a}"
case $sn_norm in
no|n ) echo 'Nuestro país será recordado por cobarde.'; exit;;
si|s ) break;;
* ) echo 'Por favor responda (Si o No)';;
esac
done
echo 'Así se habla general. Se van a enterar los japoneses'
echo 'Marineros, virad a estribor. Tenemos unos isleños a los que bombardear'
echo '-----------'
echo 'Mi general, hay mucha niebla, por lo que nuestros lanzamientos han de ser a ciegas'
echo 'He diseñado un sistema de casillas para que me de la orden. Van del 1 al 25'
vencedor=0
vencido=1 


buquesenemigos=('T' '-' 'T' '-' '-' '-' 'T' '-' '-' 'T' '-' '-' '-' 'T' '-' '-' 'T' '-' 'T' 'T' 'T' '-' '-' 'T')
mapadeguerra=('-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-' '-')

while [ $vencido != '16' ]
do
	if [ $vencedor == '10' ]
	then
		break
	fi
	echo ¿Mi general, que casilla bombardeamos?
	read movimiento
	# Permitir rendirse
	case ${movimiento,,} in
		rendirse|r|salir)
			echo 'Nuestro país será recordado por cobarde.'
			exit
			;;
	esac
	# Validar que sea un número
	if ! [[ "$movimiento" =~ ^[0-9]+$ ]]; then
		echo "Por favor, introduce un número del 1 al 25"
		continue
	fi
	if [ "$movimiento" -lt 1 ] || [ "$movimiento" -gt 25 ]; then
		echo "Por favor, introduce un número del 1 al 25"
		continue
	fi
	((movimiento = movimiento - 1))
	if [ ${buquesenemigos[movimiento]} == 'T' ]
	then
		echo ¡Mi general, hemos hundido un buque japonés!
		echo Sigamos hasta acabar con ellos
		mapadeguerra[$movimiento]='T'
		buquesenemigos[$movimiento]='O'
		echo ${mapadeguerra[*]}
		((vencedor = vencedor + 1))
		((vencido = vencido + 1))
	elif [ ${buquesenemigos[movimiento]} == 'O' ]
	then
		echo Mi general, hemos vuelto a dar a un barco ya hundido
		echo ${mapadeguerra[*]}
	else
		echo Rayos, hemos errado el disparo y los nipones se acercan
		echo ${mapadeguerra[*]}
		((vencido = vencido + 1))
	fi
	
done

if [ $vencido == '16' ]
then
	echo Nos hemos quedado sin munición, y los japoneses nos han alcanzado. Ha sido un honor luchar a su lado general Adler. Rezo a dios para que nuestra muerte sea rápida. --------------- EL acorazado Iowa ha sido destruido
	echo '----------'
	echo 'Gracias a Mercedes y a Aníbal por ayudarme a aclararme con los comandos'
else
	echo El general Adler ha conseguido hundir a la flota Yamato, y el general Nipón Kirito Seru ha cometido Seppuku. Nuestra victoria está cada vez más cerca. Puede volver a casa
	echo '----------'
	echo 'Gracias a Mercedes y a Aníbal por ayudarme a aclararme con los comandos'

fi
		
		
