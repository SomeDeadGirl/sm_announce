#include <sourcemod>
#include <tf2>
#include <tf2_stocks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
    name = "Server Announcement",
    author = "gloom",
    description = "Allows admins to send center-screen announcements via console command.",
    version = "1.1",
    url = ""
};

public void OnPluginStart()
{
    // Register the console command: sm_announce <message>
    RegAdminCmd("sm_announce", Command_Announce, ADMFLAG_ROOT, "sm_announce <message> - Sends a center-screen message to all players");
}

public Action Command_Announce(int client, int args)
{
    if (args < 1)
    {
        ReplyToCommand(client, "[SM] Usage: sm_announce <message>");
        return Plugin_Handled;
    }

    char message[256];
    GetCmdArgString(message, sizeof(message));

    // Create the formatted message
    // Center text does not support standard color codes like \x07, 
    // but it supports standard newlines \n for spacing.
    char buffer[512];
    Format(buffer, sizeof(buffer), "%s", message);

    // Send Center Text to all players
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && !IsFakeClient(i))
        {
            PrintCenterText(i, "%s", buffer);
        }
    }

    LogMessage("Center Announcement by %L: %s", client, message);

    return Plugin_Handled;
}