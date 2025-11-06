#!/usr/bin/env bash

set -u
shopt -s extglob


start_lines=(
"La niebla de la mañana lo oculta todo."
"El horizonte se tiñe de plomo y pólvora."
"El silencio del mar precede a la tormenta."
"Las sirenas de ataque rompen la calma."
"Navegamos a ciegas, hacia el inevitable choque."
"Se oyen disparos lejanos... ¿amigos o enemigos?"
"El radar no detecta nada, pero la tensión es máxima."
"El destino del océano está a punto de decidirse."
"Los cañones rugen, marcando el inicio de la batalla."
"Maniobras de evasión. El enemigo está cerca."
)


hit_lines=(
"¡Impacto directo! El casco cruje."
"Una columna de humo negro se alza en la distancia."
"Explosión a babor, parece grave."
"El mar se tiñe de rojo."
"Los carroñeros del mar se darán un festín."
"Un impacto limpio. ¡Bien hecho!"
"Han recibido de lleno. Se tambalean."
)

miss_lines=(
"Salpicaduras de agua. El misil ha quedado corto."
"Demasiada distancia. El proyectil se pierde en el mar."
"¡Fallo! Hemos sobrepasado el objetivo."
"Un estruendo, pero solo el agua ha temblado."
"El objetivo esquiva el proyectil con pericia."
)

enemy_hit_lines=(
"¡Hemos recibido un impacto! Alerta máxima."
"El enemigo ha encontrado un punto débil, ¡daños en la sala de máquinas!"
"Alarma de incendio. ¡El fuego se extiende rápidamente!"
"Nos han alcanzado. La estructura se tambalea."
)

enemy_miss_lines=(
"El estruendo resuena en la distancia, pero el impacto ha sido en el agua."
"Han fallado el tiro. Por suerte."
"Un ruido sordo. Por poco."
"El enemigo ha subestimado la distancia, ¡esquivado!"
)


rand_line(){
    local arr_name="$1"
    local -n _arr="$arr_name"
    echo "${_arr[$((RANDOM % ${#_arr[@]}))]}"
}


historias=( "Guerra de Marruecos (1909-1927)" "Guerra del Pacífico - WWII (1941-1945)"
 "Guerra de Crimea (1853-1856)" "Campaña de Gallípoli - WWI (1915)"
 "Guerra de Independencia de Indonesia (1945-1949)" )

jug_names_0=( "Acosta" "Serrano" "De la Hoz" "Peña" "Ruiz" )
ene_names_0=( "Abdel-Krim" "Alaoui" "Awada" "Saadi" "Mehdi" )

jug_names_1=( "Patterson" "Henderson" "Fitzgerald" "Sullivan" "Morgan" )
ene_names_1=( "Hayashi" "Nagumo" "Kondo" "Ozawa" "Yamamoto" )

jug_names_2=( "Volkonsky" "Chernyshev" "Bagration" "Kutuzov" "Orlov" )
ene_names_2=( "Mitchell" "Hartwell" "Pemberton" "Ashford" "Bennett" )

jug_names_3=( "Kemal" "Enver" "Cemal" "Fevzi" "Fuad" )
ene_names_3=( "Thornton" "Blackwood" "Caldwell" "Morrison" "Harris" )

jug_names_4=( "Sukarno" "Nasution" "Sudirman" "Yani" "Suharto" )
ene_names_4=( "Van Mook" "Spoor" "Buurman" "De Ruyter" "Van der Plas" )

random_index=$(( RANDOM % ${#historias[@]} ))
historia="${historias[$random_index]}"

if [ "$random_index" -eq 0 ]; then
    JNAMES=( "${jug_names_0[@]}" )
    ENAMES=( "${ene_names_0[@]}" )
elif [ "$random_index" -eq 1 ]; then
    JNAMES=( "${jug_names_1[@]}" )
    ENAMES=( "${ene_names_1[@]}" )
elif [ "$random_index" -eq 2 ]; then
    JNAMES=( "${jug_names_2[@]}" )
    ENAMES=( "${ene_names_2[@]}" )
elif [ "$random_index" -eq 3 ]; then
    JNAMES=( "${jug_names_3[@]}" )
    ENAMES=( "${ene_names_3[@]}" )
else
    JNAMES=( "${jug_names_4[@]}" )
    ENAMES=( "${ene_names_4[@]}" )
fi

PLAYER_SHORT="${JNAMES[$((RANDOM % ${#JNAMES[@]}))]}"
ENEMY_SHORT="${ENAMES[$((RANDOM % ${#ENAMES[@]}))]}"
PLAYER_NAME="Comandante $PLAYER_SHORT"
ENEMY_NAME="Comandante $ENEMY_SHORT"

# inicio narrativo sencillito
echo
echo "========================================"
echo "  $historia"
echo "  $PLAYER_NAME  vs  $ENEMY_NAME"
echo "----------------------------------------"
echo "  $(rand_line start_lines)"
echo "  El conflicto se presenta en la costa, con niebla y artillería. Buena suerte."
echo "========================================"
echo

confirmar() {
    local pregunta="$1"
    local respuesta
    while true; do
        read -r -p "$pregunta (Sí/No): " respuesta
        respuesta="${respuesta,,}"
        respuesta="${respuesta//í/i}"
        respuesta="${respuesta//á/a}"
        if [ "$respuesta" = "no" ] || [ "$respuesta" = "n" ]; then
            echo "Ok, salimos."
            exit
        fi
        if [ "$respuesta" = "si" ] || [ "$respuesta" = "s" ]; then
            return 0
        fi
        echo "Escribe Si o No."
    done
}

print_grid() {
    local arr_name="$1"
    local rows="$2"
    local cols="$3"
    local vis_name="${4:-}"
    local title="${5:-}"

    local -n arr_ref="$arr_name"
    if [ -z "$vis_name" ]; then
        local -a vis_local
        for (( i=0; i<rows*cols; i++ )); do vis_local[$i]=1; done
        local -n vis_ref="vis_local"
    else
        local -n vis_ref="$vis_name"
    fi

    if [ -n "$title" ]; then
        echo "$title"
    fi

    printf "    "
    for ((c=0;c<cols;c++)); do
        letter=$(printf \\$(printf '%03o' $((65 + c))))
        printf " %2s " "$letter"
    done
    printf "\n"

    for ((r=1;r<=rows;r++)); do
        printf " %2d " "$r"
        for ((c=0;c<cols;c++)); do
            idx=$(( (r-1)*cols + c ))
            if [ "${vis_ref[$idx]:-0}" -eq 1 ]; then
                cell="${arr_ref[$idx]:--}"
                case "$cell" in
                    E) printf "  E " ;;
                    H) printf "  X " ;;
                    M) printf "  o " ;;
                    P) printf "  P " ;;
                    -) printf "  . " ;;
                    *) printf " %2s " "$cell" ;;
                esac
            else
                printf "  # "
            fi
        done
        printf "\n"
    done
    printf "\n"
}

convert_input_to_index() {
    local mov="$1"; local cols="$2"; local rows="$3"
    if [[ "$mov" =~ ^(rendirse|salir|r)$ ]]; then
        echo "SURRENDER"
        return
    fi
    if [[ "$mov" =~ ^[0-9]+$ ]]; then
        if [ "$mov" -lt 1 ] || [ "$mov" -gt $((rows*cols)) ]; then echo -1; return; fi
        echo $((mov-1)); return
    fi
    if [[ "$mov" =~ ^([A-Za-z])([0-9]+)$ ]]; then
        local col_letter="${BASH_REMATCH[1]}"
        local rownum="${BASH_REMATCH[2]}"
        col_letter="${col_letter^^}"
        local col_code=$(printf "%d" "'$col_letter")
        local col_idx=$((col_code - 65))
        if [ "$col_idx" -lt 0 ] || [ "$col_idx" -ge "$cols" ]; then echo -1; return; fi
        if ! [[ "$rownum" =~ ^[0-9]+$ ]]; then echo -1; return; fi
        if [ "$rownum" -lt 1 ] || [ "$rownum" -gt "$rows" ]; then echo -1; return; fi
        local idx=$(( (rownum-1)*cols + col_idx ))
        echo "$idx"; return
    fi
    echo -1
}

choose_random_positions() {
    local total=$1; local count=$2
    local -a arr=()
    while [ "${#arr[@]}" -lt "$count" ]; do
        local v=$(( RANDOM % total ))
        local ok=1
        for x in "${arr[@]}"; do if [ "$x" -eq "$v" ]; then ok=0; break; fi; done
        if [ "$ok" -eq 1 ]; then arr+=("$v"); fi
    done
    echo "${arr[@]}"
}

# rendirse - salida coherente
surrender_now() {
    echo
    echo "El $PLAYER_NAME ha decidido rendirse y acabar de manera cobarde con su vida. Todos nuestros hombres serán ejecutados."
    echo "Fin de la campaña: $historia"
    echo
    exit 0
}

skirmish() {

    local rows=4
    local cols=5
    local total=$((rows*cols))

    declare -a enemy_map
    declare -a enemy_vis
    declare -a player_map
    declare -a player_vis

    for ((i=0;i<total;i++)); do
        enemy_map[$i]='-'
        enemy_vis[$i]=0
        player_map[$i]='-'
        player_vis[$i]=1
    done

    local enemies=$((5 + RANDOM % 6))
    local player_units=5

    local -a epos=( $(choose_random_positions $total $enemies) )
    for p in "${epos[@]}"; do enemy_map[$p]='E'; done

    local playerpos=()
    while [ "${#playerpos[@]}" -lt "$player_units" ]; do
        p=$(( RANDOM % total ))
        if [ "${enemy_map[$p]}" == "E" ]; then
            continue
        fi
        local found=0
        for q in "${playerpos[@]}"; do
            if [ "$q" -eq "$p" ]; then found=1; break; fi
        done
        if [ "$found" -eq 0 ]; then playerpos+=("$p"); fi
    done

    for p in "${playerpos[@]}"; do player_map[$p]='P'; done

    echo "Comienza Escaramuza ($historia). $PLAYER_NAME vs $ENEMY_NAME"
    echo "Entrada: numero (1..$total) o A1  - escribe rendirse / r / salir para rendirte"
    echo

    local vidas=$player_units
    local enemies_sunk=0

    while true; do

        print_grid enemy_map $rows $cols enemy_vis "Mapa enemigo (niebla)"
        print_grid player_map $rows $cols "" "Tu mapa (unidades propias)"

        read -r -p "¿Qué casilla atacamos? " mov_raw
        if [[ "${mov_raw,,}" =~ ^(rendirse|salir|r)$ ]]; then
            surrender_now
        fi

        idx=$(convert_input_to_index "$mov_raw" $cols $rows)
        if [ "$idx" = "SURRENDER" ]; then surrender_now; fi
        if [ "$idx" -lt 0 ]; then
            echo "Entrada inválida."
            continue
        fi

        enemy_vis[$idx]=1
        if [ "${enemy_map[$idx]}" == "E" ]; then
            echo "$(rand_line hit_lines)"
            enemy_map[$idx]='H'
            enemies_sunk=$((enemies_sunk+1))
        elif [ "${enemy_map[$idx]}" == "H" ]; then
            echo "Esa ya está hundida."
        else
            echo "$(rand_line miss_lines)"
            enemy_map[$idx]='M'
        fi

        if [ "$enemies_sunk" -ge "$enemies" ]; then
            echo "Victoria en Escaramuza!"
            break
        fi

        e_shot=$(( RANDOM % total ))
        enemy_vis[$e_shot]=1

        if [ "${player_map[$e_shot]}" == "P" ]; then
            echo "$(rand_line enemy_hit_lines)"
            player_map[$e_shot]='M'
            vidas=$((vidas-1))
            echo "Unidades: $vidas"
        else
            echo "$(rand_line enemy_miss_lines)"
        fi

        if [ "$vidas" -le 0 ]; then
            echo "Has perdido todas las unidades. Fin."
            break
        fi

        echo
    done

    echo "Fin Escaramuza."
}

battle() {

    local total=$((60 + RANDOM % 41))
    local cols=10
    local rows=$(( (total + cols - 1) / cols ))
    total=$(( rows * cols ))

    declare -a grid
    declare -a hp
    declare -a visible

    for ((i=0;i<total;i++)); do grid[$i]='-'; hp[$i]=0; visible[$i]=0; done

    declare -a player_map
    declare -a player_vis
    for ((i=0;i<total;i++)); do player_map[$i]='-'; player_vis[$i]=1; done

    declare -A unit_hp
    unit_hp[Fragata]=1; unit_hp[Crucero]=2; unit_hp[Acorazado]=4; unit_hp[Polvorin]=2
    local enemies=$((20 + RANDOM % 11))

    place_cluster() {
        local center=$1; local size=$2
        for ((i=0;i<size;i++)); do
            local attempt=$(( center + (RANDOM % 7) - 3 ))
            if [ "$attempt" -lt 0 ] || [ "$attempt" -ge "$total" ]; then
                continue
            fi
            if [ "${hp[$attempt]}" -eq 0 ]; then
                local tnum=$((RANDOM % 4))
                local type
                if [ "$tnum" -eq 0 ]; then
                    type="Fragata"
                elif [ "$tnum" -eq 1 ]; then
                    type="Crucero"
                elif [ "$tnum" -eq 2 ]; then
                    type="Acorazado"
                else
                    type="Polvorin"
                fi
                grid[$attempt]='E'
                hp[$attempt]=${unit_hp[$type]}
            fi
        done
    }

    place_line() {
        local start=$1; local length=$2
        local dir=$((RANDOM % 2))
        for ((i=0;i<length;i++)); do
            local idx
            if [ "$dir" -eq 0 ]; then
                idx=$(( start + i ))
            else
                idx=$(( start + i*cols ))
            fi
            if [ "$idx" -lt 0 ] || [ "$idx" -ge "$total" ]; then
                break
            fi
            if [ "${hp[$idx]}" -eq 0 ]; then
                local tnum=$((RANDOM % 4))
                local type
                case $tnum in
                    0) type="Fragata" ;;
                    1) type="Crucero" ;;
                    2) type="Acorazado" ;;
                    3) type="Polvorin" ;;
                esac
                grid[$idx]='E'
                hp[$idx]=${unit_hp[$type]}
            fi
        done
    }

    local placed=0
    while [ "$placed" -lt "$enemies" ]; do
        local strat=$((RANDOM % 3))
        local center=$(( RANDOM % total ))
        if [ "$strat" -eq 0 ]; then
            size=$((1 + RANDOM % 4))
            place_cluster $center $size
        elif [ "$strat" -eq 1 ]; then
            length=$((2 + RANDOM % 5))
            place_line $center $length
        else
            if [ "${hp[$center]}" -eq 0 ]; then
                tnum=$((RANDOM % 4))
                local ty
                case $tnum in
                    0) ty="Fragata" ;;
                    1) ty="Crucero" ;;
                    2) ty="Acorazado" ;;
                    3) ty="Polvorin" ;;
                esac
                grid[$center]='E'
                hp[$center]=${unit_hp[$ty]}
            fi
        fi

        placed=0
        for ((i=0;i<total;i++)); do
            if [ "${hp[$i]}" -gt 0 ]; then placed=$((placed+1)); fi
        done
        if [ "$placed" -gt "$enemies" ]; then
            break
        fi
    done

    local offset=$(( RANDOM % 21 - 10 ))
    local player_units=$(( enemies + offset ))
    if [ "$player_units" -lt 1 ]; then player_units=1; fi

    local -a mypos=( $(choose_random_positions $total $player_units) )
    for p in "${mypos[@]}"; do player_map[$p]='P'; done

    declare -A w_damage; declare -A w_radius; declare -A w_ammo
    w_damage[Artilleria]=1; w_radius[Artilleria]=0; w_ammo[Artilleria]=97
    w_damage[Recon]=0; w_radius[Recon]=1; w_ammo[Recon]=2         
    w_damage[Superbomba]=3; w_radius[Superbomba]=1; w_ammo[Superbomba]=1

    echo "BATALLA: $historia"
    echo "Casillas: $total ($rows x $cols)  Enemigos:$enemies  Tus unidades:$player_units"
    echo "Municion total: $(( w_ammo[Artilleria] + w_ammo[Recon] + w_ammo[Superbomba] ))"
    echo "  - Artilleria: ${w_ammo[Artilleria]}  Recon: ${w_ammo[Recon]}  Superbomba: ${w_ammo[Superbomba]}"
    echo

    local enemigos_vivos=0
    for ((i=0;i<total;i++)); do if [ "${hp[$i]}" -gt 0 ]; then enemigos_vivos=$((enemigos_vivos+1)); fi; done

    local turn=0

    reveal_area() {
        local cidx=$1; local radius=$2
        for ((r=-radius;r<=radius;r++)); do
            for ((s=-radius;s<=radius;s++)); do
                local rr=$(( cidx/cols + r ))
                local cc=$(( cidx%cols + s ))
                if [ "$rr" -ge 0 ] && [ "$rr" -lt "$rows" ] && [ "$cc" -ge 0 ] && [ "$cc" -lt "$cols" ]; then
                    local idx=$(( rr*cols + cc ))
                    visible[$idx]=1
                fi
            done
        done
    }

    while true; do

        turn=$((turn+1))
        echo "Turno $turn"

        # muestro municion restante por tipo y total cada turno
        local total_ammo=$(( w_ammo[Artilleria] + w_ammo[Recon] + w_ammo[Superbomba] ))
        echo "Municion (total $total_ammo): Artilleria=${w_ammo[Artilleria]}  Recon=${w_ammo[Recon]}  Superbomba=${w_ammo[Superbomba]}"

        print_grid grid $rows $cols visible "Mapa enemigo (niebla parcial)"
        print_grid player_map $rows $cols "" "Tu mapa (estructuras propias)"

        enemigos_vivos=0
        for ((i=0;i<total;i++)); do
            if [ "${hp[$i]}" -gt 0 ]; then
                enemigos_vivos=$((enemigos_vivos+1))
            fi
        done
        echo "Enemigos vivos: $enemigos_vivos"

        if [ "$enemigos_vivos" -le 0 ]; then
            echo "Victoria total!"
            break
        fi

        if [ "$total_ammo" -le 0 ]; then
            echo "Se ha agotado la municion. Has perdido."
            break
        fi

        echo "Elige arma: 1) Artilleria  2) Recon  3) Superbomba  - escribe rendirse / r / salir para rendirte"
        read -r -p "Opcion arma (numero): " aop
        if [[ "${aop,,}" =~ ^(rendirse|salir|r)$ ]]; then
            surrender_now
        fi
        if ! [[ "$aop" =~ ^[0-9]+$ ]]; then
            echo "Entrada invalida, turno perdido."
            continue
        fi
        if [ "$aop" -lt 1 ] || [ "$aop" -gt 3 ]; then
            echo "Entrada invalida, turno perdido."
            continue
        fi

        if [ "$aop" -eq 1 ]; then
            arma="Artilleria"
        elif [ "$aop" -eq 2 ]; then
            arma="Recon"
        else
            arma="Superbomba"
        fi

        if [ "${w_ammo[$arma]}" -le 0 ]; then
            echo "Municion de $arma agotada, turno perdido."
            continue
        fi

        read -r -p "Casilla objetivo (1..$total o ej. A3) - o rendirse: " targ
        if [[ "${targ,,}" =~ ^(rendirse|salir|r)$ ]]; then
            surrender_now
        fi

        tidx=$(convert_input_to_index "$targ" $cols $rows)
        if [ "$tidx" = "SURRENDER" ]; then surrender_now; fi
        if [ "$tidx" -lt 0 ]; then
            echo "Objetivo invalido."
            continue
        fi

        w_ammo[$arma]=$(( w_ammo[$arma] - 1 ))
        reveal_area $tidx ${w_radius[$arma]}

        if [ "${hp[$tidx]}" -gt 0 ]; then
            hp[$tidx]=$(( hp[$tidx] - w_damage[$arma] ))
            if [ "${hp[$tidx]}" -le 0 ]; then
                grid[$tidx]='H'
                echo "¡Impacto! unidad enemiga destruida en casilla $((tidx+1))."
            else
                echo "Impacto: unidad enemiga dañada (HP:${hp[$tidx]})."
            fi
        else
            grid[$tidx]='M'
            echo "No habia objetivo en esa casilla."
        fi

        local enemy_shots=$(( 1 + RANDOM % 3 ))
        for ((s=0;s<enemy_shots;s++)); do
            eidx=$(( RANDOM % total ))
            visible[$eidx]=1
            if [ "${player_map[$eidx]}" == "P" ]; then
                echo "$(rand_line enemy_hit_lines)"
                player_map[$eidx]='M'
            else
                echo "$(rand_line enemy_miss_lines)"
            fi
        done

        echo

    done

    echo "Fin Batalla completa."
}


if [ -z "${modo:-}" ]; then
  echo "Elija modo de juego:"
  echo "  1) Escaramuza (rápido, 4x5)"
  echo "  2) Batalla completa (mayor escala)"
  while true; do
    read -r -p "Modo (1/2): " choice
    case "$choice" in
      1) modo="escaramuza"; break;;
      2) modo="batalla"; break;;
      *) echo "Seleccione 1 o 2.";;
    esac
  done
fi

confirmar "¿Seguro?"
if [ "${modo}" = "escaramuza" ]; then
  skirmish
else
  battle
fi

echo "Terminado. Gracias."
