using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyController : BasedGameObjects {
	
    public GameObject EnemyExploisionPartickle;
	public ParticleSystem EnemmyFallingPartickle;
    public int ScoreForEnemy = 1;
	[SerializeField]
	float chanceToEvasion = 15;
	[SerializeField]
	float evasionMinRange = 2, evasionMaxRange = 5, evasionTime = 1;
	[SerializeField]
	AnimationCurve evasionCurve = null, fallingCurve = null;
	float startEvasionXPosition = 0, endEvasionXposition = 0;
	float startAnimationTime = 0;
	float startFallingYPosition = 0, endFallingYPostion = -9;
	[SerializeField]
	float fallingTime = 0;
	Vector3 FallPosition;
	[SerializeField]
	BaseWeapon enemyWeapon = null;
	float lastFireTime = 0;
	[SerializeField]
	float minFireDelay = 0;
	[SerializeField]
	float maxFireDealy = 0;
	[SerializeField]
	float randomDelay = 0;
	float percentToFire = 0;
    [SerializeField]
    bool noEvasion = false;
    [SerializeField]
    bool fire = false;
    


    
	public enum EnemyStages 
	{
		Idle,
		Evasion,
		Deth,
		ActiveFire
	}

    public override void Initialized()
    {
		Done_GameController.Instance.AllDead += Death;

        Type = Types.hazard;
		StageInitialize(new CommonStages [] { 
			new CommonStages(EnemyStages.Idle.ToString(),null,IdleStageUpdate,null),
			new CommonStages(EnemyStages.Evasion.ToString(),EvasionStageStart,EvasionStageUpdate,EvasionStageEnd),
			new CommonStages(EnemyStages.Deth.ToString(), DeathStageStart, DeathStageUpdate, DeathStageEnd)
		});
    }

	public void EnemyFire ()
	{
		if (enemyWeapon)
		enemyWeapon.FireStart ();
	}

    public override void Death()
    {
		Done_GameController.Instance.AllDead -= Death;
		if (!noEvasion)
			SetStage (EnemyStages.Deth.ToString ());
		else
			DeathStageEnd ();
    }

    public override void Impact(BasedGameObjects objectImpact)
    {
        objectImpact.AddedGamage(1);
        AddedGamage(1);
    }

    public void EvasionStageStart ()
    {
		if (!noEvasion) {
			float moveVectoreX;
			startEvasionXPosition = transform.position.x;
			if (startEvasionXPosition == 0)
				moveVectoreX = -1;
			else
				moveVectoreX = Mathf.Sign (startEvasionXPosition) * -1;
			endEvasionXposition = startEvasionXPosition + (Random.Range (evasionMinRange, evasionMaxRange) * moveVectoreX);
			startAnimationTime = Time.time;
		}
    }

	public void EvasionStageUpdate ()
    {
		if (!noEvasion) {
			Vector3 currentPosition = transform.position;
			currentPosition.x = Mathf.Lerp (startEvasionXPosition, endEvasionXposition, evasionCurve.Evaluate (Mathf.InverseLerp (startAnimationTime, startAnimationTime + evasionTime, Time.time)));
			transform.position = currentPosition;
			if (Time.time >= startAnimationTime + evasionTime)
				SetStage (EnemyStages.Idle.ToString ());
		}
    }

	public void EvasionStageEnd ()
    {
        
    }

	public void IdleStageUpdate ()
	{
		if (fire)
        {
			percentToFire = Random.Range (0, 100);
			if (percentToFire == 20f)
				EnemyFire ();
			else
				enemyWeapon.FireEnd ();
		

			if (transform.position.z < 35f && transform.position.z < 32f) {
				enemyWeapon.WeaponLevel = 2;
				percentToFire = 20f;
			}

			if (Input.GetMouseButtonDown (0) || Input.GetKeyDown (KeyCode.Space)) {

				float curentPercent = Random.Range (0, 100);
				if (curentPercent <= chanceToEvasion)
					SetStage (EnemyStages.Evasion.ToString ());
			}
		}
	}

	public void DeathStageStart ()
	{
		
		if (!noEvasion) {
			
			FallPosition = transform.position;
			var g = gameObject;
			startFallingYPosition = transform.position.y;
			GetComponent <CapsuleCollider> ().enabled = false;
			if (EnemmyFallingPartickle)
			EnemmyFallingPartickle.Play (true);
			startAnimationTime = Time.time;
		}
		
	}

	public void DeathStageUpdate () 
	{
		if (!noEvasion) {
			Vector3 currentPosition = transform.position;
			currentPosition.y = Mathf.Lerp (startFallingYPosition, endFallingYPostion, fallingCurve.Evaluate (Mathf.InverseLerp (startAnimationTime, startAnimationTime + fallingTime, Time.time)));
			transform.position = currentPosition;
			if (Time.time >= startAnimationTime + fallingTime)
				Stop ();
			transform.LookAt (FallPosition - currentPosition + transform.position);
			FallPosition = transform.position;
		}
	}

	public void DeathStageEnd ()
	{
		Done_GameController.Instance.AddScore (ScoreForEnemy);
		Instantiate(EnemyExploisionPartickle, transform.position, Quaternion.identity, transform.parent);
		Destroy(gameObject);
	}

	void OnDestroy ()
	{
		Done_GameController.Instance.AllDead -= Death;
	}
}
