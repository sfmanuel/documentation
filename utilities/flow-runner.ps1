param (
    [Parameter(Mandatory=$true)][string]$FLOW
)

Write-Host "Runinng flow..."
$DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
$TOKEN_FILE = "${DIR}/token"
if (-Not (Test-Path "${TOKEN_FILE}"))
{
    Invoke-Expression -Command "${DIR}/auth.ps1"
}
$TOKEN = Get-Content -Path "${TOKEN_FILE}"

if (-Not (Test-Path "${FLOW}"))
{
    Write-Error "flow ${FLOW} does not exist"
    Exit 1
}
Write-Host "Flow: ${FLOW}"

$NAME = Split-Path "${FLOW}" -Leaf
$SCRIPT_PLAIN = Get-Content "${FLOW}"
$BYTES = [System.Text.Encoding]::Ascii.GetBytes($SCRIPT_PLAIN)
$SCRIPT = [Convert]::ToBase64String($BYTES)

$EXECUTION = @{
    script = "${SCRIPT}"
    name = "${NAME}"
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "https://cloudomation.com/api/1/execution" `
    -Method Post `
    -Body "${EXECUTION}" `
    -Headers @{Authorization = "${TOKEN}"}
