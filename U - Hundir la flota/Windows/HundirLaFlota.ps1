# Hundirlaflota.ps1

function Confirmar {
    param([string]$pregunta)
    while ($true) {
        $respuesta = Read-Host "$pregunta (Si/No)"
        if ($null -eq $respuesta) { continue }
        $r = $respuesta.ToLower()
        switch ($r) {
            'no' { Write-Host "Nuestro pais sera recordado por cobarde."; exit 0 }
            'n'  { Write-Host "Nuestro pais sera recordado por cobarde."; exit 0 }
            'si' { return }
            's'  { return }
            default { Write-Host "Por favor responda (Si o No)"; }
        }
    }
}

Write-Host " Va a iniciar el juego de hundir la flota"
Write-Host "Este juego esta tematizado con ambientacion en la 2a Guerra Mundial"
Write-Host "Jugaras al mando del Acorazado Iowa, y te enfrentaras a la temida flota nipona Yamato"
Write-Host "Podras huir del combate en cualquier momento, pero eso sera una deshonra para los EEUU"
Write-Host "A partir de ahora eres el Almirante Adler"
Write-Host "Buena suerte mi general"
Write-Host "------------"

Confirmar '¿Mi general, esta seguro de que quiere plantar seguir en la batalla?'

Write-Host "Asi se habla general. Se van a enterar los japoneses"
Write-Host "Marineros, virad a estribor. Tenemos unos islenos a los que bombardear"
Write-Host "-----------"
Write-Host "Mi general, hay mucha niebla, por lo que nuestros lanzamientos han de ser a ciegas"
Write-Host "He disenado un sistema de casillas para que me de la orden. Van del 1 al 25"

# Variables
[int]$vencedor = 0
[int]$vencido  = 1

# Arrays (25 casillas)
$buquesenemigos = @('T','-','T','-','-','-','T','-','-','T','-','-','-','T','-','-','T','-','T','T','T','-','-','T')
# (he usado 24 en el original; aqui ajusto para 25)
if ($buquesenemigos.Count -lt 25) {
    # Si faltan elementos los rellenamos con '-'
    while ($buquesenemigos.Count -lt 25) { $buquesenemigos += '-' }
}
$mapadeguerra = (1..25 | ForEach-Object { '-' })

# Juego principal
while ($vencido -ne 16) {
    if ($vencedor -eq 10) { break }

    Write-Host ""
    $movInput = Read-Host "¿Mi general, que casilla bombardeamos? (1-25) - escribe 'rendirse' para salir"
    if ($null -eq $movInput) { continue }
    $low = $movInput.ToLower()
    if ($low -in @('rendirse','r','salir')) {
        Write-Host "El Almirante Adler ha decidido retirarse. Nuestro honor esta empañado."
        exit 0
    }

    # validar numero
    if (-not ($movInput -as [int])) {
        Write-Host "Entrada invalida. Introduzca un numero entre 1 y 25."
        continue
    }
    $movimiento = [int]$movInput
    if ($movimiento -lt 1 -or $movimiento -gt 25) {
        Write-Host "Casilla fuera de rango. Elija entre 1 y 25."
        continue
    }

    $idx = $movimiento - 1

    if ($buquesenemigos[$idx] -eq 'T') {
        Write-Host "movimiento : $vencido"
        Write-Host "¡Mi general, hemos hundido un buque japones!"
        Write-Host "Sigamos hasta acabar con ellos"
        $mapadeguerra[$idx] = 'T'
        $buquesenemigos[$idx] = 'O'
        Write-Host ($mapadeguerra -join ' ')
        $vencedor = $vencedor + 1
        $vencido  = $vencido + 1
    }
    elseif ($buquesenemigos[$idx] -eq 'O') {
        Write-Host "Mi general, hemos vuelto a dar a un barco ya hundido"
        Write-Host ($mapadeguerra -join ' ')
    }
    else {
        Write-Host "Jugada : $vencido"
        Write-Host "Rayos, hemos errado el disparo y los nipones se acercan"
        $mapadeguerra[$idx] = 'M'
        Write-Host ($mapadeguerra -join ' ')
        $vencido = $vencido + 1

        # pedir confirmacion para seguir
        Confirmar '¿Mi general, esta seguro de que quiere seguir en la batalla?'
    }
}

if ($vencido -eq 16) {
    Write-Host "Nos hemos quedado sin municion, y los japoneses nos han alcanzado. Ha sido un honor luchar a su lado general Adler. Rezo a dios para que nuestra muerte sea rapida. --------------- EL acorazado Iowa ha sido destruido"
    Write-Host "----------"
    Write-Host "Gracias a Mercedes y a Anibal por ayudarme a aclararme con los comandos"
}
else {
    Write-Host "El general Adler ha conseguido hundir a la flota Yamato, y el general Nipon Kirito Seru ha cometido Seppuku. Nuestra victoria esta cada vez mas cerca. Puede volver a casa"
    Write-Host "----------"
    Write-Host "Gracias a Mercedes y a Anibal por ayudarme a aclararme con los comandos"
}

