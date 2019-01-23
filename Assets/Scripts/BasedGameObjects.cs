using System.Collections; 
using System.Collections.Generic;
using UnityEngine;

public class BasedGameObjects : StageController
{
    void Start()
    {
        Initialized();
    }
    public enum Types
    {
        player,
        hazard,
        bonys,
        bulet,
        wall
    };
	[SerializeField]
	protected float healthPoints;
	public virtual float HealthPoints
    {
        get { return healthPoints; }
        set { healthPoints = value;

            if (healthPoints <= 0)
                Death();
        }

    }
    public float moveSpeedX, moveSpeedZ;
    public Types Type;
    public Types[] CollusionMassive;

	public virtual void AddedGamage (float Damage)
    {
        HealthPoints -= Damage;
    }

    public virtual void Initialized ()
    { }
    public virtual void Death ()
    { }
    public virtual void OutOfGameField ()
    {
        Destroy(gameObject);
    }
    public virtual void Mover ()
    { }

    void OnTriggerEnter(Collider other)
    {
        BasedGameObjects CollusionObject = other.gameObject.GetComponent<BasedGameObjects>();
        if (CollusionObject == null)
        {
         //   Debug.LogError("ALLLARM! Not BasedGameObject in " + other.gameObject.name);
            return;
        }
        foreach (Types triggerType in CollusionMassive)
        {
            if (CollusionObject.Type == triggerType)
            {
                Impact(CollusionObject);
                break;

            }

        }
    }
    public virtual void Impact (BasedGameObjects objectImpact)
    {

    }


}
