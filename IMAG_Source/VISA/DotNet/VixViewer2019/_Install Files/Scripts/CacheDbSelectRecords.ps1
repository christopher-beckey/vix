param(
	[Parameter(Mandatory=$false)][string]$relativePath,
	[Parameter(Mandatory=$false)][string]$pathToSqlite3 = "C:\Program Files\VistA\Imaging\VIX.Render.Service\Db\sqlite3.exe",
	[Parameter(Mandatory=$false)][string]$pathToDb = "C:\Program Files\VistA\Imaging\VIX.Render.Service\Db\SqliteDb.db",
	[Parameter(Mandatory=$false)][string]$outFile)

$msg = "relativePath = " + $relativePath
Write-Output $msg
$msg = "outFile = " + $outFile
Write-Output $msg

if ($relativePath -eq "1")
{
	$pathToSqlite3="..\VIX.Render.Service\Db\sqlite3.exe"
	$pathToDb="..\VIX.Render.Service\Db\SqliteDb.db"
}

$tableNames = & $pathToSqlite3 $pathToDb "SELECT name FROM sqlite_master where type = 'table'"

if($null -ne $outFile -and ![string]::IsNullOrWhiteSpace($outFile))
{
	Start-Transcript -Path $outFile
}

$msg = "sqlite3.exe path = " + $pathToSqlite3
Write-Output $msg
$msg = "database path =    " + $pathToDb
Write-Output $msg

foreach($name in $tableNames)
{
	Write-Output "---"
	$msg = "Table name = $name"
	Write-Output $msg
	$selectFieldNames = "SELECT group_concat(name,'|') from pragma_table_info('$name')"
	$fieldNames = & $pathToSqlite3 $pathToDb $selectFieldNames
	$msg = "Field names = " + $fieldNames
	Write-Output $msg
	& $pathToSqlite3 $pathToDb "SELECT * FROM $name" | Write-Output
    & $pathToSqlite3 $pathToDb "SELECT 'Record count = ' || COUNT(*) FROM $name" | Write-Output
}

if($null -ne $outFile -and ![string]::IsNullOrWhiteSpace($outFile))
{
	Stop-Transcript
}