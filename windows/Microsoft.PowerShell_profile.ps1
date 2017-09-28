function Docker-Connect {
    docker exec -t -i dev /bin/bash -c 'su - wherewolf'
}

function Docker-Run {
	C:\Users\lathonez\code\wherewolf\docker\postgres\run.ps1
	C:\Users\lathonez\code\wherewolf\docker\dev\run.ps1
}

function Sublime([string]$arg1) {
	C:\Program` Files\Sublime` Text` 3\subl.exe $arg1
}

function Meld([string]$arg1, [string]$arg2) {
	git difftool --dir-diff
}

function Branch([string]$arg1) {
	C:\Users\lathonez\code\wherewolf\helperscripts\branch.ps1 $arg1
}

function Esp() {
	$allArgs = $PsBoundParameters.Values + $args
	node C:\Users\lathonez\code\wherewolf\Espresso\bin\espresso.js $allArgs
}

Set-Location ~/code
Set-Alias dc Docker-Connect
Set-Alias dr Docker-Run
Set-Alias subl Sublime
Set-Alias espresso Esp

Import-Module Posh-Git
