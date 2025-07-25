# 改进版：大文件分割脚本（流式处理，支持超大文件）
param(
    [Parameter(Mandatory=$true)]
    [string]$SourceFile,  # 源文件路径
    [Parameter(Mandatory=$true)]
    [long]$ChunkSize      # 每个分卷大小（字节）
)

# 确保文件路径是绝对路径
if (-not [System.IO.Path]::IsPathRooted($SourceFile)) {
    $SourceFile = Join-Path -Path (Get-Location) -ChildPath $SourceFile
}

# 检查源文件是否存在
if (-not (Test-Path $SourceFile)) {
    Write-Error "错误：源文件 '$SourceFile' 不存在！"
    exit 1
}

# 获取源文件信息
$file = Get-Item $SourceFile
$totalSize = $file.Length
$fileName = $file.Name
$baseName = $file.BaseName
$extension = $file.Extension

# 计算分卷数量
$chunkCount = [Math]::Ceiling($totalSize / $ChunkSize)
Write-Host "开始分割 '$fileName'（总大小：$($totalSize/1GB.ToString("0.00"))GB）"
Write-Host "分卷大小：$($ChunkSize/1GB.ToString("0.00"))GB，共 $chunkCount 个分卷"

# 定义缓冲区大小（64MB，可根据内存情况调整）
$bufferSize = 67108864  # 64MB
$buffer = New-Object byte[] $bufferSize

# 创建文件流读取源文件
$sourceStream = [System.IO.File]::OpenRead($SourceFile)

try {
    # 循环创建分卷文件
    for ($i = 0; $i -lt $chunkCount; $i++) {
        $chunkFileName = "$baseName$extension.$($i + 1).part"
        $chunkFilePath = Join-Path -Path (Get-Location) -ChildPath $chunkFileName
        $chunkStream = [System.IO.File]::OpenWrite($chunkFilePath)
        
        try {
            $bytesWritten = 0
            $bytesToWrite = [Math]::Min($ChunkSize, $totalSize - $i * $ChunkSize)
            
            Write-Host "正在生成分卷：$chunkFileName（目标大小：$($bytesToWrite/1MB.ToString("0.00"))MB）"
            
            # 逐块读取并写入分卷文件
            while ($bytesWritten -lt $bytesToWrite) {
                $bytesToRead = [Math]::Min($bufferSize, $bytesToWrite - $bytesWritten)
                $bytesRead = $sourceStream.Read($buffer, 0, $bytesToRead)
                
                if ($bytesRead -eq 0) { break }
                
                $chunkStream.Write($buffer, 0, $bytesRead)
                $bytesWritten += $bytesRead
                
                # 显示进度
                $percent = [Math]::Floor(($bytesWritten / $bytesToWrite) * 100)
                Write-Progress -Activity "分卷 $($i + 1)/$chunkCount" -Status "$percent% 完成" -PercentComplete $percent
            }
            
            Write-Progress -Activity "分卷 $($i + 1)/$chunkCount" -Completed
            Write-Host "已完成分卷：$chunkFileName（实际大小：$($bytesWritten/1MB.ToString("0.00"))MB）"
        }
        finally {
            $chunkStream.Close()
        }
    }
}
finally {
    $sourceStream.Close()
}

Write-Host "`n分割完成！所有分卷已保存到当前目录。"