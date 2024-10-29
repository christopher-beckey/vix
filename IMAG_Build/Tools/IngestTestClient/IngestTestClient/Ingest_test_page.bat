SET VIXHOST=localhost
SET VIXPORT=8080
SET LOCATION=B
SET TIUTITLE=D
SET TIUSTATUS=unsigned
SET AUTHORDUZ=20095
SET LOCALAV=boating1:boating1.
"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --user-data-dir="C:/Chrome dev session" --disable-web-security "file:///%~dp0/login.html?vix=%VIXHOST%&port=%VIXPORT%&loc=%LOCATION%&title=%TIUTITLE%&stat=%TIUSTATUS%&author=%AUTHORDUZ%&localAuth=%LOCALAV%"