Write-Host "Authenticating..."
$CLIENT_NAME_DEFAULT = "CorpInc AG"
$CLIENT_NAME = Read-Host -Prompt "Client Name [${CLIENT_NAME_DEFAULT}]"
if ("${CLIENT_NAME}" -eq "") {
    $CLIENT_NAME = "${CLIENT_NAME_DEFAULT}"
}
$USER_NAME_DEFAULT = "kevin"
$USER_NAME = Read-Host -Prompt "User Name [${USER_NAME_DEFAULT}]"
if ("${USER_NAME}" -eq "") {
    $USER_NAME = "${USER_NAME_DEFAULT}"
}
$PASSWORD_SEC = Read-Host -AsSecureString 'Password'
$PASSWORD = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(${PASSWORD_SEC}))

$AUTH = @{
    client_name = "${CLIENT_NAME}"
    user_name = "${USER_NAME}"
    password = "${PASSWORD}"
} | ConvertTo-Json

Write-Host "Sending auth..."
try {
    $REPLY = Invoke-RestMethod -Uri "https://cloudomation.io/api/1/auth" -Method Post -Body "${AUTH}"
}
catch {
    $STATUS_CODE = $_.Exception.Response.StatusCode.value__
    if ($STATUS_CODE -eq "401") {
        Write-Error "Authentication failed: ${STATUS_CODE}"
        Exit 1
    }
}

echo "Extracting token..."
if(${REPLY}.token -eq $null) {
    Write-Error "Failed to extract token!"
    Exit 1
}
$TOKEN = ${REPLY}.token

$DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
$TOKEN_FILE = "${DIR}/token"
if (-Not (Test-Path "${TOKEN_FILE}"))
{
    New-Item -ItemType file "${TOKEN_FILE}" | Out-Null
}
if ($IsLinux) {
    Invoke-Expression "chmod 600 `"${TOKEN_FILE}`""
} elseif($IsWindows) {
    Set-ItemProperty "${TOKEN_FILE}" -name IsReadOnly -value $false
}
Set-Content -Path "${TOKEN_FILE}" -Value "${TOKEN}"
if ($IsLinux) {
    Invoke-Expression "chmod 400 `"${TOKEN_FILE}`""
} elseif($IsWindows) {
    Set-ItemProperty "${TOKEN_FILE}" -name IsReadOnly -value $true
}
Write-Host "Token was stored in ${TOKEN_FILE}. All done!"
