using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Collections;
using System.Xml;
using System.Xml.Serialization;

public class Done_GameController : MonoBehaviour
{
    public event System.Action AllDead;
    [SerializeField]
    WaveControllerV2 waveController;
    public GameObject[] hazards;
    public GameObject[] bonuses;
    [SerializeField]
    GameObject bomb;
    public Vector3 spawnValues;
    public int hazardCount;
    public int bonusCount;
    public float spawnWait;
    public float startWait;
    public float waveWait;
    public static Done_GameController Instance;
    public float Xmin, Xmax;
    [SerializeField]
    GameObject UIcontrol;

    public Text scoreText;
    public GameObject restartButton;
    public Text gameOverText;
    public Text weaponLvlTxt;

    public Text HealthText;


    private bool gameOver;
    private bool restart;
    private int score;
    [SerializeField]
    float minTimeSpawnBonus, maxTimeSpawnBonus;
    Transform GOparant;
    public BaseWeapon[] Weapons;

    public PlayerController Player;

    float alpha = 0;

    bool background = true;


    void Start()
    {
        UIcontrol.SetActive(false);
  //      StartCoroutine(SpawnBackGround());
        gameOver = false;
        restart = false;
        restartButton.SetActive(false);
        gameOverText.color = Color.clear;
        gameOverText.text = "";
        score = 0;
        UpdateScore();
        Player.gameObject.SetActive(false);
        background = true;

        GOparant = new GameObject("GOparant").transform;

        if (Screen.height > Screen.width)
        {
            Xmin = -4.5f;
            Xmax = 4.5f;
            spawnValues = new Vector3(Random.Range(-4.5f, 4.5f), spawnValues.y, spawnValues.z);
        }

    }

    void Awake()
    {
        Done_GameController.Instance = this;
    }

    void Update()
    {
        if (gameOver)
        {
            restartButton.SetActive(true);
            alpha += Time.deltaTime * 0.5f;
           // restart = true;
            gameOverText.color = new Color(1, 1, 1, alpha);
        }
        if (restart)
        {
            if (Input.GetKeyDown(KeyCode.R) || restart == true)
            {
                SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
            }
        }
    }
    public void rGame ()
    {
        restart = true;
    }
    public void StartGame()
    {

        UIcontrol.SetActive(true);
        Player.gameObject.SetActive(true);
        //	StartCoroutine (SpawnWaves ());
        StartCoroutine(SpawnBonus());
        //	StartCoroutine (SpawnBomb ());
        UpdateWeaponInfo();
        waveController.StartWaves();

        background = false;
    }

    IEnumerator SpawnBonus()
    {
        yield return new WaitForSeconds(Random.Range(minTimeSpawnBonus, maxTimeSpawnBonus));
        while (true)
        {
            if (bonuses.Length == 0)
                break;
            GameObject bonus = bonuses[Random.Range(0, bonuses.Length)];
            Vector3 bonuSpawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);
            Quaternion bonusSpawnRotation = Quaternion.identity;
            Instantiate(bonus, bonuSpawnPosition, bonusSpawnRotation, GOparant);
            yield return new WaitForSeconds(Random.Range(minTimeSpawnBonus, maxTimeSpawnBonus));
        }
    }
    IEnumerator SpawnBomb()
    {
        yield return new WaitForSeconds(Random.Range(35, 50));
        while (true)
        {
            Vector3 bombSpawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);
            Quaternion bombSpawnRotation = Quaternion.identity;
            Instantiate(bomb, bombSpawnPosition, bombSpawnRotation, GOparant);
            yield return new WaitForSeconds(Random.Range(15, 20));
        }
        yield break;
    }

    IEnumerator SpawnBackGround()
    {
        while (true)
        {

            GameObject hazard = hazards[Random.Range(0, hazards.Length)];
            Vector3 spawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);
            Quaternion spawnRotation = Quaternion.identity;
            Instantiate(hazard, spawnPosition, spawnRotation, GOparant);
            Debug.Log("Spawning bcground<<<<<<<<<<" + hazard.name);
            yield return new WaitForSeconds(Random.Range(1, 3));

        }
        yield break;
    }

    public void AddScore(int newScoreValue)
    {
        score += newScoreValue;
        UpdateScore();
    }

    public void UpdateWeaponInfo()
    {
        weaponLvlTxt.text = "Your weapon level: " + Player.Weapon.WeaponLevel;
    }

    void UpdateScore()
    {
        scoreText.text = "Score: " + score;
    }

    public void UpdateHealth(float HealthPoints)
    {
        HealthText.text = "Health: " + HealthPoints;
    }

    public void GameOver()
    {
        gameOverText.text = "Game Over!";
        gameOver = true;
        StopAllCoroutines();
    }
    public void AddBonus(BonusContainer Container)
    {
        switch (Container.BonusType) {

            case BonusContainer.ChoseBonusType.HelathPonts:
                {
                    Player.HealthPoints += Container.BonusQuantity;
                    break;
                }
            case BonusContainer.ChoseBonusType.Immortality:
                {
                    Player.AddImmoratl((float)Container.BonusQuantity);
                    break;
                }
            case BonusContainer.ChoseBonusType.Weapon:
                {
                    if (Player.Weapon.Type != Container.WeaponType) {
                        bool playerShoted = false;
                        if (Player.Weapon.fireOn == true) {
                            Player.Weapon.FireEnd();
                            playerShoted = true;
                        }

                        foreach (BaseWeapon wip in Weapons) {

                            if (wip.Type == Container.WeaponType) {
                                Player.Weapon = wip;
                                break;
                            }
                        }
                        if (playerShoted == true)
                            Player.Weapon.FireStart();
                        UpdateWeaponInfo();
                    } else if (Player.Weapon.WeaponLevel == Player.Weapon.MaxWeaponLevel)
                        return;
                    else {
                        Player.Weapon.WeaponLevelsUp();
                        UpdateWeaponInfo();
                    }
                    break;
                }
            case BonusContainer.ChoseBonusType.GreatBaBah:
                {
                    if (AllDead != null)
                        AllDead();
                    break;
                }
        }
    }

   /* public void SpawnEnemy()
    {
        GameObject hazard = hazards[Random.Range(0, hazards.Length)];
        Vector3 spawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);
        Quaternion spawnRotation = Quaternion.identity;
        Instantiate(hazard, spawnPosition, spawnRotation, GOparant);
    }

    public void SpawnLaser()
    {
        GameObject bonus = bonuses[Random.Range(0, bonuses.Length)];
        Vector3 bonuSpawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);
        Quaternion bonusSpawnRotation = Quaternion.identity;
        Instantiate(bonus, bonuSpawnPosition, bonusSpawnRotation, GOparant);
    }

    public void SpawnBombss()
    {
        Vector3 bombSpawnPosition = new Vector3(Random.Range(-spawnValues.x, spawnValues.x), spawnValues.y, spawnValues.z);
        Quaternion bombSpawnRotation = Quaternion.identity;
        Instantiate(bomb, bombSpawnPosition, bombSpawnRotation, GOparant);
    }
    public void StopBackround()
    {
        StopCoroutine(SpawnBackGround());
        Debug.LogWarning("Stopped!!!!!!1111");
    }
    public void StartBackround()
    {
        StartCoroutine(SpawnBackGround());
        Debug.LogWarning("Started!");
    }*/
    public void QuiyGame ()
	{
		Application.Quit ();
	}
}