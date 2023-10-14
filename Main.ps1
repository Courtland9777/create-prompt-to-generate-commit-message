function CopyGitDiffPromptToClipboard {
    <#
    .SYNOPSIS
    Checks if Git is available on the system and if the current directory is a Git repository. If both conditions are met, it retrieves the colored diff output using the `git diff` command. If there are changes detected, it creates a message with the diff output and copies it to the clipboard using the `ClipboardHelper` class.

    .EXAMPLE
    CopyGitDiffPromptToClipboard

    .NOTES
    None
    #>

    # Check if git is available on the system
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "git is not found on this system. Please install git or ensure it's available in PATH."
        return
    }

    # Check if the current directory is a git repository
    if (-not (Test-Path -PathType Container -Path (Join-Path -Path $PWD -ChildPath ".git"))) {
        Write-Error "The current directory is not a git repository."
        return
    }

    try {
        $diffOutput = git diff --color=always HEAD
    } catch {
        Write-Error "An error occurred while getting the git diff. Details: $($_.Exception.Message)"
        return
    }

    # Check if there are any changes
    if (-not $diffOutput) {
        Write-Output "No changes detected. Nothing to commit."
        return
    }

    $message = @"
---
INSTRUCTION: 
Please create a concise git commit summary and description based on the changes shown below.

DIFF OUTPUT:
$diffOutput
---
"@

    try {
        [Clipboard]::SetText($message)
        Write-Output "Copied to Clipboard."
    } catch {
        Write-Error "Failed to copy the message to the clipboard. Details: $($_.Exception.Message)"
    }
}
