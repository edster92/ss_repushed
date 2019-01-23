using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SingleShot : BaseWeapon {


	public override void FireStart ()
	{
		if (Time.time >= lastFireTime + fireRate [WeaponLevel - 1]) 
		{
			foreach (Transform T in levelAnchors [WeaponLevel - 1].ShotAnchors) 
			{
				Instantiate (bulletSample, T.position, T.rotation, null);
			}
		}
	}
}
