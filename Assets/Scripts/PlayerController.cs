using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : BasedGameObjects
{

    public GameObject ExploisionPartickle;
    [SerializeField]
    float immortalTime;
    public GameObject ImmortalVisualObject;
    private float timeBeforKick;
    float currentXposition;
    public Animator anim;
    [SerializeField]
    private float mergeAnimationSpeed;
    public static PlayerController instance;
	public BaseWeapon Weapon;
	[SerializeField]
	UIprogressBar progressBar;
    bool moveR = false;
    bool moveL = false;

	float immortalityTime;

	public override float HealthPoints
	{
		get { return healthPoints; }
		set { healthPoints = value;
			Done_GameController.Instance.UpdateHealth (value);
			if (healthPoints <= 0) {
				Done_GameController.Instance.GameOver ();
				Death ();
			}
		}
	}

    void Awake()
    {
        PlayerController.instance = this;
    }
   // float currentMoveVector = anim.GetFloat("MoveVector");
    void Update ()
    {
		if (Input.GetMouseButtonDown (0) || Input.GetKeyDown (KeyCode.Space))
			Weapon.FireStart ();
		if (Input.GetMouseButtonUp (0) || Input.GetKeyUp (KeyCode.Space))
			Weapon.FireEnd ();
        float currentMoveVector = anim.GetFloat("MoveVector");



        if (Input.GetKey(KeyCode.RightArrow) || moveR == true)
        {
            
            MoveRight();
        }
        else if (Input.GetKey(KeyCode.LeftArrow) || moveL == true)
        {
            
            MoveLeft();
        }
        else
        {
            anim.SetFloat("MoveVector", currentMoveVector - (Mathf.Abs(currentMoveVector) > (mergeAnimationSpeed * Time.deltaTime) ?
                (mergeAnimationSpeed * Time.deltaTime * Mathf.Sign(currentMoveVector)) : currentMoveVector));
        }
        transform.localPosition = new Vector3 (currentXposition, transform.localPosition.y, transform.localPosition.z);
        moveR = false;
        moveL = false;

    }

    public void MoveLeft()
    {
        moveL = true;
        float currentMoveVector = anim.GetFloat("MoveVector");
        currentXposition = Mathf.Clamp(currentXposition - (moveSpeedX * Time.deltaTime), Done_GameController.Instance.Xmin, Done_GameController.Instance.Xmax);
        anim.SetFloat("MoveVector", Mathf.Clamp(currentMoveVector - (mergeAnimationSpeed * Time.deltaTime), -1, 1));
    }
    public void MoveRight ()
    {
        moveR = true;
        float currentMoveVector = anim.GetFloat("MoveVector");
        currentXposition = Mathf.Clamp(currentXposition + (moveSpeedX * Time.deltaTime), Done_GameController.Instance.Xmin, Done_GameController.Instance.Xmax);
        anim.SetFloat("MoveVector", Mathf.Clamp(currentMoveVector + (mergeAnimationSpeed * Time.deltaTime), -1, 1));
    }

    public override void Initialized()
    {
        Type = Types.player;
		Done_GameController.Instance.UpdateHealth (HealthPoints);
    }
    public override void Death()
    {
        Instantiate(ExploisionPartickle, transform.position, Quaternion.identity);
        Done_GameController.Instance.GameOver();
        Destroy(gameObject);
    }
	public override void AddedGamage (float Damage)
    {
		
        if (Time.time >= timeBeforKick)
        {
			HealthPoints -= Damage;
			if (HealthPoints > 0)
				AddImmoratl(immortalTime);
        }
    }
    public void AddImmoratl (float TimeForImmortal)
    {
		if (Time.time < immortalTime) {
			immortalityTime = TimeForImmortal;
			timeBeforKick += TimeForImmortal;
		}
        else
        {
			immortalityTime = TimeForImmortal;
            timeBeforKick = Time.time + TimeForImmortal;
            StartCoroutine(ImmortalVisual());
        }
    }
    public IEnumerator ImmortalVisual ()
    {
        ImmortalVisualObject.SetActive(true);
		progressBar.icon.SetActive(true);
		while (Time.time < timeBeforKick) {
			progressBar.CurrentValue = (timeBeforKick - Time.time) / immortalityTime;
			yield return null;
		}
		progressBar.CurrentValue = 0;
        ImmortalVisualObject.SetActive(false);
		progressBar.icon.SetActive (false);
    }
}
