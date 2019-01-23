using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[System.Serializable]
public class CommonStages
{

    public delegate void Robert();
	[SerializeField]
    public Robert StartStep, LoopStep, EndStep;
    public string StageName;
    
    public CommonStages (string Name, Robert startStep, Robert loopStep, Robert endStep)
    {
        StageName = Name;
        StartStep = startStep;
        LoopStep = loopStep;
        EndStep = endStep;
    }

}
