# Hundirlaflota_windows.ps1



try { chcp 65001 > $null } catch {}
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# arrays de texto
$start_lines = @(
"La niebla de la manana lo oculta todo."
"El horizonte se tiñe de plomo y polvora."
"El silencio del mar precede a la tormenta."
"Las sirenas de ataque rompen la calma."
"Navegamos a ciegas, hacia el inevitable choque."
"Se oyen disparos lejanos... amigos o enemigos?"
"El radar no detecta nada, pero la tension es maxima."
"El destino del oceano esta a punto de decidirse."
"Los canones rugen, marcando el inicio de la batalla."
"Maniobras de evasion. El enemigo esta cerca."
)

$hit_lines = @(
"Impacto directo! El casco cruje."
"Una columna de humo negro se alza en la distancia."
"Explosion a babor, parece grave."
"El mar se tiñe de rojo."
"Los carronyeros del mar tendran un festin."
"Un impacto limpio. Bien hecho!"
"Han recibido de lleno. Se tambalean."
)

$miss_lines = @(
"Salpicaduras de agua. El misil ha quedado corto."
"Demasiada distancia. El proyectil se pierde en el mar."
"Fallo! Hemos sobrepasado el objetivo."
"Un estruendo, pero solo el agua ha temblado."
"El objetivo esquiva el proyectil con pericia."
)

$enemy_hit_lines = @(
"Hemos recibido un impacto! Alerta maxima."
"El enemigo ha encontrado un punto debil, danos en la sala de maquinas!"
"Alarma de incendio. El fuego se extiende rapidamente!"
"Nos han alcanzado. La estructura se tambalea."
)

$enemy_miss_lines = @(
"El estruendo resuena en la distancia, pero el impacto ha sido en el agua."
"Han fallado el tiro. Por suerte."
"Un ruido sordo. Por poco."
"El enemigo ha subestimado la distancia, esquivado!"
)

function Rand-Line {
    param([array]$arr)
    if ($arr.Count -eq 0) { return "" }
    $i = Get-Random -Minimum 0 -Maximum $arr.Count
    return $arr[$i]
}

$historias = @(
"Guerra de Marruecos (1909-1927)",
"Guerra del Pacifico - WWII (1941-1945)",
"Guerra de Crimea (1853-1856)",
"Campana de Gallipoli - WWI (1915)",
"Guerra de Independencia de Indonesia (1945-1949)"
)

$jug_names_0 = @("Acosta","Serrano","De la Hoz","Pena","Ruiz")
$ene_names_0 = @("Abdel-Krim","Alaoui","Awada","Saadi","Mehdi")

$jug_names_1 = @("Patterson","Henderson","Fitzgerald","Sullivan","Morgan")
$ene_names_1 = @("Hayashi","Nagumo","Kondo","Ozawa","Yamamoto")

$jug_names_2 = @("Volkonsky","Chernyshev","Bagration","Kutuzov","Orlov")
$ene_names_2 = @("Mitchell","Hartwell","Pemberton","Ashford","Bennett")

$jug_names_3 = @("Kemal","Enver","Cemal","Fevzi","Fuad")
$ene_names_3 = @("Thornton","Blackwood","Caldwell","Morrison","Harris")

$jug_names_4 = @("Sukarno","Nasution","Sudirman","Yani","Suharto")
$ene_names_4 = @("Van Mook","Spoor","Buurman","De Ruyter","Van der Plas")

# elegir historia y nombres
$random_index = Get-Random -Minimum 0 -Maximum $historias.Count
$historia = $historias[$random_index]

switch ($random_index) {
    0 { $JNAMES = $jug_names_0; $ENAMES = $ene_names_0 }
    1 { $JNAMES = $jug_names_1; $ENAMES = $ene_names_1 }
    2 { $JNAMES = $jug_names_2; $ENAMES = $ene_names_2 }
    3 { $JNAMES = $jug_names_3; $ENAMES = $ene_names_3 }
    default { $JNAMES = $jug_names_4; $ENAMES = $ene_names_4 }
}

$PLAYER_SHORT = Get-Random -InputObject $JNAMES
$ENEMY_SHORT  = Get-Random -InputObject $ENAMES
$PLAYER_NAME = "Comandante $PLAYER_SHORT"
$ENEMY_NAME  = "Comandante $ENEMY_SHORT"

# inicio narrativo
Write-Host ""
Write-Host "========================================"
Write-Host "  $historia"
Write-Host "  $PLAYER_NAME  vs  $ENEMY_NAME"
Write-Host "----------------------------------------"
Write-Host "  $(Rand-Line $start_lines)"
Write-Host "  El conflicto se presenta en la costa, con niebla y artilleria. Buena suerte."
Write-Host "========================================"
Write-Host ""

function Confirmar {
    param([string]$pregunta)
    while ($true) {
        $respuesta = Read-Host "$pregunta (Si/No)"
        if ($null -eq $respuesta) { continue }
        $r = $respuesta.ToLower()
        $r = $r -replace '[íì]','i' -replace '[áà]','a' -replace '[éè]','e' -replace '[óò]','o' -replace '[úù]','u' -replace 'ñ','n'
        switch ($r) {
            'no' { Write-Host "Nuestro pais sera recordado por cobarde."; exit 0 }
            'n'  { Write-Host "Nuestro pais sera recordado por cobarde."; exit 0 }
            'si' { return }
            's'  { return }
            default { Write-Host "Por favor responda (Si o No)"; }
        }
    }
}

function Print-Grid {
    param(
        [array]$arr,
        [int]$rows,
        [int]$cols,
        [array]$vis = $null,
        [string]$title = ""
    )
    if ($null -eq $vis) {
        $vis = @()
        for ($i=0; $i -lt $rows*$cols; $i++) { $vis += 1 }
    }

    if ($title -ne "") { Write-Host $title }

    $line = "    "
    for ($c=0; $c -lt $cols; $c++) {
        $letter = [char](65 + $c)
        $line += (" {0,2}" -f $letter)
    }
    Write-Host $line

    for ($r=1; $r -le $rows; $r++) {
        $rowstr = (" {0,2} " -f $r)
        for ($c=0; $c -lt $cols; $c++) {
            $idx = ($r - 1) * $cols + $c
            if ($vis[$idx] -eq 1) {
                $cell = $arr[$idx]
                switch ($cell) {
                    "E" { $rowstr += "  E " }
                    "H" { $rowstr += "  X " }
                    "M" { $rowstr += "  o " }
                    "P" { $rowstr += "  P " }
                    "-" { $rowstr += "  . " }
                    default { $rowstr += (" {0,2}" -f $cell) }
                }
            } else {
                $rowstr += "  # "
            }
        }
        Write-Host $rowstr
    }
    Write-Host ""
}

function Convert-InputToIndex {
    param([string]$mov, [int]$cols, [int]$rows)
    if ($mov -match '^(?i)(rendirse|salir|r)$') { return "SURRENDER" }
    if ($mov -match '^[0-9]+$') {
        $n = [int]$mov
        if ($n -lt 1 -or $n -gt $rows*$cols) { return -1 }
        return ($n - 1)
    }
    if ($mov -match '^([A-Za-z])([0-9]+)$') {
        $col_letter = $matches[1].ToUpper()
        $rownum = [int]$matches[2]
        $col_idx = [int][char]$col_letter - 65
        if ($col_idx -lt 0 -or $col_idx -ge $cols) { return -1 }
        if ($rownum -lt 1 -or $rownum -gt $rows) { return -1 }
        return (($rownum - 1) * $cols + $col_idx)
    }
    return -1
}

function Choose-RandomPositions {
    param([int]$total, [int]$count)
    $arr = @()
    while ($arr.Count -lt $count) {
        $v = Get-Random -Minimum 0 -Maximum $total
        if ($arr -notcontains $v) { $arr += $v }
    }
    return $arr
}

function Surrender-Now {
    param([string]$player, [string]$hist)
    Write-Host ""
    Write-Host "El $player ha decidido rendirse. La campaña termina."
    Write-Host "Fin de la campana: $hist"
    Write-Host ""
    exit 0
}

function Skirmish {
    # 4x5
    $rows = 4; $cols = 5
    $total = $rows * $cols

    $enemy_map = @(); $enemy_vis = @()
    $player_map = @(); $player_vis = @()
    for ($i=0; $i -lt $total; $i++) {
        $enemy_map += '-'; $enemy_vis += 0
        $player_map += '-'; $player_vis += 1
    }

    $enemies = 5 + (Get-Random -Minimum 0 -Maximum 6)
    $player_units = 5

    $epos = Choose-RandomPositions -total $total -count $enemies
    foreach ($p in $epos) { $enemy_map[$p] = 'E' }

    $playerpos = @()
    while ($playerpos.Count -lt $player_units) {
        $p = Get-Random -Minimum 0 -Maximum $total
        if ($enemy_map[$p] -eq 'E') { continue }
        if ($playerpos -notcontains $p) { $playerpos += $p }
    }
    foreach ($p in $playerpos) { $player_map[$p] = 'P' }

    Write-Host "Comienza Escaramuza ($historia). $PLAYER_NAME vs $ENEMY_NAME"
    Write-Host "Entrada: numero (1..$total) o A1  - escribe rendirse / r / salir para rendirte"
    Write-Host ""

    $vidas = $player_units
    $enemies_sunk = 0

    while ($true) {
        Print-Grid -arr $enemy_map -rows $rows -cols $cols -vis $enemy_vis -title "Mapa enemigo (niebla)"
        Print-Grid -arr $player_map -rows $rows -cols $cols -title "Tu mapa (unidades propias)"

        $mov_raw = Read-Host "Que casilla atacamos?"
        if ($mov_raw -match '^(?i)(rendirse|salir|r)$') { Surrender-Now -player $PLAYER_NAME -hist $historia }

        $idx = Convert-InputToIndex -mov $mov_raw -cols $cols -rows $rows
        if ($idx -eq "SURRENDER") { Surrender-Now -player $PLAYER_NAME -hist $historia }
        if ([int]$idx -lt 0) { Write-Host "Entrada invalida."; continue }

        $enemy_vis[$idx] = 1
        if ($enemy_map[$idx] -eq 'E') {
            Write-Host (Rand-Line $hit_lines)
            $enemy_map[$idx] = 'H'
            $enemies_sunk++
        } elseif ($enemy_map[$idx] -eq 'H') {
            Write-Host "Esa ya esta hundida."
        } else {
            Write-Host (Rand-Line $miss_lines)
            $enemy_map[$idx] = 'M'
        }

        if ($enemies_sunk -ge $enemies) { Write-Host "Victoria en Escaramuza!"; break }

        $e_shot = Get-Random -Minimum 0 -Maximum $total
        $enemy_vis[$e_shot] = 1
        if ($player_map[$e_shot] -eq 'P') {
            Write-Host (Rand-Line $enemy_hit_lines)
            $player_map[$e_shot] = 'M'
            $vidas--
            Write-Host "Unidades: $vidas"
        } else {
            Write-Host (Rand-Line $enemy_miss_lines)
        }

        if ($vidas -le 0) { Write-Host "Has perdido todas las unidades. Fin."; break }
        Write-Host ""
    }

    Write-Host "Fin Escaramuza."
}

function Battle {
    $total = 60 + (Get-Random -Minimum 0 -Maximum 41)
    $cols = 10
    $rows = [math]::Ceiling($total / $cols)
    $total = $rows * $cols

    $grid = @(); $hp = @(); $visible = @()
    for ($i=0; $i -lt $total; $i++) { $grid += '-'; $hp += 0; $visible += 0 }

    $player_map = @(); $player_vis = @()
    for ($i=0; $i -lt $total; $i++) { $player_map += '-'; $player_vis += 1 }

    $unit_hp = @{ Fragata=1; Crucero=2; Ac0razado=4; Polvorin=2 }
    $enemies = 20 + (Get-Random -Minimum 0 -Maximum 11)

    function Place-Cluster {
        param($center, $size)
        for ($i=0; $i -lt $size; $i++) {
            $attempt = $center + (Get-Random -Minimum -3 -Maximum 4)
            if ($attempt -lt 0 -or $attempt -ge $total) { continue }
            if ($hp[$attempt] -eq 0) {
                $tnum = Get-Random -Minimum 0 -Maximum 4
                switch ($tnum) {
                    0 { $type = "Fragata" }
                    1 { $type = "Crucero" }
                    2 { $type = "Ac0razado" }
                    default { $type = "Polvorin" }
                }
                $grid[$attempt] = 'E'
                $hp[$attempt] = $unit_hp[$type]
            }
        }
    }

    function Place-Line {
        param($start, $length)
        $dir = Get-Random -Minimum 0 -Maximum 2
        for ($i=0; $i -lt $length; $i++) {
            if ($dir -eq 0) { $idx = $start + $i } else { $idx = $start + $i * $cols }
            if ($idx -lt 0 -or $idx -ge $total) { break }
            if ($hp[$idx] -eq 0) {
                $tnum = Get-Random -Minimum 0 -Maximum 4
                switch ($tnum) {
                    0 { $type = "Fragata" }
                    1 { $type = "Crucero" }
                    2 { $type = "Ac0razado" }
                    default { $type = "Polvorin" }
                }
                $grid[$idx] = 'E'
                $hp[$idx] = $unit_hp[$type]
            }
        }
    }

    $placed = 0
    while ($placed -lt $enemies) {
        $strat = Get-Random -Minimum 0 -Maximum 3
        $center = Get-Random -Minimum 0 -Maximum $total
        if ($strat -eq 0) {
            $size = 1 + (Get-Random -Minimum 0 -Maximum 4)
            Place-Cluster -center $center -size $size
        } elseif ($strat -eq 1) {
            $length = 2 + (Get-Random -Minimum 0 -Maximum 5)
            Place-Line -start $center -length $length
        } else {
            if ($hp[$center] -eq 0) {
                $tnum = Get-Random -Minimum 0 -Maximum 4
                switch ($tnum) {
                    0 { $ty = "Fragata" }
                    1 { $ty = "Crucero" }
                    2 { $ty = "Ac0razado" }
                    3 { $ty = "Polvorin" }
                }
                $grid[$center] = 'E'
                $hp[$center] = $unit_hp[$ty]
            }
        }

        $placed = 0
        for ($i=0; $i -lt $total; $i++) { if ($hp[$i] -gt 0) { $placed++ } }
        if ($placed -gt $enemies) { break }
    }

    $offset = (Get-Random -Minimum -10 -Maximum 11)
    $player_units = $enemies + $offset
    if ($player_units -lt 1) { $player_units = 1 }

    $mypos = Choose-RandomPositions -total $total -count $player_units
    foreach ($p in $mypos) { $player_map[$p] = 'P' }

    $w_damage = @{ Artilleria=1; Recon=0; Superbomba=3 }
    $w_radius = @{ Artilleria=0; Recon=1; Superbomba=1 }
    $w_ammo   = @{ Artilleria=97; Recon=2; Superbomba=1 }

    Write-Host "BATALLA: $historia"
    Write-Host "Casillas: $total ($rows x $cols)  Enemigos:$enemies  Tus unidades:$player_units"
    $totalAmmo = $w_ammo["Artilleria"] + $w_ammo["Recon"] + $w_ammo["Superbomba"]
    Write-Host "Municion total: $totalAmmo"
    Write-Host "  - Artilleria: $($w_ammo['Artilleria'])  Recon: $($w_ammo['Recon'])  Superbomba: $($w_ammo['Superbomba'])"
    Write-Host ""

    $enemigos_vivos = 0
    for ($i=0; $i -lt $total; $i++) { if ($hp[$i] -gt 0) { $enemigos_vivos++ } }

    $turn = 0

    function Reveal-Area {
        param($cidx, $radius)
        for ($r=-$radius; $r -le $radius; $r++) {
            for ($s=-$radius; $s -le $radius; $s++) {
                $rr = [math]::Floor($cidx / $cols) + $r
                $cc = ($cidx % $cols) + $s
                if ($rr -ge 0 -and $rr -lt $rows -and $cc -ge 0 -and $cc -lt $cols) {
                    $idx = $rr * $cols + $cc
                    $visible[$idx] = 1
                }
            }
        }
    }

    while ($true) {
        $turn++
        Write-Host "Turno $turn"

        $totalAmmo = $w_ammo["Artilleria"] + $w_ammo["Recon"] + $w_ammo["Superbomba"]
        Write-Host "Municion (total $totalAmmo): Artilleria=$($w_ammo['Artilleria'])  Recon=$($w_ammo['Recon'])  Superbomba=$($w_ammo['Superbomba'])"

        Print-Grid -arr $grid -rows $rows -cols $cols -vis $visible -title "Mapa enemigo (niebla parcial)"
        Print-Grid -arr $player_map -rows $rows -cols $cols -title "Tu mapa (estructuras propias)"

        $enemigos_vivos = 0
        for ($i=0; $i -lt $total; $i++) { if ($hp[$i] -gt 0) { $enemigos_vivos++ } }
        Write-Host "Enemigos vivos: $enemigos_vivos"

        if ($enemigos_vivos -le 0) { Write-Host "Victoria total!"; break }
        if ($totalAmmo -le 0) { Write-Host "Se ha agotado la municion. Has perdido."; break }

        Write-Host "Elige arma: 1) Artilleria  2) Recon  3) Superbomba  - escribe rendirse / r / salir para rendirte"
        $aop = Read-Host "Opcion arma (numero)"
        if ($aop -match '^(?i)(rendirse|salir|r)$') { Surrender-Now -player $PLAYER_NAME -hist $historia }
        if (-not ($aop -match '^[0-9]+$')) { Write-Host "Entrada invalida, turno perdido."; continue }
        $aop = [int]$aop
        if ($aop -lt 1 -or $aop -gt 3) { Write-Host "Entrada invalida, turno perdido."; continue }

        if ($aop -eq 1) { $arma = "Artilleria" }
        elseif ($aop -eq 2) { $arma = "Recon" }
        else { $arma = "Superbomba" }

        if ($w_ammo[$arma] -le 0) { Write-Host "Municion de $arma agotada, turno perdido."; continue }

        $targ = Read-Host "Casilla objetivo (1..$total o ej. A3) - o rendirse"
        if ($targ -match '^(?i)(rendirse|salir|r)$') { Surrender-Now -player $PLAYER_NAME -hist $historia }

        $tidx = Convert-InputToIndex -mov $targ -cols $cols -rows $rows
        if ($tidx -eq "SURRENDER") { Surrender-Now -player $PLAYER_NAME -hist $historia }
        if ([int]$tidx -lt 0) { Write-Host "Objetvo invalido."; continue }

        $w_ammo[$arma] = $w_ammo[$arma] - 1
        Reveal-Area -cidx $tidx -radius $w_radius[$arma]

        if ($hp[$tidx] -gt 0) {
            $hp[$tidx] = $hp[$tidx] - $w_damage[$arma]
            if ($hp[$tidx] -le 0) {
                $grid[$tidx] = 'H'
                Write-Host "Impacto! unidad enemiga destruida en casilla $($tidx+1)."
            } else {
                Write-Host "Impacto: unidad enemiga danada (HP:$($hp[$tidx]))."
            }
        } else {
            $grid[$tidx] = 'M'
            Write-Host "No habia objetivo en esa casilla."
        }

        $enemy_shots = 1 + (Get-Random -Minimum 0 -Maximum 3)
        for ($s=0; $s -lt $enemy_shots; $s++) {
            $eidx = Get-Random -Minimum 0 -Maximum $total
            $visible[$eidx] = 1
            if ($player_map[$eidx] -eq 'P') {
                Write-Host "El enemigo ha alcanzado una de tus estructuras en casilla $($eidx+1)."
                $player_map[$eidx] = 'M'
            } else {
                if ($hp[$eidx] -gt 0) {
                    $hp[$eidx] = $hp[$eidx] - 1
                    if ($hp[$eidx] -le 0) {
                        $grid[$eidx] = 'H'
                        Write-Host "Fuego enemigo destruye unidad enemiga en casilla $($eidx+1)."
                    }
                }
            }
        }

        Write-Host ""
    }

    Write-Host "Fin Batalla completa."
}

# pedir modo si no esta definido
if (-not $env:modo -and -not (Get-Variable -Name modo -Scope Script -ErrorAction SilentlyContinue)) {
    Write-Host "Elija modo de juego:"
    Write-Host "  1) Escaramuza (rapido, 4x5)"
    Write-Host "  2) Batalla completa (mayor escala)"
    while ($true) {
        $choice = Read-Host "Modo (1/2)"
        if ($choice -eq '1') { $script:modo = "escaramuza"; break }
        if ($choice -eq '2') { $script:modo = "batalla"; break }
        Write-Host "Seleccione 1 o 2."
    }
} else {
    # si la variable modo esta en entorno o en script, usarla
    if ($env:modo) { $script:modo = $env:modo }
}

Confirmar "Seguro?"
if ($script:modo -eq "escaramuza") {
    Skirmish
} else {
    Battle
}

Write-Host "Terminado. Gracias."
