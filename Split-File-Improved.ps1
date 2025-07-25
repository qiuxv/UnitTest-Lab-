# �Ľ��棺���ļ��ָ�ű�����ʽ����֧�ֳ����ļ���
param(
    [Parameter(Mandatory=$true)]
    [string]$SourceFile,  # Դ�ļ�·��
    [Parameter(Mandatory=$true)]
    [long]$ChunkSize      # ÿ���־��С���ֽڣ�
)

# ȷ���ļ�·���Ǿ���·��
if (-not [System.IO.Path]::IsPathRooted($SourceFile)) {
    $SourceFile = Join-Path -Path (Get-Location) -ChildPath $SourceFile
}

# ���Դ�ļ��Ƿ����
if (-not (Test-Path $SourceFile)) {
    Write-Error "����Դ�ļ� '$SourceFile' �����ڣ�"
    exit 1
}

# ��ȡԴ�ļ���Ϣ
$file = Get-Item $SourceFile
$totalSize = $file.Length
$fileName = $file.Name
$baseName = $file.BaseName
$extension = $file.Extension

# ����־�����
$chunkCount = [Math]::Ceiling($totalSize / $ChunkSize)
Write-Host "��ʼ�ָ� '$fileName'���ܴ�С��$($totalSize/1GB.ToString("0.00"))GB��"
Write-Host "�־��С��$($ChunkSize/1GB.ToString("0.00"))GB���� $chunkCount ���־�"

# ���建������С��64MB���ɸ����ڴ����������
$bufferSize = 67108864  # 64MB
$buffer = New-Object byte[] $bufferSize

# �����ļ�����ȡԴ�ļ�
$sourceStream = [System.IO.File]::OpenRead($SourceFile)

try {
    # ѭ�������־��ļ�
    for ($i = 0; $i -lt $chunkCount; $i++) {
        $chunkFileName = "$baseName$extension.$($i + 1).part"
        $chunkFilePath = Join-Path -Path (Get-Location) -ChildPath $chunkFileName
        $chunkStream = [System.IO.File]::OpenWrite($chunkFilePath)
        
        try {
            $bytesWritten = 0
            $bytesToWrite = [Math]::Min($ChunkSize, $totalSize - $i * $ChunkSize)
            
            Write-Host "�������ɷ־�$chunkFileName��Ŀ���С��$($bytesToWrite/1MB.ToString("0.00"))MB��"
            
            # ����ȡ��д��־��ļ�
            while ($bytesWritten -lt $bytesToWrite) {
                $bytesToRead = [Math]::Min($bufferSize, $bytesToWrite - $bytesWritten)
                $bytesRead = $sourceStream.Read($buffer, 0, $bytesToRead)
                
                if ($bytesRead -eq 0) { break }
                
                $chunkStream.Write($buffer, 0, $bytesRead)
                $bytesWritten += $bytesRead
                
                # ��ʾ����
                $percent = [Math]::Floor(($bytesWritten / $bytesToWrite) * 100)
                Write-Progress -Activity "�־� $($i + 1)/$chunkCount" -Status "$percent% ���" -PercentComplete $percent
            }
            
            Write-Progress -Activity "�־� $($i + 1)/$chunkCount" -Completed
            Write-Host "����ɷ־�$chunkFileName��ʵ�ʴ�С��$($bytesWritten/1MB.ToString("0.00"))MB��"
        }
        finally {
            $chunkStream.Close()
        }
    }
}
finally {
    $sourceStream.Close()
}

Write-Host "`n�ָ���ɣ����з־��ѱ��浽��ǰĿ¼��"