using System.Collections;
using UnityEngine.UI;
using System.Collections.Generic;
using UnityEngine;

public class WaveController : MonoBehaviour {

	[SerializeField]
	float timeBetwenWaves;
	[SerializeField]
	List <Wave> waves = new List<Wave> ();
	float timeToSpawn;
	Transform GOparant1;
	[SerializeField]
	Vector3 spawnValues;
	[SerializeField]
	Text nextWaveText;
	bool txtNextLvl = false;
	float alpha;
	float timeForTxt = 3;
    int indexCurrWave = 0;




	void Start ()
	{
		GOparant1 = new GameObject("GOparant1").transform;
	}

	IEnumerator wavesHandler ()
	{
		for (int i = 0; i < waves.Count; i++) 
		{
			
			timeToSpawn = Time.time + Random.Range (waves [i].minTimeSpawn, waves [i].maxTimeSpawn);
			txtNextLvl = false;
			nextWaveText.gameObject.SetActive (false);

			while (true) 
				
			{
				
				if (timeToSpawn <= Time.time) 
					
				{
					int U = Random.Range (0, waves [i].WaveUnits.Count - 1);

					Vector3 spawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);
					Quaternion spawnRotation = Quaternion.identity;
					Instantiate (waves [i].WaveUnits [U].unit, spawnPosition, spawnRotation); 

					waves [i].WaveUnits[U].unitQuantity--;
					if (waves [i].WaveUnits [U].unitQuantity == 0)
						waves [i].WaveUnits.RemoveAt (U);



					if (waves [i].WaveUnits.Count <= 0) 
					{
						


						Debug.Log ("NEXXXT");
						txtNextLvl = true;
						nextWaveText.gameObject.SetActive (true);

					}


					timeToSpawn = Time.time + Random.Range (waves [i].minTimeSpawn, waves [i].maxTimeSpawn);
				}

				yield return new WaitForSeconds (timeBetwenWaves);
			}
		}
	}

	public void SpawnLastWave ()
	{
		Debug.Log ("  LastWave!");
	}

	void Update ()
	{
		if (txtNextLvl)
		{
			alpha += Time.deltaTime * 0.5f;
			nextWaveText.color = new Color (1, 1, 1, alpha); 
			if (alpha > 1.5f) 
			{
				txtNextLvl = false;
				nextWaveText.gameObject.SetActive (false);
			}
		}
	}

	public void StartWaves ()
	{
		StartCoroutine (wavesHandler ());
	}


    public void SpawnUnits(List<Units> currUnits )
    {
        
    }


    private void SpawnWave(Wave currWave )
    {



    }

    private void SpawnObjects(Units unit )
    {
        Vector3 spawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);
        Quaternion spawnRotation = Quaternion.identity;
        Instantiate(unit.unit, spawnPosition, spawnRotation, GOparant1);
    }

}
