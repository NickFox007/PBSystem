#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
	name = "PBS Core",
	author = "NickFox",
	description = "ProgressBar System (Core)",
	version = "0.1",
	url = "https://vk.com/nf_dev"
}

bool g_bIsBusy[MAXPLAYERS+1];

int m_flSimulationTime;
int m_flProgressBarStartTime;
int m_iProgressBarDuration;
int m_iBlockingUseActionInProgress;

int m_hBombDefuser;

public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max) 
{
	CreateNative("PBS_ShowTimer", Native_ShowTimer);
	CreateNative("PBS_ResetTimer", Native_ResetTimer);
	CreateNative("PBS_IsBusy", Native_IsBusy);
	RegPluginLibrary("pbs");
  
	return APLRes_Success;

}

public void OnPluginStart(){

	m_flSimulationTime = FindSendPropInfo("CBaseEntity", "m_flSimulationTime");
	m_flProgressBarStartTime = FindSendPropInfo("CCSPlayer", "m_flProgressBarStartTime");
	m_iProgressBarDuration = FindSendPropInfo("CCSPlayer", "m_iProgressBarDuration");
	m_iBlockingUseActionInProgress = FindSendPropInfo("CCSPlayer", "m_iBlockingUseActionInProgress");
	
	m_hBombDefuser = FindSendPropInfo("CPlantedC4", "m_hBombDefuser");

}

public int Native_ShowTimer(Handle hPlugin, int iNumParams)
{   
	int iClient = GetNativeCell(1);
	float fTime = GetNativeCell(2);
	return ShowPB(iClient,fTime);
}

public int Native_ResetTimer(Handle hPlugin, int iNumParams)
{   
    int iClient = GetNativeCell(1);
    return ResetPB(iClient);
}

public int Native_IsBusy(Handle hPlugin, int iNumParams)
{   
    int iClient = GetNativeCell(1);
    return g_bIsBusy[iClient];
}

void SetInfoPB(int iClient, float fTime){

	float flGameTime = GetGameTime();	
	SetEntData(iClient, m_iBlockingUseActionInProgress, 0, 4, true);
	SetEntDataFloat(iClient, m_flSimulationTime, flGameTime + fTime, true);
	SetEntData(iClient, m_iProgressBarDuration, RoundToCeil(fTime),  4, true);
	SetEntDataFloat(iClient, m_flProgressBarStartTime, flGameTime, true);
	
	SetEntData(iClient, m_hBombDefuser, 0, 4, true);
}

public bool ShowPB(int iClient, float fTime){

	if(g_bIsBusy[iClient]) return false;	
	
	SetInfoPB(iClient,fTime);
	
	CreateTimer(fTime,Timer_Reset,iClient);
	
	g_bIsBusy[iClient] = true;
	return true;
}

Action Timer_Reset(Handle hTimer, int iClient){
	ResetPB(iClient);
}

public bool ResetPB(int iClient){
	
	if(!g_bIsBusy[iClient]) return false;
	
	SetInfoPB(iClient,0.0);
	
	g_bIsBusy[iClient] = false;
	
	return true;

}
