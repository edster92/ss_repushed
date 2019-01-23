using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletController : BasedGameObjects {

	public float BulletDamage = 0;
	[SerializeField]
	ParticleSystem impactEffect = null;
	[SerializeField]
	bool useWeaponDamage;

    public override void Initialized()
    {
        Type = Types.bulet;
    }

    public override void Death()
    {
        Destroy(gameObject);
    }

    public override void Impact(BasedGameObjects objectImpact)
    {
		if (useWeaponDamage)
			objectImpact.AddedGamage (PlayerController.instance.Weapon.damage [PlayerController.instance.Weapon.WeaponLevel - 1]);
		else
			objectImpact.AddedGamage (BulletDamage);
		if (impactEffect) {
			Instantiate (impactEffect, transform.position, Quaternion.identity);
		}

		Death ();
    }
}
