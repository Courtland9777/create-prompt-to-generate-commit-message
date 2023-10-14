# create-prompt-to-generate-commit-message
This PowerShell function checks if Git is available on the system and if the current directory is a Git repository. If both conditions are met, it retrieves the colored diff output using the git diff command. If there are changes detected, it creates a message with the diff output and copies it to the clipboard using the ClipboardHelper class.
