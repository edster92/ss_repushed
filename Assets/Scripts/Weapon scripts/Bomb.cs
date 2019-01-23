using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bomb : BasedGameObjects {
	
	[SerializeField]
	float rotationSpeed;


}

/*EnemyController [] foundedEnemys;

	public void FindObjects ()
	{
		foundedEnemys = FindObjectsOfType <EnemyController> ();
		foreach (EnemyController enemy in foundedEnemys)
			enemy.Death ();
	}

	public override void Impact (BasedGameObjects objectImpact)
	{
		FindObjects ();
	}*/
