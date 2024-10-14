#include <sourcemod>
#include <sdktools>

public Plugin:myinfo =
{
    name = "HudText On Spawn",
    author = "Lucas",
    description = "Exibe uma mensagem HUD piscando na tela quando o jogador spawnar",
    version = "1.0",
    url = "http://farwest.com.br"
};

Handle hHudTimer[MAXPLAYERS + 1] = {INVALID_HANDLE, ...}; // Array para armazenar o timer de cada jogador
bool bShowHud[MAXPLAYERS + 1] = {false, ...}; // Array para controlar o estado de visibilidade do HUD

public void OnPluginStart()
{
  LoadTranslations("Hud-alert-OnClientPutInServer.phrases");
}

public OnClientPutInServer(client)
{
	if(IsClientInGame(client) && IsClientConnected(client))
	{
        // Se o jogador já tem um timer, destrua-o antes de criar um novo
        if (hHudTimer[client] != INVALID_HANDLE)
        {
            CloseHandle(hHudTimer[client]);
        }

        // Iniciar o timer que faz o HUD piscar
        hHudTimer[client] = CreateTimer(1.0, HudBlinkTimer, client, TIMER_REPEAT);
	}
}

// Função que alterna a exibição do HUD a cada chamada
public Action HudBlinkTimer(Handle timer, int client)
{
    if (!IsClientInGame(client)) 
    {
        return Plugin_Stop;  // Para o timer se o cliente sair
    }

    // Alternar visibilidade do HUD
    bShowHud[client] = !bShowHud[client];

    if (bShowHud[client])
    {
        // Exibir o HUD quando o estado for verdadeiro
        SetHudTextParams(-1.0, 0.6, 99999.0, 254, 221, 0, 0, 0, 0.0, 0.0, 0.0);
        ShowHudText(client, 0, "%t", "hud_translation");
    }
    else
    {
        SetHudTextParams(-1.0, 0.6, 99999.0, 255, 0, 0, 0, 0, 0.0, 0.0, 0.0);
        ShowHudText(client, 0, "%t", "hud_translation");
    }

    return Plugin_Continue;  // Continuar o timer
}

public void OnClientDisconnect(int client)
{
    // Parar o timer e limpar os dados quando o jogador sair
    if (hHudTimer[client] != INVALID_HANDLE)
    {
        CloseHandle(hHudTimer[client]);
        hHudTimer[client] = INVALID_HANDLE;
    }
}
