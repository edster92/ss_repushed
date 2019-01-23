using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageController: MonoBehaviour
{
    CommonStages [] Stages;
    int currentStageIndex;

    public void StageInitialize (CommonStages[] stages)
    {
        Stages = stages;

        if (Stages[0].StartStep != null)
             Stages[0].StartStep();

        StartCoroutine(UpdateStages());
    }
    public void SetStage(int indexStage)
    {
        if (indexStage >= Stages.Length)
        {
            Stop();
            return;
        }
        if (Stages[currentStageIndex].EndStep != null)
            Stages[currentStageIndex].EndStep();

        currentStageIndex = indexStage;
        if (Stages[currentStageIndex].StartStep != null)
            Stages[currentStageIndex].StartStep();
    }
    public void SetStage(string nameStage)
    {
        for (int i = 0; i < Stages.Length; i++)
        {
            if (Stages[i].StageName == nameStage)
            {
                SetStage(i);
                return;
            }
        }
		Debug.LogError ("Not find stage " + nameStage);
    }
    public void NextStage()
    {
        SetStage(currentStageIndex + 1);
    }
    public void Stop()
    {
        if (Stages[currentStageIndex].EndStep != null)
            Stages[currentStageIndex].EndStep();

        StopCoroutine(UpdateStages());
    }
    IEnumerator UpdateStages()
    {
        while (true)
        {
            if (Stages[currentStageIndex].LoopStep != null)
                Stages[currentStageIndex].LoopStep();
            yield return null;
        }
    }
}
