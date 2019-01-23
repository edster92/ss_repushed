using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class Wave {

	public float minTimeSpawn = 2, maxTimeSpawn = 5;
	public List <Units> WaveUnits = new List<Units> ();

}
