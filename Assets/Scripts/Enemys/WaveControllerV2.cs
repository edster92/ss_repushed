using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveControllerV2 : MonoBehaviour {

    [SerializeField]
    Vector3 spawnValues;
    public enum SpawnState { SPAWNING, WAITING, COUNTING };

    [System.Serializable]
    public class waveUnit
    {
        public string name;
        public Transform enemy;
        public int count;
        public float rate;
    }


    public waveUnit[] waves;
    int nextWave = 0;
    public float timeBetwenWaves = 5f;
    public float waveCountDown;
    float searchCoundown = 1f;
    bool startGame = false;

    private SpawnState state = SpawnState.COUNTING;

    void Start ()
    {
        waveCountDown = timeBetwenWaves;
        startGame = false;
    }

    void Update ()
    {
        if (state == SpawnState.WAITING)
        {
            if (!EnemyIsAlive())
            {
                BeginNewRound ();
            }
            else
            {
                return;
            }
        } 

        if (waveCountDown <= 0)
        {
            if (state != SpawnState.SPAWNING && startGame == true)
            {
                StartCoroutine(SpawnWave(waves[nextWave]));
            }
        }

        else
        {
            waveCountDown -= Time.deltaTime;
        }
    }

    bool EnemyIsAlive()
    {
        searchCoundown -= Time.deltaTime;

        if (searchCoundown <= 0f)
        {
            searchCoundown = 1f;

            if (GameObject.FindGameObjectWithTag("Enemy") == null)

            {
                return false;
            }
        }
        return true;
    }

    public void BeginNewRound ()
    {
        Debug.Log("Begin new level!");
        state = SpawnState.COUNTING;
        waveCountDown = timeBetwenWaves;
        if (nextWave +1 > waves.Length - 1)
        {
            nextWave = 0;
            Debug.Log("All Waves Are Complited!!!!");
        }
        nextWave++;
    }

    IEnumerator SpawnWave (waveUnit _wave)
    {
        Debug.Log("Spawning wave: " + _wave.name);
        state = SpawnState.SPAWNING;
        for (int i = 0; i<_wave.count; i++)
        {
            SpawnEnemy(_wave.enemy);
            yield return new WaitForSeconds(1f / _wave.rate);
        }
        state = SpawnState.WAITING;
        yield break;
    }
    public void StartWaves ()
    {
        startGame = true;
    //    Done_GameController.Instance.StopBackround();
    }
    void SpawnEnemy (Transform _enemy)
    {
        //SpawnEnemy
        Vector3 spawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);

        Instantiate(_enemy, spawnPosition, transform.rotation);
        Debug.Log("Spawning enemy: " + _enemy.name);
    }

}
