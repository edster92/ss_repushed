using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponMultiShot : BaseWeapon 
{
	
	protected override IEnumerator Fire ()
	{
		while (fireOn) {
			if (Time.time >= lastFireTime + fireRate [WeaponLevel - 1]) {
				foreach (Transform T in levelAnchors [WeaponLevel - 1].ShotAnchors) {
					Instantiate (bulletSample, T.position, T.rotation, null);
				}
				lastFireTime = Time.time;
			}
			yield return null;
		}

	}
}