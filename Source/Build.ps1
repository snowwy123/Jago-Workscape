$ErrorActionPreference='Stop'
$compiler=Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'
$source=Join-Path $PSScriptRoot 'Workspace.cs'
$output=Join-Path (Split-Path $PSScriptRoot) 'Jago-Workscape.exe'
$iconResources=@()
foreach($file in Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'Brand') -Filter '*.png'){ $iconResources+=('/resource:'+$file.FullName+',Jago.Icon.'+$file.BaseName+'.png') }
& $compiler @iconResources /nologo /target:winexe /platform:x64 /optimize+ /utf8output ('/out:'+$output) ('/win32manifest:'+(Join-Path $PSScriptRoot 'app.manifest')) ('/win32icon:'+(Join-Path $PSScriptRoot 'workspace.ico')) /reference:System.dll /reference:System.Core.dll /reference:System.Drawing.dll /reference:System.Windows.Forms.dll /reference:System.Web.Extensions.dll $source (Join-Path $PSScriptRoot 'StudioManager.cs') (Join-Path $PSScriptRoot 'LifecycleTests.cs') (Join-Path $PSScriptRoot 'Handoff.cs') (Join-Path $PSScriptRoot 'KeyboardTests.cs') (Join-Path $PSScriptRoot 'EmbeddedKeyboard.cs') (Join-Path $PSScriptRoot 'BrandingTests.cs') (Join-Path $PSScriptRoot 'ScrollTests.cs')
if($LASTEXITCODE -ne 0){throw 'Workspace build failed'}
