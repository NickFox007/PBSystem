#if defined _pbs_included
    #endinput
#endif
#define _pbs_included  

native bool PBS_ShowTimer(int iClient, float fTime);
native bool PBS_ResetTimer(int iClient);
native bool PBS_IsBusy(int iClient);