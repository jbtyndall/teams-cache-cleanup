# Teams Cache Cleanup

Sometimes it is necessary to clear the Microsoft Teams cache to resolve issues such as:

* Teams not loading or stuck on a blank screen
* Missing messages, channels, or calendar/calendar entries
* Sign-in problems or authentication errors
* Outdated UI elements after updates

This script automates the process by closing Teams and Office apps, removing cache files, and restarting the apps. Both **New Teams** and **Classic Teams** are supported.

Clearing the Teams cache is **nondestructive**: it only removes temporary cache files. User data, including chats, files, and settings, will be preserved after clearing the cache. 

*Users will need to sign in to Teams again after the cleanup.*

## Features
- Detects and closes running Office apps and Teams.
- Clears Teams cache:
  - **New Teams**: `%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe`
  - **Classic Teams**: `%APPDATA%\Microsoft\Teams`
- Waits until Teams is fully closed before cleaning up.
- Restarts previously closed apps.
- Logs actions to `%TEMP%\TeamsCleanup.log`.
- Optional system restart prompt.

## Usage
1. Download the **[batch file](teams-cache-cleanup.bat).**

1. Double-click **teams-cache-cleanup.bat** to run.

1. Follow the prompts:

   * Save your work.
   * Confirm optional restart when prompted.

---

## Logging

Actions are logged to:

```
%TEMP%\TeamsCleanup.log
```

Example log entry:
```
[11/05/2025 08:30:12] Closed outlook.exe
[11/05/2025 08:30:15] Cleared New Teams cache
```

## Notes

* This script removes the Teams cache completely but **does not delete user data**.
* Users will need to sign in again after cleanup.
* If Teams or Office apps fail to restart, check the log file for errors.

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.
